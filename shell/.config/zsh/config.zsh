#!/usr/bin/env zsh
autoload -Uz plug

unsetopt BEEP
setopt GLOB_DOTS
setopt NOMATCH
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS
setopt APPEND_HISTORY
setopt autocd

HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
# WORDCHARS='*?_-.[]~=&;!#$%^(){}<>/'
WORDCHARS=${WORDCHARS/\//} # Remove `/` from WORDCHARS
WORDCHARS=${WORDCHARS/-/}  # Remove `-` from WORDCHARS
WORDCHARS=${WORDCHARS/./}  # Remove `.` from WORDCHARS
WORDCHARS=${WORDCHARS/_/}  # Remove `_` from WORDCHARS
WORDCHARS=${WORDCHARS/;/}  # Remove `;` from WORDCHARS

setopt BANG_HIST              # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY       # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY          # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS       # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found.
setopt HIST_IGNORE_SPACE      # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS      # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY            # Don't execute immediately upon history expansion.

# Colors
autoload -Uz colors && colors
