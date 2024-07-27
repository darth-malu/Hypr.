return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({ ensure_installed = { "lua_ls", "pyright", "cssls", "jsonls", "sqls", "bashls", "jedi_language_server", "pylsp", "taplo", "yamlls"} })
        end
    },

    {
        "neovim/nvim-lspconfig",
        --event="VeryLazy",
        config = function()
            -- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            local lspconfig = require('lspconfig')
            lspconfig.lua_ls.setup({capabilities = capabilities})
            lspconfig.pyright.setup({capabilities = capabilities})
            lspconfig.cssls.setup({capabilities = capabilities})
            lspconfig.sqls.setup({capabilities = capabilities})
            lspconfig.jsonls.setup({capabilities = capabilities})
            lspconfig.bashls.setup({capabilities = capabilities})
            lspconfig.jedi_language_server.setup({capabilities = capabilities})
            lspconfig.pylsp.setup({capabilities = capabilities})
            lspconfig.taplo.setup({capabilities = capabilities})
            lspconfig.yamlls.setup({capabilities = capabilities})
            -- Global mappings.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local opts = { buffer = ev.buf }
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
                    --vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    --vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    --vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                    --vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                    --vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                    --vim.keymap.set('n', '<space>wl', function()
                        --print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    --end, opts)
                    --vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                    --vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
                    --vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    --vim.keymap.set('n', '<space>f', function()
                        --vim.lsp.buf.format { async = true }
                    --end, opts)
                end,
            })
        end
    }
}
