# Set a custom session root path. Default is `$HOME`.
session_root "$PROJECT_ROOT/Work"

if initialize_session "supervisor"; then

  # ── Window 1: supervisor ──
  window_root "$PROJECT_ROOT/Work/production-server-supervisor"
  new_window "supervisor"

  split_h 50

  # Split left pane vertically: lazygit (top) + npm run dev (bottom)
  select_pane 1
  split_v 50

  select_pane 1
  run_cmd "npm run dev"

  # Right pane: nvim
  select_pane 3
  run_cmd "nvim"

  # ── Window 2: server ──
  window_root "$PROJECT_ROOT/Work/production-server-v2"
  new_window "server"

  split_h 50

  # Split left pane vertically: lazygit (top) + npm run dev (bottom)
  select_pane 1
  split_v 50

  select_pane 1
  run_cmd "npm run dev"

  # Right pane: nvim
  select_pane 3
  run_cmd "nvim"

  # Start on the first window
  select_window 1
fi

finalize_and_go_to_session
