#!/usr/bin/env zsh

install() {
    echo "Installing $1"
    if hash pacman 2>/dev/null; then
        sudo pacman -S $1
    elif hash pkg 2>/dev/null; then
        pkg $1
    fi
    zsh
}

alias :q='exit'

if command -v exa &>/dev/null; then
    alias l='exa'
    alias ls='exa --group-directories-first --icons --git'
    alias ll='ls -lah --git'
    alias la='exa -a'
    alias tree='ll --tree --level=2'
else
    echo "exa is not installed."
    install exa
fi

if command -v fasd &>/dev/null; then
    alias j="fasd_cd -d -r"
else
    echo "exa is not installed."
    install fasd
fi

alias lt="ls --sort newest"
alias llt="ll --sort newest"
alias ltr="ls --sort oldest"
alias lltr="ll --sort oldest"

alias egrep="egrep --color=auto"
alias grep="grep --color=auto"
alias egr="egrep -iHnr"
alias gr="grep -iHnr"
alias cegr="egrep -iHnr --color=always"
alias cgr="egrep -iHnr --color=always"

# A trailing space in VALUE causes the next word to be checked for alias substitution when the alias is expanded.
alias watch="watch --color --interval 0.5 "

if hash nvim 2>/dev/null; then
    alias vim="nvim"
    alias v="nvim"
else
    echo "neovim is missing"
    install neovim
fi

if hash fping 2>/dev/null; then
    alias wping="fping wp.pl -l | cut -d , -f 3-4"
else
    echo "fping is missing"
    install fping
fi

if hash ranger 2>/dev/null; then
    alias ranger='ranger --choosedir=$HOME/.rangerdir; cd `cat $HOME/.rangerdir`'
    alias ra="ranger"
else
    echo "ranger is missing"
    install ranger
fi

if hash trash 2>/dev/null; then
    alias rmm="trash"
else
    echo "trash-cli is not installed."
    install trash-cli
fi

if hash git 2>/dev/null; then
    alias g=git
    # cd to git root
    alias gcd='[ ! -z `git rev-parse --show-cdup` ] && cd `git rev-parse --show-cdup || pwd`'
    alias git-delete-merged='git branch --merged | grep -Ev \(develop\|master\) | xargs git br -d'

else
    echo "git is missing"
    install git
fi

if hash gh 2>/dev/null; then
    alias gh-create='gh pr create -t $(git branch --show-current)'
    alias gh-create-web='gh pr create -w -t $(git branch --show-current)'
    alias gh-complete='gh pr merge --auto --delete-branch --squash  -t $(git branch --show-current)'

else
    echo "gh is missing"
    install github-cli
fi

if hash lazygit 2>/dev/null; then
    alias lg='lazygit'
    alias gg='lazygit'
else
    echo "lazygit is missing"
    install lazygit
fi

if hash cmatrix 2>/dev/null; then
    alias s='cmatrix -absCcyan'
else
    echo "cmatrix is missing"
    install cmatrix
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
    install translate-shell
fi

if hash ag 2>/dev/null; then
    alias ag='ag --smart-case'
else
    echo "the_silver_searcher or silversearcher-ag or silver-searcher is not installed."
    install the_silver_searcher
    install silversearcher-ag
    install silver-searcher
fi

if hash yarn 2>/dev/null; then
    alias y='yarn'
else
    echo "yarn is not installed."
    install yarn
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
    install xclip
fi

if hash tig 2>/dev/null; then
    alias tiga='tig --all'
else
    echo "tig is not installed."
    install tig
fi

if hash tmux 2>/dev/null; then
    alias ta='tmux attach -t'
    alias tn='tmux new -t'
    alias tl='tmux ls'
else
    echo "tmux is not installed."
    install tmux
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
