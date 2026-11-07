# dotfiles

Personal macOS dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Install

```bash
git clone git@github.com:yogi7y/dotfiles.git ~/dotfiles
cd ~/dotfiles
make install
```

`make install` installs Homebrew, applies the `Brewfile`, symlinks every config with stow,
and installs tmux + editor plugins. It's idempotent — safe to re-run any time.

Heavy apps (Docker, Android Studio, …) are intentionally left out of the `Brewfile`; install
those manually.

## Common tasks

| Command | What it does |
|---------|--------------|
| `make help` | List all targets |
| `make brew` | Install/update Homebrew packages from the `Brewfile` |
| `make stow` | Symlink all config packages into `$HOME` |
| `make extensions` | Install VS Code / Cursor extensions |
| `make update` | Update brew packages, then re-stow |
| `make aerospace-personal` | Use the personal AeroSpace config on this machine |

## Layout

Each top-level directory is a stow package mirroring the `$HOME` layout (e.g.
`aerospace/`, `zsh/`, `git/`). Edit files inside the package, not the deployed symlinks.

VS Code and Cursor share one config: the canonical `settings.json`/`keybindings.json` live in
the `vscode` package, and the `cursor` package symlinks to them.

AeroSpace uses `aerospace/config/personal.toml` and is **not** stowed. After install, link it
with `make aerospace-personal`.

## AI instructions and skills

- **Convention:** Follow [AGENTS.md](https://github.com/agentsmd/agents.md) for shared
  instructions and [Agent Skills](https://agentskills.io/specification) for portable
  skills. Codex and Claude are configured together; switching tools needs no command.
- **Setup:** Run `make ai` once on an existing machine. `make install` and `make stow`
  also run it. Start fresh tool sessions afterward. Use `make ai-check` to verify links.
  If Stow reports unrelated existing config conflicts, reconcile those separately;
  `make ai` works independently and does not replace provider settings.
- **Global rules:** Edit `ai/.config/ai/AGENTS.md`. Both tools read this source through
  their personal instruction paths. Existing response, Git, and Flutter preferences
  are consolidated here. Keep the file self-contained; imports are not universal.
- **Project rules:** Commit `AGENTS.md` inside each project. Use nested files for
  directory-specific guidance. For Claude compatibility, put `@AGENTS.md` in the
  project's `CLAUDE.md`. Keep branch targets and project commands in project rules.
- **Shared skills:** Add a portable skill folder under `ai/.config/ai/skills/`, with
  its `SKILL.md` and supporting resources, then run `make ai`. Each skill is linked
  individually into Codex's `~/.agents/skills/` and Claude's `~/.claude/skills/`.
  Editing an existing skill needs no relinking. After deleting or renaming a skill,
  remove its obsolete links from both tools and rerun `make ai`.
- **Existing skills:** Provider-synced and built-in skills remain provider-managed.
  They are not copied into this repository. Audit tool dependencies and private
  content before moving a skill into the shared collection, which starts empty.
- **New tools:** Add the tool's documented global instruction and skill paths to
  the setup adapter, verify discovery, then run `make ai`. This is one-time onboarding,
  not a step when switching tools. No other providers are configured yet.
- **Backups:** Conflicting destination files or individual skill folders are moved to
  `~/.local/state/dotfiles/ai-backups/` before linking. Review backups for unique
  preferences. Other provider settings and skill directories are preserved.
- **Overrides:** Setup stops for a nonempty Codex `AGENTS.override.md` or a custom
  `CODEX_HOME`; reconcile those explicitly before installing the default adapter.
- **Limits:** Permissions, hooks, credentials, and automatic memories are separate.
  Tool-specific skill features need adaptation. Remote/cloud sessions need their own
  provisioning; local links do not travel with Git. `make unstow` removes Stow-owned
  links, not the additional links created by `make ai`.
- **Verification:** Run `python3 -m unittest discover -s scripts -p 'test_*.py'` for
  isolated migration checks. In fresh Codex and Claude sessions, verify global and
  project instructions in two projects, then confirm a global edit is visible.

Loading references: [Codex](https://learn.chatgpt.com/docs/agent-configuration/agents-md),
[Claude Code](https://code.claude.com/docs/en/memory).
