# Dotfiles

## Clone

Don't forget about submodules.
```
git clone -j8 --recursive https://github.com/undg/.dot

cd .dot

git submodule foreach git pull

sh <(curl -s https://raw.githubusercontent.com/undg/zap/master/install.sh)   # Install zap.
./install

touch ~/.config/zsh/secret.zsh # private env variables and scripts 

```
> -j8 is an optional performance optimization available in version 2.8. It fetches up to 8 submodules in parallel.


Have you forgotten? Again? xS
```
git submodule update --init --recursive
```

```
git submodule init
```

```
git submodule update
```

done


## Manage dotfiles

```
./install
./clean-env
```

