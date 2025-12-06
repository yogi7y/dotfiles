# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository that uses GNU Stow for symlink management. The repository contains configuration files for various development tools including Neovim, tmux, Zsh, WezTerm, VSCode, and more.

## Common Commands

### Installation and Setup
```bash
# Initial setup (installs Homebrew packages and symlinks configs)
./install.sh

# Symlink individual configurations using stow
stow nvim      # Neovim config
stow tmux      # tmux config
stow zsh       # Zsh config (.zshrc)
stow wezterm   # WezTerm terminal config
stow starship  # Starship prompt config
stow git       # Git config

# Remove symlinks
stow -D nvim   # Unstow a configuration
```

### VSCode Extensions Management
```bash
# Update extensions list
./vscode/update-extensions.sh

# Install extensions from list
./vscode/install-extensions.sh
```

### Python Scripts and Testing
```bash
# Run Python tests
cd scripts/python
pytest tests/

# Run specific test
pytest tests/test_concat_files.py
```

## Repository Structure

The repository uses a stow-friendly directory structure where each tool has its own directory containing the expected file hierarchy:

- `nvim/` - Contains `.config/nvim/` with Neovim configuration
- `tmux/` - Contains `.config/tmux/` with tmux configuration
- `zsh/` - Contains `.zshrc` for Zsh shell configuration
- `wezterm/` - Contains `.config/wezterm/wezterm.lua` for WezTerm terminal
- `starship/` - Starship prompt configuration
- `git/` - Git configuration files
- `vscode/` - VSCode settings and extension management scripts
- `scripts/` - Utility scripts in Python and JavaScript
  - `python/` - Python utilities with pytest tests
  - `javascript/` - JavaScript utilities

## Key Technical Details

1. **Symlink Management**: Uses GNU Stow v2.4.1 for managing symlinks. Each directory represents a "package" that gets symlinked to the home directory maintaining the internal structure.

2. **Installation Script**: The `install.sh` script handles:
   - Homebrew installation check
   - Package installation (neovim, tmux, zsh, starship, fzf, zoxide, eza, git, lua, stow)
   - Zsh plugin installation (autosuggestions, syntax-highlighting)
   - TPM (Tmux Plugin Manager) setup
   - lazy.nvim (Neovim plugin manager) installation
   - Automatic stowing of configurations

3. **Python Development**: The `scripts/python/` directory contains Python utilities with a proper test structure using pytest.

4. **Neovim Setup**: Uses lazy.nvim as the plugin manager, which gets installed to `~/.local/share/nvim/lazy/lazy.nvim`

5. **tmux Setup**: Uses TPM (Tmux Plugin Manager) installed at `~/.tmux/plugins/tpm`

6. **Shell Navigation**: Use `builtin cd` instead of `cd` for directory navigation. The `cd` command is aliased to zoxide, which may not be available in the shell environment.

## Code Style Guidelines

### Configuration Comments
**ALWAYS add comments when making configuration changes** to explain what each setting does:
- Add a brief comment above or inline with each configuration option
- Comments should explain the purpose and effect of the setting
- Keep comments concise but informative

Examples:
```lua
-- Enable relative line numbers for easier navigation
vim.opt.relativenumber = true

-- Set tab width to 2 spaces for consistency
vim.opt.tabstop = 2
```

```bash
# Enable syntax highlighting in less
export LESS='-R'

# Use zoxide for smarter directory navigation
alias cd='z'
```