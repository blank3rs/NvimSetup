local float_term_win = nil
local float_term_buf = nil

-- Keymap to toggle the floating terminal
vim.api.nvim_set_keymap('n', '<Leader>t', [[:lua ToggleFloatTerm()<CR>]], { noremap = true, silent = true })

-- Function to toggle the floating terminal
function ToggleFloatTerm()
    if float_term_win ~= nil and vim.api.nvim_win_is_valid(float_term_win) then
        -- Close the floating terminal if it's open
        vim.api.nvim_win_close(float_term_win, true)
        float_term_win = nil
    else
        -- Create a new buffer for the floating terminal
        float_term_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_option(float_term_buf, 'bufhidden', 'wipe')

        -- Get window dimensions
        local width = vim.o.columns
        local height = vim.o.lines

        -- Set floating window size and position
        local win_width = math.floor(width * 0.7)
        local win_height = math.floor(height * 0.7)
        local row = math.floor((height - win_height) / 2)
        local col = math.floor((width - win_width) / 2)

        -- Open the floating window with appropriate style
        float_term_win = vim.api.nvim_open_win(float_term_buf, true, {
            relative = 'editor',
            width = win_width,
            height = win_height,
            row = row,
            col = col,
            style = 'minimal',
            border = 'rounded',
            noautocmd = true
        })

        -- Apply terminal colors to match background
        vim.api.nvim_win_set_option(float_term_win, 'winblend', 0) -- No transparency
        vim.api.nvim_win_set_option(float_term_win, 'winhighlight', 'Normal:Normal,FloatBorder:Normal')

        -- Start the terminal and enter insert mode
        vim.fn.termopen(vim.o.shell)
        vim.cmd('startinsert')

        -- Close the terminal on Esc
        vim.api.nvim_buf_set_keymap(float_term_buf, 't', '<Esc>', [[<C-\><C-n>:lua CloseFloatTerm()<CR>]],
            { noremap = true, silent = true })
    end
end

-- Function to close the floating terminal
function CloseFloatTerm()
    if float_term_win ~= nil and vim.api.nvim_win_is_valid(float_term_win) then
        vim.api.nvim_win_close(float_term_win, true)
        float_term_win = nil
    end
end
