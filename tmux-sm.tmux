#!/usr/bin/env bash

default_key_binding="@session_manager_key"
key_binding_option="$(tmux show-option -gqv "$default_key_binding")"
key_binding="${key_binding_option:-"j"}"

tmux bind-key "$key_binding" display-popup -E -w 80% -h 60% -T ' tmux-session-manager ' '
  tmux list-sessions -F "#{session_name}|#{session_windows}|#{?session_attached,attached,detached}" | 
  grep -v "^$(tmux display-message -p "#S")|" | 
  awk -F"|" "{
    status = (\$3 == \"attached\") ? \"\" : \"\"
    printf \"%-20s %s %2s windows %s\\n\", \$1, status, \$2, \"\"
  }" |
  fzf --reverse \
      --prompt="-> " \
      --header="═══ Session Switcher ═══ | Ctrl-R: refresh | Ctrl-D: delete | Ctrl-N: new-session" \
      --header-first \
      --border=rounded \
      --color="header:italic" \
      --preview="tmux list-windows -t {1} -F \"  #{window_index}: #{window_name} #{?window_active,(active),}\"" \
      --preview-window="right:40%:wrap" \
      --bind="ctrl-r:reload(tmux list-sessions -F \"#{session_name}|#{session_windows}|#{?session_attached,attached,detached}\" | grep -v \"^\$(tmux display-message -p \"#S\")|\" | awk -F\"|\" \"{status = (\\\$3 == \\\"attached\\\") ? \\\"\\\" : \\\"\\\"; printf \\\"%-20s %s %2s windows %s\\\\n\\\", \\\$1, status, \\\$2, \\\"\\\"}\")" \
      --bind="ctrl-d:execute(tmux kill-session -t {1})+reload(tmux list-sessions -F \"#{session_name}|#{session_windows}|#{?session_attached,attached,detached}\" | grep -v \"^\$(tmux display-message -p \"#S\")|\" | awk -F\"|\" \"{status = (\\\$3 == \\\"attached\\\") ? \\\"\\\" : \\\"\\\"; printf \\\"%-20s %s %2s windows %s\\\\n\\\", \\\$1, status, \\\$2, \\\"\\\"}\")" \
      --bind="ctrl-n:execute(bash -c '\''echo -n -e \"== New tmux Session === \n Session Name ->  \" && read name && [ -n \"\$name\" ] && tmux new-session -d -s \"\$name\" 2>/dev/null && tmux switch-client -t \"\$name\"'\'')+abort" \
      --info=inline \
      --layout=reverse |
  awk "{print \$1}" | 
  xargs -r tmux switch-client -t
'
