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
	# https://www.gh-dash.dev/companions/enhance/getting-started/
	alias gh-actions='gh enhance $(gh pr view --json=number --jq .number)'
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

pnpm-versions() {
	pnpm view "$1" versions | jq -r '.[]' | sort --version-sort
}

npm-versions() {
	npm view "$1" versions | jq -r '.[]' | sort --version-sort
}

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

# Avoid breaking fingers with date
# alias date-clip='date --iso-8601 | xclip'
# alias date-clip='date --iso-8601 | win32yank.exe -i'
alias date-today="date +%Y-%m-%d"
alias date-now="date +%Y-%m-%d_%H-%m_%S"

colors() {
	for i in {0..255}; do
		print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$( (i%6)):#3}:+$'\n'}
	done
}

alias ollama-user-log='journalctl --user-unit ollama.service --since today'

alias docker-ps='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Names}}"'

if hash opencode &>/dev/null; then
	alias o='opencode'
	alias oo='opencode --continue'
	alias og='opencode --prompt "Hi Grug"'
	alias oc='opencode --prompt "Caveman mode on"'
	op() { opencode --prompt "$*"; }
	alias oa='OPENCODE_CONFIG=~/.config/opencode/opencode.local.json opencode'
else
	echo "opencode is not installed."
fi

if hash claude &>/dev/null; then
	alias cl='claude'
fi

if hash ccusage &>/dev/null; then
	alias ccusage='PI_AGENT_DIR=~/.config/pi/sessions ccusage'
fi

alias phone-call="adb shell am start -a android.intent.action.DIAL -d "

#################################################
# Probabilistic Graphical Modelling
#################################################

alias pgm-teardown-be="pkill -f 'uvicorn.*7083'; pkill -f 'uvicorn.*7082'"
alias pgm-teardown-fe="pkill -f 'vite.js'"
alias pgm-teardown="pgm-teardown-be; docker rm -f gitea-postgres gitea-rootless localstack ofelia pgm-graph_sanity pgm-sampling-integration-tkrisk-sample-worker-1 pgm-sampling-integration-tkrisk-sample-worker-2 pgm-tkrisk pgm-tkrisk-ui redis-01 redis-02 redis-03;"

pgm-fe-start() {
	pgm-teardown-fe
	node_modules/.bin/vite --no-open --mode custom
}

pgm-fe-start-local() {
	pgm-teardown-fe
	node_modules/.bin/vite --no-open --mode custom-local
}

pgm-be-start() {
	pgm-teardown
	cd ~/Code/pgm-sampling-integration
	bash _dev-setup/prepare-dev.sh
	cd -
	task dev:prepare-dev
	local bottom_pane_id=$(herdr pane split --direction down | jq -r ".result.pane.pane_id")

	herdr pane run "$bottom_pane_id" task dev:serve-editor # bottom pane
	task dev:serve                                         # top pane (current pane)
}

pgm-be-serve() {
	pgm-teardown-be

	local bottom_pane_id=$(herdr pane split --direction down | jq -r ".result.pane.pane_id")

	herdr pane run "$bottom_pane_id" task dev:serve-editor # bottom pane
	task dev:serve                                         # top pane (current pane)
}
