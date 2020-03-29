# If you come from bash you might have to change your $PATH.
if [[ "$PATH" != *"$HOME/.local/bin"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi
export DOT="${DOT:-"$HOME/.dotfiles"}"

export FZF_BASE="$DOT/fzf"
export NVM_DIR="$DOT/nvm"

# Path to your oh-my-zsh installation.
export ZSH="$DOT/oh-my-zsh"


# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
DEFAULT_USER="zhoukun"
BULLETTRAIN_CONTEXT_DEFAULT_USER="zhoukun"
BULLETTRAIN_IS_SSH_CLIENT=true
BULLETTRAIN_GIT_COLORIZE_DIRTY=true
BULLETTRAIN_STATUS_EXIT_SHOW=true
BULLETTRAIN_PROMPT_ORDER=( time status context dir git cmd_exec_time )

ZSH_THEME="bullet-train" # "agnoster" 

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
#
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM="$DOT/zsh-custom"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#

export _ZL_DATA="~/.z"
export FZ_HISTORY_CD_CMD="_zlua"
export RANGER_ZLUA="${ZSH_CUSTOM}/plugins/z.lua/z.lua"

export FZF_MARKS_FILE="${XDG_CONFIG_HOME:-"$HOME/.config"}/fzf-marks"

_fzf_compgen_dir() {
  fd --type directory --hidden --follow --exclude ".git" --color=always . "$@"
}

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" --color=always . "$@"
}

plugins=(
  alias-tips
  colored-man-pages
  common-aliases
  debian
  dirhistory
  docker
  docker-compose
  # fast-syntax-highlighting
  fd
  firewalld
  fzf
  fzf-marks
  git
  forgit
  httpie
  mosh
  node
  npm
  nvm  
  nvm-auto
  pip
  python
  ripgrep
  sudo
  systemd
  tmux
  wakeonlan
  yum
  z.lua
  zsh-autosuggestions
  zsh-syntax-highlighting
  # z
  fz
)

autoload -Uz is-at-least

if is-at-least 5.0.3; then
    plugins+=("zsh-autopair")
else
  alias v="vim"
fi

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
unalias fd

fpath=($DOT/zfuncs "$fpath[@]")
export FPATH

autoload -Uz has proxy noproxy set_no_proxy my-backward-delete-word \
  preview _ssh _sshrc

if has rg; then
  alias rg="rg --smart-case"
  alias -g G="| rg"
elif has ag; then
  alias -g G="| ag --smart-case"
else
  alias -g G="| egrep -i"
fi

alias -g B="| bat --color=always"
alias -g BB="2>&1 | bat --color=always"
alias -g F="| fzf"
alias -g H="| head -q"
alias -g HH="2>&1 | head -q"
alias -g J="| jq . | bat -l json"
alias -g L="| less -R"
alias -g LL="2>&1 | less -R"
alias -g T="| tail"
alias -g TF="2>&1 | tail -f"
alias -g TT="2>&1 | tail"
alias -g X="| bat -l xml"
alias -g Y="| yank -i"
alias -g YY="2>&1 | yank -i"
alias aar="sudo apt autoremove"
alias al="apt list"
alias alu="apt list --upgradable"
alias as="apt search"
alias aw="apt show"
alias b="bat --color=always"
alias c="cd"
alias di="sudo docker image"
alias dii="sudo docker image inspect"
alias dil="sudo docker image ls"
alias dip="sudo docker image prune"
alias dl="sudo docker pull"
alias dp="sudo docker ps"
alias f="fzm"
alias ff="fzf -f"
alias ft="fzf-tmux"
alias goo="BROWSER=w3m googler -l cn"
alias gpo="git push origin --all"
alias https="http --default-scheme https"
alias jc="journalctl -x"
alias jce="journalctl -xe"
alias jcu="journalctl -xe -u"
alias m="mark"
alias p="ps -ef"
alias s="sudo "
alias sc-dr="sudo systemctl daemon-reload"
alias se='sudo -E env PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"'
alias yw="sudo yum info"

export PREVIEW="$DOT/zfuncs/preview"
export FZF_DEFAULT_COMMAND='fd --hidden --color=always'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_COMPLETION_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --hidden --type directory --color=always . . ~ /"
export FZF_DEFAULT_OPTS="--multi --cycle --inline-info --ansi --height 50% --border --layout=reverse --preview '$PREVIEW {}'"
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"
export FZF_COMPLETION_OPTS="$FZF_DEFAULT_OPTS +m"
export FZF_ALT_C_OPTS="$FZF_DEFAULT_OPTS +m"
# export _ZL_FZF_FLAG="+s -1 +m --preview 'echo {} | sed -E \"s/^\\S+\\s*(.+)/\\1/\" | xargs $PREVIEW'"
export _ZL_FZF_FLAG="+s -1 +m --preview 'echo {} | awk \"{print \\\$2}\" | xargs $PREVIEW'"

fb() {
  fd --hidden --type file --color=always "$@" | fzf --preview 'bat --color=always {}'
}

export PAGER="less -R"
export BAT_PAGER="less -R"

if has winstart; then
  export BROWSER="winstart chrome"
  alias e="winstart EmEditor"
elif [[ -n "$DISPLAY" ]]; then
  if has google-chrome; then
    export BROWSER="google-chrome"
  elif has firefox; then
    export BROWSER="firefox"
  fi
  alias e="gedit"
else
  alias e="${EDITOR:-vim}"
fi

if [[ -z "$BROWSER" ]]; then
  export BROWSER="w3m"
fi

lD () {
  fd --type directory --max-depth 1 . "$1" | xargs ls --color=auto -d
}

lld () {
  fd --type directory --max-depth 1 . "$1" | xargs ls --color=auto -lhd
}

if has exa; then
    alias ls="exa"
    alias lsa="exa -a"
    alias l="exa -lg"
    alias la="exa -lgaa"
    alias lD="exa -D"
    alias lld="exa -lgD"
    alias lt="exa -T"
    alias lt2="exa -gT -L 2"
    alias lt3="exa -gT -L 3"
    alias lt4="exa -gT -L 4"
    alias ltl="exa -gT -L"
    alias lss="exa -lg -s size -r"
    alias lst="exa -lg -s modified -r"
    alias l@="exa -lga@"
elif has lsd; then
    alias ls="lsd"
    alias lsa="lad -A"
    alias l="lsd -l"
    alias la="lsd -la"
    alias lt="lsd --tree"
    alias lt2="lsd --tree --depth 2"
    alias lt3="lsd --tree --depth 3"
    alias lt4="lsd --tree --depth 4"
    alias ltl="lsd --tree --depth"
    alias lss="lsd -lS"
    alias lst="lsd -lt"
else
  alias l="command ls --color=auto -lh"
  alias la="command ls --color=auto -lha"
  alias lsa="command ls --color=auto -A"
  alias lss="command ls --color=auto -lhS"
  alias lst="command ls --color=auto -lht"
fi

zle -N my-backward-delete-word
bindkey '' my-backward-delete-word
bindkey '' vi-find-next-char
bindkey '' vi-find-prev-char
bindkey ';' vi-repeat-find
bindkey ',' vi-rev-repeat-find

__fzf_complete_ssh() {
  _fzf_complete +m -- "$@" < <(grep -iw "Host" ~/.ssh/config \
    | awk '{for(i=2;i<=NF;i++)print $i}' | grep -v "[*?]")
}

_fzf_complete_sshrc() {
  __fzf_complete_ssh "$@"
}

set_no_proxy

