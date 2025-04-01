# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(
	fzf-tab
	zsh-syntax-highlighting
	ohmyzsh-full-autoupdate
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
eval "$(starship init zsh)"

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

# check is zoxide is install and source it
[ -f $(which zoxide) ] && eval "$(zoxide init zsh)" && alias cd='z'

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
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# # clear tmux history and screen
# c() {
#    clear
#    tmux clear-history
# }


# GO
export PATH=$PATH:$(go env GOPATH)/bin

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
source <(kubectl completion zsh)
# Define alias
alias k=kubectl
# Enable completion for the alias
compdef k=kubectl
compdef ks=kubectl
compdef ka=kubectl

# Krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

alias t="tofu"
alias ti="tofu init"
alias ta="tofu apply"
alias tp="tofu plan"
alias td="tofu destroy"
alias to='tofu output -json | jq "reduce to_entries[] as \$entry ({}; .[\$entry.key] = \$entry.value.value)"'


alias tf="terraform"
alias tfi="terraform init"
alias tfa="terraform apply"
alias tfd="terraform destroy"
alias tfo='terraform output -json | jq "reduce to_entries[] as \$entry ({}; .[\$entry.key] = \$entry.value.value)"'
alias n="nvim ."



# check if eza is installed start code block
if [ -f $(which eza) ]; then
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
source <(helm completion zsh)

# aws autocomplete
# only if installed
[ -f $(which aws_completer) ] && complete -C $(which aws_completer) aws

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

	# tmux process detection, only go here is we are not in tmux
	if [ "$TMUX" = "" ]; then
		if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
			echo "We are in nvim terminal"
		else
			tmux attach-session -t 0
			# if above fails, create new session with non 0 exit code
			if [ $? -ne 0 ]; then
				# session setup in background
				tmux new-session -s 0 -d
				# windows setup
				#tmux kill-window -t 0
				tmux new-window -d -t 2 -n "infrastructure" -c "$HOME/Documents/infrastructure/"
				tmux new-window -d -t 3 -n "cloud-infra" -c "$HOME/Documents/cloud-infra/"
				tmux new-window -d -t 4 -n "devops_k8s" -c "$HOME/Documents/devops_k8s/"
				tmux new-window -d -t 5 -n "ghix_devops" -c "$HOME/Documents/ghix_devops/"
				tmux new-window -d -t 6 -n "temp" -c "$HOME/temp"
				tmux new-window -d -t 7 -n "Downloads" -c "$HOME/Downloads"
				tmux new-window -d -t 8 -n "open" -c "$HOME"
				# attach to new session
				tmux attach-session -t 0
			fi

		fi

	fi

# TF autocomplete
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C terraform terraform

# Check if stern is installed if so enable completion
[ -f $(which stern) ] && source <(stern --completion=zsh)
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="${HOME}/.local/bin":${PATH}

export PATH="/usr/local/bin:$PATH"
. "/Users/sjc-lp03742/.deno/env"

export K9S_CONFIG_DIR="$HOME/.config/k9s"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
