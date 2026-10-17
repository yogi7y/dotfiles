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
| `make stow` | Symlink config packages and apply portable AI settings |
| `make extensions` | Install VS Code / Cursor extensions |
| `make update` | Update brew packages, re-stow and apply AI settings |
| `make ai-export` | Capture portable Codex and CodexBar settings |
| `make ai-apply` | Restore portable AI settings on this machine |
| `make aerospace-personal` | Use the personal AeroSpace config on this machine |

## Layout

Each top-level directory is a stow package mirroring the `$HOME` layout (e.g.
`aerospace/`, `zsh/`, `git/`). Edit files inside the package, not the deployed symlinks.

VS Code and Cursor share one config: the canonical `settings.json`/`keybindings.json` live in
the `vscode` package, and the `cursor` package symlinks to them.

AeroSpace uses `aerospace/config/personal.toml` and is **not** stowed. After install, link it
with `make aerospace-personal`.

## Codex and CodexBar

- On the machine with the settings to share, run `make ai-export`, review `git diff`, then commit and push the changes.
- On the other machine, pull the repo and run `make ai-apply`. Initial setup and `make stow` also apply the snapshots.
- Quit both apps before applying; reopen them afterward. Settings changes in the apps need another export before Git can sync them. No background sync or automatic commits are installed.
- `codex/settings.toml` shares model defaults, allowlisted desktop preferences and plugin enablement. `codex/AGENTS.md` and `codex/keybindings.json` share instructions and shortcuts.
- Local Codex MCP servers, marketplaces, credentials, hooks, project trust, sessions and databases stay on each machine. Install the same plugins and local tools separately.
- `codexbar/providers.json` shares provider ordering, enablement and region. Existing local credentials and other provider fields are preserved; providers absent from the snapshot stay at the end.
- `codexbar/preferences.json` uses CodexBar's allowlisted portable UI export. Install CodexBar before applying UI preferences; the CLI is found in PATH or the app bundle.
- Existing files changed by apply are backed up under `~/.local/state/dotfiles-ai/backups/`. CodexBar's prior portable UI preferences are backed up before import.
- `codex/` and `codexbar/` contain snapshots, not Stow packages. Do not stow their runtime directories or add authentication files to them.
- Review every export for private information, including edits to instructions and shortcuts.
