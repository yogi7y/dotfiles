# --------- Zinit Plugin Manager ----------
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33}Installing zinit…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
fi
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"


# ---------- PATH ----------
export PATH="$HOME/.local/bin:$PATH"


# ---------- Plugins ----------
zinit light zsh-users/zsh-syntax-highlighting  # Syntax highlighting — colors commands as you type (red = invalid, green = valid)
zinit light zsh-users/zsh-autosuggestions  # Autosuggestions — suggests commands from your history as you type (press → to accept)
zinit light zsh-users/zsh-completions  # Completions — better tab completion for hundreds of tools


# ---------- History ----------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY          # share history across all sessions
setopt HIST_IGNORE_ALL_DUPS   # remove older duplicates
setopt HIST_IGNORE_SPACE      # don't save commands starting with space


# ---------- General Settings ----------
setopt AUTO_CD                # type a folder name to cd into it
setopt CORRECT                # suggest corrections for typos
autoload -Uz compinit && compinit  # enable completion system


# ---------- Aliases ----------
alias ls="eza --icons"
alias ll="eza -la --icons --git"
alias lt="eza --tree --level=2 --icons"

alias cat="bat"


# ---------- Starship ----------
eval "$(starship init zsh)"

# ---------- BAT ----------
export BAT_THEME="Catppuccin Mocha"

