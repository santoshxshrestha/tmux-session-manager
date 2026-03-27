#!/usr/bin/env bash

SEARCH_DIRS="${search_dirs:-$HOME}"
EXCLUDE_DIRS="${exclude_dirs:-node_modules,.git,target}"

IFS=',' read -ra DIRS <<< "$EXCLUDE_DIRS"

exclude_args=""
for d in "${DIRS[@]}"; do
    exclude_args="$exclude_args -o -name '$d'"
done

selected=$(find "$SEARCH_DIRS" -mindepth 1 -maxdepth 4 \( -name "${DIRS[0]}" $exclude_args \) -prune -o -type d -print 2>/dev/null | fzf --reverse --prompt="✦ ❯ " --header="━━ ✦ NEW SESSION ✦ ━━" --header-first --color="header:italic" --preview="tree -C -L 2 {}" --preview-window="right:50%:wrap")

if [ -n "$selected" ]; then
    session=$(basename "$selected" | tr "." "_")
    tmux new-session -ds "$session" -c "$selected" 2>/dev/null && tmux switch-client -t "$session"
fi
