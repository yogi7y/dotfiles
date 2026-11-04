#!/usr/bin/env python3
import argparse
import copy
import datetime
import fcntl
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import tomllib


ROOT_KEYS = {"model", "model_reasoning_effort", "service_tier"}
TABLES = {"desktop", "plugins"}
PROVIDER_KEYS = {"id", "enabled", "region"}
DESKTOP_KEYS = {
    "followUpQueueMode", "external-agent-import-sync-item-types",
    "external-agent-import-sync-enabled", "conversationDetailMode",
    "ambient-suggestions-enabled", "appearanceTheme", "appearanceDarkCodeThemeId",
    "appearanceLightCodeThemeId", "avatar-overlay-pet-visible", "dock-icon-preference",
    "usePointerCursors", "sansFontSize", "primary-number-shortcut-target",
    "appearanceDiffMarkerStyle", "pagesFullWidth", "appearanceDarkChromeTheme",
    "appearanceLightChromeTheme",
}


def read_json(path):
    return json.loads(path.read_text()) if path.exists() else {}


def json_text(value):
    return json.dumps(value, indent=2, ensure_ascii=False) + "\n"


def table_header(line):
    match = re.fullmatch(r"\s*\[([^\[\]]+)\]\s*(?:#.*)?", line)
    return match.group(1).split(".")[0].strip('" ') if match else None


def portable_toml(text):
    parsed = tomllib.loads(text)
    shared = {k: v for k, v in parsed.items() if k in ROOT_KEYS}
    shared["desktop"] = {k: v for k, v in parsed.get("desktop", {}).items() if k in DESKTOP_KEYS}
    shared["plugins"] = {k: {"enabled": v["enabled"]} for k, v in parsed.get("plugins", {}).items() if "enabled" in v}
    return render_toml(shared)


def render_toml(data):
    lines = []

    def emit(table, path=()):
        if path:
            lines.extend(["", "[" + ".".join(json.dumps(k) for k in path) + "]"])
        for key, value in table.items():
            if not isinstance(value, dict):
                if not isinstance(value, (str, bool, int, float, list)):
                    raise ValueError(f"Unsupported portable TOML value: {key}")
                lines.append(f"{json.dumps(key)} = {json.dumps(value, ensure_ascii=False)}")
        for key, value in table.items():
            if isinstance(value, dict):
                emit(value, (*path, key))

    emit(data)
    result = "\n".join(lines).strip() + "\n"
    if tomllib.loads(result) != data:
        raise ValueError("Portable TOML verification failed")
    return result


def deep_update(existing, incoming):
    result = copy.deepcopy(existing)
    for key, value in incoming.items():
        if isinstance(value, dict) and isinstance(result.get(key), dict):
            result[key] = deep_update(result[key], value)
        else:
            result[key] = copy.deepcopy(value)
    return result


def merge_toml(local, shared):
    existing = tomllib.loads(local)
    incoming = tomllib.loads(shared)
    if set(incoming) - (ROOT_KEYS | TABLES):
        raise ValueError("Shared Codex config contains a machine-local section")
    if set(incoming.get("desktop", {})) - DESKTOP_KEYS:
        raise ValueError("Shared Codex desktop config contains a non-portable field")
    if any(set(plugin) - {"enabled"} for plugin in incoming.get("plugins", {}).values()):
        raise ValueError("Only plugin enablement may be shared")
    expected = deep_update(existing, incoming)
    shared = render_toml({k: v for k, v in expected.items() if k in incoming})
    root = True
    remove = False
    retained = []
    for line in local.splitlines(keepends=True):
        header = table_header(line)
        if header is not None:
            root = False
            remove = header in TABLES and header in incoming
        assignment = re.match(r'''\s*(["']?)([a-zA-Z_]+)\1\s*=''', line) if root else None
        if remove or (assignment and assignment.group(2) in ROOT_KEYS & incoming.keys()):
            continue
        retained.append(line)
    # Shared root assignments must precede every local table.
    shared_roots, shared_tables = [], []
    in_table = False
    for line in shared.splitlines(keepends=True):
        in_table = in_table or table_header(line) is not None
        (shared_tables if in_table else shared_roots).append(line)
    result = "".join(shared_roots).rstrip() + "\n\n" + "".join(retained).strip() + "\n\n" + "".join(shared_tables)
    if tomllib.loads(result) != expected:
        raise ValueError("TOML merge verification failed; local config left unchanged")
    return result


def write(path, content):
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", dir=path.parent, delete=False) as output:
        temporary = Path(output.name)
        os.chmod(temporary, 0o600)
        output.write(content)
    os.replace(temporary, path)


def codexbar_cli():
    return shutil.which("codexbar") or next((str(p) for p in [
        Path("/Applications/CodexBar.app/Contents/Helpers/CodexBarCLI"),
        Path.home() / "Applications/CodexBar.app/Contents/Helpers/CodexBarCLI",
    ] if p.is_file()), None)


def provider_projection(config):
    return {"version": 1, "providers": [
        {k: v for k, v in provider.items() if k in PROVIDER_KEYS}
        for provider in config.get("providers", [])
    ]}


def export(repo, home):
    codex = home / ".codex"
    write(repo / "codex/settings.toml", portable_toml((codex / "config.toml").read_text()))
    for name in ["AGENTS.md", "keybindings.json"]:
        if (codex / name).exists():
            write(repo / "codex" / name, (codex / name).read_text())
    config = home / ".config/codexbar/config.json"
    if config.exists():
        write(repo / "codexbar/providers.json", json_text(provider_projection(read_json(config))))
    cli = codexbar_cli()
    if cli:
        preferences = subprocess.check_output([cli, "config", "preferences", "export"], text=True)
        write(repo / "codexbar/preferences.json", json_text(json.loads(preferences)))
    else:
        print("CodexBar CLI unavailable; existing portable UI snapshot retained")
    print("Exported portable AI settings. Review the diff before committing.")


def apply(repo, home):
    codex = home / ".codex"
    for directory in [codex, home / ".config", home / ".config/codexbar"]:
        if directory.is_symlink():
            raise ValueError(f"Keep runtime directories local, not symlinked: {directory}")
    config = codex / "config.toml"
    local = config.read_text() if config.exists() else ""
    updates = [(config, merge_toml(local, (repo / "codex/settings.toml").read_text()))]
    for name in ["AGENTS.md", "keybindings.json"]:
        source = repo / "codex" / name
        if source.exists():
            updates.append((codex / name, source.read_text()))
    bar_config = home / ".config/codexbar/config.json"
    bar_config.parent.mkdir(parents=True, exist_ok=True)
    with (bar_config.parent / "config.json.lock").open("a") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        bar = read_json(bar_config) or {"version": 1, "providers": []}
        shared = read_json(repo / "codexbar/providers.json")
        for provider in shared.get("providers", []):
            if set(provider) - PROVIDER_KEYS:
                raise ValueError("Shared provider config contains a non-portable field")
        providers = {p["id"]: p for p in bar.get("providers", [])}
        ordered = []
        for provider in shared.get("providers", []):
            merged = providers.pop(provider["id"], {"id": provider["id"]})
            merged.update(provider)
            ordered.append(merged)
        bar["providers"] = ordered + list(providers.values())
        if shared:
            updates.append((bar_config, json_text(bar)))
        stamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S-%f")
        backup = home / ".local/state/dotfiles-ai/backups" / stamp
        for path, _ in updates:
            if path.is_symlink():
                raise ValueError(f"Refusing to replace existing symlink: {path}")
        for path, content in updates:
            if path.exists() and path.read_text() == content:
                continue
            if path.exists():
                backup.mkdir(parents=True, exist_ok=True, mode=0o700)
                write(backup / path.relative_to(home), path.read_text())
            write(path, content)
        cli = codexbar_cli()
        prefs = repo / "codexbar/preferences.json"
        if cli and prefs.exists():
            current = subprocess.check_output([cli, "config", "preferences", "export"], text=True)
            if json.loads(current) != read_json(prefs):
                write(backup / "codexbar/preferences.json", current)
                subprocess.run([cli, "config", "preferences", "import", "--file", str(prefs)], check=True)
        elif prefs.exists():
            print("Install CodexBar, then rerun make ai-apply to restore UI preferences")
    print("Applied portable AI settings; local credentials, paths, hooks and trust retained.")
    if backup.exists():
        print(f"Backups: {backup}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=["export", "apply"])
    parser.add_argument("--repo", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--home", type=Path, default=Path.home())
    args = parser.parse_args()
    export(args.repo, args.home) if args.action == "export" else apply(args.repo, args.home)
