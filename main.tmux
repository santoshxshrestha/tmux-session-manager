#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

session_manager_key="$(tmux show-option -gqv "@session_manager_key")"
sessionizer_key="$(tmux show-option -gqv "@sessionizer_key")"

session_manager_height="$(tmux show-option -gqv "@session_manager_height")"
session_manager_width="$(tmux show-option -gqv "@session_manager_width")"

sessionizer_height="$(tmux show-option -gqv "@sessionizer_height")"
sessionizer_width="$(tmux show-option -gqv "@sessionizer_width")"

session_manager_key="${session_manager_key:-j}"
sessionizer_key="${sessionizer_key:-i}"

session_manager_height="${session_manager_height:-30%}"
session_manager_width="${session_manager_width:-40%}"

sessionizer_height="${sessionizer_height:-60%}"
sessionizer_width="${sessionizer_width:-60%}"

tmux bind-key "$session_manager_key" display-popup -E -B -w "$session_manager_width" -h "$session_manager_height" "bash '$current_dir/scripts/session-manager'"

if [[ "$sessionizer_key" == *"-n"* ]]; then
    sessionizer_key=$(echo "$sessionizer_key" | awk '{print $NF}')
    tmux bind-key -n "$sessionizer_key" display-popup -E -B -w "$sessionizer_width" -h "$sessionizer_height" "bash '$current_dir/scripts/sessionizer'"
else
    tmux bind-key "$sessionizer_key" display-popup -E -B -w "$sessionizer_width" -h "$sessionizer_height" "bash '$current_dir/scripts/sessionizer'"
fi
