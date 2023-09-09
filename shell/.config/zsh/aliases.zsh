#!/usr/bin/env zsh

install() {
    if hash pacman 2>/dev/null; then
        echo "Installing $1"
        # sudo pacman -S $1
        yay -S $1
    elif hash pkg 2>/dev/null; then
        case $1 in
            xclip | fping)
                return 
                ;;
        esac
        echo "Installing $1"
        pkg install $1
    fi
    zsh
}

alias :q='exit'

if command -v eza &>/dev/null; then
    alias l='eza'
    alias ls='eza --group-directories-first --icons --git'
    alias ll='ls -lah --git'
    alias la='eza -a'
    alias tree='ll --tree --level=2'
else
    echo "eza is not installed."
    install eza
fi

alias lt="ls --sort newest"
alias llt="ll --sort newest"
alias ltr="ls --sort oldest"
alias lltr="ll --sort oldest"

if command -v fasd &>/dev/null; then
    alias j="fasd_cd -d -r"
else
    echo "exa is not installed."
    install fasd
fi

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
else
    echo "git is missing"
    install git
fi

if hash gh 2>/dev/null; then
    alias gh-create='gh pr create -t $(git branch --show-current)'
    alias gh-create-web='gh pr create -w -t $(git branch --show-current)'
    # alias gh-complete='gh pr merge --auto --delete-branch --squash'
    # alias gh-complete='gh pr merge --auto --delete-branch --squash -t $(git branch --show-current)'

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
    alias ag='\ag  --smart-case --pager="less -XFR"'
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

if hash pnpm 2>/dev/null; then
    alias p='pnpm'
else
    # echo "pnpm is not installed."
    # install pnpm
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

alias yay-update='yay -Quq --aur | xargs -n 1 yay -S --noconfirm'
alias yay-list='yay -Qu --aur'

# Avoid breaking fingers with date
alias date-clip='date --iso-8601 | xclip'
alias date-today="date +%Y-%m-%d"
alias date-now="date +%Y-%m-%d_%H-%m_%S"

colors() {
  for i in {0..255};
  do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'};
  done
}

