-- Recolors the UI accents with the color apply-accent.sh took from the wallpaper.
-- Syntax colors stay Catppuccin Mocha.
local M = {}

local dir = vim.fn.expand("~/.cache/quickshell")
local path = dir .. "/accent"

local groups = {
  "CursorLineNr",
  "FloatBorder",
  "FloatTitle",
  "NvimTreeFolderIcon",
  "NvimTreeRootFolder",
  "TelescopeBorder",
  "TelescopePreviewBorder",
  "TelescopePromptBorder",
  "TelescopeResultsBorder",
  "TelescopeSelectionCaret",
  "TelescopeTitle",
}

local function read_accent()
  local file = io.open(path, "r")
  if not file then
    return nil
  end

  local line = file:read("*l")
  file:close()

  return line and line:match("^#%x%x%x%x%x%x$")
end

local function apply()
  local accent = read_accent()
  if not accent then
    return
  end

  for _, name in ipairs(groups) do
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    hl.fg = accent
    vim.api.nvim_set_hl(0, name, hl)
  end
end

function M.setup()
  apply()

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("KazutoAccent", { clear = true }),
    callback = apply,
  })

  -- The script rewrites the file in place, so an empty read during the write is ignored
  vim.fn.mkdir(dir, "p")
  M.watcher = vim.uv.new_fs_event()
  M.watcher:start(dir, {}, function(_, filename)
    if filename == "accent" then
      vim.schedule(apply)
    end
  end)
end

return M
