# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(
	fzf-tab
	zsh-syntax-highlighting
	vi-mode
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# enable vi mode
bindkey -v
# enable escape on jk in insert mode
bindkey -M viins 'jk' vi-cmd-mode
# https://github.com/mcornella/ohmyzsh/blob/master/plugins/vi-mode/README.md
VI_MODE_SET_CURSOR=true

# ZSH fix slow paste
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

# ZSH disable matches
setopt +o nomatch

# ZSH big history
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify



# ZSH do not add to history if things start with space
setopt HIST_IGNORE_SPACE

# ZSH disable AUTOCD
unsetopt AUTO_CD

# ZSH don't show "%" on partial lines
PROMPT_EOL_MARK=''

# ZSH disable matches
setopt +o nomatch

# fix slow paste (not sure if needed)
# zstyle ':bracketed-paste-magic' active-widgets '.self-*'

# theme https://starship.rs/guide/#%F0%9F%9A%80-installation
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# fzf https://github.com/junegunn/fzf#using-git
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fancy preview for fzf
export FZF_CTRL_R_OPTS="--preview 'echo {2..}'
  --preview-window wrap:top:20%
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-t:track+clear-query'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --height 60%
  --header 'Press CTRL-Y to copy ucommand into clipboard'"

# check if zoxide is installed and source it
if command -v zoxide >/dev/null 2>&1; then
	eval "$(zoxide init zsh)"
	alias cd='z'
fi

# this will search dev folders with some ignores
fcd() {
	local folder="$1" # Get the folder name from the first argument
	local selected_dir
	# is second argument is provided, set no_ignore variable to --no-ignore
	[[ -n "$2" ]] && local no_ignore="--no-ignore" || local no_ignore=""
	selected_dir=$(fd --type d $no_ignore --maxdepth 15 \
  -E '.vscode*' \
  -E '.idea*' \
  -E 'Library/*' \
  -E '_arch/*' \
  -E '.local/*' \
  -E 'node_modules/*' \
  -E 'bower_components/*' \
  -E 'public/*' \
  -E 'dist/*' \
  -E 'build/*' \
  -E 'target/*' \
  --hidden --strip-cwd-prefix --exclude .git \
  --base-directory $folder |	fzf +m --height 40%)
	cd "$folder/$selected_dir" || return

}
# Bind Ctrl+g to the fcd function with a folder of /dev/infrastructure
bindkey -s '^g' 'fcd $HOME no-ignore\n'

# Bind Ctrl+d to the fcd function with a folder of "Documents"
bindkey -s '^d' 'fcd $HOME/Documents/\n'

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}


# Brew
eval "$(/opt/homebrew/bin/brew shellenv)" # arm one
#eval "$(/usr/local/bin/brew shellenv)" # x86 one
# Intel Brew for components and are not supported on arm
alias brew64="arch -x86_64 /usr/local/homebrew/bin/brew"

export PATH=/usr/local/Homebrew/bin:$PATH # x86 path
export PATH=/opt/homebrew/bin:$PATH       # arm brew (takes precedence)

# DENO
export DENO_INSTALL="/Users/sjc-lp03742/.deno"

# thefuck
if command -v thefuck >/dev/null 2>&1; then
	eval "$(thefuck --alias)"
	eval "$(thefuck --alias fk)"
fi

# # clear tmux history and screen
# c() {
#    clear
#    tmux clear-history
# }


# GO
export GOPATH="${GOPATH:-$HOME/go}"
export PATH="$PATH:$GOPATH/bin"

# My BIN
export PATH=$PATH:$HOME/bin

# mysql
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# Krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# MC editor
export EDITOR=nvim

# disable AWS pager
export AWS_PAGER=""

# Aliases
alias k="kubectl"
alias ks="kubectl -n kube-system "
alias ka="kubectl --all-namespaces=true "
# Load kubectl completions
command -v kubectl >/dev/null 2>&1 && source <(kubectl completion zsh)
# Define alias
alias k=kubectl

#assume -- granted
alias ac="assume -c"
alias at="assume -t"
alias act="assume -c -t"

# Personal cursor
alias cursorperso='/Applications/Cursor_perso.app/Contents/MacOS/Cursor --user-data-dir=$HOME/.cursor-profile-2 --extensions-dir=$HOME/.cursor-profile-2/extensions'

# Enable completion for the alias
compdef k=kubectl
compdef ks=kubectl
compdef ka=kubectl

# Krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"


export TERRAPRISM_TOFU=true
alias t="terraprism"
alias ti="terraprism init"
alias ta="terraprism apply"
alias tp="terraprism plan"
alias td="terraprism destroy"
alias th="terraprism history"
alias to='terraprism output -json | jq "reduce to_entries[] as \$entry ({}; .[\$entry.key] = \$entry.value.value)"'


alias tf="terraprism"
alias tfi="terraprism init"
alias tfp="terraprism plan"
alias tfa="terraprism apply"
alias tfd="terraprism destroy"
alias tfh="terraprism history"
alias tfo='terraprism output -json | jq "reduce to_entries[] as \$entry ({}; .[\$entry.key] = \$entry.value.value)"'
alias n="nvim ."



# check if eza is installed start code block
if command -v eza >/dev/null 2>&1; then
	# eza is installed
	alias ls="eza --icons=auto"
fi

alias la='ls -lah'
alias ll='ls -lah'


# aws profile selector
alias aws-profile='export AWS_PROFILE=$(aws configure list-profiles | fzf)'
export AWS_PROFILE="gen3-com-root"
# kubectl context selector
alias kctx='kubectl config use-context $(kubectl config get-contexts -o name | fzf)'


# display
# alias display-restore='displayplacer "id:2997316B-A423-47EA-8390-865F1276C0E2 res:3440x1440 hz:100 color_depth:8 enabled:true scaling:off origin:(0,0) degree:0" "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1728x1117 hz:120 color_depth:8 enabled:true scaling:on origin:(-1728,323) degree:0" "id:33A9F171-8D5E-4A0A-8472-A882E0CEC299 res:1440x2560 hz:60 color_depth:8 enabled:true scaling:on origin:(3440,-466) degree:270"'

# krew
export PATH="${PATH}:${HOME}/.krew/bin"

# helm autocomplete
# source <(helm completion zsh)

# aws autocomplete
# only if installed
# [ -f $(which aws_completer) ] && complete -C $(which aws_completer) aws

# Idea fix to use COMMAND ARROWS
# bindkey "\e\eOD" beginning-of-line
# bindkey "\e\eOC" end-of-line

# Custom clear function to preservce scrollback
clearx() {
  for i in {3..$(tput lines)}
  do
    printf '\n'
  done
  zle clear-screen
}
zle -N clearx
bindkey '^L' clearx


# check if $TERM_PROGRAM == iTerm.app variable set to identify terminal

tmuxs () {
	if [[ -n "$TMUX" ]]; then
		return 0
	fi

	if [[ -n "$NVIM_LISTEN_ADDRESS" ]]; then
		echo "tmuxs skipped inside Neovim terminal"
		return 1
	fi

	local session="main"

	if ! tmux has-session -t "$session" 2>/dev/null; then
		tmux new-session -d -s "$session" -n "home" -c "$HOME"
		tmux new-window -d -t "${session}:2" -n "git" -c "$HOME/Documents/git/infrastructure/"
		tmux new-window -d -t "${session}:3" -n "rename1" -c "$HOME/Documents/git/"
		tmux new-window -d -t "${session}:4" -n "rename2" -c "$HOME/Documents/git/"
		tmux new-window -d -t "${session}:5" -n "rename3" -c "$HOME/Documents/git/"
		tmux new-window -d -t "${session}:6" -n "temp" -c "$HOME/temp"
		tmux new-window -d -t "${session}:7" -n "Downloads" -c "$HOME/Downloads"
		tmux new-window -d -t "${session}:8" -n "open" -c "$HOME"
	fi

	exec tmux attach-session -t "$session"
}
# TF autocomplete
# autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C terraform terraform

# carapace shell-autocomplete
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
command -v carapace >/dev/null 2>&1 && source <(carapace _carapace zsh)

# Check if stern is installed if so enable completion
# [ -f $(which stern) ] && source <(stern --completion=zsh)
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# export PATH="${HOME}/.local/bin":${PATH}

export PATH="/usr/local/bin:$PATH"
. "/Users/sjc-lp03742/.deno/env"

export K9S_CONFIG_DIR="$HOME/.config/k9s"
export K9S_FEATURE_GATE_NODE_SHELL=true
export AWS_SDK_LOAD_CONFIG=1
export TF_FORCE_LOCAL_BACKEND=1

# >>> conda initialize >>>
# Prefer the static profile script to avoid spawning `conda shell.zsh hook` on every shell startup.
if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
    . "/opt/anaconda3/etc/profile.d/conda.sh"
elif [ -d "/opt/anaconda3/bin" ]; then
    export PATH="/opt/anaconda3/bin:$PATH"
fi
# <<< conda initialize <<<

if [ -f "$HOME/.atuin/bin/env" ]; then
	. "$HOME/.atuin/bin/env"
fi

command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"

[[ "$TERM_PROGRAM" == "kiro" ]] && command -v kiro >/dev/null 2>&1 && . "$(kiro --locate-shell-integration-path zsh)"
command -v /usr/libexec/java_home >/dev/null 2>&1 && export JAVA_HOME=$(/usr/libexec/java_home)
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
