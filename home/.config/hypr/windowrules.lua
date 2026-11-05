hl.window_rule({
  name = "ghostty-opacity",
  match = { class = "ghostty" },

  opacity = "1.0 0.5",
})

hl.window_rule({
  name = "file-progress",
  match = { class = "file_progress" },

  float = true,
})

hl.window_rule({
  name = "confirm",
  match = { class = "confirm" },

  float = true,
})

hl.window_rule({
  name = "dialog",
  match = { class = "dialog" },

  float = true,
})

hl.window_rule({
  name = "download",
  match = { class = "download" },

  float = true,
})

hl.window_rule({
  name = "notification",
  match = { class = "notification" },

  float = true,
})

hl.window_rule({
  name = "error",
  match = { class = "error" },

  float = true,
})

hl.window_rule({
  name = "splash",
  match = { class = "splash" },

  float = true,
})

hl.window_rule({
  name = "confirmreset",
  match = { class = "confirmreset" },

  float = true,
})

hl.window_rule({
  name = "open-file",
  match = { title = "Open File" },

  float = true,
})

hl.window_rule({
  name = "branchdialog",
  match = { title = "branchdialog" },

  float = true,
})

hl.window_rule({
  name = "lxappearance",
  match = { class = "Lxappearance" },

  float = true,
})

hl.window_rule({
  name = "rofi",
  match = { class = "Rofi" },

  float = true,
  no_anim = true,
  dim_around = true,
})

hl.window_rule({
  name = "viewnior",
  match = { class = "viewnior" },

  float = true,
  size = "1720 1080",
  center = true,
})

hl.window_rule({
  name = "feh",
  match = { class = "feh" },

  float = true,
})

hl.window_rule({
  name = "pavucontrol-qt",
  match = { class = "pavucontrol-qt" },

  float = true,
})

hl.window_rule({
  name = "pavucontrol",
  match = { class = "pavucontrol" },

  float = true,
})

hl.window_rule({
  name = "file-roller",
  match = { class = "file-roller" },

  float = true,
})

hl.window_rule({
  name = "mpv",
  match = { class = "mpv" },

  idle_inhibit = "focus",
})

hl.window_rule({
  name = "google-chrome",
  match = { class = "google-chrome" },

  idle_inhibit = "fullscreen",
})

hl.window_rule({
  name = "media-viewer",
  match = { title = "^(Media viewer)$" },

  float = true,
})

hl.window_rule({
  name = "volume-control",
  match = { title = "^(Volume Control)$" },

  float = true,
  size = "800 600",
  move = "75 monitor_h*0.44",
})

hl.window_rule({
  name = "picture-in-picture",
  match = { title = "^(Picture-in-Picture)$" },

  float = true,
})

hl.window_rule({
  name = "floating-windows",
  match = { float = true },

  border_size = 0,
})

hl.window_rule({
  name = "ghostty-workspace",
  match = { class = "ghostty" },

  workspace = "2",
})

hl.window_rule({
  name = "vesktop",
  match = { class = "vesktop" },

  workspace = "6 silent",
})

hl.window_rule({
  name = "steam",
  match = { class = "steam" },

  workspace = "3",
  float = true,
})

hl.window_rule({
  name = "Proton Mail",
  match = { class = "Proton Mail" },

  workspace = "5",
})

hl.window_rule({
  name = "spotify",
  match = { class = "Spotify" },

  workspace = "8 silent",
})

hl.window_rule({
  name = "steam-games",
  match = { class = "^(steam_app_.*)$" },

  workspace = "3",
})

hl.window_rule({
  name = "Aniimo",
  match = { class = "^(steam_app_.*)$", title = "^(Aniimo)$" },

  fullscreen_state = "2 2",
  suppress_event = "fullscreen",
})

hl.window_rule({
  name = "prominence",
  match = { class = "Prominence™ II: Hasturian Era" },

  workspace = "3",
  fullscreen_state = "2 2",
  content = "game",
  immediate = true,
  suppress_event = "fullscreen",
  no_follow_mouse = true,
})
