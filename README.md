# Dotfiles

## Installation

```bash
git clone https://github.com/undg/.dot # clone the repository

cd .dot # enter the repository

sh <(curl -s https://raw.githubusercontent.com/undg/zap/master/install.sh)   # Install zap.

./install # symlink dotfiles with stow

```

## Bind custom githooks

Alter git config with custom githooks:

```
hooksPath = _githooks
```


OR CLI:

```bash
git config --local core.hooksPath _githooks/
```

Done


## Manage dotfiles

```bash
./install
 
# OR

./clean-env
```


