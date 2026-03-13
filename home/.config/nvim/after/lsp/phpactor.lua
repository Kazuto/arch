-- Enhanced phpactor.lua (focused on refactoring, no diagnostics)
return {
  settings = {},
  init_options = {
    ["language_server_phpstan.enabled"] = false,
    ["code_transform.import_globals"] = true,
    ["language_server_psalm.enabled"] = false,
    -- Memory and performance optimizations
    ["indexer.enabled_watchers"] = { "php" },
    ["indexer.exclude_patterns"] = {
      "**/node_modules/**",
      "**/build/**",
      "**/storage/**",
      "**/cache/**",
      "**/.git/**",
      "**/phpstan/**",
      "**/*resultCache*",
      "**/*.cache",
      "**/bootstrap/cache/**",
    },
    ["indexer.poll_time"] = 5000,
    ["completion.dedupe"] = true,
    ["completion_worse.snippets"] = false,
    ["worse_reflection.enable_cache"] = true,
    ["language_server.diagnostics_on_update"] = false,
    ["language_server.diagnostics_on_open"] = false,
    ["language_server.diagnostics_on_save"] = false,
    ["language_server_worse_reflection.diagnostics.enable"] = false,
  },
  on_attach = function(client, bufnr)
    -- Phpactor handles: renaming, refactoring, code actions
    -- Disable capabilities that Intelephense does better
    client.server_capabilities.completionProvider = false
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.documentSymbolProvider = false
    client.server_capabilities.workspaceSymbolProvider = false
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.declarationProvider = false
    client.server_capabilities.implementationProvider = false
    client.server_capabilities.referencesProvider = false
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- COMPLETELY DISABLE DIAGNOSTICS - Let Intelephense handle all diagnostics
    client.server_capabilities.diagnosticProvider = false
    client.server_capabilities.publishDiagnostics = false

    -- Disable diagnostic handlers for this client only
    client.handlers = client.handlers or {}
    client.handlers["textDocument/publishDiagnostics"] = function() end

    -- Keep only what phpactor does well
    -- client.server_capabilities.renameProvider = true (keep default)
    -- client.server_capabilities.codeActionProvider = true (keep default)
  end,
}
