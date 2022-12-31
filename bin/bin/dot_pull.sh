#!/bin/bash

paths=(
~/.vim
~/.zprezto
~/vimwiki
)
for item in ${paths[*]}
do
    echo $item
    git -C $item status
    git -C $item pull --rebase
    echo '----------------------------------------------'
done
