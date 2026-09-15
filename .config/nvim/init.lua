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
  gh('nvim-mini', 'mini.nvim'),
  gh('stevearc', 'conform.nvim'),
}

require('mini.icons').setup()
require('mini.tabline').setup()
require('mini.bufremove').setup()
require('mini.files').setup()
require('mini.git').setup()
require('mini.pick').setup()
require('mini.ai').setup()
require('mini.notify').setup()
require('mini.basics').setup({
  options = {
    basic = true,
    extra_ui = true,
  }
})
require('conform').setup({
  default_format_opts = {
    lsp_format = 'fallback',
  },
})

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
