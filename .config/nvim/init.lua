vim.o.number = true
vim.o.relativenumber = true
vim.o.confirm = true
vim.o.signcolumn = 'yes:1'

function gh(username, repo)
  return 'https://github.com/' .. username .. '/' .. repo .. ''
end

vim.pack.add {
  gh('catppuccin', 'nvim'),
  gh('neovim', 'nvim-lspconfig'),
  gh('nvim-mini', 'mini.nvim')
}

require('mini.icons').setup()
require('mini.files').setup()
require('mini.pick').setup()
require('mini.ai').setup()

vim.cmd.colorscheme('catppuccin')

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.lsp.enable('lua_ls')
vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
          path ~= vim.fn.stdpath('config')
          and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    })
  end,
  settings = {
    Lua = {
      format = {
        defaultConfig = {
          indent_style = 'space',
          indent_size = '2',
        },
      },
    },
  },
})

vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>y', '"+y', { noremap = true, silent = true, desc = 'Yank to clipboard' })
vim.keymap.set({ 'v', 'x' }, '<leader>y', '"+y', { noremap = true, silent = true, desc = 'Yank to clipboard' })
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>yy', '"+yy',
  { noremap = true, silent = true, desc = 'Yank line to clipboard' })
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>Y', '"+yy', { noremap = true, silent = true, desc = 'Yank line to clipboard' })
vim.keymap.set({ 'n', 'v', 'x' }, '<C-a>', 'gg0vG$', { noremap = true, silent = true, desc = 'Select all' })
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>p', '"+p', { noremap = true, silent = true, desc = 'Paste from clipboard' })
vim.keymap.set('i', '<C-p>', '<C-r><C-p>+',
  { noremap = true, silent = true, desc = 'Paste from clipboard from within insert mode' })

-- mini.files
local MiniFiles = require('mini.files')
vim.keymap.set('n', '<leader>e', function()
  if not MiniFiles.close() then
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    MiniFiles.reveal_cwd()
  end
end, { desc = 'Toggle (fresh for current file) mini.files window' })
