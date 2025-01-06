local cmp = require('cmp')

-- General autocompletion setup
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'luasnip' },
    }),
})

-- Setup for command-line mode (for terminal command completion)
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' },
        { name = 'cmdline' },
    }),
})

-- Setup for search mode
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' },
    },
})
