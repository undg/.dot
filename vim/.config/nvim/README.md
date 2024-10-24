
```
    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
```


# Testing
You need to install `lua` (lua51, jit, whatever) and `busted` form distro repo

Install dependencies with `make`:

Install dependencies:

```bash
make install
```

Tests are in `spec/` directory. To run all of them:

```bash
busted
```

or only one file:

```bash
busted spec/str_spec.lua
```

More about test runner on [busted doc](https://lunarmodules.github.io/busted/) page.
