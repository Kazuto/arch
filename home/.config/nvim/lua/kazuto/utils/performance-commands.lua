-- Performance monitoring commands
-- Provides user commands for accessing performance utilities

local performance = require("kazuto.utils.performance")

-- Create user commands for performance monitoring
vim.api.nvim_create_user_command("PerfReport", function()
  performance.print_performance_report()
end, {
  desc = "Show detailed performance report"
})

vim.api.nvim_create_user_command("PerfDiagnose", function()
  performance.print_diagnostic_report()
end, {
  desc = "Diagnose performance issues and show suggestions"
})

vim.api.nvim_create_user_command("PerfProfile", function(opts)
  if opts.args == "" then
    local current_profile = performance.get_performance_profile()
    print("Current performance profile: " .. current_profile)
    print("Available profiles: conservative, balanced, performance")
  else
    performance.apply_performance_profile(opts.args)
  end
end, {
  desc = "Get or set performance profile",
  nargs = "?",
  complete = function()
    return { "conservative", "balanced", "performance" }
  end
})

vim.api.nvim_create_user_command("PerfMemory", function()
  local memory_mb = performance.get_memory_usage()
  local system_info = performance.get_system_info()
  
  print(string.format("Current memory usage: %dMB", memory_mb))
  print(string.format("CPU usage: %.1f%%", system_info.cpu_percent))
  
  if memory_mb > performance.config.performance_threshold.memory_limit_mb then
    print("⚠️  Memory usage is above threshold!")
  else
    print("✅ Memory usage is within normal limits")
  end
end, {
  desc = "Show current memory and CPU usage"
})

vim.api.nvim_create_user_command("PerfFileSize", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local size_bytes = performance.get_file_size(bufnr)
  local size_mb = size_bytes / (1024 * 1024)
  local line_count = performance.get_line_count(bufnr)
  local longest_line = performance.get_longest_line_length(bufnr)
  local is_large = performance.is_large_file(bufnr)
  
  print(string.format("File size: %.2fMB (%d bytes)", size_mb, size_bytes))
  print(string.format("Lines: %d", line_count))
  print(string.format("Longest line: %d characters", longest_line))
  
  if is_large then
    print("⚠️  This is considered a large file - some features may be disabled")
  else
    print("✅ File size is within normal limits")
  end
end, {
  desc = "Show current file size and statistics"
})

vim.api.nvim_create_user_command("PerfReset", function()
  performance.metrics = {
    startup_time = vim.loop.hrtime(),
    lsp_response_times = {},
    completion_latency = {},
    memory_usage = {},
    file_sizes = {},
    plugin_load_times = {},
    last_updated = vim.loop.hrtime(),
  }
  
  print("✅ Performance metrics reset")
end, {
  desc = "Reset all performance metrics"
})

vim.api.nvim_create_user_command("PerfConfig", function()
  print("=== Performance Configuration ===")
  print("Monitoring enabled: " .. tostring(performance.config.enable_monitoring))
  print("Max history size: " .. performance.config.max_history_size)
  print("Memory check interval: " .. performance.config.memory_check_interval .. "ms")
  print()
  print("Performance Thresholds:")
  print("  LSP timeout: " .. performance.config.performance_threshold.lsp_timeout .. "ms")
  print("  Completion timeout: " .. performance.config.performance_threshold.completion_timeout .. "ms")
  print("  Memory limit: " .. performance.config.performance_threshold.memory_limit_mb .. "MB")
  print("  Large file size: " .. math.floor(performance.config.performance_threshold.large_file_size / 1024) .. "KB")
end, {
  desc = "Show current performance configuration"
})

-- Auto-complete for performance commands
vim.api.nvim_create_user_command("PerfHelp", function()
  print("=== Performance Monitoring Commands ===")
  print(":PerfReport      - Show detailed performance report")
  print(":PerfDiagnose    - Diagnose performance issues")
  print(":PerfProfile     - Get/set performance profile")
  print(":PerfMemory      - Show memory and CPU usage")
  print(":PerfFileSize    - Show current file statistics")
  print(":PerfReset       - Reset performance metrics")
  print(":PerfConfig      - Show configuration")
  print(":PerfHelp        - Show this help")
end, {
  desc = "Show performance monitoring help"
})

return performance