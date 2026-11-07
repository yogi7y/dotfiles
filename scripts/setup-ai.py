#!/usr/bin/env python3
"""Install shared instructions without replacing provider-managed skill directories."""

import argparse
import os
from pathlib import Path
import tempfile


REPO = Path(__file__).resolve().parents[1]
SOURCE = REPO / "ai/.config/ai"


def links(home):
    instructions = SOURCE / "AGENTS.md"
    yield home / ".config/ai/AGENTS.md", instructions
    yield home / ".codex/AGENTS.md", instructions
    yield home / ".claude/CLAUDE.md", REPO / "claude/.claude/CLAUDE.md"
    for skill in sorted((SOURCE / "skills").iterdir()):
        if skill.is_dir() and (skill / "SKILL.md").is_file():
            for directory in (".agents/skills", ".claude/skills"):
                yield home / directory / skill.name, skill


def installed(destination, source):
    return destination.is_symlink() and destination.resolve() == source.resolve()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--target-home", type=Path, default=Path.home())
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    home = args.target_home.expanduser().resolve()
    if os.environ.get("CODEX_HOME") and Path(os.environ["CODEX_HOME"]).expanduser().resolve() != home / ".codex":
        parser.error("Custom CODEX_HOME detected; configure its instruction adapter explicitly.")
    override = home / ".codex/AGENTS.override.md"
    if override.is_file() and override.read_text().strip():
        parser.error(f"{override} overrides shared instructions; reconcile it first.")

    planned = list(links(home))
    if args.check:
        missing = [str(dst) for dst, src in planned if not installed(dst, src)]
        if missing:
            parser.exit(1, "Missing or incorrect links:\n" + "\n".join(missing) + "\n")
        print(f"Verified {len(planned)} shared instruction/skill links.")
        return

    backup = None
    for destination, source in planned:
        if installed(destination, source):
            continue
        destination.parent.mkdir(parents=True, exist_ok=True)
        if destination.exists() or destination.is_symlink():
            if backup is None:
                root = home / ".local/state/dotfiles/ai-backups"
                root.mkdir(parents=True, exist_ok=True)
                backup = Path(tempfile.mkdtemp(prefix="migration-", dir=root))
            saved = backup / destination.relative_to(home)
            saved.parent.mkdir(parents=True, exist_ok=True)
            destination.rename(saved)
            print(f"Backed up {destination} to {saved}")
        destination.symlink_to(os.path.relpath(source, destination.parent))
        print(f"Linked {destination}")
    print("Shared instructions ready for Codex and Claude. Start fresh sessions.")


if __name__ == "__main__":
    main()
