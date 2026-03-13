# Set a custom session root path. Default is `$HOME`.
session_root "$PROJECT_ROOT/Private"

if initialize_session "eunoia"; then

  # ── Window 1: eunioa ──
  window_root "$PROJECT_ROOT/Private/eunoia"
  new_window "eunoia"

  split_h 50

  # Left pane: Dev server
  select_pane 1
  run_cmd "bun storybook"

  # Right pane: nvim
  select_pane 2
  run_cmd "nvim"

  # ── Window 2: claude ──
  new_window "claude"

  # Start on the first window
  select_window 1

fi

finalize_and_go_to_session
