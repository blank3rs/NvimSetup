-- Import LSP-Zero
local lsp_zero = require('lsp-zero')

-- Mason setup
require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = {
        "clangd",        -- C/C++
        "pylsp",         -- Python
        "jdtls",         -- Java
        "rust_analyzer", -- Rust
        "eslint",        -- JavaScript/TypeScript Linter
        "zls",           -- Zig
        "lua_ls",        -- Lua
    },
    automatic_installation = true,
})

-- Global diagnostics configuration (ONLY errors)
vim.diagnostic.config({
    virtual_text = {
        severity = vim.diagnostic.severity.ERROR, -- Show only errors in virtual text
    },
    signs = {
        severity = vim.diagnostic.severity.ERROR, -- Show only errors in gutter signs
    },
    underline = {
        severity = vim.diagnostic.severity.ERROR, -- Underline only errors
    },
    update_in_insert = false,
    float = {
        source = "always",
        border = "rounded",
        severity = vim.diagnostic.severity.ERROR, -- Show only errors in float diagnostics
    },
})

-- Remove all warning signs
local signs = { Error = "✘", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Keybinding helper
local function on_attach(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

    -- Autoformat on save
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function() vim.lsp.buf.format() end,
        })
    end
end

-- LSP server setup with global suppression of warnings
require("mason-lspconfig").setup_handlers({
    function(server_name)
        require('lspconfig')[server_name].setup({
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
            on_attach = on_attach,
            handlers = {
                ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
                    if result.diagnostics == nil then
                        return
                    end
                    -- Filter out warnings, hints, and info
                    local filtered_diagnostics = {}
                    for _, diagnostic in ipairs(result.diagnostics) do
                        if diagnostic.severity == vim.diagnostic.severity.ERROR then
                            table.insert(filtered_diagnostics, diagnostic)
                        end
                    end
                    result.diagnostics = filtered_diagnostics
                    vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
                end,
            },
        })
    end,
})

-- Autocompletion Setup
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'luasnip' },
    },
})

-- Rust-specific configuration
require("rust-tools").setup({
    tools = {
        inlay_hints = { auto = false },
        hover_actions = { auto_focus = true },
    },
    server = {
        settings = {
            ["rust-analyzer"] = { diagnostics = { enable = false } },
        },
    },
})

-- LSP status indicator
require('fidget').setup({})

-- Floating Terminal Autocompletion
cmp.setup.buffer({
    sources = {
        { name = 'buffer' },
        { name = 'path' },
    },
})

