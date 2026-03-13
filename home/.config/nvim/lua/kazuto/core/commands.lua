-- Credit: https://github.com/LunarVim/LunarVim/blob/45f9825d1e666890ed37baf15a14707ae40e5cff/lua/lvim/core/bufferline.lua#L147-L219
local function buf_kill(kill_command, bufnr, force)
  kill_command = kill_command or "bd"

  local bo = vim.bo
  local api = vim.api
  local fmt = string.format
  local fnamemodify = vim.fn.fnamemodify

  if bufnr == 0 or bufnr == nil then
    bufnr = api.nvim_get_current_buf()
  end

  local bufname = api.nvim_buf_get_name(bufnr)

  if not force then
    local warning
    if bo[bufnr].modified then
      warning = fmt([[No write since last change for (%s)]], fnamemodify(bufname, ":t"))
    elseif api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
      warning = fmt([[Terminal %s will be killed]], bufname)
    end
    if warning then
      vim.ui.input({
        prompt = string.format([[%s. Close it anyway? [y]es or [n]o (default: no): ]], warning),
      }, function(choice)
        if choice:match("ye?s?") then
          force = true
        end
      end)
      if not force then
        return
      end
    end
  end

  -- Get list of windows IDs with the buffer to close
  local windows = vim.tbl_filter(function(win)
    return api.nvim_win_get_buf(win) == bufnr
  end, api.nvim_list_wins())

  if #windows == 0 then
    return
  end

  if force then
    kill_command = kill_command .. "!"
  end

  -- Get list of active buffers
  local buffers = vim.tbl_filter(function(buf)
    return api.nvim_buf_is_valid(buf) and bo[buf].buflisted
  end, api.nvim_list_bufs())

  -- If there is only one buffer (which has to be the current one), vim will
  -- create a new buffer on :bd.
  -- For more than one buffer, pick the previous buffer (wrapping around if necessary)
  if #buffers > 1 then
    for i, v in ipairs(buffers) do
      if v == bufnr then
        local prev_buf_idx = i == 1 and (#buffers - 1) or (i - 1)
        local prev_buffer = buffers[prev_buf_idx]
        for _, win in ipairs(windows) do
          api.nvim_win_set_buf(win, prev_buffer)
        end
      end
    end
  end

  -- Check if buffer still exists, to ensure the target buffer wasn't killed
  -- due to options like bufhidden=wipe.
  if api.nvim_buf_is_valid(bufnr) and bo[bufnr].buflisted then
    vim.cmd(string.format("%s %d", kill_command, bufnr))
  end
end

local common_opts = { force = true }

local collection = {
  {
    name = "BufferKill",
    fn = function()
      buf_kill("bd")
    end,
  },
  {
    name = "PhpactorRestart",
    fn = function()
      -- Stop phpactor
      for _, client in pairs(vim.lsp.get_clients()) do
        if client.name == "phpactor" then
          client.stop()
          vim.notify("Stopping PHPActor...", vim.log.levels.INFO)
        end
      end

      -- Wait a moment then restart
      vim.defer_fn(function()
        vim.cmd("LspStart phpactor")
        vim.notify("PHPActor restarted", vim.log.levels.INFO)
      end, 1000)
    end,
  },
  {
    name = "PerformanceInfo",
    fn = function()
      -- Use the new performance utilities
      require("kazuto.utils.performance-commands")
      vim.cmd("PerfReport")
    end,
  },
}

for _, cmd in pairs(collection) do
  local opts = vim.tbl_deep_extend("force", common_opts, cmd.opts or {})
  vim.api.nvim_create_user_command(cmd.name, cmd.fn, opts)
end

-- Initialize performance monitoring utilities
require("kazuto.utils.performance-commands")
