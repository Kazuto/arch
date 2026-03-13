-- Simple test to verify performance utilities work correctly
-- This file can be used to test the performance monitoring functionality

local M = {}

function M.test_performance_utilities()
  local performance = require("kazuto.utils.performance")
  
  -- Test configuration validation
  local valid_config = {
    performance_threshold = {
      lsp_timeout = 3000,
      completion_timeout = 500,
      memory_limit_mb = 512,
      large_file_size = 1024 * 1024,
    },
    max_history_size = 100,
    memory_check_interval = 5000,
  }
  
  local is_valid, errors = performance.validate_config(valid_config)
  assert(is_valid, "Valid config should pass validation")
  assert(#errors == 0, "Valid config should have no errors")
  
  -- Test invalid config
  local invalid_config = {
    performance_threshold = {
      lsp_timeout = 50, -- Too low
      memory_limit_mb = 10000, -- Too high
    },
    max_history_size = 5, -- Too low
  }
  
  local is_invalid, invalid_errors = performance.validate_config(invalid_config)
  assert(not is_invalid, "Invalid config should fail validation")
  assert(#invalid_errors > 0, "Invalid config should have errors")
  
  -- Test environment detection
  local env = performance.detect_environment()
  assert(type(env) == "table", "Environment detection should return a table")
  assert(type(env.is_ssh) == "boolean", "SSH detection should return boolean")
  assert(type(env.terminal) == "string", "Terminal should be a string")
  
  -- Test performance profile detection
  local profile = performance.get_performance_profile()
  assert(type(profile) == "string", "Performance profile should be a string")
  assert(profile == "conservative" or profile == "balanced" or profile == "performance", 
         "Profile should be one of the valid options")
  
  -- Test timer functionality
  local timer = performance.create_timer("test_timer")
  assert(type(timer) == "table", "Timer should return a table")
  assert(type(timer.stop) == "function", "Timer should have a stop function")
  
  -- Test function profiling
  local test_func = function()
    -- Simulate some work
    local total = 0
    for i = 1, 1000 do
      total = total + i
    end
    return total
  end
  
  local result, duration = performance.profile_function(test_func, "test_function")
  assert(result == 500500, "Profiled function should return correct result")
  assert(type(duration) == "number", "Duration should be a number")
  assert(duration >= 0, "Duration should be non-negative")
  
  print("✅ All performance utility tests passed!")
  return true
end

-- Test command to run the tests
vim.api.nvim_create_user_command("PerfTest", function()
  local success, error_msg = pcall(M.test_performance_utilities)
  if success then
    vim.notify("Performance utilities test passed!", vim.log.levels.INFO)
  else
    vim.notify("Performance utilities test failed: " .. error_msg, vim.log.levels.ERROR)
  end
end, {
  desc = "Test performance utilities functionality"
})

return M