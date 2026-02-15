#!/usr/bin/env zsh

# 😎
alias :q='exit'

if hash eza 2>/dev/null; then
	alias l='eza'
	alias ls='eza --group-directories-first --icons --git'
	alias ll='ls -lah --git'
	alias la='eza -a'
	alias tree='ll --tree'
	alias treee='ll --tree --level=3'
else
	echo "eza is not installed."
fi

alias lt="ls --sort newest"
alias llt="ll --sort newest"
alias ltr="ls --sort oldest"
alias lltr="ll --sort oldest"

if hash fasd 2>/dev/null; then
	alias j="fasd_cd -d -r"
else
	echo "fasd is not installed."
fi

# Search
alias egrep="egrep --color=auto"
alias grep="grep --color=auto"
alias gr="grep -iHnr"

alias duh="du -h | sort -h"

# A trailing space in VALUE causes the next word to be checked for alias substitution when the alias is expanded.
alias watch="watch --color --interval 0.5 "

if hash nvim 2>/dev/null; then
	alias v="vim"
	alias vim="nvim"
	alias vp="nvim --nopugin"
	alias gp="nvim -c ':AiProofread'"
else
	echo "neovim is missing"
fi

if hash mise 2>/dev/null; then
	alias m="mise"
else
	echo "mise is missing"
fi

if hash fping 2>/dev/null; then
	alias wping="fping wp.pl -l | cut -d , -f 3-4"
else
	echo "fping is missing"
fi

if hash ranger 2>/dev/null; then
	alias ranger='ranger --choosedir=$HOME/.rangerdir; cd `cat $HOME/.rangerdir`'
	alias ra="ranger"
else
	echo "ranger is missing"
fi

if hash trash 2>/dev/null; then
	alias rmm="trash"
else
	echo "trash-cli is not installed."
fi

if hash git 2>/dev/null; then
	# cd to git root
	alias gcd='[ ! -z `git rev-parse --show-cdup` ] && cd `git rev-parse --show-cdup || pwd`'
else
	echo "git is missing"
fi

if hash gh 2>/dev/null; then
	alias gh-dash='gh dash'
	alias gh-create='gh pr create -t $(git branch --show-current)'
	alias gh-create-web='gh pr create -w -t $(git branch --show-current)'
else
	echo "gh is missing"
fi

if hash lazygit 2>/dev/null; then
	alias lg='lazygit'
	alias gg='lazygit'
else
	echo "lazygit is missing"
fi

if hash cmatrix 2>/dev/null; then
	alias s='cmatrix -absCcyan'
else
	echo "cmatrix is missing"
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
	alias ag='\ag  --smart-case --pager="less -XFR"'
else
	echo "the_silver_searcher or silversearcher-ag or silver-searcher is not installed."
fi

alias y='yarn'
alias p='pnpm'

alias vimwiki='nvim -c VimwikiIndex'

if hash xclip 2>/dev/null; then
	alias xclip='xclip -sel c'
fi

if hash win32yank.exe 2>/dev/null; then
	alias xclip='win32yank.exe -i'
fi

if hash tig 2>/dev/null; then
	alias tiga='tig --all'
else
	echo "tig is not installed."
fi

if hash tmux 2>/dev/null; then
	alias tn='tmux new -t'
	alias ta='tmux new -A -s'
	alias tl='tmux ls'
else
	echo "tmux is not installed."
fi

alias yay-update='yay -Quq --aur | xargs -n 1 yay -S --noconfirm'
alias yay-list='yay -Qu --aur'

# Avoid breaking fingers with date
# alias date-clip='date --iso-8601 | xclip'
# alias date-clip='date --iso-8601 | win32yank.exe -i'
alias date-today="date +%Y-%m-%d"
alias date-now="date +%Y-%m-%d_%H-%m_%S"

colors() {
	for i in {0..255};
	do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'};
	done
}

alias ollama-user-log='journalctl --user-unit ollama.service --since today'

alias docker-ps='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Names}}"'

if hash  opencode &>/dev/null; then
	alias o='opencode'
	alias oc='opencode --continue'
else
	echo "opencode is not installed."
fi
