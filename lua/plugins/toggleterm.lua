--------------------------------------------------------------------------------
local enable_tmux_slime = true
if vim.loop.os_uname().sysname == "Windows_NT" then
  --- tmux does not work on windows so we use wezterm
  enable_tmux_slime = false
end

-- I borrowed this from https://github.com/you-n-g/deploy/blob/623a56064926fb551cff7e4afb0984d2233bf788/configs/lazynvim/lua/plugins/slime.lua#L18
function reset_slime()
  -- this part is designed coupled with toggleterm
  if vim.api.nvim_get_var("slime_target") == "neovim" then
    if vim.o.filetype == "toggleterm" then
      vim.api.nvim_set_var("slime_last_toggleterm_channel", vim.o.channel)
    else
      local ok, last_channel = pcall(vim.api.nvim_get_var, "slime_last_toggleterm_channel")
      if ok then
        vim.api.nvim_buf_set_var(0, "slime_config", { jobid = last_channel })
      end
    end
  end
end

--------------------------------------------------------------------------------
return {

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
    keys = {
      {
        "<C-\\>",
        "<cmd>ToggleTerm<cr>",
        desc = "Open a floating terminal",
      },
    },
    opts = {
      -- open_mapping = [[<C-t>]],
      open_mapping = [[<C-\>]],
      direction = "horizontal",
      size = 20,
      -- direction = "float",
      hide_numbers = true,
      terminal_mappings = true,
      insert_mappings = true,
      start_in_insert = true,
      auto_scroll = true,
      close_on_exit = true,
      shade_terminals = true,
      shading_factor = "2",
      -- shade_filetypes = { "none", "fzf" },
      shade_filetypes = {},
    },
  },

  -- {
  --   "jpalardy/vim-slime",
  --   lazy = false,
  --   config = function()
  --     vim.g.slime_target = "wezterm"
  --     -- vim.g.slime_default_config = { socket_name = "default", target_pane = "{left-of}" }
  --     vim.g.slime_default_config = { pane_id = "1" }
  --   end,
  --   enabled = true,
  -- },
  --
  -- vim-slime {{{
  {
    "invisibleaxm/vim-slime",
    lazy = true,
    event = "VeryLazy",
    cmd = {
      "SlimeConfig",
      "SlimeSend",
      "SlimeSend0",
      "SlimeSend1",
      "SlimeSendCurrentLine",
    },
    init = function()
      if enable_tmux_slime == true then
        vim.g.slime_target = "tmux"
        vim.g.slime_paste_file = vim.api.nvim_eval("tempname()")
        vim.g.slime_bracketed_paste = true
        vim.g.slime_default_config = {
          socket_name = "default",
          target_pane = "{right-of}",
        }
      else
        vim.g.slime_bracketed_paste = true
        vim.g.slime_target = "wezterm"
        vim.g.slime_default_config = {
          pane_id = "1",
        }
      end
      -- I have not tried this, but its supposed to work for neovim terminal/toggleterm buffers.
      --         vim.g.slime_target = "neovim"
      --         vim.g.slime_python_ipython = 1
      --         vim.api.nvim_set_keymap("n", "<c-c><c-u>", [[<cmd>SlimeSend0 "\x15"<CR>]], { noremap = true })
      --         vim.api.nvim_set_keymap("n", "<c-c><c-i>", [[<cmd>SlimeSend0 "\x03"<CR>]], { noremap = true })
      --         vim.api.nvim_set_keymap("n", "<c-c><c-d>", [[<cmd>SlimeSend0 "\x04"<CR>]], { noremap = true })
      --         vim.api.nvim_set_keymap("n", "<c-c><c-p>", [[<cmd>SlimeSend0 "\x1bk\x0d"<CR>]], { noremap = true })
      --         vim.api.nvim_set_keymap("n", "<c-c><cr>", [[<cmd>SlimeSend0 "\x0d"<CR>]], { noremap = true })
      --         vim.api.nvim_exec(
      --           [[
      -- augroup auto_slime_channel
      --   autocmd!
      --   autocmd BufEnter,WinEnter,TermOpen  * lua reset_slime()
      -- augroup END]],
      --           false
      --         )
    end,
  }, -- }}}
}
