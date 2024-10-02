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
            --require("mason-lspconfig").setup({ ensure_installed = { "lua_ls", "pyright", "cssls", "jsonls", "sqls", "bashls", "jedi_language_server", "pylsp", "taplo", "yamlls", "markdownlint-cli2", "markdown-toc"} })
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

            -- Use LspAttach autocommand to only map the following keys after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('DarthLspConfig', { clear = true }),
                callback = function(event)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[event.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local opts = { buffer = event.buf }

                    -- hover, Documentation for word under cursor
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer=0})

                    vim.keymap.set('n', '<leader>t', "<cmd>Telescope diagnostics<CR>", {buffer=0})
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {buffer=0})

                    -- lsp specific mappings
                    local map = function (keys, func, desc)
                       vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc, remap = false })
                    end

                    -- Definitions
                    -- <C-T>  to go back
                    map('<leader>gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                    --vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

                    -- References
                    --vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    map('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                    -- implementation
                    map('<leader>gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementations')

                    -- Type of var
                    --map('<leader>d', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

                    -- symbols eg var, func
                    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

                    -- symbols in workspace
                    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                    --vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    --vim.keymap.set('n', '<leader>t', ":Telescope diagnostics<CR>", {buffer=0})
                    --vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    --vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                    --vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                    --vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                    --vim.keymap.set('n', '<space>wl', function()
                        --print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    --end, opts)
                    --vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                    --vim.keymap.set('n', '<space>f', function()
                        --vim.lsp.buf.format { async = true }
                    --end, opts)
                end,
            })
        end
    }
}
