-- Start Packer
return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Telescope for fuzzy finding
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- Onedark theme
    use 'navarasu/onedark.nvim'

    -- Treesitter for better syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }


    -- Harpoon for file navigation
    use 'theprimeagen/harpoon'

    -- Undo tree visualization
    use 'mbbill/undotree'

    -- LSP-Zero setup for Neovim LSP
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x', -- Use the latest branch
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },             -- LSP configurations
            { 'williamboman/mason.nvim' },           -- LSP server manager
            { 'williamboman/mason-lspconfig.nvim' }, -- Bridge for Mason and LSPConfig

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },         -- Completion engine
            { 'hrsh7th/cmp-buffer' },       -- Buffer completions
            { 'hrsh7th/cmp-path' },         -- File path completions
            { 'saadparwaiz1/cmp_luasnip' }, -- LuaSnip completions
            { 'hrsh7th/cmp-nvim-lsp' },     -- LSP completions
            { 'hrsh7th/cmp-nvim-lua' },     -- Lua completions

            -- Snippets
            { 'L3MON4D3/LuaSnip' },             -- Snippet engine
            { 'rafamadriz/friendly-snippets' }, -- Predefined snippets
        }
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    use {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup {}
        end
    }
    use "numToStr/FTerm.nvim"
    use 'hrsh7th/nvim-cmp'         -- Completion plugin
    use 'hrsh7th/cmp-nvim-lsp'     -- LSP source for nvim-cmp
    use 'hrsh7th/cmp-buffer'       -- Buffer source
    use 'hrsh7th/cmp-path'         -- Path source
    use 'hrsh7th/cmp-cmdline'      -- Command-line completion
    use 'L3MON4D3/LuaSnip'         -- Snippet engine
    use 'saadparwaiz1/cmp_luasnip' -- Snippet completion source
end)
