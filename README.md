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

## Disabled Neovim Plugins
We keep disabled plugin specs in a separate folder to reduce clutter and avoid loading them.

- Location: `nvim/.config/nvim/lua/plugins/_disabled/`
- Why: Specs in this folder typically have `enabled = false` and are not loaded by Lazy.nvim, keeping startup clean.
- Re-enable a plugin:
  - Move its spec back to `nvim/.config/nvim/lua/plugins/`
  - Set `enabled = true` inside the spec
  - Restart Neovim or run `:Lazy sync`
- Disable again:
  - Set `enabled = false` and optionally move the spec back to `_disabled/`
- Notes:
  - Some disabled specs may reference Snacks functions. That’s fine—they won’t execute while disabled.
  - File locations matter only for your organization. Lazy.nvim discovers specs anywhere under `lua/`.
