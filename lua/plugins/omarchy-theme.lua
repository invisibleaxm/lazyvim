-- Load the active Omarchy Neovim theme spec when this machine has one.
-- Omarchy writes ~/.local/state/omarchy/current/theme/neovim.lua on
-- `omarchy theme set`. Cross-platform: missing file -> LazyVim default.
if vim.g.vscode then
  return {}
end

local path = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")
if vim.fn.filereadable(path) == 1 then
  local ok, spec = pcall(dofile, path)
  if ok and type(spec) == "table" then
    return spec
  end
end

return {}
