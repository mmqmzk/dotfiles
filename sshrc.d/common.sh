#!/usr.bin/env bash
__lfd() {
  t="$1"
  shift
  a="$1"
  shift
  for name in "$@"; do
    if [ $# -gt 1 ]; then
      echo "${name}:"
    fi
    find "${name}" -maxdepth 1 -type "$t" \
      | sed -E 's|^\./||;s|/$||;/^\.$/d;s/.+/"\0"/' \
      | LANG=C sort \
      | xargs -r -n 1 ls --color=auto ${a:+$a} \
      | column -t
  done
}

__lfdc() {
  t="$1"
  shift
  a="$1"
  shift
  for name in "$@"; do
    if [ $# -gt 1 ]; then
      echo "${name}:"
    fi
    find "${name}" -maxdepth 1 -type "$t" \
      | sed -E 's|^\./||;s|/$||;/^\.$/d;s/.+/"\0"/' \
      | LANG=C sort \
      | xargs -r -n 1 ls --color=always ${a:+$a} \
      | column -t
  done
}

_lfd() {
  f="$1"
  shift
  t="$1"
  shift
  a="$1"
  shift
  if [ $# -eq 0 ]; then
    ${f:+$f} "$t" "$a" .
  else
    ${f:+$f} "$t" "$a" "$@"
  fi
}


__lt() {
  level="$1"
  if [ "$level" != "0" ]; then
    level="-maxdepth $level"
  else
    unset level
  fi
  shift
  {
    if [ $# -eq 0 ]; then
      find "$@" ${level:+$level} -print0
    else
      find . ${level:+$level} -print0
    fi
  } | LANG=C sort -z \
    | xargs -0 -r  -n 1 ls -lhd --color=always \
    | sed '1s;/[^/]*$;;;s;\([^/]*\)/;|-;g;s;-|; |;g'
}

_pushd() {
  if [ $# -eq 0 ]; then
    builtin cd || return
  else
    pushd "$@" || return
  fi
}

sshrcd="$(cd "$(dirname "$0")" && pwd)"
[[ ! -d sshrcd ]] && sshrcd="$HOME/.sshrc.d"

export LESS='-iwR -P"?m(File\:%i/%m) .[?f%f:-stdin-.]. Lines\:?lt%lt-%lb:-./?L%L:-. Page\:?db%db:-./?D%D:-. ?pb%pb:-.\%"'

# export PAGER="less -imwR"

gbell() {
  while true; do
    if grep "$@"; then
      echo -e '\a'
      echo "Success matched!"
      return
    fi
    sleep 5
  done
}

alias eco='echo $?'
alias ebell=': $? && (($_)) && echo -e "\\aExitCode=$_" || echo "Success"'
alias bell='echo -e "done!\\a"'

alias -- -="_pushd -"
alias ..="_pushd .."
alias ...="_pushd ../.."
alias ....="_pushd ../../.."
alias .....="_pushd ../../../.."

alias aac="sudo apt autoclean"
alias aar="sudo apt autoremove"
alias ad="sudo apt update"
alias adg="sudo apt update && sudo apt upgrade"
alias adu="sudo apt update && sudo apt dist-upgrade"
alias ai="sudo apt install"
alias al="apt list"
alias all="apt list --installed"
alias alu="apt list --upgradable"
alias ap="sudo apt purge"
alias ar="sudo apt remove"
alias ari="sudo apt reinstall"
alias as="apt search"
alias au="sudo apt upgrade"
alias aw="apt show"
alias b="less ${LESS:-"-imwR"}"
alias c="_pushd"
alias ca="cat -A"
alias dud="du -h -d 1"

alias g="git"
alias gRM="git rm --force"
alias ga.="git add ."
alias ga="git add"
alias gaa="git add ."
alias gb="git branch"
alias gbD="git branch -D"
alias gba="git branch -a"
alias gbd="git branch -d"
alias gbu="git branch --set-upstream-to"
alias gca="git commit --amend"
alias gcl="git clone --recurse-submodules"
alias gcm="git checkout master"
alias gcma="git commit --amend"
alias gcmm="git commit --message"
alias gcmma="git commit --amend --message"
alias gco-="git checkout --"
alias gco.="git checkout -- ."
alias gco="git checkout"
alias gcoa="git checkout -- ."
alias gcoc="git checkout console"
alias gcod="git checkout develop"
alias gcom="git checkout master"
alias gf1="git fetch --depth=1"
alias gf="git fetch"
alias gl1="git pull --depth=1"
alias gl="git pull"
alias gla="git pull --all"
alias glog="git log --oneline --decorate --graph"
alias glr="git pull --rebase"
alias gma="git merge --abort"
alias gmc="git merge --continue"
alias goo="BROWSER=w3m googler -l cn"
alias gp="git push"
alias gpn="git push --dry-run"
alias gpo="git push origin"
alias gpoa="git push origin --all"
alias gpoat="git push origin --all && git push origin --tags"
alias gpot="git push origin --tags"
alias grb="git rebase"
alias grba="git rebase --abort"
alias grbc="git rebase --continue"
alias grbi="git rebase -i"
alias grbn="git rebase --dry-run"
alias grbs="git rebase --skip"
alias gre="git remote"
alias grea="git remote add"
alias grm="git rm"
alias grst="git reset"
alias grsthh="git reset --hard"
alias gs="git status"
alias gsa="git stash apply"
alias gsb="git status -sb"
alias gsc="git stash clear"
alias gsd="git svn dcommit"
alias gsf="git submodule foreach"
alias gsfg="git submodule foreach git"
alias gsl="git stash list"
alias gsp="git stash pop"
alias gsr="git svn rebase"
alias gsrf="git submodule foreach --recursive"
alias gsrfg="git submodule foreach --recursive git"
alias gsvn="git svn"
alias gss="git stash push"
alias gst="git status"
alias gsu="git submodule"
alias gsui="git submodule init"
alias gsuri="git submodule init --recursive"
alias gsuru="git submodule update --init --recursive"
alias gsuu="git submodule update --init"

alias h="history"
alias he="head"
alias jgc="jstat -gcutil"
alias juc="journalctl -x"
alias juce="journalctl -xe"
alias jucu="journalctl -xe -u"
alias k="kill"
alias l="command ls --color=auto -lh"
alias la="command ls --color=auto -lha"
alias lD="_lfd __lfd d -dh"
alias le="less ${LESS:-"-imwR"}"
alias lef="less ${LESS:-"-imwR"} +F"
alias lf="_lfd __lfd f -h"
alias lL="_lfd __lfd l -h"
alias lld="_lfd __lfdc d -lhd"
alias llD="_lfd __lfdc d -lhd"
alias llf="_lfd __lfdc f -lh"
alias llL="_lfd __lfdc l -lhd"
alias lsa="command ls --color=auto -A"
alias lss="command ls --color=auto -lhS"
alias lst="command ls --color=auto -lht"
alias lt="__lt 0"
alias lt2="__lt 2"
alias lt3="__lt 3"
alias lt4="__lt 4"
alias myip="curl -4sSL ifconfig.me/ip"
alias p="ps -ef"
alias par="parallel"
alias pd="popd"
alias pdd="popd;popd"
alias pddd="popd;popd;popd"
alias pg="pgrep"
alias pga="pgrep -fa"
alias pgf="pgrep -f"
alias pgl="pgrep -fl"
alias pk="pkill"
alias pkf="pkill -f"
alias psp="ps -fp"
alias s="sudo "
alias sc-dr="sudo systemctl daemon-reload"
alias se="sudo -E"
alias sp="sudo --preserve-env=PATH env"
alias sshl="ssh -N -L"
alias sshn="ssh -N"
alias sshnf="ssh -Nf"
alias sshpw="ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no"
alias sshr="ssh -N -R"
alias t="tail"
alias tf="tail -f"
alias vdf="vimdiff"
alias vu="vim -u ${sshrcd}/vimrc"
alias wh="which"
alias ye="sudo yum erase"
alias yi="sudo yum install"
alias yr="sudo yum erase"
alias yri="sudo yum reinstall"
alias ys="sudo yum search"
alias yu="sudo yum update"
alias yw="sudo yum info"
