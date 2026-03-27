#!/usr/bin/env bash

KEY_REFRESH="${key_refresh:-ctrl-r}"
KEY_DELETE="${key_delete:-ctrl-d}"
SEARCH_DIRS="${search_dirs:-$HOME}"
EXCLUDE_DIRS="${exclude_dirs:-node_modules,.git,target}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

get_current_session() {
    tmux display-message -p "#S"
}

list_sessions() {
    tmux list-sessions -F "#{session_name}|#{session_windows}|#{?session_attached,attached,detached}" 2>/dev/null
}

get_sessions_formatted() {
    local current_session
    current_session="$(get_current_session)"
    list_sessions | grep -v "^${current_session}|" | while IFS='|' read -r name windows status; do
        printf "%-20s %2s windows\n" "$name" "$windows"
    done
}

delete_session() {
    local session_name="$1"
    tmux kill-session -t "$session_name" 2>/dev/null && return 0
    return 1
}

create_new_session() {
    local dir="$1"
    [ -z "$dir" ] && return 1

    local session_name
    session_name=$(basename "$dir" | tr . _)

    if ! tmux has-session -t="$session_name" 2>/dev/null; then
        tmux new-session -ds "$session_name" -c "$dir" 2>/dev/null || return 1
    fi

    tmux switch-client -t "$session_name" && return 0
    return 1
}

get_preview_window() {
    local selected_session="$1"
    tmux list-windows -t "$selected_session" -F "  #{window_index}: #{window_name} #{?window_active,(active),}"
}

get_delete_cmd() {
    cat <<'DELETEEOF'
tmux kill-session -t {} 2>/dev/null
DELETEEOF
}

get_sessions_filter_cmd() {
    cat <<'CMDEOF'
tmux list-sessions -F '%{=3:session_name}|%{=2:session_windows}|%{=?session_attached,attached,detached}' | grep -v "^$(tmux display-message -p '#S')|" | while IFS='|' read -r name windows status; do printf '%-20s %2s windows\n' "$name" "$windows"; done
CMDEOF
}

get_fzf_bindings() {
    local refresh_cmd
    refresh_cmd=$(get_sessions_filter_cmd)

    printf '%s\n%s\n%s' \
        "--bind=${KEY_REFRESH}:reload(${refresh_cmd})" \
        "--bind=${KEY_DELETE}:execute(tmux kill-session -t {} 2>/dev/null)+reload(${refresh_cmd})" \
        "--bind=ctrl-f:execute(bash ${SCRIPT_DIR}/new-session.sh)"
}

get_header_text() {
    local key_refresh_upper="${KEY_REFRESH%%-*}"
    key_refresh_upper="${key_refresh_upper^}"
    local key_delete_upper="${KEY_DELETE%%-*}"
    key_delete_upper="${key_delete_upper^}"
    
    printf "═══ Session Switcher ═══ | %s: refresh | %s: delete | ctrl-f: new-session | ctrl-n/j: next" \
        "$key_refresh_upper" "$key_delete_upper"
}

get_preview_cmd() {
    cat <<'PREVIEWEOF'
bash -c 's=$(echo {} | awk "{print \$1}"); tmux list-windows -t "$s" -F "#{window_index}: #{window_name}#{?window_active,*,}"
PREVIEWEOF
}

get_fzf_options() {
    local current_session
    current_session="$(get_current_session)"
    
    local sessions_formatted
    sessions_formatted=$(get_sessions_formatted)
    
    local bindings
    mapfile -t binding_lines < <(get_fzf_bindings)

    local header_text
    header_text=$(get_header_text)

    local preview_cmd
    preview_cmd=$(get_preview_cmd)

    printf '%s' "${sessions_formatted}" | fzf \
        --prompt="-> " \
        --header="$header_text" \
        --header-first \
        --border=rounded \
        --color="header:italic" \
        --preview="$preview_cmd" \
        --preview-window="right:50%:wrap" \
        "${binding_lines[@]}" \
        --info=inline \
        --layout=reverse
}

switch_to_session() {
    local session_name="$1"
    [ -n "$session_name" ] && tmux switch-client -t "$session_name"
}

main() {
    local selected_session
    selected_session=$(get_fzf_options | awk '{print $1}')

    [ -n "$selected_session" ] && switch_to_session "$selected_session"
}

main "$@"
