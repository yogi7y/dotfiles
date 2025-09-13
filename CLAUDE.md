# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository containing configuration files for a macOS development environment. The repository uses GNU Stow for managing dotfiles symlinks and includes configurations for terminal, editor, window management, and development tools.

## Installation and Setup Commands

- **Install all dependencies and configure system**: `./install.sh`
- **Stow specific configurations**: `stow <package>` (e.g., `stow nvim`, `stow zsh`)
- **Check stow status**: `stow -nv <package>` (dry run to see what would be linked)

## Repository Structure

- **Configuration packages**: Each directory (nvim, zsh, tmux, etc.) contains config files that get stowed to appropriate locations in $HOME
- **Scripts**: Custom automation scripts in `scripts/python/` and `scripts/javascript/`
- **Package management**: Simple Node.js project with minimal dependencies (primarily html-to-text for scripts)

## Key Configuration Areas

### Terminal & Shell (zsh/)
- Zsh configuration with custom prompt via Starship
- Uses zsh-autosuggestions and zsh-syntax-highlighting plugins
- Configured with fzf, zoxide, and eza for enhanced navigation

### Window Management (aerospace/)
- AeroSpace tiling window manager configuration
- Vim-like keybindings (hjkl) with Alt modifier
- Workspace switching with Alt+1-9
- App-specific floating window rules for Finder, WhatsApp, YouTube Music, LocalSend

### Terminal Emulator (wezterm/)
- WezTerm configuration with Catppuccin Mocha theme
- JetBrains Mono font at 16pt
- Custom keybinding: Cmd+K for clear command

### Editor (nvim.bak/)
- Neovim configuration using lazy.nvim plugin manager
- Note: Main nvim config may be managed elsewhere as this is marked as .bak

### Version Control (git/)
- Git configuration and aliases
- Stored in git/.config/git/ and git/.gitconfig

### Other Tools
- **tmux/**: Terminal multiplexer configuration
- **starship/**: Cross-shell prompt configuration  
- **vscode/**: VS Code extensions management scripts
- **karabiner/**: Keyboard customization (Karabiner-Elements)

## Development Workflow

When working with this dotfiles repository:

1. Use `stow -nv <package>` to preview changes before applying
2. Test configuration changes in a new terminal session
3. The install.sh script handles dependency installation via Homebrew
4. Configuration files follow XDG Base Directory specification where possible

## Important Notes

- This is a macOS-specific setup (uses Homebrew, macOS applications)
- Some configurations expect specific applications to be installed (WezTerm, AeroSpace, etc.)
- The repository uses Stow for symlink management - avoid manually copying files
- Python and JavaScript automation scripts are available in scripts/ directory