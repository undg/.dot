# Dark/Light Mode Switching — Plan

**TL;DR:** One config file controls all app themes. Three fields per app: symlink path, dark theme file, light theme file. `light-on` switches symlinks to light; `light-off` to dark. Original configs untouched. Git clean (symlinks gitignored, theme files tracked). Setup: run `light-off` after clone.

**Branch:** `feat/dark-light-mode`

**Goal:** Implement a simple `light-on`/`light-off` terminal command that switches all configured apps between dark and light themes using symlinks.

---

## Architecture

**Mechanism:**
- Original configs stay untouched (dark theme)
- Light configs stored separately as `.light.*` or in `themes/light/`
- Symlinks switch between dark/light versions
- Symlink target IS the state (no flag file needed)
- State persists across reboots naturally

**Command Interface:**
```bash
light-on    # Switch all configured apps to light theme
light-off   # Switch all configured apps to dark theme
```

---

## Phase 1: Requirements & Architecture - DONE

**Decisions made:**
- ✅ Symlink strategy (simplicity over live switching)
- ✅ No flag file - symlink target is the state
- ✅ Original dotfiles remain intact
- ✅ 3-field config format: config, dark, light

---

## Phase 2: Implementation

### Task 2.1: Create light-on/off Commands
- [ ] Create `light-on` script
  - For each configured app, switch symlink to light version
  - Output summary of changes (which apps switched)
  - Handle case where already in light mode
- [ ] Create `light-off` script
  - For each configured app, switch symlink to dark version
  - Output summary of changes (which apps switched)
  - Handle case where already in dark mode
- [ ] Create config file listing all apps and their paths
- [ ] Add both scripts to $PATH

### Task 2.2: Alacritty Theme Switching
- [ ] Add symlink entry for `~/.config/alacritty/current-theme.toml`
- [ ] Light theme: `~/.config/alacritty/themes/themes/github_light_default.toml`
- [ ] Dark theme: `~/.config/alacritty/themes/themes/hyper.toml` (current)
- [ ] Update alacritty.toml to import `current-theme.toml`

### Task 2.3: Tmux Theme Switching
- [ ] Inspect current tmux config
- [ ] Create light theme variant (adjustments needed)
- [ ] Set up symlink

### Task 2.4: Additional Apps (TBD)
- [ ] Kitty terminal
- [ ] Ghostty terminal
- [ ] Television (partially follows terminal - needs investigation)
- [ ] Any other CLI tools

**Notes:**
- Neovim using Gruvbox theme automatically follows terminal colors
- Lazydocker automatically follows terminal colors  
- Lazygit automatically follows terminal colors
- Television partially respects terminal theme (50/50)
- Opencode: doesn't read terminal bg, uses toggle-appearance (PR opportunity for maintainers)

---

## Phase 3: Configuration Mapping

**Format:** TOML with 3 explicit fields per app
- `config` - symlink location (where app reads config)
- `dark` - target file when in dark mode  
- `light` - target file when in light mode

| App | config | dark | light |
|-----|--------|------|-------|
| Alacritty | `~/.config/alacritty/current-theme.toml` | `~/.config/alacritty/themes/themes/hyper.toml` | `~/.config/alacritty/themes/themes/github_light_default.toml` |
| Tmux | TBD | TBD | TBD |
| Kitty | TBD | TBD | TBD |
| Ghostty | TBD | TBD | TBD |

---

## Next Steps

**Current:** Need to inspect existing configs to understand:
1. Tmux theme setup and required adjustments
2. Your preferred light theme choices for remaining apps

Ready to examine your configs to fill in the mapping table?