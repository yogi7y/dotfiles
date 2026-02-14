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

alias code="cursor"


# ---------- Starship ----------
eval "$(starship init zsh)"

# ---------- BAT ----------
export BAT_THEME="Catppuccin Mocha"


# ---------- FZF ----------
eval "$(fzf --zsh)"

# ---------- Atuin + FZF History ----------
atuin-setup() {
    if ! command -v atuin &> /dev/null; then
        echo "atuin not found. Please install it first."
        return 1
    fi

    bindkey '^E' _atuin_search_widget

    export ATUIN_NOBIND="true"
    eval "$(atuin init zsh)"

    fzf-atuin-history-widget() {
        local selected
        setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

        local atuin_opts="--cmd-only"
        local fzf_opts=(
            --height=40%
            --layout=reverse
            --tac
            "-n2..,.."
            --tiebreak=index
            "--query=${LBUFFER}"
            "+m"
            "--bind=ctrl-d:reload(atuin search $atuin_opts -c $PWD),ctrl-r:reload(atuin search $atuin_opts)"
        )

        selected=$(
            eval "atuin search ${atuin_opts}" |
                fzf "${fzf_opts[@]}"
        )

        if [ -n "$selected" ]; then
            LBUFFER+="${selected}"
        fi

        zle reset-prompt
        return $?
    }

    zle -N fzf-atuin-history-widget
    bindkey '^R' fzf-atuin-history-widget

    # Bind fzf-atuin-history-widget to Ctrl+R in both vi insert and normal modes
    bindkey -M viins '^R' fzf-atuin-history-widget  # Insert mode
    bindkey -M vicmd '^R' fzf-atuin-history-widget  # Normal mode
}

atuin-setup


# ---------- rbenv ----------
eval "$(rbenv init - zsh)"
