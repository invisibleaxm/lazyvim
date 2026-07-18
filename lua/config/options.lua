-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim.opt.conceallevel = 0
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = -1
vim.opt.foldenable = true

-- highlight options for search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.scrolloff = 8

vim.opt.numberwidth = 3
-- vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s"
-- vim.opt.statuscolumn = "%l %r"

if vim.loop.os_uname().sysname == "Windows_NT" then
  -- Ensure MSYS2 MinGW64 tools are in PATH for building plugins
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
  vim.g.python3_host_prog = os.getenv("USERPROFILE") .. "\\.pyenv\\pyenv-win\\shims\\python.bat"
end

if vim.loop.os_uname().sysname == "Darwin" then
  vim.g.python3_host_prog = "/Users/alex/.pyenv/shims/python"
end


local M = {}

local function paste()
  return {
    vim.split(vim.fn.getreg(''), '\n'),
    vim.fn.getregtype(''),
  }
end

function M.init()
  if vim.env.SSH_TTY then
    vim.g.clipboard = {
      name = 'OSC 52',
      copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
      },
      paste = {
        ['+'] = paste,
        ['*'] = paste,
      },
    }
  end
end

return M


-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
