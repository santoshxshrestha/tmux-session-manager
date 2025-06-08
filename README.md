# tmux-session-manager

A fuzzy terminal popup to manage tmux sessions using `fzf`.
Just a simple and fast session manager for tmux — no plugin manager required. It opens a popup using `fzf` where you can:

- View all other sessions (excluding your current one)
- See how many windows each has
- Preview windows in the selected session
- Switch to it or kill it with a keybind

---

## 🔧 Requirements

- `tmux` 3.2 or higher (for `display-popup`)
- [`fzf`](https://github.com/junegunn/fzf)
- Common UNIX tools (`awk`, `bash`)

---
