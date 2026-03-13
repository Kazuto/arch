# Set a custom session root path. Default is `$HOME`.
session_root "$PROJECT_ROOT/Work"

if initialize_session "frontend-merchant"; then

  # ── Window 1: eunioa ──
  window_root "$PROJECT_ROOT/Work/frontend-merchant-administration/"
  new_window "frontend-merchant"

  split_h 50

  # Left pane: Dev server
  select_pane 1
  run_cmd "npm run dev"

  # Right pane: nvim
  select_pane 2
  run_cmd "nvim"

  # ── Window 2: claude ──
  new_window "claude"

  select_pane 1
  run_cmd "claude"

  # Start on the first window
  select_window 1

fi

finalize_and_go_to_session
