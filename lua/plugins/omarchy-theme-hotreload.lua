-- Reload Neovim colors when Omarchy changes theme. Same logic as Omarchy's
-- starter config, plus a file watcher so we do not need their theme.lua symlink.
if vim.g.vscode then
  return {}
end

local omarchy_theme_dir = vim.fn.expand("~/.local/state/omarchy/current/theme")
local omarchy_theme_file = omarchy_theme_dir .. "/neovim.lua"
local transparency_file = vim.fn.stdpath("config") .. "/plugin/after/transparency.lua"

local function apply_omarchy_theme()
  package.loaded["plugins.omarchy-theme"] = nil

  vim.schedule(function()
    local ok, theme_spec = pcall(require, "plugins.omarchy-theme")
    if not ok or type(theme_spec) ~= "table" then
      return
    end

    local theme_plugin_name = nil
    for _, spec in ipairs(theme_spec) do
      if spec[1] and spec[1] ~= "LazyVim/LazyVim" then
        theme_plugin_name = spec.name or spec[1]
        break
      end
    end

    vim.cmd("highlight clear")
    if vim.fn.exists("syntax_on") then
      vim.cmd("syntax reset")
    end
    vim.o.background = "dark"

    if theme_plugin_name then
      local plugin = require("lazy.core.config").plugins[theme_plugin_name]
      if plugin then
        require("lazy.core.util").walkmods(plugin.dir .. "/lua", function(modname)
          package.loaded[modname] = nil
          package.preload[modname] = nil
        end)
      end
    end

    for _, spec in ipairs(theme_spec) do
      if spec[1] == "LazyVim/LazyVim" and spec.opts and spec.opts.colorscheme then
        local colorscheme = spec.opts.colorscheme
        local theme_plugin = theme_plugin_name and require("lazy.core.config").plugins[theme_plugin_name]
        if theme_plugin and theme_plugin._.loaded then
          require("lazy.core.loader").reload(theme_plugin)
        else
          require("lazy.core.loader").colorscheme(colorscheme)
        end

        vim.defer_fn(function()
          pcall(vim.cmd.colorscheme, colorscheme)
          vim.cmd("redraw!")
          if vim.fn.filereadable(transparency_file) == 1 then
            vim.defer_fn(function()
              vim.cmd.source(transparency_file)
              vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
              vim.cmd("redraw!")
            end, 5)
          end
        end, 5)
        break
      end
    end
  end)
end

return {
  {
    name = "omarchy-theme-hotreload",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 1000,
    config = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyReload",
        callback = apply_omarchy_theme,
      })

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          if vim.fn.filereadable(transparency_file) == 1 then
            vim.cmd.source(transparency_file)
          end
        end,
      })

      if vim.fn.isdirectory(omarchy_theme_dir) == 0 then
        return
      end

      local uv = vim.uv or vim.loop
      local watcher = uv.new_fs_event()
      if not watcher then
        return
      end

      local timer = uv.new_timer()
      watcher:start(omarchy_theme_dir, {}, function(err, filename)
        if err then
          return
        end
        if filename and filename ~= "neovim.lua" then
          return
        end
        if timer then
          timer:stop()
          timer:start(50, 0, vim.schedule_wrap(apply_omarchy_theme))
        else
          vim.schedule(apply_omarchy_theme)
        end
      end)

      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          watcher:stop()
          if timer then
            timer:stop()
            timer:close()
          end
          watcher:close()
        end,
      })
    end,
  },
}
