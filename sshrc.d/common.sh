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
  } | xargs -0 -r  -n 1 ls -lhd --color=always \
    | sed '1s;/[^/]*$;;;s;\([^/]*\)/;|-;g;s;-|; |;g'
}

export LESS='-iwR -P"?m(File\:%i/%m) .[?f%f:-stdin-.]. Lines\:?lt%lt-%lb:-./?L%L:-. Page\:?db%db:-./?D%D:-. ?pb%pb:-.\%"'

# export PAGER="less -imwR"

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
alias c="cd"
alias dud="du -h -d 1"
alias g="git"
alias gaa="git add ."
alias gca="git commit --amend"
alias gcl="git clone --recurse-submodules"
alias gcm="git checkout master"
alias gcmm="git commit --message"
alias gco="git checkout"
alias gcoa="git checkout -- ."
alias gcoc="git checkout console"
alias gcom="git checkout master"
alias gf1="git fetch --depth=1"
alias gf="git fetch"
alias gl1="git pull --depth=1"
alias gl="git pull"
alias glog="git log --oneline --decorate --graph"
alias glr="git pull --rebase"
alias gma="git merge --abort"
alias gmc="git merge --continue"
alias goo="BROWSER=w3m googler -l cn"
alias gp="git push"
alias gp="git push"
alias gpn="git push --dry-run"
alias gpo="git push origin --all"
alias gpo="git push origin --all"
alias gpoat="git push origin --all && git push origin --tags"
alias gpot="git push origin --all --tags"
alias gr="git remote"
alias gra="git remote add"
alias grb="git rebase"
alias grba="git rebase --abort"
alias grbc="git rebase --continue"
alias grbi="git rebase -i"
alias grbn="git rebase --dry-run"
alias grbs="git rebase --skip"
alias grhh="git reset --hard"
alias grm="git rm"
alias gRM="git rm --force"
alias grst="git reset"
alias gsa="git stash apply"
alias gsb="git status -sb"
alias gsc="git stash clear"
alias gsd="git svn dcommit"
alias gsf="git submodule foreach"
alias gsfg="git submodule foreach git"
alias gsrf="git submodule foreach --recursive"
alias gsrfg="git submodule foreach --recursive git"
alias gsl="git stash list"
alias gsp="git stash pop"
alias gsr="git svn rebase"
alias gss="git stash push"
alias gst="git status"
alias gsu="git submodule"
alias gsui="git submodule init"
alias gsuri="git submodule init --recursive"
alias gsuru="git submodule update --init --recursive"
alias gsuu="git submodule update --init"
alias h="history"
alias he="head"
alias jc="journalctl -x"
alias jce="journalctl -xe"
alias jcu="journalctl -xe -u"
alias k="kill"
alias l="command ls --color=auto -lh"
alias la="command ls --color=auto -lha"
alias le="less ${LESS:-"-imwR"}"
alias lf="_lfd __lfd f -h"
alias llf="_lfd __lfdc f -lh"
alias lD="_lfd __lfd d -dh"
alias lL="_lfd __lfd l -h"
alias llD="_lfd __lfdc d -lhd"
alias lld="_lfd __lfdc d -lhd"
alias llL="_lfd __lfdc l -lhd"
alias lsa="command ls --color=auto -A"
alias lss="command ls --color=auto -lhS"
alias lst="command ls --color=auto -lht"
alias lt="__lt 0"
alias lt2="__lt 2"
alias lt3="__lt 3"
alias lt4="__lt 4"
alias p="ps -ef"
alias par="parallel"
alias pk="pkill"
alias s="sudo "
alias sc-dr="sudo systemctl daemon-reload"
alias t="tail"
alias tf="tail -f"
alias vdf="vimdiff"
alias ye="sudo yum erase"
alias yi="sudo yum install"
alias yr="sudo yum erase"
alias yri="sudo yum reinstall"
alias ys="sudo yum search"
alias yu="sudo yum update"
alias yw="sudo yum info"
