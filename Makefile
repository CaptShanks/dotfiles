.PHONY: help install install-all check-system install-brew install-packages install-zsh install-nvim install-tmux install-starship install-wezterm install-k9s install-opencode install-dev-tools stow-all unstow-all clean

# Variables
DOTFILES_DIR := $(PWD)
HOME_DIR := $(HOME)
BREW_PREFIX := /opt/homebrew
INTEL_BREW_PREFIX := /usr/local/homebrew

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# Check if running on Apple Silicon
ARCH := $(shell uname -m)
IS_ARM64 := $(shell test "$(ARCH)" = "arm64" && echo "yes" || echo "no")

# Stow packages (directory names in dotfiles)
STOW_PACKAGES := zsh tmux wezterm nvim starship k9s opencode

help: ## Show this help message
	@echo "$(BLUE)Dotfiles Makefile for Mac M1/Apple Silicon$(NC)"
	@echo "============================================"
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-20s$(NC) %s\n", $$1, $$2}'
	@echo
	@echo "$(YELLOW)Architecture detected: $(ARCH)$(NC)"
	@echo "$(YELLOW)ARM64 optimized: $(IS_ARM64)$(NC)"
	@echo
	@echo "$(BLUE)Available stow packages:$(NC) $(STOW_PACKAGES)"

check-system: ## Check system requirements and architecture
	@echo "$(BLUE)Checking system requirements...$(NC)"
	@echo "Architecture: $(ARCH)"
	@echo "macOS Version: $$(sw_vers -productVersion)"
	@if [ "$(IS_ARM64)" = "yes" ]; then \
		echo "$(GREEN)✓ Apple Silicon detected - ARM64 optimizations enabled$(NC)"; \
	else \
		echo "$(YELLOW)⚠ Intel Mac detected - some optimizations may not apply$(NC)"; \
	fi
	@if ! command -v xcode-select >/dev/null 2>&1 || ! xcode-select -p >/dev/null 2>&1; then \
		echo "$(RED)✗ Xcode Command Line Tools not installed$(NC)"; \
		echo "Run: xcode-select --install"; \
		exit 1; \
	else \
		echo "$(GREEN)✓ Xcode Command Line Tools installed$(NC)"; \
	fi
	@if ! command -v stow >/dev/null 2>&1; then \
		echo "$(RED)✗ GNU Stow not installed$(NC)"; \
		echo "Run: brew install stow"; \
		exit 1; \
	else \
		echo "$(GREEN)✓ GNU Stow installed$(NC)"; \
	fi

install-brew: check-system ## Install Homebrew (ARM64 and Intel)
	@echo "$(BLUE)Installing Homebrew...$(NC)"
	@if ! command -v $(BREW_PREFIX)/bin/brew >/dev/null 2>&1; then \
		echo "Installing ARM64 Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		eval "$$($(BREW_PREFIX)/bin/brew shellenv)"; \
	else \
		echo "$(GREEN)✓ ARM64 Homebrew already installed$(NC)"; \
	fi
	@if [ "$(IS_ARM64)" = "yes" ] && [ ! -d "$(INTEL_BREW_PREFIX)" ]; then \
		echo "$(YELLOW)Installing Intel Homebrew for compatibility...$(NC)"; \
		arch -x86_64 /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || true; \
		if [ -d "$(INTEL_BREW_PREFIX)" ]; then \
			echo "$(GREEN)✓ Intel Homebrew installed$(NC)"; \
		fi; \
	fi

install-packages: install-brew ## Install essential packages via Homebrew
	@echo "$(BLUE)Installing essential packages...$(NC)"
	@eval "$$($(BREW_PREFIX)/bin/brew shellenv)" && \
	$(BREW_PREFIX)/bin/brew install \
		stow \
		git \
		neovim \
		tmux \
		starship \
		fzf \
		fd \
		ripgrep \
		eza \
		zoxide \
		thefuck \
		go \
		nvm \
		kubectl \
		helm \
		k9s \
		awscli \
		jq \
		yq \
		tree \
		htop \
		curl \
		wget \
		mysql-client \
		atuin \
		displayplacer \
		carapace
	@echo "$(GREEN)✓ Essential packages installed$(NC)"

stow-all: check-system ## Stow all configuration packages
	@echo "$(BLUE)Stowing all configurations...$(NC)"
	@for package in $(STOW_PACKAGES); do \
		if [ -d "$$package" ]; then \
			echo "Stowing $$package..."; \
			stow -t $(HOME_DIR) $$package; \
		else \
			echo "$(YELLOW)⚠ Package $$package not found, skipping$(NC)"; \
		fi; \
	done
	@echo "$(GREEN)✓ All configurations stowed$(NC)"

unstow-all: ## Unstow all configuration packages
	@echo "$(BLUE)Unstowing all configurations...$(NC)"
	@for package in $(STOW_PACKAGES); do \
		if [ -d "$$package" ]; then \
			echo "Unstowing $$package..."; \
			stow -t $(HOME_DIR) -D $$package; \
		fi; \
	done
	@echo "$(GREEN)✓ All configurations unstowed$(NC)"

stow-%: ## Stow a specific package (e.g., make stow-zsh)
	@package=$(subst stow-,,$@); \
	if [ -d "$$package" ]; then \
		echo "$(BLUE)Stowing $$package...$(NC)"; \
		stow -t $(HOME_DIR) $$package; \
		echo "$(GREEN)✓ $$package stowed$(NC)"; \
	else \
		echo "$(RED)✗ Package $$package not found$(NC)"; \
		exit 1; \
	fi

unstow-%: ## Unstow a specific package (e.g., make unstow-zsh)
	@package=$(subst unstow-,,$@); \
	if [ -d "$$package" ]; then \
		echo "$(BLUE)Unstowing $$package...$(NC)"; \
		stow -t $(HOME_DIR) -D $$package; \
		echo "$(GREEN)✓ $$package unstowed$(NC)"; \
	else \
		echo "$(RED)✗ Package $$package not found$(NC)"; \
		exit 1; \
	fi

restow-%: ## Restow a specific package (e.g., make restow-zsh)
	@package=$(subst restow-,,$@); \
	if [ -d "$$package" ]; then \
		echo "$(BLUE)Restowing $$package...$(NC)"; \
		stow -t $(HOME_DIR) -R $$package; \
		echo "$(GREEN)✓ $$package restowed$(NC)"; \
	else \
		echo "$(RED)✗ Package $$package not found$(NC)"; \
		exit 1; \
	fi

install-zsh: ## Install and configure Zsh with Oh My Zsh
	@echo "$(BLUE)Setting up Zsh...$(NC)"
	@if [ ! -d "$(HOME_DIR)/.oh-my-zsh" ]; then \
		echo "Installing Oh My Zsh..."; \
		sh -c "$$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
	else \
		echo "$(GREEN)✓ Oh My Zsh already installed$(NC)"; \
	fi
	@echo "Installing Zsh plugins..."
	@if [ ! -d "$(HOME_DIR)/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then \
		git clone https://github.com/zsh-users/zsh-autosuggestions $(HOME_DIR)/.oh-my-zsh/custom/plugins/zsh-autosuggestions; \
	fi
	@if [ ! -d "$(HOME_DIR)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then \
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $(HOME_DIR)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting; \
	fi
	@if [ ! -d "$(HOME_DIR)/.oh-my-zsh/custom/plugins/fzf-tab" ]; then \
		git clone https://github.com/Aloxaf/fzf-tab $(HOME_DIR)/.oh-my-zsh/custom/plugins/fzf-tab; \
	fi
	@if [ ! -d "$(HOME_DIR)/.oh-my-zsh/custom/plugins/ohmyzsh-full-autoupdate" ]; then \
		git clone https://github.com/Pilaton/OhMyZsh-full-autoupdate.git $(HOME_DIR)/.oh-my-zsh/custom/plugins/ohmyzsh-full-autoupdate; \
	fi
	@echo "$(GREEN)✓ Zsh and plugins installed$(NC)"

install-dev-tools: ## Install additional development tools
	@echo "$(BLUE)Setting up development environment...$(NC)"
	@if [ ! -d "$(HOME_DIR)/.nvm" ]; then \
		echo "Setting up NVM..."; \
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash; \
	fi
	@if [ ! -f "$(HOME_DIR)/.fzf.zsh" ]; then \
		echo "Setting up FZF key bindings..."; \
		$(BREW_PREFIX)/opt/fzf/install --all; \
	fi
	@echo "$(GREEN)✓ Development tools configured$(NC)"

install-all: install-packages install-zsh install-dev-tools stow-all ## Install everything and stow configs
	@echo "$(GREEN)================================$(NC)"
	@echo "$(GREEN)✓ All dotfiles installed successfully!$(NC)"
	@echo "$(GREEN)================================$(NC)"
	@echo
	@echo "$(YELLOW)Next steps:$(NC)"
	@echo "1. Restart your terminal or run: source ~/.zshrc"
	@echo "2. Open Neovim and run: :Lazy sync"
	@echo "3. Open Tmux and press prefix + I to install plugins"
	@echo "4. Set up your Git user: git config --global user.name 'Your Name'"
	@echo "5. Set up your Git email: git config --global user.email 'your@email.com'"

install: install-all ## Alias for install-all

clean: unstow-all ## Remove all symlinks using stow
	@echo "$(GREEN)✓ All symlinks removed$(NC)"

update: ## Update dotfiles repository and restow configs
	@echo "$(BLUE)Updating dotfiles...$(NC)"
	@git pull origin main
	@$(MAKE) stow-all
	@echo "$(GREEN)✓ Dotfiles updated$(NC)"

info: ## Show system and installation info
	@echo "$(BLUE)System Information:$(NC)"
	@echo "Architecture: $(ARCH)"
	@echo "macOS Version: $$(sw_vers -productVersion)"
	@echo "Dotfiles Directory: $(DOTFILES_DIR)"
	@echo "ARM64 Brew: $(BREW_PREFIX)"
	@echo "Intel Brew: $(INTEL_BREW_PREFIX)"
	@echo
	@echo "$(BLUE)Stow Packages:$(NC) $(STOW_PACKAGES)"
	@echo
	@echo "$(BLUE)Installation Status:$(NC)"
	@for package in $(STOW_PACKAGES); do \
		if [ -L "$(HOME_DIR)/.config/$$package" ] || [ -L "$(HOME_DIR)/.$$package" ] || [ -L "$(HOME_DIR)/.zshrc" ] || [ -L "$(HOME_DIR)/.tmux.conf" ] || [ -L "$(HOME_DIR)/.wezterm.lua" ]; then \
			echo "$(GREEN)✓ $$package configured$(NC)"; \
		else \
			echo "$(RED)✗ $$package not configured$(NC)"; \
		fi; \
	done
