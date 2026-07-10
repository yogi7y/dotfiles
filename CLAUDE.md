# Dotfiles

Personal dotfiles managed with GNU Stow. Each top-level directory is a Stow package
(e.g. `aerospace/`, `zsh/`, `git/`) whose contents mirror the target layout under `$HOME`.

## Rules

- **Keep this repo free of secrets and proprietary information.** Dotfiles are portable
  config only. Never commit credentials, tokens, internal hostnames/domains, private URLs,
  or any employer-proprietary or confidential data.

## Setup (new machine)

```bash
git clone <repo> ~/dotfiles && cd ~/dotfiles && make install
```

`make install` runs `bootstrap.sh`: installs Homebrew, applies the `Brewfile`, stows every
package, installs tmux + editor plugins. Every step is idempotent (safe to re-run). Run
`make help` for individual targets (`brew`, `stow`, `extensions`, `update`). Heavy apps
(Docker, Android Studio, …) are intentionally not in the Brewfile — install those manually.

## Working here

- Edit the file inside the Stow package (e.g. `aerospace/.config/aerospace/aerospace.toml`),
  not the deployed symlink/hardlink under `~`. Live configs point at the repo, so changes
  apply immediately.
- Reload the relevant app after config changes (e.g. `aerospace reload-config`,
  `tmux source-file ~/.tmux.conf`).
- **VS Code + Cursor share one config.** The canonical `settings.json`/`keybindings.json`
  live in the `vscode` package; the `cursor` package's copies are symlinks to them. Edit the
  `vscode` files; both editors update. Editor-specific keys are harmlessly ignored by the other.
- **AeroSpace is per-machine and NOT stowed.** Full configs live in `aerospace/config/`
  (`personal.toml`, `work.toml`). Select one per machine with `make aerospace-personal` or
  `make aerospace-work` — it symlinks `~/.config/aerospace/aerospace.toml` to that file (so
  edits are still live, and AeroSpace auto-reloads). Machine-specific rules (e.g. Chrome →
  different workspace) go in the respective file; shared changes must be mirrored into both.
- Add a Homebrew tool by adding a line to `Brewfile`; add an editor extension via
  `editor/extensions.txt`.
