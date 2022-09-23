#!/bin/sh

cp -f src/* backup/

rbw gen-completions zsh >| src/_rbw

bun completions
mv ~/.bun/_bun src/
