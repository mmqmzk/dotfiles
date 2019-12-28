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
export RANGER_ZLUA="$DOT/zsh-custom/plugins/z.lua/z.lua"

export FZF_MARKS_FILE="$HOME/.config/fzf-marks"

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

autoload -Uz is-at-least has

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

if has rg; then
  alias -g G="| rg -S"
elif has ag; then
  alias -g G="| ag -S"
else
  alias -g G="| egrep -i"
fi

alias -g HH="2>&1 | head -q"
alias -g L="| less -R"
alias -g LL="2>&1 | less -R"
alias -g TT="2>&1 | tail"
alias -g TF="2>&1 | tail -f"
alias -g B="| bat --color=always"
alias -g BB="2>&1 | bat --color=always"
alias -g F="| fzf"
alias -g Y="| yank -i"
alias p="ps -ef"
alias https="http --default-scheme https"
alias b="bat --color=always"
alias fb="fzf --preview 'bat --color=always {}'"
alias ff="fzf -f"
alias ft="fzf-tmux"
alias se='sudo -E env PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"'
alias s="sudo "
alias as="apt search"
alias al="apt list"
alias alu="apt list --upgradable"
alias aw="apt show"
alias aar="sudo apt autoremove"
alias yw="sudo yum info"
alias sc-dr="sudo systemctl daemon-reload"
alias jc="journalctl -x"
alias jce="journalctl -xe"
alias jcu="journalctl -xe -u"
alias dl="sudo docker pull"
alias dp="sudo docker ps"
alias di="sudo docker image"
alias dil="sudo docker image ls"
alias dii="sudo docker image inspect"
alias dip="sudo docker image prune"
alias m="mark"
alias f="fzm"
alias goo="BROWSER=w3m googler -l cn"

export FZF_DEFAULT_COMMAND='fd --type file --color=always'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_COMPLETION_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--multi --cycle --inline-info --ansi --height 50% --border --layout=reverse"
export FZF_CTRL_T_OPTS="$FF_DEFAULT_OPTS"
export FZF_COMPLETION_OPTS="$FZF_DEFAULT_OPTS"

export PAGER="less -R"
export BAT_PAGER="less -R"

if has runexe; then
  export BROWSER="runexe cmd.exe /C start chrome"
elif [[ -n "$DISPLAY" ]]; then
  if has google-chrome; then
    export BROWSER="google-chrome"
  elif has firefox; then
    export BROWSER="firefox"
  fi
fi
if [[ -z "$BROWSER" ]]; then
  export BROWSER="w3m"
fi

lD () {
  fd -t d -d 1 .+ "$1" | xargs ls --color=auto -d
}

lld () {
  fd -t d -d 1 .+ "$1" | xargs ls --color=auto -lhd
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

autoload -Uz proxy noproxy set_no_proxy my-backward-delete-word

zle -N my-backward-delete-word
bindkey '' my-backward-delete-word
bindkey '' vi-find-next-char
bindkey '' vi-find-prev-char
bindkey ';' vi-repeat-find
bindkey ',' vi-rev-repeat-find

set_no_proxy

