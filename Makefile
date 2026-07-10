# Dotfiles — run `make` or `make help` to see targets.

STOW_PACKAGES := aerospace atuin claude cursor ghostty git karabiner starship tmux vscode zsh

.DEFAULT_GOAL := help

.PHONY: help install brew stow unstow extensions update

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

install: ## Full setup: Homebrew + packages + stow + plugins + extensions
	@./bootstrap.sh

brew: ## Install/update Homebrew packages from the Brewfile
	@grep -E '^tap "' Brewfile | sed -E 's/^tap "([^"]+)".*/\1/' | while read -r t; do brew trust "$$t" >/dev/null 2>&1 || true; done
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
