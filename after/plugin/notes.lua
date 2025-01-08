-- Create a global sticky_notes table
_G.sticky_notes = {}

-- Set the sticky note file path
sticky_notes.file_path = vim.fn.stdpath("data") .. "/sticky_note.txt"

-- Function to open the sticky note in a floating window
function sticky_notes.open_floating_note()
    if sticky_notes.win_id and vim.api.nvim_win_is_valid(sticky_notes.win_id) then
        vim.api.nvim_win_close(sticky_notes.win_id, true)
        return
    end

    local buf = vim.api.nvim_create_buf(false, true)
    if vim.fn.filereadable(sticky_notes.file_path) == 1 then
        vim.api.nvim_buf_call(buf, function()
            vim.cmd("silent! read " .. sticky_notes.file_path)
        end)
    end

    local width = math.floor(vim.o.columns * 0.7)
    local height = math.floor(vim.o.lines * 0.7)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    sticky_notes.win_id = vim.api.nvim_open_win(buf, true, {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = "rounded",
        noautocmd = true,
    })

    vim.api.nvim_win_set_option(sticky_notes.win_id, "winblend", 0)
    vim.api.nvim_win_set_option(sticky_notes.win_id, "winhighlight", "Normal:Normal")

    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "swapfile", false)

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufLeave", "CursorHold" }, {
        buffer = buf,
        callback = function()
            vim.cmd("silent! write! " .. sticky_notes.file_path)
        end,
    })

    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })
end

-- Function to show a floating input box
function sticky_notes.input_task(callback)
    local input_buf = vim.api.nvim_create_buf(false, true)
    local width = 50
    local height = 1
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local win_id = vim.api.nvim_open_win(input_buf, true, {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = "rounded",
    })

    vim.api.nvim_buf_set_option(input_buf, "modifiable", true)
    vim.api.nvim_buf_set_keymap(input_buf, "i", "<CR>",
        "<cmd>lua sticky_notes.submit_task(" .. input_buf .. ", " .. win_id .. ")<CR>", { noremap = true, silent = true })

    vim.cmd("startinsert")
end

-- Function to handle task submission
function sticky_notes.submit_task(input_buf, win_id)
    local lines = vim.api.nvim_buf_get_lines(input_buf, 0, -1, false)
    local task_name = lines[1] or ""

    vim.api.nvim_win_close(win_id, true)

    if task_name ~= "" then
        local buf = vim.api.nvim_get_current_buf()
        local line_count = vim.api.nvim_buf_line_count(buf)
        vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, { "- [ ] " .. task_name })
    end
end

-- Function to toggle done/undone state of the task on the current line
function sticky_notes.toggle_done()
    local buf = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0) -- Get cursor position {row, col}
    local line_num = cursor[1] - 1                -- Convert to 0-based index

    local current_line = vim.api.nvim_buf_get_lines(buf, line_num, line_num + 1, false)[1]
    if current_line:match("%- %[ %]") then
        vim.api.nvim_buf_set_lines(buf, line_num, line_num + 1, false, { current_line:gsub("%- %[ %]", "- [x]") })
    elseif current_line:match("%- %[x%]") then
        vim.api.nvim_buf_set_lines(buf, line_num, line_num + 1, false, { current_line:gsub("%- %[x%]", "- [ ]") })
    end
end

-- Function to remove the task on the current line
function sticky_notes.remove_task()
    local buf = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0) -- Get cursor position {row, col}
    local line_num = cursor[1] - 1                -- Convert to 0-based index

    vim.api.nvim_buf_set_lines(buf, line_num, line_num + 1, false, {})
end

-- Function to create a new sticky note
function sticky_notes.new_note()
    os.remove(sticky_notes.file_path)
    sticky_notes.open_floating_note()
end

-- Keybindings
vim.api.nvim_set_keymap("n", "<leader>nn", "<cmd>lua sticky_notes.open_floating_note()<CR>",
    { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>NN", "<cmd>lua sticky_notes.new_note()<CR>", { noremap = true, silent = true })

-- Keybindings for tasks
vim.api.nvim_set_keymap("n", "<leader>na", "<cmd>lua sticky_notes.input_task()<CR>", { noremap = true, silent = true })
