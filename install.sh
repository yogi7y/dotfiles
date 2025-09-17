#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if Homebrew is installed, install if it's not
if ! command_exists brew; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew is already installed."
fi

# Install required packages
echo "Installing required packages..."
brew install \
  neovim \
  tmux \
  zsh \
  starship \
  fzf \
  zoxide \
  eza \
  git \
  lua \
  stow

# Install Zsh plugins
echo "Installing Zsh plugins..."
brew install zsh-autosuggestions zsh-syntax-highlighting

# Install Tmux Plugin Manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "Installing Tmux Plugin Manager..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  echo "Tmux Plugin Manager is already installed."
fi

# Install Neovim plugin manager (lazy.nvim)
if [ ! -d "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy/lazy.nvim" ]; then
  echo "Installing lazy.nvim..."
  git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/lazy/lazy.nvim
else
  echo "lazy.nvim is already installed."
fi

# Set up Zsh as the default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Setting Zsh as the default shell..."
  chsh -s "$(which zsh)"
else
  echo "Zsh is already the default shell."
fi

# Stow dotfiles
echo "Stowing dotfiles..."
stow nvim
stow starship
stow wezterm
stow tmux
stow zsh
stow git
stow claude

echo "Installation complete! Please restart your terminal or run 'source ~/.zshrc' to apply changes."
