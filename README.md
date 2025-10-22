# dotfiles

## Installation with GNU Stow

Install configuration files using [GNU Stow](https://www.gnu.org/software/stow/):

```bash
# Install all configurations
stow */

# Install specific configurations
stow nvim
stow tmux
stow zsh

# Remove configurations
stow -D nvim
```

Each directory represents a stow package that will be symlinked to `$HOME`.

## Optional: Tree-sitter CLI (npm)
This repo does not track node_modules or package manifests. If you need the Tree-sitter CLI for parser tasks:

- Prerequisite: Node.js 18+ installed (via asdf, Homebrew, or nvm).
- Global install:
  - `npm install -g tree-sitter-cli@^0.25.10`
  - `tree-sitter --version`
- Ad-hoc usage (no global install):
  - `npx -y tree-sitter-cli@^0.25.10 --help`

Note: For normal Neovim usage, nvim-treesitter handles parsers via `:TSUpdate` and does not require the CLI.
