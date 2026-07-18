-- Quick Copilot diagnostics and fix script
-- Run with: :source %

print("=== Copilot Diagnostics ===")

-- Check if copilot.lua is loaded
local copilot_ok, copilot = pcall(require, "copilot")
if not copilot_ok then
  print("❌ Copilot plugin not loaded")
  print("   Run: :Lazy sync")
  return
end
print("✅ Copilot plugin loaded")

-- Check Copilot status
vim.cmd("Copilot status")

-- Provide fix instructions
print("\n=== To Fix Authentication ===")
print("1. Run: :Copilot auth")
print("2. Follow the browser prompts")
print("3. After auth completes, run: :Copilot restart")
print("4. Check status: :Copilot status")
print("\nIf still failing:")
print("5. Quit Neovim completely")
print("6. Reopen and run: :Copilot status")
