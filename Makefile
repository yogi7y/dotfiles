# Dotfiles — run `make` or `make help` to see targets.

# aerospace is intentionally excluded — its config is per-machine, selected with
# `make aerospace-personal` / `make aerospace-work` (see below), not stowed.
STOW_PACKAGES := atuin claude cursor ghostty git karabiner starship tmux vscode zsh

AEROSPACE_DIR := $(HOME)/.config/aerospace
AEROSPACE_OUT := $(AEROSPACE_DIR)/aerospace.toml

.DEFAULT_GOAL := help

.PHONY: help install brew stow unstow extensions update aerospace-personal aerospace-work

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

install: ## Full setup: Homebrew + packages + stow + plugins + extensions
	@./bootstrap.sh

brew: ## Install/update Homebrew packages from the Brewfile
	@brew bundle --file=Brewfile

stow: ## Symlink all config packages into $$HOME
	@stow --restow --target=$$HOME $(STOW_PACKAGES)

unstow: ## Remove the symlinks created by stow
	@stow --delete --target=$$HOME $(STOW_PACKAGES)

extensions: ## Install VS Code / Cursor extensions from editor/extensions.txt
	@for e in code cursor; do \
		command -v $$e >/dev/null 2>&1 || { echo "-- $$e not found, skipping"; continue; }; \
		echo "==> $$e extensions"; \
		while IFS= read -r ext; do [ -n "$$ext" ] && $$e --install-extension "$$ext" --force >/dev/null; done < editor/extensions.txt; \
	done

update: brew ## Refresh: update brew packages then re-stow
	@$(MAKE) stow

aerospace-personal: ## Use the personal AeroSpace config on this machine
	@[ -L "$(AEROSPACE_DIR)" ] && rm -f "$(AEROSPACE_DIR)" || true  # clear stale stow-folded symlink
	@mkdir -p "$(AEROSPACE_DIR)"
	@ln -sfn $(CURDIR)/aerospace/config/personal.toml $(AEROSPACE_OUT)
	@command -v aerospace >/dev/null 2>&1 && aerospace reload-config || true
	@echo "aerospace: using personal config"

aerospace-work: ## Use the work AeroSpace config on this machine
	@[ -L "$(AEROSPACE_DIR)" ] && rm -f "$(AEROSPACE_DIR)" || true  # clear stale stow-folded symlink
	@mkdir -p "$(AEROSPACE_DIR)"
	@ln -sfn $(CURDIR)/aerospace/config/work.toml $(AEROSPACE_OUT)
	@command -v aerospace >/dev/null 2>&1 && aerospace reload-config || true
	@echo "aerospace: using work config"
