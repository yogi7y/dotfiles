# Dotfiles

Personal dotfiles managed with GNU Stow. Each top-level directory is a Stow package
(e.g. `aerospace/`, `zsh/`, `git/`) whose contents mirror the target layout under `$HOME`.

## Rules

- **Keep this repo free of secrets and proprietary information.** Dotfiles are portable
  config only. Never commit credentials, tokens, internal hostnames/domains, private URLs,
  or any employer-proprietary or confidential data.

- **Don't add comments or docstrings that merely restate the code.** Aim for
  self-documenting, readable code so comments aren't needed to explain *what* it does. Only
  add a comment when it conveys something the code itself can't — the *why*, non-obvious
  context, trade-offs, gotchas, or intent. Think before adding one.

## Setup (new machine)

```bash
git clone <repo> ~/dotfiles && cd ~/dotfiles && make install
```

`make install` runs `bootstrap.sh`: installs Homebrew, applies the `Brewfile`, stows every
package, installs tmux + editor plugins. Every step is idempotent (safe to re-run). Run
`make help` for individual targets (`brew`, `stow`, `extensions`, `update`). Heavy apps
(Docker, Android Studio, …) are intentionally not in the Brewfile — install those manually.

## Working here

- Edit the file inside the Stow package (e.g. `ghostty/.config/ghostty/config`),
  not the deployed symlink/hardlink under `~`. Live configs point at the repo, so changes
  apply immediately.
- Reload the relevant app after config changes (e.g. `aerospace reload-config`,
  `tmux source-file ~/.tmux.conf`).
- **VS Code + Cursor share one config.** The canonical `settings.json`/`keybindings.json`
  live in the `vscode` package; the `cursor` package's copies are symlinks to them. Edit the
  `vscode` files; both editors update. Editor-specific keys are harmlessly ignored by the other.
- **AeroSpace is NOT stowed.** Its config lives in `aerospace/config/personal.toml`.
  Run `make aerospace-personal` to symlink `~/.config/aerospace/aerospace.toml` to it.
  Edit the repo file; changes are live and AeroSpace auto-reloads.
- Add a Homebrew tool by adding a line to `Brewfile`; add an editor extension via
  `editor/extensions.txt`.
