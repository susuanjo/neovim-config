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

      lsp_zero.on_attach(function(_, bufnr)
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

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
            telemetry = { enable = false },
          },
        },
      })

      require('mason-lspconfig').setup()
    end,
}
