#!/usr/bin/env bash

default_key_binding="@session_manager_key"
key_binding_option="$(tmux show-option -gqv "$default_key_binding")"
key_binding="${key_binding_option:-"j"}"

tmux bind-key "$key_binding" display-popup -E -w 80% -h 60% -T ' tmux-session-manager' run-shell "$(dirname "$(realpath "$0")")/session-manager.sh"
