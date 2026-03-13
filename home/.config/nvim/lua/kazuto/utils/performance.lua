-- Performance monitoring and optimization utilities
-- Provides tools for tracking LSP response times, memory usage, and system performance

local M = {}

-- Performance metrics storage
M.metrics = {
  startup_time = 0,
  lsp_response_times = {},
  completion_latency = {},
  memory_usage = {},
  file_sizes = {},
  plugin_load_times = {},
  last_updated = 0,
}

-- Configuration for performance monitoring
M.config = {
  enable_monitoring = true,
  max_history_size = 100,
  memory_check_interval = 5000, -- 5 seconds
  performance_threshold = {
    lsp_timeout = 3000, -- 3 seconds
    completion_timeout = 500, -- 500ms
    memory_limit_mb = 512, -- 512MB
    large_file_size = 1024 * 1024, -- 1MB
  },
}

-- Initialize performance monitoring
function M.init()
  M.metrics.startup_time = vim.loop.hrtime()
  M.metrics.last_updated = vim.loop.hrtime()
  
  -- Set up periodic memory monitoring
  if M.config.enable_monitoring then
    M.start_memory_monitoring()
  end
end

-- Memory monitoring functions
function M.get_memory_usage()
  local handle = io.popen("ps -o rss= -p " .. vim.fn.getpid())
  if not handle then
    return 0
  end
  
  local result = handle:read("*a")
  handle:close()
  
  -- RSS is in KB, convert to MB
  local memory_kb = tonumber(result) or 0
  return math.floor(memory_kb / 1024)
end

function M.start_memory_monitoring()
  local timer = vim.loop.new_timer()
  if not timer then
    return
  end
  
  timer:start(M.config.memory_check_interval, M.config.memory_check_interval, function()
    vim.schedule(function()
      local memory_mb = M.get_memory_usage()
      table.insert(M.metrics.memory_usage, {
        timestamp = vim.loop.hrtime(),
        memory_mb = memory_mb,
      })
      
      -- Keep only recent history
      if #M.metrics.memory_usage > M.config.max_history_size then
        table.remove(M.metrics.memory_usage, 1)
      end
      
      -- Alert if memory usage is high
      if memory_mb > M.config.performance_threshold.memory_limit_mb then
        vim.notify(
          string.format("High memory usage detected: %dMB", memory_mb),
          vim.log.levels.WARN,
          { title = "Performance Monitor" }
        )
      end
    end)
  end)
end

-- LSP performance tracking
function M.track_lsp_request(server_name, request_type, start_time)
  local end_time = vim.loop.hrtime()
  local duration_ms = (end_time - start_time) / 1000000 -- Convert to milliseconds
  
  if not M.metrics.lsp_response_times[server_name] then
    M.metrics.lsp_response_times[server_name] = {}
  end
  
  table.insert(M.metrics.lsp_response_times[server_name], {
    request_type = request_type,
    duration_ms = duration_ms,
    timestamp = end_time,
  })
  
  -- Keep only recent history
  local server_metrics = M.metrics.lsp_response_times[server_name]
  if #server_metrics > M.config.max_history_size then
    table.remove(server_metrics, 1)
  end
  
  -- Alert if response time is too slow
  if duration_ms > M.config.performance_threshold.lsp_timeout then
    vim.notify(
      string.format("Slow LSP response from %s: %dms", server_name, duration_ms),
      vim.log.levels.WARN,
      { title = "Performance Monitor" }
    )
  end
  
  return duration_ms
end

-- Completion performance tracking
function M.track_completion_latency(source, start_time)
  local end_time = vim.loop.hrtime()
  local duration_ms = (end_time - start_time) / 1000000
  
  if not M.metrics.completion_latency[source] then
    M.metrics.completion_latency[source] = {}
  end
  
  table.insert(M.metrics.completion_latency[source], {
    duration_ms = duration_ms,
    timestamp = end_time,
  })
  
  -- Keep only recent history
  local source_metrics = M.metrics.completion_latency[source]
  if #source_metrics > M.config.max_history_size then
    table.remove(source_metrics, 1)
  end
  
  return duration_ms
end

-- Plugin load time tracking
function M.track_plugin_load(plugin_name, start_time)
  local end_time = vim.loop.hrtime()
  local duration_ms = (end_time - start_time) / 1000000
  
  M.metrics.plugin_load_times[plugin_name] = duration_ms
  
  return duration_ms
end

-- File size detection and optimization helpers
function M.get_file_size(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)
  
  if filename == "" then
    return 0
  end
  
  local stat = vim.loop.fs_stat(filename)
  if not stat then
    return 0
  end
  
  local size = stat.size or 0
  M.metrics.file_sizes[bufnr] = size
  
  return size
end

function M.is_large_file(bufnr)
  local size = M.get_file_size(bufnr)
  return size > M.config.performance_threshold.large_file_size
end

function M.get_line_count(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return vim.api.nvim_buf_line_count(bufnr)
end

function M.get_longest_line_length(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local max_length = 0
  
  for _, line in ipairs(lines) do
    local length = #line
    if length > max_length then
      max_length = length
    end
  end
  
  return max_length
end

-- Performance profiling helpers
function M.profile_function(func, name)
  name = name or "anonymous"
  local start_time = vim.loop.hrtime()
  
  local success, result = pcall(func)
  
  local end_time = vim.loop.hrtime()
  local duration_ms = (end_time - start_time) / 1000000
  
  if M.config.enable_monitoring then
    vim.notify(
      string.format("Profile [%s]: %.2fms", name, duration_ms),
      vim.log.levels.DEBUG,
      { title = "Performance Profiler" }
    )
  end
  
  if not success then
    vim.notify(
      string.format("Error in profiled function [%s]: %s", name, result),
      vim.log.levels.ERROR,
      { title = "Performance Profiler" }
    )
    return nil, result
  end
  
  return result, duration_ms
end

function M.create_timer(name)
  return {
    name = name,
    start_time = vim.loop.hrtime(),
    stop = function(self)
      local end_time = vim.loop.hrtime()
      local duration_ms = (end_time - self.start_time) / 1000000
      
      if M.config.enable_monitoring then
        vim.notify(
          string.format("Timer [%s]: %.2fms", self.name, duration_ms),
          vim.log.levels.DEBUG,
          { title = "Performance Timer" }
        )
      end
      
      return duration_ms
    end,
  }
end

-- System resource detection
function M.get_cpu_usage()
  local handle = io.popen("ps -o %cpu= -p " .. vim.fn.getpid())
  if not handle then
    return 0
  end
  
  local result = handle:read("*a")
  handle:close()
  
  return tonumber(result) or 0
end

function M.get_system_info()
  return {
    os = vim.loop.os_uname().sysname,
    arch = vim.loop.os_uname().machine,
    version = vim.loop.os_uname().release,
    nvim_version = vim.version(),
    memory_mb = M.get_memory_usage(),
    cpu_percent = M.get_cpu_usage(),
  }
end

-- Configuration validation and environment detection
function M.validate_config(config)
  local errors = {}
  
  -- Validate performance thresholds
  if config.performance_threshold then
    local thresholds = config.performance_threshold
    
    if thresholds.lsp_timeout and (thresholds.lsp_timeout < 100 or thresholds.lsp_timeout > 30000) then
      table.insert(errors, "lsp_timeout must be between 100ms and 30000ms")
    end
    
    if thresholds.completion_timeout and (thresholds.completion_timeout < 50 or thresholds.completion_timeout > 5000) then
      table.insert(errors, "completion_timeout must be between 50ms and 5000ms")
    end
    
    if thresholds.memory_limit_mb and (thresholds.memory_limit_mb < 64 or thresholds.memory_limit_mb > 8192) then
      table.insert(errors, "memory_limit_mb must be between 64MB and 8192MB")
    end
    
    if thresholds.large_file_size and (thresholds.large_file_size < 1024 or thresholds.large_file_size > 100 * 1024 * 1024) then
      table.insert(errors, "large_file_size must be between 1KB and 100MB")
    end
  end
  
  -- Validate monitoring settings
  if config.max_history_size and (config.max_history_size < 10 or config.max_history_size > 1000) then
    table.insert(errors, "max_history_size must be between 10 and 1000")
  end
  
  if config.memory_check_interval and (config.memory_check_interval < 1000 or config.memory_check_interval > 60000) then
    table.insert(errors, "memory_check_interval must be between 1000ms and 60000ms")
  end
  
  return #errors == 0, errors
end

function M.detect_environment()
  local env = {
    is_ssh = os.getenv("SSH_CLIENT") ~= nil or os.getenv("SSH_TTY") ~= nil,
    is_tmux = os.getenv("TMUX") ~= nil,
    is_screen = os.getenv("STY") ~= nil,
    terminal = os.getenv("TERM") or "unknown",
    shell = os.getenv("SHELL") or "unknown",
    home = os.getenv("HOME") or "unknown",
    user = os.getenv("USER") or "unknown",
    display = os.getenv("DISPLAY"),
    colorterm = os.getenv("COLORTERM"),
  }
  
  -- Detect if running in a resource-constrained environment
  local memory_mb = M.get_memory_usage()
  env.is_low_memory = memory_mb > 0 and memory_mb < 256
  env.is_high_memory = memory_mb > 1024
  
  -- Detect system capabilities
  env.has_clipboard = vim.fn.has("clipboard") == 1
  env.has_python3 = vim.fn.has("python3") == 1
  env.has_node = vim.fn.executable("node") == 1
  env.has_git = vim.fn.executable("git") == 1
  
  return env
end

function M.get_performance_profile()
  local env = M.detect_environment()
  local memory_mb = M.get_memory_usage()
  
  -- Determine appropriate performance profile based on environment
  if env.is_ssh or env.is_low_memory or memory_mb < 256 then
    return "conservative"
  elseif env.is_high_memory and memory_mb > 1024 then
    return "performance"
  else
    return "balanced"
  end
end

function M.apply_performance_profile(profile_name)
  local profiles = {
    conservative = {
      performance_threshold = {
        lsp_timeout = 5000,
        completion_timeout = 1000,
        memory_limit_mb = 256,
        large_file_size = 512 * 1024, -- 512KB
      },
      max_history_size = 50,
      memory_check_interval = 10000, -- 10 seconds
    },
    balanced = {
      performance_threshold = {
        lsp_timeout = 3000,
        completion_timeout = 500,
        memory_limit_mb = 512,
        large_file_size = 1024 * 1024, -- 1MB
      },
      max_history_size = 100,
      memory_check_interval = 5000, -- 5 seconds
    },
    performance = {
      performance_threshold = {
        lsp_timeout = 2000,
        completion_timeout = 200,
        memory_limit_mb = 1024,
        large_file_size = 5 * 1024 * 1024, -- 5MB
      },
      max_history_size = 200,
      memory_check_interval = 2000, -- 2 seconds
    },
  }
  
  local profile = profiles[profile_name]
  if not profile then
    vim.notify(
      string.format("Unknown performance profile: %s", profile_name),
      vim.log.levels.ERROR,
      { title = "Performance Monitor" }
    )
    return false
  end
  
  -- Merge profile settings with current config
  M.config = vim.tbl_deep_extend("force", M.config, profile)
  
  vim.notify(
    string.format("Applied performance profile: %s", profile_name),
    vim.log.levels.INFO,
    { title = "Performance Monitor" }
  )
  
  return true
end

-- Helper function to sum array values
local function sum(array)
  local total = 0
  for _, value in ipairs(array) do
    total = total + value
  end
  return total
end

-- Performance reporting and diagnostics
function M.get_performance_report()
  local report = {
    timestamp = os.date("%Y-%m-%d %H:%M:%S"),
    system_info = M.get_system_info(),
    environment = M.detect_environment(),
    current_profile = M.get_performance_profile(),
    metrics = {},
  }
  
  -- Calculate average LSP response times
  report.metrics.lsp_averages = {}
  for server, responses in pairs(M.metrics.lsp_response_times) do
    if #responses > 0 then
      local total = 0
      for _, response in ipairs(responses) do
        total = total + response.duration_ms
      end
      report.metrics.lsp_averages[server] = {
        average_ms = total / #responses,
        request_count = #responses,
        slowest_ms = math.max(unpack(vim.tbl_map(function(r) return r.duration_ms end, responses))),
      }
    end
  end
  
  -- Calculate completion latency averages
  report.metrics.completion_averages = {}
  for source, latencies in pairs(M.metrics.completion_latency) do
    if #latencies > 0 then
      local total = 0
      for _, latency in ipairs(latencies) do
        total = total + latency.duration_ms
      end
      report.metrics.completion_averages[source] = {
        average_ms = total / #latencies,
        request_count = #latencies,
      }
    end
  end
  
  -- Memory usage statistics
  if #M.metrics.memory_usage > 0 then
    local memory_values = vim.tbl_map(function(m) return m.memory_mb end, M.metrics.memory_usage)
    report.metrics.memory_stats = {
      current_mb = M.get_memory_usage(),
      average_mb = sum(memory_values) / #memory_values,
      peak_mb = math.max(unpack(memory_values)),
      samples = #memory_values,
    }
  end
  
  -- File size statistics
  if next(M.metrics.file_sizes) then
    local sizes = vim.tbl_values(M.metrics.file_sizes)
    report.metrics.file_stats = {
      total_files = #sizes,
      total_size_mb = sum(sizes) / (1024 * 1024),
      largest_file_mb = math.max(unpack(sizes)) / (1024 * 1024),
      large_files_count = #vim.tbl_filter(function(size) 
        return size > M.config.performance_threshold.large_file_size 
      end, sizes),
    }
  end
  
  -- Plugin load times
  if next(M.metrics.plugin_load_times) then
    local load_times = vim.tbl_values(M.metrics.plugin_load_times)
    report.metrics.plugin_stats = {
      total_plugins = #load_times,
      total_load_time_ms = sum(load_times),
      average_load_time_ms = sum(load_times) / #load_times,
      slowest_plugin = nil,
      slowest_time_ms = 0,
    }
    
    -- Find slowest plugin
    for plugin, time in pairs(M.metrics.plugin_load_times) do
      if time > report.metrics.plugin_stats.slowest_time_ms then
        report.metrics.plugin_stats.slowest_plugin = plugin
        report.metrics.plugin_stats.slowest_time_ms = time
      end
    end
  end
  
  return report
end

function M.print_performance_report()
  local report = M.get_performance_report()
  
  print("=== Neovim Performance Report ===")
  print(string.format("Generated: %s", report.timestamp))
  print(string.format("Profile: %s", report.current_profile))
  print()
  
  -- System info
  print("System Information:")
  print(string.format("  OS: %s %s", report.system_info.os, report.system_info.arch))
  print(string.format("  Neovim: %s", vim.inspect(report.system_info.nvim_version)))
  print(string.format("  Memory: %dMB", report.system_info.memory_mb))
  print(string.format("  CPU: %.1f%%", report.system_info.cpu_percent))
  print()
  
  -- LSP performance
  if next(report.metrics.lsp_averages or {}) then
    print("LSP Performance:")
    for server, stats in pairs(report.metrics.lsp_averages) do
      print(string.format("  %s: %.1fms avg (%.1fms max, %d requests)", 
        server, stats.average_ms, stats.slowest_ms, stats.request_count))
    end
    print()
  end
  
  -- Completion performance
  if next(report.metrics.completion_averages or {}) then
    print("Completion Performance:")
    for source, stats in pairs(report.metrics.completion_averages) do
      print(string.format("  %s: %.1fms avg (%d requests)", 
        source, stats.average_ms, stats.request_count))
    end
    print()
  end
  
  -- Memory statistics
  if report.metrics.memory_stats then
    local mem = report.metrics.memory_stats
    print("Memory Usage:")
    print(string.format("  Current: %dMB", mem.current_mb))
    print(string.format("  Average: %.1fMB", mem.average_mb))
    print(string.format("  Peak: %dMB", mem.peak_mb))
    print()
  end
  
  -- File statistics
  if report.metrics.file_stats then
    local files = report.metrics.file_stats
    print("File Statistics:")
    print(string.format("  Total files: %d", files.total_files))
    print(string.format("  Total size: %.1fMB", files.total_size_mb))
    print(string.format("  Largest file: %.1fMB", files.largest_file_mb))
    print(string.format("  Large files: %d", files.large_files_count))
    print()
  end
  
  -- Plugin statistics
  if report.metrics.plugin_stats then
    local plugins = report.metrics.plugin_stats
    print("Plugin Load Times:")
    print(string.format("  Total plugins: %d", plugins.total_plugins))
    print(string.format("  Total load time: %.1fms", plugins.total_load_time_ms))
    print(string.format("  Average load time: %.1fms", plugins.average_load_time_ms))
    if plugins.slowest_plugin then
      print(string.format("  Slowest plugin: %s (%.1fms)", plugins.slowest_plugin, plugins.slowest_time_ms))
    end
    print()
  end
end

-- Diagnostic commands
function M.diagnose_performance_issues()
  local issues = {}
  local report = M.get_performance_report()
  
  -- Check memory usage
  if report.system_info.memory_mb > M.config.performance_threshold.memory_limit_mb then
    table.insert(issues, {
      type = "memory",
      severity = "high",
      message = string.format("High memory usage: %dMB (limit: %dMB)", 
        report.system_info.memory_mb, M.config.performance_threshold.memory_limit_mb),
      suggestion = "Consider closing unused buffers or reducing plugin usage"
    })
  end
  
  -- Check LSP response times
  if report.metrics.lsp_averages then
    for server, stats in pairs(report.metrics.lsp_averages) do
      if stats.average_ms > M.config.performance_threshold.lsp_timeout then
        table.insert(issues, {
          type = "lsp",
          severity = "medium",
          message = string.format("Slow LSP server %s: %.1fms average", server, stats.average_ms),
          suggestion = "Consider restarting the LSP server or checking server configuration"
        })
      end
    end
  end
  
  -- Check for large files
  if report.metrics.file_stats and report.metrics.file_stats.large_files_count > 0 then
    table.insert(issues, {
      type = "files",
      severity = "low",
      message = string.format("%d large files detected", report.metrics.file_stats.large_files_count),
      suggestion = "Large files may cause performance issues. Consider optimizing syntax highlighting."
    })
  end
  
  -- Check plugin load times
  if report.metrics.plugin_stats and report.metrics.plugin_stats.slowest_time_ms > 100 then
    table.insert(issues, {
      type = "plugins",
      severity = "medium",
      message = string.format("Slow plugin loading: %s took %.1fms", 
        report.metrics.plugin_stats.slowest_plugin, report.metrics.plugin_stats.slowest_time_ms),
      suggestion = "Consider lazy loading this plugin or finding alternatives"
    })
  end
  
  return issues
end

function M.print_diagnostic_report()
  local issues = M.diagnose_performance_issues()
  
  if #issues == 0 then
    print("✅ No performance issues detected!")
    return
  end
  
  print("=== Performance Issues Detected ===")
  print()
  
  for i, issue in ipairs(issues) do
    local icon = issue.severity == "high" and "🔴" or issue.severity == "medium" and "🟡" or "🟢"
    print(string.format("%s [%s] %s", icon, string.upper(issue.severity), issue.message))
    print(string.format("   💡 %s", issue.suggestion))
    print()
  end
end

-- Auto-initialize when module is loaded
M.init()

return M