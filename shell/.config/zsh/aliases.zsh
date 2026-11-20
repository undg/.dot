#!/usr/bin/env zsh

alias :q='exit' # 😎

if command -v eza >/dev/null 2>&1; then
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

if command -v nvim >/dev/null 2>&1; then
	alias v="vim"
	alias vim="nvim"
	alias vp="nvim --nopugin"
	alias gp="nvim -c ':AiProofread'"
else
	echo "neovim is missing"
fi

if command -v mise >/dev/null 2>&1; then
	alias m="mise"
else
	echo "mise is missing"
fi

if command -v fping >/dev/null 2>&1; then
	alias wping="fping wp.pl -l | cut -d , -f 3-4"
else
	echo "fping is missing"
fi

if command -v ranger >/dev/null 2>&1; then
	alias ranger='ranger --choosedir=$HOME/.rangerdir; cd `cat $HOME/.rangerdir`'
	alias ra="ranger"
else
	echo "ranger is missing"
fi

if command -v trash >/dev/null 2>&1; then
	alias rmm="trash"
else
	echo "trash-cli is not installed."
fi

if command -v git >/dev/null 2>&1; then
	# cd to git root
	alias gcd='[ ! -z `git rev-parse --show-cdup` ] && cd `git rev-parse --show-cdup || pwd`'
else
	echo "git is missing"
fi

if command -v gh >/dev/null 2>&1; then
	alias gh-dash='gh dash'
	alias gh-create='gh pr create -t $(git branch --show-current)'
	alias gh-create-web='gh pr create -w -t $(git branch --show-current)'
	# https://www.gh-dash.dev/companions/enhance/getting-started/
	alias gh-actions='gh enhance $(gh pr view --json=number --jq .number)'
else
	echo "gh is missing"
fi

if command -v lazygit >/dev/null 2>&1; then
	alias lg='lazygit'
	alias gg='lazygit'
else
	echo "lazygit is missing"
fi

# translation with http://git.io/trans
if command -v trans >/dev/null 2>&1; then
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

if command -v ag >/dev/null 2>&1; then
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

if command -v xclip >/dev/null 2>&1; then
	alias xclip='xclip -sel c'
fi

if command -v win32yank.exe >/dev/null 2>&1; then
	alias xclip='win32yank.exe -i'
fi

if command -v tig >/dev/null 2>&1; then
	alias tiga='tig --all'
else
	echo "tig is not installed."
fi

if command -v tmux >/dev/null 2>&1; then
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

if command -v opencode >/dev/null 2>&1; then
	alias o='opencode'
	alias oo='opencode --continue'
	alias og='opencode --prompt "Hi Grug"'
	alias oc='opencode --prompt "Caveman mode on"'
	op() { opencode --prompt "$*"; }
	alias oa='OPENCODE_CONFIG=~/.config/opencode/opencode.local.json opencode'
else
	echo "opencode is not installed."
fi

if command -v claude >/dev/null 2>&1; then
	alias cl='claude'
fi

if command -v ccusage >/dev/null 2>&1; then
	alias ccusage='PI_AGENT_DIR=~/.config/pi/sessions ccusage'
fi

alias phone-call="adb shell am start -a android.intent.action.DIAL -d "

if command -v zoxide >/dev/null 2>&1; then
	alias j='z'
fi

#################################################
# Ej Aj
#################################################
s() {
	mkdir -p ~/tmp/Research
	cd ~/tmp/Research
	pissbox --yes
	# cd -
}

#################################################
# Probabilistic Graphical Modelling
#################################################

alias pgm-fe-start='pgm --fe-start'
alias pgm-fe-start-local='pgm --fe-start-local'
alias pgm-fe-stop='pgm --fe-stop'
alias pgm-be-start='pgm --be-start'
alias pgm-be-stop='pgm --be-stop'
alias pgm-be-serve='pgm --be-serve'
alias pgm-be-teardown='pgm --be-teardown'

yz() {
	emulate -L zsh
	local tmp cwd
	tmp="$(mktemp -t "yazi-cwd.XXXXXX")" || return 1
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd <"$tmp"
	rm -f -- "$tmp"
	if [[ -d "$cwd" && "$cwd" != "$PWD" ]]; then
		builtin cd -- "$cwd"
	fi
}
