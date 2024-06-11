# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++SETTINGS TO USE ALWAYS++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# =========Plugins============
ENABLE_CORRECTION="false"
setopt HIST_IGNORE_SPACE
plugins=(fzf zsh-syntax-highlighting zsh-autosuggestions zsh-vi-mode)

# =========Exports============
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:/usr/local/opt/gnu-sed/libexec/gnubin:$(go env GOPATH)/bin:/Users/shashanktyagi/Library/Python/3.9/bin
export AWS_PROFILE="bs3-package"
export GETMESH_HOME="$HOME/.getmesh"
export PATH="$GETMESH_HOME/bin:$HOME/bin:$PATH"

export BS="bluescape-system"
export EDITOR="nvim"

# =========Alias============
alias d=docker
alias ls="/usr/local/bin/colorls"

# Kubernetes
alias k=kubectl
alias kg="kubectl get"
alias kgy="kubectl get -o yaml"
alias ke="kubectl edit"
alias kd="kubectl describe"
alias kdel="kubectl delete"

alias python="python3"
alias readlink="/opt/homebrew/bin/greadlink"

# Terraform
alias t="terraform"
alias ti="terraform init"
alias tp="terraform plan"
alias tf="terraform fmt -recursive"
alias ta="terraform apply"
alias td="terraform destroy"
alias tw="terraform workspace"

# helm
alias hdu="helm diff upgrade"
alias hla="helm list -A"
alias hu="helm uninstall"

alias bat="bat -p"
alias sed="/opt/homebrew/bin/gsed"
alias enodeview="eks-node-viewer"

# ========Sourcing files============
# source /Users/shashanktyagi/bluescape-workspace/set-k8s-env-tkc
export SET_K8S_ENV_EKS="/Users/shashanktyagi/bluescape-workspace/set-k8s-env-eks"
source $ZSH/oh-my-zsh.sh
source /Users/shashanktyagi/bluescape-workspace/set-k8s-env-eks


# =========custom functions============
# Change Audio settings
function audio() {
    if [[ "$1" =~ "headphones" ]]
    then
        SwitchAudioSource -t output -s "External Headphones"
    elif [[ $1 =~ "macbook" ]]
    then
        SwitchAudioSource -t output -s "MacBook Pro Speakers"
    elif [[ $1 =~ "monitor" ]]
    then
        SwitchAudioSource -t output -s "LG HDR 4K"
    fi
}

function docker () {
	if [[ `uname -m` == "arm64" ]] && [[ "$1" == "run" || "$1" == "build" || "$1" == "pull" ]]
	then
		/usr/local/bin/docker "$1" --platform linux/amd64 "${@:2}"
	else
		/usr/local/bin/docker "$@"
	fi
}

# Restart en0
function restart_network() {
    sudo ifconfig en0 down
    sleep 10
    sudo ifconfig en0 up
}

# ========evals============
eval "$(starship init zsh)"

# Fuzzy Search
export FZF_DEFAULT_OPTS='-m --height 50% --border'
export FZF_DEFAULT_COMMAND="fd . $HOME/Documents $HOME/Downloads $HOME/Desktop"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d . $HOME"

fp() {
    fzf --preview 'bat --color=always --line-range :500 {}'
}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# infra-env sourcing. See more at https://github.com/Bluescape/infra-env
if [ -f "$HOME/.config/infra-env/rc.sh" ]; then
  source "$HOME/.config/infra-env/rc.sh"
else
  echo "[WARNING] infra-env rc file not found: $HOME/.config/infra-env/rc.sh. See more at: https://github.com/Bluescape/infra-env"
fi
# /infra-env sourcing.

# Created by `pipx` on 2024-04-23 20:16:46
export PATH="$PATH:/Users/shashanktyagi/.local/bin"
