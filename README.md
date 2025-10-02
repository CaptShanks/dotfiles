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
