
## clone
Don't forget about submodules.
```
git clone -j8 --recursive https://github.com/undg/.dot
cd .dot
git submodule foreach git pull
sh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.sh)   # Install zap.
./install
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




## full system setup
run ansible playbook
```
cd _init
```

## only dotfiles

```
./install
./clean-env
```

