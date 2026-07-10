#!/usr/bin/env bash
#
# bootstrap.sh — set up this machine from the dotfiles repo.
# Safe to re-run: every step checks first and skips work that's already done.
#
# Usage: ./bootstrap.sh
#
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

# Stow packages to link into $HOME (top-level dirs that mirror the home layout).
STOW_PACKAGES=(aerospace atuin claude cursor ghostty git karabiner starship tmux vscode zsh)

info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
skip() { printf '\033[1;33m--\033[0m  %s\n' "$1"; }
ok()   { printf '\033[1;32mok\033[0m  %s\n' "$1"; }

# ---------- 1. Homebrew ----------
if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Make brew available in this shell (Apple Silicon path; falls back to Intel).
  if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then eval "$(/usr/local/bin/brew shellenv)"; fi
else
  skip "Homebrew already installed"
fi

# ---------- 2. Brew packages ----------
# Newer Homebrew (with HOMEBREW_REQUIRE_TAP_TRUST, common on managed machines) refuses to
# load third-party taps until trusted. Trust every tap declared in the Brewfile.
info "Trusting third-party taps…"
grep -E '^tap "' "$DOTFILES_DIR/Brewfile" | sed -E 's/^tap "([^"]+)".*/\1/' | while read -r tap; do
  brew trust "$tap" >/dev/null 2>&1 || true
done

info "Installing packages from Brewfile (skips what's already present)…"
brew bundle --file="$DOTFILES_DIR/Brewfile"
ok "Brewfile applied"

# ---------- 3. Git submodules (e.g. tmux tpm) ----------
if [ -f .gitmodules ]; then
  info "Syncing git submodules…"
  git submodule update --init --recursive
fi

# ---------- 4. Stow packages ----------
info "Linking config with stow…"
for pkg in "${STOW_PACKAGES[@]}"; do
  if [ -d "$pkg" ]; then
    stow --restow --target="$HOME" "$pkg"
    ok "stowed $pkg"
  fi
done

# ---------- 5. tmux plugins (tpm) ----------
if [ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
  info "Installing tmux plugins…"
  "$HOME/.tmux/plugins/tpm/bin/install_plugins"
fi

# ---------- 6. Editor extensions ----------
EXT_FILE="$DOTFILES_DIR/editor/extensions.txt"
if [ -f "$EXT_FILE" ]; then
  for editor in code cursor; do
    if command -v "$editor" >/dev/null 2>&1; then
      info "Installing $editor extensions…"
      installed="$("$editor" --list-extensions 2>/dev/null || true)"
      while IFS= read -r ext; do
        [ -z "$ext" ] && continue
        if grep -qix "$ext" <<<"$installed"; then
          skip "$editor: $ext"
        else
          "$editor" --install-extension "$ext" --force >/dev/null && ok "$editor: $ext"
        fi
      done < "$EXT_FILE"
    else
      skip "$editor CLI not found — skipping its extensions"
    fi
  done
fi

# ---------- 7. Reload aerospace if running ----------
if command -v aerospace >/dev/null 2>&1 && aerospace list-windows >/dev/null 2>&1; then
  aerospace reload-config && ok "aerospace config reloaded"
fi

info "Done. Note: shell plugins (zinit) install on first new shell; language runtimes (rbenv/fvm versions) are installed per-project."
