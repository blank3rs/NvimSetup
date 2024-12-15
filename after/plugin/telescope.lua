local telescope = require('telescope')
local actions = require('telescope.actions')

-- Telescope Configuration
telescope.setup {
	defaults = {
		layout_strategy = 'horizontal',
		layout_config = {
			horizontal = {
				preview_width = 0.6,
			},
		},
		pickers = {
			find_files = {
				hidden = true
			}
		},
		file_ignore_patterns = {
			-- Hidden files and git metadata
			".git/",
			".git/*",
			".DS_Store$",
			"thumbs%.db",
			"%.cache/",

			-- Language-specific files
			"node_modules/",
			"dist/",
			"out/",
			"package%-lock%.json",
			"yarn%-lock%.json",
			"target/",
			"target/*",
			"venv/",
			"%.venv/",
			"__pycache__/",
			"__pycache__/*",
			"site%-packages/",
			"site%-packages/*",
			"%.pytest_cache/",
			"build/",
			"cmake%-build.*/",
			"bin/",
			"pkg/",

			-- Temporary and log files
			"%.log$",
			"%.tmp$",
			"%.bak$",
			"%.o$",
			"%.a$",
			"%.so$",
			"%.exe$",
			"%.dll$",

			-- IDE and editor files
			"%.class$",
			"%.idea/",
			"%.idea/*",
			"%.vscode/",
			"%.vscode/*",
			"%.settings/",
		},
		mappings = {
			i = {
				["<esc>"] = actions.close,  -- Close Telescope with ESC
			},
		},
	},
}

-- Keybindings for Telescope
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>Telescope buffers<CR>", { noremap = true, silent = true })

-- Load Telescope extensions
-- telescope.load_extension('your_extension_here')
