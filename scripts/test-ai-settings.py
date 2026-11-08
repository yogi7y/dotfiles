import importlib.util
import json
from pathlib import Path
import tempfile
import tomllib
import unittest


spec = importlib.util.spec_from_file_location("ai_settings", Path(__file__).with_name("ai-settings.py"))
settings = importlib.util.module_from_spec(spec)
spec.loader.exec_module(settings)


class SettingsTests(unittest.TestCase):
    def test_export_excludes_machine_state_and_plugin_secrets(self):
        local = '''model = "example"
notify = ["/local/notify"]
[desktop]
appearanceTheme = "dark"
localOnlyPath = "/private/local"
[mcp_servers.private]
command = "/private/mcp"
[plugins."example@market"]
enabled = true
token = "private-plugin-token"
[projects."/private/project"]
trust_level = "trusted"
'''
        portable = tomllib.loads(settings.portable_toml(local))
        self.assertEqual(portable, {
            "model": "example", "desktop": {"appearanceTheme": "dark"},
            "plugins": {"example@market": {"enabled": True}},
        })

    def test_merge_preserves_local_values_and_is_idempotent(self):
        local = '''# retain this comment
model = "old"
notify = ["/local/notify"]
[desktop]
appearanceTheme = "light"
localOnlyPath = "/local/path"
[desktop.appearanceDarkChromeTheme]
accent = "old"
localOnly = true
[plugins."example@market"]
enabled = false
token = "private-plugin-token"
[mcp_servers.private]
command = "/local/mcp"
[projects."/local/project"]
trust_level = "trusted"
[hooks.state]
localHash = "unchanged"
'''
        shared = '''model = "new"
[desktop]
appearanceTheme = "dark"
[desktop.appearanceDarkChromeTheme]
accent = "new"
[plugins."example@market"]
enabled = true
'''
        result = settings.merge_toml(local, shared)
        expected = tomllib.loads(local)
        expected["model"] = "new"
        expected["desktop"]["appearanceTheme"] = "dark"
        expected["desktop"]["appearanceDarkChromeTheme"]["accent"] = "new"
        expected["plugins"]["example@market"]["enabled"] = True
        self.assertEqual(tomllib.loads(result), expected)
        self.assertIn("# retain this comment", result)
        self.assertEqual(settings.merge_toml(result, shared), result)

    def test_apply_preserves_provider_credentials_unknowns_and_backups(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            repo, home = root / "repo", root / "home"
            settings.write(repo / "codex/settings.toml", 'model = "new"\n')
            settings.write(repo / "codexbar/providers.json", settings.json_text({
                "version": 1, "providers": [{"id": "a", "enabled": False}, {"id": "new", "enabled": True}],
            }))
            settings.write(home / ".codex/config.toml", 'model = "old"\n[projects.local]\ntrust_level = "trusted"\n')
            bar = home / ".config/codexbar/config.json"
            settings.write(bar, settings.json_text({
                "version": 1, "hooks": {"enabled": True}, "providers": [
                    {"id": "a", "enabled": True, "apiKey": "local-secret", "source": "cli"},
                    {"id": "extra", "enabled": True},
                ],
            }))
            original_cli = settings.codexbar_cli
            settings.codexbar_cli = lambda: None
            try:
                settings.apply(repo, home)
                first = bar.read_text()
                settings.apply(repo, home)
                self.assertEqual(bar.read_text(), first)
            finally:
                settings.codexbar_cli = original_cli
            result = json.loads(first)
            self.assertEqual([p["id"] for p in result["providers"]], ["a", "new", "extra"])
            self.assertEqual(result["providers"][0], {
                "id": "a", "enabled": False, "apiKey": "local-secret", "source": "cli",
            })
            self.assertEqual(result["hooks"], {"enabled": True})
            backups = list((home / ".local/state/dotfiles-ai/backups").glob("*/.config/codexbar/config.json"))
            self.assertEqual(len(backups), 1)
            self.assertIn("local-secret", backups[0].read_text())
            self.assertEqual(backups[0].stat().st_mode & 0o777, 0o600)

    def test_rejects_nonportable_shared_settings(self):
        for shared in ['[mcp_servers.bad]\ncommand = "bad"\n', '[desktop]\nlocalOnlyPath = "bad"\n', '[plugins.test]\napiKey = "bad"\n']:
            with self.assertRaises(ValueError):
                settings.merge_toml("", shared)


if __name__ == "__main__":
    unittest.main()
