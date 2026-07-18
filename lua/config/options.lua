-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- ============================================================================
-- VSCODE DETECTION
-- ============================================================================

-- Detect if running in VSCode and print startup message
if vim.g.vscode then
  -- Defer notification to avoid startup conflicts
  vim.defer_fn(function()
    print("🚀 Neovim Hybrid Mode Active in VSCode")
  end, 100)
end

-- ============================================================================
-- CROSS-PLATFORM CLIPBOARD & MOUSE
-- ============================================================================

-- Enable mouse support in all modes (works in terminal and SSH)
vim.opt.mouse = "a"

-- Enable system clipboard integration (works locally)
-- For SSH, OSC 52 is configured below
vim.opt.clipboard = "unnamedplus"

-- OSC 52 clipboard for SSH sessions
-- This allows clipboard to work even when SSH'd into a remote server
if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
  local function paste()
    return {
      vim.fn.split(vim.fn.getreg(""), "\n"),
      vim.fn.getregtype(""),
    }
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = paste,
      ["*"] = paste,
    },
  }
end

-- ============================================================================
-- FOLDING (UFO plugin provides better defaults, these are minimal overrides)
-- ============================================================================

vim.opt.foldcolumn = "0" -- Hide fold column for cleaner look
vim.opt.foldlevel = 99 -- Open all folds by default
vim.opt.foldlevelstart = 99 -- Start with all folds open
vim.opt.foldenable = true

-- ============================================================================
-- SEARCH & SCROLL
-- ============================================================================

vim.opt.hlsearch = false -- Don't highlight all search matches
vim.opt.incsearch = true -- Show search matches as you type
vim.opt.scrolloff = 8 -- Keep 8 lines visible above/below cursor

-- ============================================================================
-- UI
-- ============================================================================

vim.opt.numberwidth = 3 -- Narrower number column

-- ============================================================================
-- PLATFORM-SPECIFIC CONFIGURATION
-- ============================================================================

if vim.loop.os_uname().sysname == "Windows_NT" then
  -- Windows: Ensure MSYS2 MinGW64 tools are in PATH for building plugins
  -- Note: Setup-MSYS2.ps1 should add this to your system PATH permanently
  -- This is a fallback that adds them if not already present
  local mingw_bin = "C:\\msys64\\mingw64\\bin"
  if vim.fn.isdirectory(mingw_bin) == 1 and not string.find(vim.env.PATH, "msys64", 1, true) then
    vim.env.PATH = mingw_bin .. ";" .. vim.env.PATH
  end

  -- Set C compiler for Treesitter
  -- Prefer gcc (from MinGW-w64/MSYS2) over clang on Windows
  if vim.fn.executable("gcc") == 1 then
    vim.env.CC = "gcc"
  elseif vim.fn.executable("clang") == 1 then
    vim.env.CC = "clang"
  end

  -- PowerShell configuration
  local powershell_options = {
    shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
    shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
  }
  for option, value in pairs(powershell_options) do
    vim.opt[option] = value
  end

  -- Python provider (auto-detect pyenv if available)
  local pyenv_path = os.getenv("USERPROFILE") .. "\\.pyenv\\pyenv-win\\shims\\python.bat"
  if vim.fn.executable(pyenv_path) == 1 then
    vim.g.python3_host_prog = pyenv_path
  end
elseif vim.loop.os_uname().sysname == "Darwin" then
  -- macOS: Python provider (auto-detect pyenv if available)
  local pyenv_path = os.getenv("HOME") .. "/.pyenv/shims/python"
  if vim.fn.executable(pyenv_path) == 1 then
    vim.g.python3_host_prog = pyenv_path
  end
else
  -- Linux: Python provider (auto-detect pyenv if available)
  local pyenv_path = os.getenv("HOME") .. "/.pyenv/shims/python"
  if vim.fn.executable(pyenv_path) == 1 then
    vim.g.python3_host_prog = pyenv_path
  end
end
