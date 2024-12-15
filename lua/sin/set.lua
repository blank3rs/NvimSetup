-- Settings.lua: Neovim configuration with good defaults

-- Basic settings
vim.opt.encoding = 'utf-8'     -- Set encoding to UTF-8
vim.opt.fileencoding = 'utf-8' -- Encoding for files
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Relative line numbers
vim.opt.cursorline = true      -- Highlight the current line
vim.opt.scrolloff = 8          -- Minimum lines above/below the cursor
vim.opt.sidescrolloff = 8      -- Minimum columns left/right of cursor
vim.opt.wrap = false           -- Disable line wrapping
vim.opt.termguicolors = true   -- Enable 24-bit RGB color in terminal
vim.opt.hidden = true          -- Allow switching buffers without saving
vim.opt.updatetime = 300       -- Faster updates
vim.opt.signcolumn = 'yes'     -- Always show the sign column
vim.opt.splitright = true      -- Open vertical splits to the right
vim.opt.splitbelow = true      -- Open horizontal splits below
vim.opt.cmdheight = 1          -- Space for command line messages
vim.opt.showmode = false       -- Don't display mode (e.g., -- INSERT --)

-- Tab and indentation
vim.opt.expandtab = true   -- Use spaces instead of tabs
vim.opt.tabstop = 4        -- Number of spaces for a tab
vim.opt.shiftwidth = 4     -- Number of spaces to use for auto-indent
vim.opt.softtabstop = 4    -- Spaces per Tab in Insert mode
vim.opt.autoindent = true  -- Auto-indent new lines
vim.opt.smartindent = true -- Smarter indentation for code

-- Search settings
vim.opt.ignorecase = true -- Case-insensitive search
vim.opt.smartcase = true  -- Case-sensitive if search has uppercase
vim.opt.hlsearch = true   -- Highlight search matches
vim.opt.incsearch = true  -- Show match while typing search

-- Backup and undo
vim.opt.backup = false                                -- Don't keep backup files
vim.opt.swapfile = false                              -- Don't use swapfiles
vim.opt.undofile = true                               -- Save undo history
vim.opt.undodir = vim.fn.stdpath('config') .. '/undo' -- Undo directory

-- Completion
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' } -- Completion options
vim.opt.pumheight = 10                                  -- Max height of completion menu

-- Clipboard
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard

-- Fold settings
vim.opt.foldmethod = 'indent' -- Fold based on indentation
vim.opt.foldlevel = 99        -- Open most folds by default

-- Wildmenu and command-line completion
vim.opt.wildmenu = true -- Enhanced command-line completion
vim.opt.wildmode = { 'list', 'longest' }

-- Performance
vim.opt.lazyredraw = true -- Don't redraw during macro execution
vim.opt.synmaxcol = 300   -- Limit syntax highlighting to first 300 cols

-- Key mappings for convenience
vim.api.nvim_set_keymap('n', '<Space>', '', { noremap = true, silent = true })
vim.g.mapleader = ' ' -- Space as the leader key
vim.g.maplocalleader = ' '

-- Plugins
vim.cmd [[
  syntax on                   " Enable syntax highlighting
  filetype plugin indent on   " Enable file type detection
]]

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank { timeout = 200 }
  augroup END
]]

-- Diagnostics display settings
vim.diagnostic.config({
	virtual_text = false, -- Use signs instead of inline messages
	signs = true,
	update_in_insert = false,
	severity_sort = true,
})

-- Customize diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
