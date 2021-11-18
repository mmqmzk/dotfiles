# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-"${HOME}/.cache"}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-"${HOME}/.cache"}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
if [[ "${PATH}" != *"${HOME}/.local/bin"* ]]; then
  export PATH="${HOME}/.local/bin:${PATH}"
fi
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"
[[ -d "$HOME/go/bin" ]] && export PATH="$HOME/go/bin:$PATH"
export DOT="${DOT:-"${HOME}/.dotfiles"}"
export GOPATH="${HOME}/go"
export GO111MODULE=on

export FZF_BASE="${DOT}/fzf"
export NVM_DIR="${DOT}/nvm"

# Path to your oh-my-zsh installation.
export ZSH="${DOT}/oh-my-zsh"


# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
DEFAULT_USER="zhoukun"
BULLETTRAIN_CONTEXT_DEFAULT_USER="zhoukun"
BULLETTRAIN_IS_SSH_CLIENT=true
BULLETTRAIN_GIT_COLORIZE_DIRTY=true
BULLETTRAIN_STATUS_EXIT_SHOW=true
BULLETTRAIN_PROMPT_ORDER=( time status context dir git cmd_exec_time )

ZSH_THEME="powerlevel10k/powerlevel10k" # "bullet-train"

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

# Uncomment the following line to display red dots whilst waiting 
# for completion.
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
ZSH_CUSTOM="${DOT}/zsh-custom"

# Which plugins would you like to load?
# (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#

export _ZL_DATA="~/.z"
export _ZL_MATCH_MODE=1
export _ZL_ADD_ONCE=1
export _ZL_CD="pushd"
export FZ_HISTORY_CD_CMD="_zlua"
export RANGER_ZLUA="${ZSH_CUSTOM}/plugins/z.lua/z.lua"

export FZF_MARKS_FILE="${XDG_CONFIG_HOME:-"${HOME}/.config"}/fzf-marks"

_fzf_compgen_dir() {
  fd --type directory --hidden --follow --exclude ".git" --color=always . "$@"
}

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" --color=always . "$@"
}

plugins=(
  colored-man-pages
  common-aliases
  debian
  dirhistory
  docker
  docker-compose
  fd
  firewalld
  fzf
  fzf-marks
  fzf-tab
  git
  gpg-agent
  forgit
  httpie
  mosh
  node
  npm
  nvm
  # nvm-auto
  pip
  python
  ripgrep
  sudo
  systemd
  themes
  tmux
  urltools
  wakeonlan
  yum
  z.lua
  zsh-autosuggestions
  fast-syntax-highlighting
  # zsh-syntax-highlighting
  # z
  # fz
)

autoload -Uz is-at-least has

if is-at-least 5.0.3; then
    plugins+=("zsh-autopair")
fi
if is-at-least 5.1; then
  plugins+=("you-should-use")
else
  plugins+=("alias-tips")
fi

source "${ZSH}/oh-my-zsh.sh"

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
# unalias fd

fpath=("${DOT}/zfuncs" "${fpath[@]}")
export FPATH

autoload -Uz proxy noproxy set_no_proxy my-backward-delete-word \
  preview exe _fzf_complete_lpass

: "${DOT}/sshrc.d/common.sh" && [[ -f "$_" ]] && source "$_"
export BAT_PAGER="less ${LESS:-"-imwR"}"

alias agc="ag --smart-case --color"
alias rg="rg --smart-case"
alias rgc="\\rg --smart-case --color=always"
if has rg; then
  alias -g G="| \\rg --smart-case"
  alias -g GC="| \\rg --smart-case --color=always"
elif has ag; then
  alias -g G="| ag --smart-case"
  alias -g GC="| ag --smart-case --color"
else
  alias ag="grep -Pi"
  alias agc="grep -Pi --color=always"
  alias -g G="| grep -Pi"
  alias -g GC="| grep -Pi --color=always"
fi

if has bat; then
  export PAGER="bat"
fi

alias -g B="| bat --color=always"
alias -g BB="2>&1 | bat --color=always"
alias -g C="| wc -l"
alias -g F="| fzf"
alias -g H="| head -q"
alias -g HH="2>&1 | head -q"
alias -g J="| jq -C . | less ${LESS:-"-imwR"}"
alias -g L="| less ${LESS:-"-imwR"}"
alias -g LF="| less ${LESS:-"-imwR"} +F"
alias -g LG="| less ${LESS:-"-imwR"} +G"
alias -g LL="2>&1 | less ${LESS:-"-imwR"}"
alias -g NC="| sed 's/\x1b\[[0-9;]*m//g'"
alias -g S="| sort"
alias -g T="| tail"
alias -g TF="| tail -f"
alias -g TT="2>&1 | tail"
alias -g TTF="2>&1 | tail -f"
alias -g X="| bat -l xml"
alias -g Y="| yank -i"
alias -g YY="2>&1 | yank -i"
alias b="bat --color=always"
# alias bai="brew cask install"
# alias bah="brew cask home"
# alias bal="brew cask list"
# alias bar="brew cask remove"
# alias bau="brew cask upgrade"
# alias baw="brew cask info"
alias bca="brew cat"
alias bcl="brew cleanup"
alias bcp="brew cleanup --prune"
alias bcm="brew command"
alias bcms="brew commands"
alias bd="brew update"
alias bh="brew home"
alias bi="brew install"
alias bif="brew install -f"
alias bl="brew list"
alias bll="brew list -l"
alias bln="brew link"
alias bo="brew outdated"
alias bp="brew pin"
alias br="brew remove"
alias bri="brew reinstall"
alias bs="brew search"
alias bsa="brew search --casks"
alias bsc="brew search --casks"
alias bt="brew tap"
alias bti="brew tap-info"
alias bu="brew upgrade"
alias bug="brew update && brew upgrade"
alias bul="brew unlink"
alias bup="brew unpin"
alias but="brew untap"
alias bw="brew info"
alias di="sudo docker image"
alias dii="sudo docker image inspect"
alias dil="sudo docker image ls"
alias dip="sudo docker image prune"
alias dl="sudo docker pull"
alias dp="sudo docker ps"
alias f="fzm"
alias ff="fzf -f"
alias fk="fkill"
alias ft="fzf-tmux"
alias https="http --default-scheme https"
alias npmi="npm install"
alias m="mark"
alias se='sudo -E'
alias sni="sudo snap install"
alias snf="snap find"
alias snl="snap list"
alias snr="sudo snap remove"
alias sns="snap find"
alias snu="sudo snap refresh"
alias snw="snap info"


export PREVIEW="${DOT}/zfuncs/preview"
FZF_PREVIEW_KEY_BIND="--bind 'ctrl-j:preview-down,"
FZF_PREVIEW_KEY_BIND="${FZF_PREVIEW_KEY_BIND}ctrl-k:preview-up,"
FZF_PREVIEW_KEY_BIND="${FZF_PREVIEW_KEY_BIND}alt-e:preview-down\
+preview-down+preview-down,"
FZF_PREVIEW_KEY_BIND="${FZF_PREVIEW_KEY_BIND}alt-y:preview-up\
+preview-up+preview-up,"
# FZF_PREVIEW_KEY_BIND="${FZF_PREVIEW_KEY_BIND}alt-h:preview-top,"
# FZF_PREVIEW_KEY_BIND="${FZF_PREVIEW_KEY_BIND}alt-l:preview-bottom,"
FZF_PREVIEW_KEY_BIND="${FZF_PREVIEW_KEY_BIND}alt-p:toggle-preview,"
FZF_PREVIEW_KEY_BIND="${FZF_PREVIEW_KEY_BIND}alt-w:toggle-preview-wrap,"
FZF_PREVIEW_KEY_BIND="${FZF_PREVIEW_KEY_BIND}ctrl-s:toggle-sort,"
FZF_PREVIEW_KEY_BIND="${FZF_PREVIEW_KEY_BIND}alt-a:toggle-all,"
FZF_PREVIEW_KEY_BIND="${FZF_PREVIEW_KEY_BIND}alt-n:toggle+down,"
FZF_PREVIEW_KEY_BIND="${FZF_PREVIEW_KEY_BIND}alt-p:toggle+up,"
FZF_PREVIEW_KEY_BIND="${FZF_PREVIEW_KEY_BIND}tab:toggle+down,"
FZF_PREVIEW_KEY_BIND="${FZF_PREVIEW_KEY_BIND}btab:toggle+up'"
export FZF_PREVIEW_KEY_BIND

export FZF_COMPLETION_TRIGGER=',,'
export FZF_DEFAULT_COMMAND='fd --hidden --color=always'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_COMPLETION_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_ALT_C_COMMAND="fd --hidden --type directory --color=always . . ~ /"

export FZF_DEFAULT_OPTS="--multi --cycle --inline-info --ansi --height 100% \
  --border --layout=default --preview '${PREVIEW} {}' --preview-window \
  'right:70%:wrap' ${FZF_PREVIEW_KEY_BIND}"
export FZF_CTRL_T_OPTS="${FZF_DEFAULT_OPTS}"
export FZF_COMPLETION_OPTS="-1 --cycle --inline-info --ansi --height 60% \
  --border --layout=reverse --preview '${PREVIEW} {}' --preview-window \
  'right:70%:wrap' ${FZF_PREVIEW_KEY_BIND}"
export FZF_CTRL_R_OPTS="+m -1 --cycle --ansi --border --no-preview"
export FZF_ALT_C_OPTS="${FZF_DEFAULT_OPTS} +m --preview-window 'right:60%'"
export _ZL_FZF_FLAG="+s -1 +m --preview 'echo {} | awk \"{print \\\$2}\" \
  | xargs ${PREVIEW}' ${FZF_PREVIEW_KEY_BIND}"
export FORGIT_FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS}"

export __FZF_TAB_OPTS=(-1 --cycle --inline-info --ansi --height 40% \
  --border --layout=reverse  --expect=/)
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' fzf-flags "${__FZF_TAB_OPTS[@]}"
zstyle ':fz${FZF_TAP_OPTS}f-tab:*' fzf-bindings "${FZF_PREVIEW_KEY_BIND}"
zstyle ':fzf-tab:complete:*:*' fzf-preview "${PREVIEW}"' $realpath'
zstyle ':completion:*:*:*:*:processes' command \
  'ps -eo user,pid,ppid,start,tty,time,cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]"  ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags \
  --preview-window='down:3:wrap'
zstyle ':completion:*:kill:*' ignored-patterns '0'

fb() {
  fd --hidden --type file --color=always "$@" \
    | fzf --preview 'bat --color=always {}'
}

if has winstart; then
  export BROWSER="chrome"
  alias e="winstart EmEditor"
elif [[ -n "${DISPLAY}" ]]; then
  if has google-chrome; then
    export BROWSER="google-chrome"
  elif has firefox; then
    export BROWSER="firefox"
  fi
  if has gedit; then
    alias e="gedit"
  else
    alias e="${EDITOR:-vim}"
  fi
else
  alias e="${EDITOR:-vim}"
fi
has wslview && export BROWSER="wslview"

[[ -z "${BROWSER}" ]] && has w3m && export BROWSER="w3m"


if has exa; then
  alias ls="exa --icons"
  alias lsa="exa -a --icons"
  alias l="exa -lg --git --time-style long-iso --icons"
  alias la="exa -lgaa --git --time-style long-iso --icons"
  alias lt="exa -T --icons"
  alias lt2="exa -gT --icons --level 2"
  alias lt3="exa -gT --icons --level 3"
  alias lt4="exa -gT --icons --level 4"
  alias ltl="exa -lgT --icons"
  alias ltl2="exa -lgT --icons --level 2"
  alias ltl3="exa -lgT --icons --level 3"
  alias ltl4="exa -lgT --icons --level 4"
  alias lss="exa -lg --git --time-style long-iso --sort size -r --icons"
  alias lst="exa -lg --git --time-style long-iso --sort modified -r --icons"
  alias l@="exa -lg --git --time-style long-iso --extend --icons"
elif has lsd; then
  alias ls="lsd"
  alias lsa="lsd -A"
  alias l="lsd -l"
  alias la="lsd -la"
  alias lt="lsd --tree"
  alias lt2="lsd --tree --depth 2"
  alias lt3="lsd --tree --depth 3"
  alias lt4="lsd --tree --depth 4"
  alias ltl="lsd -l --tree"
  alias ltl2="lsd -l --tree --depth 2"
  alias ltl3="lsd -l --tree --depth 3"
  alias ltl4="lsd -l --tree --depth 4"
  alias lss="lsd -lS"
  alias lst="lsd -lt"
fi

toggle_comment() {
  if [[ "${LBUFFER}" == \#* ]]; then
    : "${LBUFFER#\#}" && : "${_## }"
  else
    : "# ${LBUFFER}"
  fi
  LBUFFER="$_"
}

yank_bufer() {
  echo -n "${LBUFFER}" | yank -i
}

zle -N my-backward-delete-word
zle -N toggle_comment
zle -N fzf_history_find
zle -N yank_bufer
bindkey '' my-backward-delete-word
bindkey '' toggle_comment
bindkey 'y' yank_bufer
bindkey '' beginning-of-line
bindkey '' vi-find-next-char
bindkey '' vi-find-prev-char
bindkey ';' vi-repeat-find
bindkey ',' vi-rev-repeat-find

__fzf_complete_ssh() {
  _fzf_complete --no-preview -- "$@" < <(grep -iw "Host" ~/.ssh/config \
    | awk '{for(i=2;i<=NF;i++)print $i}' | grep -v "[*?]")
}
functions[_fzf_complete_ssh]='__fzf_complete_ssh "$@"'

_fzf_complete_sshrc() {
  __fzf_complete_ssh "$@"
}

hex() {
  hexyl "$@" | less -P"%btB./%ltL./%dtP.?e END" -iwR
}

mdl() {
  glow "$@" -s dark \
    | less -iwR \
    -P'Line\:?lt%lt-%lb:-./?L%L:-. Page\:?db%db:-./?D%D:-. ?pb%pb:-.\%.?e END'
}

set_no_proxy

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
: "${DOT}/p10k.zsh"  && [[ -f "$_" ]] && source "$_"
