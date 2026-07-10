# Dotfiles

Personal dotfiles managed with GNU Stow. Each top-level directory is a Stow package
(e.g. `aerospace/`, `zsh/`, `git/`) whose contents mirror the target layout under `$HOME`.

## Rules

- **Keep this repo free of secrets and proprietary information.** Dotfiles are portable
  config only. Never commit credentials, tokens, internal hostnames/domains, private URLs,
  or any employer-proprietary or confidential data.

## Working here

- Edit the file inside the Stow package (e.g. `aerospace/.config/aerospace/aerospace.toml`),
  not the deployed symlink/hardlink under `~`. Live configs point at the repo, so changes
  apply immediately.
- Reload the relevant app after config changes (e.g. `aerospace reload-config`,
  `tmux source-file ~/.tmux.conf`).
