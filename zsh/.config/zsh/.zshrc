#!/usr/bin/env zsh

[ -f "$ZDOTDIR/plugins.zsh" ] && source "$ZDOTDIR/plugins.zsh" || echo 'file plugins not found'

[ -f "$ZDOTDIR/zaliases.zsh" ] && source "$ZDOTDIR/zaliases.zsh" || echo 'file zaliases not found'
