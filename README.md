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

## Required: Tree-sitter CLI (npm)
Install the Tree-sitter CLI to support parser tasks in this setup.

- Prerequisite: Node.js 18+ installed (via asdf, Homebrew, or nvm).
- Global install:
  - `npm install -g tree-sitter-cli@^0.25.10`
  - `tree-sitter --version` should print the installed version
- Ad-hoc usage (if you prefer not to install globally):
  - `npx -y tree-sitter-cli@^0.25.10 --help`
