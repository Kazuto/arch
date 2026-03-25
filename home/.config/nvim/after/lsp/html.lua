return {
  filetypes = { "html", "blade", "templ" },
  on_attach = function(client, bufnr)
    -- Disable formatting for blade files - use blade-formatter instead
    if vim.bo[bufnr].filetype == "blade" then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
  end,
}
