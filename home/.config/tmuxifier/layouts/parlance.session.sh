# Set a custom session root path. Default is `$HOME`.
session_root "$PROJECT_ROOT/Private/parlance"

if initialize_session "client"; then

  # ── Window 1: client ──
  window_root "$PROJECT_ROOT/Private/parlance/client/"
  new_window "client"

  split_h 50

  # Split left pane vertically: lazygit (top) + npm run dev (bottom)
  select_pane 1
  split_v 25

  select_pane 1
  run_cmd "lazygit"

  select_pane 2
  run_cmd "npm run dev"

  # Right pane: nvim
  select_pane 3
  run_cmd "nvim"

  # ── Window 2: server ──
  window_root "$PROJECT_ROOT/Private/parlance/server/"
  new_window "server"

  split_h 50

  # Split left pane vertically: lazygit (top) + npm run dev (bottom)
  select_pane 1
  run_cmd "lazygit"

  # Right pane: nvim
  select_pane 2
  run_cmd "nvim"

  # Start on the first window
  select_window 1
fi

finalize_and_go_to_session
