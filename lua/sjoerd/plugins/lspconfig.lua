return {
    'neovim/nvim-lspconfig',
    cmd = {'LspInfo', 'LspInstall', 'LspStart'},
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason-lspconfig.nvim'},
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({buffer = bufnr})
      end)

      vim.lsp.config('nixd', {
        filetypes = { 'nix' },
        settings = {
            nixd = {
                options = {
                    home_manager = {
                        expr = '(import <home-manager/modules> { configuration = ~/.config/home-manager/home.nix; }).options',
                    },
                },
                nixpkgs = {
                    expr = 'import <nixpkgs> { }',
                },
                formatting = {
                    command = { 'nixfmt' },
                },
            },
         },
      })

      if vim.fn.executable('nixd') == 1 then
        vim.lsp.enable('nixd')
      end

      require('mason-lspconfig').setup({
        ensure_installed = { 'nixd' },
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            -- (Optional) Configure lua language server for neovim
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
         end,
        }
      })
    end,
}
