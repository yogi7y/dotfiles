import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


class SetupAITest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        root = Path(self.temp.name).resolve()
        self.home = root / "home"
        self.repo = root / "repo"
        self.script = self.repo / "scripts/setup-ai.py"
        self.script.parent.mkdir(parents=True)
        shutil.copyfile(Path(__file__).with_name("setup-ai.py"), self.script)
        self.source = self.repo / "ai/.config/ai"
        self.skill = self.source / "skills/example"
        self.skill.mkdir(parents=True)
        (self.skill / "SKILL.md").write_text("---\nname: example\ndescription: Test fixture\n---\n")
        (self.source / "AGENTS.md").write_text("Shared preferences\n")
        adapter = self.repo / "claude/.claude/CLAUDE.md"
        adapter.parent.mkdir(parents=True)
        adapter.symlink_to("../../ai/.config/ai/AGENTS.md")
        self.env = dict(os.environ)
        self.env.pop("CODEX_HOME", None)

    def run_setup(self, *args):
        return subprocess.run(
            ["python3", str(self.script), "--target-home", str(self.home), *args],
            env=self.env, capture_output=True, text=True,
        )

    def test_preserves_existing_files_and_managed_skills(self):
        old = self.home / ".codex/AGENTS.md"
        old.parent.mkdir(parents=True)
        old.write_text("Existing preferences")
        managed = self.home / ".claude/skills/synced/managed.txt"
        managed.parent.mkdir(parents=True)
        managed.write_text("Provider-managed")
        self.assertEqual(self.run_setup().returncode, 0)
        backups = list((self.home / ".local/state/dotfiles/ai-backups").glob("*/.codex/AGENTS.md"))
        self.assertEqual(len(backups), 1)
        self.assertEqual(backups[0].read_text(), "Existing preferences")
        self.assertEqual(managed.read_text(), "Provider-managed")
        self.assertEqual(self.run_setup().returncode, 0)
        self.assertEqual(len(list((self.home / ".local/state/dotfiles/ai-backups").iterdir())), 1)
        self.assertEqual(self.run_setup("--check").returncode, 0)
        (self.source / "AGENTS.md").write_text("Updated preferences")
        for path in (".codex/AGENTS.md", ".claude/CLAUDE.md"):
            self.assertEqual((self.home / path).read_text(), "Updated preferences")
        for path in (".agents/skills/example", ".claude/skills/example"):
            self.assertEqual((self.home / path).resolve(), self.skill)

    def test_override_stops_before_writing(self):
        override = self.home / ".codex/AGENTS.override.md"
        override.parent.mkdir(parents=True)
        override.write_text("Override")
        self.assertNotEqual(self.run_setup().returncode, 0)
        self.assertFalse((self.home / ".config").exists())

    def test_check_is_read_only(self):
        self.assertNotEqual(self.run_setup("--check").returncode, 0)
        self.assertFalse(self.home.exists())

    def test_stow_accepts_installed_claude_adapter(self):
        self.assertEqual(self.run_setup().returncode, 0)
        result = subprocess.run(
            ["stow", "--restow", "--dir", str(self.repo), "--target", str(self.home), "claude"],
            capture_output=True, text=True,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.run_setup("--check").returncode, 0)


if __name__ == "__main__":
    unittest.main()
