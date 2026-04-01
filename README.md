# tmux-session-manager

A fuzzy terminal popup to manage and create tmux sessions using `fzf`.

![tmux session switcher popup](./assets/session-manager.png)

![tmux session creator popup](./assets/session-creator.png)

_You can replace these screenshots with the latest UI images._

Just a simple and fast tmux workflow helper - available as a plugin or standalone. It opens popups using `fzf` where you can:

- View and switch sessions quickly
- Preview windows in the selected session
- Delete a session with confirmation
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
run-shell ~/.tmux/plugins/tmux-sm/tmux-sm.tmux
```

3. Reload tmux config:

```bash
tmux source-file ~/.tmux.conf
```

### Quick Install (Standalone)

> ⚠️ **Discontinued:** the standalone snippet below is kept for legacy users only.
> It is messy, hard to refactor safely, and no longer actively maintained.
> Prefer the plugin install path above for ongoing updates.

Add these lines to your `~/.tmux.conf`:

```bash
bind j display-popup -E -w 80% -h 60% -T ' tmux-session-manager ' '
  tmux list-sessions -F "#{session_name}|#{session_windows}|#{?session_attached,attached,detached}" |
  grep -v "^$(tmux display-message -p "#S")|" |
  awk -F"|" "{
    status = (
      \$3 == \"attached\"
    ) ? \" (attached)\" : \"\"
    printf \"%-24s %3s windows%s\\n\", \$1, \$2, status
  }" |
  fzf --reverse \
      --prompt="-> " \
      --header="Session Switcher" \
      --header-first \
      --border=rounded \
      --preview="tmux list-windows -t {1}" \
      --preview-window="right:50%:wrap" \
      --layout=reverse |
  awk "{print \$1}" |
  xargs -r tmux switch-client -t
'
```

Then reload your tmux config:

```bash
tmux source-file ~/.tmux.conf
```

It still works, but it is provided as-is.

## Usage

### Default Key Bindings

- **Press `prefix` + `s`** to open the session switcher
- **Press `prefix` + `j`** to open the session creator

### Custom Key Bindings

Add to your `~/.tmux.conf` to change default keys:

```bash
set -g @session_switcher_key 'S'  # Switcher key (default: 's')
set -g @session_create_key 'J'    # Creator key (default: 'j')
```

Legacy option names are still supported:

```bash
set -g @session_manager_key 'S'
set -g @session_creator_key 'J'
```

### Session Switcher Controls

Inside the switcher popup:

- **Type to search** - Fuzzy find sessions by name
- **Enter** - Switch to selected session
- **Ctrl-O** - Open session creator
- **Ctrl-D** - Delete selected session (with `y/n` confirmation)
- **Esc** - Close without switching

### Session Creator Behavior

Inside the creator popup:

- **Type to search** - Fuzzy find directories under `$HOME`
- **Enter** - Create/switch to session named from directory basename
- If tmux is not running, it starts a new tmux session
- If the session exists, it switches/attaches to it
- **Esc** - Close without creating/switching

## Customization

### Available Options

```bash
# Session switcher key binding (default: 's')
set -g @session_switcher_key 's'

# Session creator key binding (default: 'j')
set -g @session_create_key 'j'
```

### Popup Size (Current Default)

The plugin currently uses:

- Width: `80%`
- Height: `60%`

To change popup size today, edit `tmux-sm.tmux` and adjust:

```bash
display-popup -E -B -w 80% -h 60%
```

## Screenshots

Current placeholders:

- Switcher: `assets/session-manager.png`
- Creator: `assets/session-creator.png`

Update these files with your newest screenshots anytime.

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

If `prefix + s` or `prefix + j` conflicts with existing bindings, change them:

```bash
set -g @session_switcher_key 'your-switcher-key'
set -g @session_create_key 'your-creator-key'
```

## Contributing

Found a bug or have a feature idea? Feel free to open an issue or submit a PR.

## License

MIT License - see [LICENSE](LICENSE).

---

**Star this repo if it improved your tmux workflow.**
