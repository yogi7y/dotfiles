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

## Layout

Each top-level directory is a stow package mirroring the `$HOME` layout (e.g.
`aerospace/`, `zsh/`, `git/`). Edit files inside the package, not the deployed symlinks.

VS Code and Cursor share one config: the canonical `settings.json`/`keybindings.json` live in
the `vscode` package, and the `cursor` package symlinks to them.
