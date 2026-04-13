# tmux-session-manager (tmux-sm)

A fuzzy terminal popup to manage and create tmux sessions using `fzf`.

## session manager

![tmux session manager popup](./assets/session-manager.png)

## sessionizer

![tmux sessionizer popup](./assets/sessionizer.png)

Just a simple and fast tmux workflow helper with a clean, minimal popup UI. It opens `fzf` popups where you can:

- View and switch sessions quickly
- Preview windows in the selected session
- Delete a session
- Create or jump to a session from a directory

---

## Requirements

- `tmux` 3.2 or higher (for `display-popup`)
- [`fzf`](https://github.com/junegunn/fzf)
- Common UNIX tools (`awk`, `bash`, `find`, `tree`)

---

## Installation

### Via TPM (Tmux Plugin Manager)

1. Add plugin to your `~/.tmux.conf`:

```bash
set -g @plugin 'vimlinuz/tmux-sm'
```

2. Press `prefix` + `I` to install.

### Manual Installation

1. Clone the repository:

```bash
git clone https://github.com/vimlinuz/tmux-sm ~/.tmux/plugins/tmux-sm
```

2. Add to your `~/.tmux.conf`:

```bash
run-shell ~/.tmux/plugins/tmux-sm/main.tmux
```

3. Reload tmux config:

```bash
tmux source-file ~/.tmux.conf
```

## Usage

### Default Key Bindings

- **Press `prefix` + `j`** to open the session-manager
- **Press `prefix` + `i`** to open the sessionizer

### Custom Key Bindings

Add to your `~/.tmux.conf` to change default keys:

```bash
set -g @session_manager_key 'k'  # session-manager key (default: 'j')
set -g @sessionizer_key 'j'    # sessionizer key (default: 'i')
```

### Session Manager controls

Inside the popup:

- **Type to search** - Fuzzy find sessions by name
- **Enter** - Switch to selected session
- **Ctrl-i** - Open sessionizer
- **Ctrl-d** - Delete selected session
- **Ctrl-l** - Change the active window in selected session to next
- **Ctrl-h** - Change the active window in selected session to previous
- **Esc** - Close without switching

### sessionizer Behavior

Inside the popup:

- **Type to search** - Fuzzy find directories under `$HOME`
- **Enter** - Create/switch to session named from directory basename
- If the session exists, it switches/attaches to it
- **Esc** - Close without creating/switching

## Customization

### Available Options

```bash
# session-manager key binding (default: 'j')
set -g @session_manager_key 's'

# sessionizer key binding (default: 'i')
set -g @sessionizer_key 'j'

# If you want to use sessionizer without <prefix> (e.g. Alt+i), you can do so by prepending -n:
set -g @sessionizer_key '-n M-i'

# session-manager popup height (default: '30%')
set -g @session_manager_height '40%'

# session-manager popup width (default: '40%')
set -g @session_manager_width '50%'

# sessionizer popup height (default: '60%' )
set -g @sessionizer_height '70%'

# sessionizer popup width (default: '60%' )
set -g @sessionizer_width '80%'
```

### Popup Size (Current Default)

Default popup size:

- Width of session-manager: `40%`
- Height of session-manager: `30%`

- Width of sessionizer: `60%`
- Height of sessionizer: `60%`

To change popup size, set options in your `~/.tmux.conf` as shown in above examples.

## Troubleshooting

**Popup does not appear?**

- Make sure you have tmux 3.2+: `tmux -V`
- Check popup command support: `tmux list-commands | grep popup`

**`fzf` not found?**

- Install fzf: `brew install fzf` or `apt install fzf`
- Or follow the [official fzf installation guide](https://github.com/junegunn/fzf#installation)

**`tree` not found in preview?**

- Install `tree` package for your OS
- Or remove/adjust the preview command in `scripts/sessionizer`

**Key binding conflicts?**

If `prefix + j` or `prefix + i` conflicts with existing bindings, change them as shown in above examples.

## Contributing

Found a bug or have a feature idea? Feel free to open an issue or submit a PR.

## License

MIT License - see [LICENSE](LICENSE).

---

**⭐ Star this repo if it improved your tmux workflow.**
