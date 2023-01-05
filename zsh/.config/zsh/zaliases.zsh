#!/usr/bin/env zsh

alias :q='exit'

if command -v exa &>/dev/null; then
    alias l='exa'
    alias ls='exa --group-directories-first --icons --git'
    alias ll='ls -lah --git'
    alias la='exa -a'
    alias tree='ll --tree --level=2'
else
    echo "exa is not installed."
fi

# alias ll="ls -lahg"
# alias la="ls -a"
alias lt="ls --sort newest"
alias llt="ll --sort newest"
alias ltr="ls --sort oldest"
alias lltr="ll --sort oldest"


if hash nvim 2>/dev/null; then
    alias vim="nvim"
    alias v="nvim"
fi

if hash fping 2>/dev/null; then
    alias wping="fping wp.pl -l | cut -d , -f 3-4"
fi

alias egrep="egrep --color=auto"
alias grep="grep --color=auto"
alias egr="egrep -iHnr"
alias gr="grep -iHnr"
alias cegr="egrep -iHnr --color=always"
alias cgr="egrep -iHnr --color=always"

if hash ranger 2>/dev/null; then
    alias ranger='ranger --choosedir=$HOME/.rangerdir; cd `cat $HOME/.rangerdir`'
    alias ra="ranger"
fi

if hash trash 2>/dev/null; then
    alias rmm="trash"
else
    echo "trash is not installed."
fi

# A trailing space in VALUE causes the next word to be checked for alias substitution when the alias is expanded.
if hash watch 2>/dev/null; then
    alias watch="watch --color --interval 0.5 "
fi

if hash git 2>/dev/null; then
    alias g=git
    # cd to git root
    alias gcd='[ ! -z `git rev-parse --show-cdup` ] && cd `git rev-parse --show-cdup || pwd`'
    alias git-delete-merged='git branch --merged | grep -Ev \(develop\|master\) | xargs git br -d'

    if hash gh 2>/dev/null; then
        alias prCreate='gh pr create -w -t $(git branch --show-current)'
        alias prComplete='gh pr merge --auto --delete-branch --squash'

    else
        echo "gh is missing,\r\nInstall it now!!!"
    fi
else
    echo "git is missing,\r\nInstall it now!!!"
fi

if hash lazygit 2>/dev/null; then
    alias lg='lazygit'
    alias gg='lazygit'
fi

if hash cmatrix 2>/dev/null; then
    alias s='cmatrix -absCcyan'
fi

# translation with http://git.io/trans
if hash trans 2>/dev/null; then
    alias t='trans en:pl'
    alias tj='trans en:pl -j'
    alias ts='trans en:pl -speak'
    alias tsj='trans en:pl -speak -j'
    alias tp='trans pl:en'
    alias tpj='trans pl:en -j'
    alias tps='trans pl:en -speak'
    alias tpsj='trans pl:en -speak -j'
else
    echo "translate-shell is missing,\r\nget it from http://git.io/trans"
fi

if hash ag 2>/dev/null; then
    alias ag='ag --smart-case'
else
    echo "the_silver_searcher or silversearcher-ag or silver-searcher is not installed."
fi

if hash yarn 2>/dev/null; then
    alias y='yarn'
else
    echo "yarn is not installed."
fi

if hash npm 2>/dev/null; then
    alias n='npm run'
else
    echo "npm is not installed."
fi

alias vimwiki='nvim -c VimwikiIndex'

if hash xclip 2>/dev/null; then
    alias xclip='xclip -sel c'
else
    echo "xclip is not installed."
fi

if hash tig 2>/dev/null; then
    alias tiga='tig --all'
else
    echo "tig is not installed."
fi

if hash tmux 2>/dev/null; then
    alias ta='tmux attach -t'
    alias tn='tmux new -t'
    alias tl='tmux ls'
else
    echo "tmux is not installed."
fi

mkdirdate() {
    local dateDirName=$(date "+%Y-%m-%d")
    while getopts ':t' OPTION; do
        case ${OPTION} in
        t) dateDirName=$(date "+%Y-%m-%d_%H-%M") ;;
        *) printf 1>&2 ' Unsupported option [ %s ].\n' "${OPTION}" ;;
        esac
    done

    if [[ -d "$dateDirName" ]]; then
        echo "$(tput setaf 3) $ cd $dateDirName"
        cd $dateDirName
    else
        echo "$(tput setaf 2) $ mkdir $dateDirName"
        mkdir $dateDirName
        echo "$(tput setaf 3) $ cd $dateDirName"
        cd $dateDirName
    fi
}

# Avoid breaking fingers with date
alias dateclip='date --iso-8601 | xclip'
alias today="date +%Y-%m-%d"
alias now="date +%Y-%m-%d_%H-%m_%S"
