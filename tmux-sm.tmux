#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

session_switcher_key="$(tmux show-option -gqv "@session_switcher_key")"
session_create_key="$(tmux show-option -gqv "@session_create_key")"
session_popup_width="$(tmux show-option -gqv "@session_popup_width")"
session_popup_height="$(tmux show-option -gqv "@session_popup_height")"

# Backward compatibility for existing option names.
if [[ -z "$session_switcher_key" ]]; then
    session_switcher_key="$(tmux show-option -gqv "@session_manager_key")"
fi

if [[ -z "$session_create_key" ]]; then
    session_create_key="$(tmux show-option -gqv "@session_creator_key")"
fi

session_switcher_key="${session_switcher_key:-s}"
session_create_key="${session_create_key:-j}"
session_popup_width="${session_popup_width:-80%}"
session_popup_height="${session_popup_height:-60%}"

tmux bind-key "$session_switcher_key" display-popup -E -B -w "$session_popup_width" -h "$session_popup_height" "bash '$current_dir/scripts/session-manager'"
tmux bind-key "$session_create_key" display-popup -E -B -w "$session_popup_width" -h "$session_popup_height" "bash '$current_dir/scripts/sessionizer'"
