#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

session_switcher_key="$(tmux show-option -gqv "@session_switcher_key")"
session_create_key="$(tmux show-option -gqv "@session_create_key")"

# Backward compatibility for existing option names.
if [[ -z "$session_switcher_key" ]]; then
    session_switcher_key="$(tmux show-option -gqv "@session_manager_key")"
fi

if [[ -z "$session_create_key" ]]; then
    session_create_key="$(tmux show-option -gqv "@session_creator_key")"
fi

session_switcher_key="${session_switcher_key:-s}"
session_create_key="${session_create_key:-j}"

tmux bind-key "$session_switcher_key" display-popup -E -w 80% -h 60% -T ' tmux-session-switcher ' "bash '$current_dir/scripts/sessioin-manager'"
tmux bind-key "$session_create_key" display-popup -E -w 80% -h 60% -T ' tmux-session-creator ' "bash '$current_dir/scripts/sessionizer'"
