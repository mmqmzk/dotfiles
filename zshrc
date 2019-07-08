# If you come from bash you might have to change your $PATH.
export PATH="$HOME/.local/bin:$PATH"
export DOT="$HOME/.dotfiles"

export FZF_BASE="$DOT/fzf"
export NVM_DIR="$DOT/nvm"

fpath=($DOT/zfuncs "$fpath[@]")

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

ZSH_THEME="bullet-train"

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

export FZ_HISTORY_CD_CMD="_zlua"
export _ZL_DATA="~/.z"

plugins=(
  alias-tips
  colored-man-pages
  common-aliases
  debian
  docker
  docker-compose
  fast-syntax-highlighting
  fd
  firewalld
  fzf
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
  yum
  z.lua
  zsh-autosuggestions
  #zsh-syntax-highlighting
  #z
  fz
)

autoload -Uz is-at-least

if is-at-least 5.0.3; then
    plugins+=("zsh-autopair")
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
alias -g G="| ag"
alias p="ps -ef"
alias https="http --default-scheme https"
alias b="bat --color=always"
alias fb="fzf --preview 'bat --color=always {}'"
alias ff="fzf -f"
alias ft="fzf-tmux"
alias se="sudo -E env PATH='$PATH:/usr/local/sbin:/usr/sbin:/sbin'"
alias s="sudo "
alias as="apt search"
alias al="apt list"
alias alu="apt list --upgradable"
alias aw="apt show"
alias aar="sudo apt autoremove"
alias sc-dr="sudo systemctl daemon-reload"
alias jc="journalctl -x"
alias jce="journalctl -xe"
alias jcu="journalctl -xe -u"
alias dp="sudo docker pull"
alias dps="sudo docker ps"
alias dil="sudo docker image ls"
alias dil="sudo docker image prune"

export FZF_DEFAULT_COMMAND='fd --type file --color=always'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_COMPLETION_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--multi --cycle --inline-info --ansi --height 50% --border --layout=reverse"
export FZF_CTRL_T_OPTS="$FF_DEFAULT_OPTS"
export FZF_COMPLETION_OPTS="$FZF_DEFAULT_OPTS"

export BAT_PAGER="less -R"

# for Ctrl-W
export WORDCHARS='*?_[]~=&;!#$%^(){}-.:'

if command which exa &> /dev/null; then
    alias ls="exa"
    alias l="exa -lg"
    alias la="exa -lga"
    alias lt="exa -lgT"
elif command which lsd &> /dev/null; then
    alias ls="lsd"
    alias l="lsd -l"
    alias la="lsd -lA"
    alias lt="lsd --tree"
fi

autoload -Uz proxy noproxy set_no_proxy
set_no_proxy

