
## clone
Don't forget about submodules.
```
git clone -j8 --recursive URL git://github.com/foo/example.git
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


```
git submodule foreach git pull
```

## full system setup
run ansible playbook
```
cd _init
```

## only dotfiles

```
./install
```
