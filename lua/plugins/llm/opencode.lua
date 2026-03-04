local M = {}

M.setup = function()
    vim.g.opencode_opts = {
        server = {
            start = false,
            stop = false,
            toggle = false,
        }
    }
    vim.o.autoread = true
    vim.keymap.set({ "n", "x" }, "<leader>aa", function() require("opencode").ask("@this: ", { submit = true }) end,
        { desc = "Ask opencode" })
    vim.keymap.set({ "n", "x" }, "<leader>ac", function() require("opencode").select() end,
        { desc = "Execute opencode action…" })
    vim.keymap.set({ "n", "t" }, "<leader>at", function() require("opencode").toggle() end, { desc = "Toggle opencode" })

    vim.keymap.set({ "n", "x" }, "<leader>ap", function() return require("opencode").operator("@this ") end,
        { expr = true, desc = "Add range to opencode" })
    vim.keymap.set("n", "<leader>ay", function() return require("opencode").operator("@this ") .. "_" end,
        { expr = true, desc = "Add line to opencode" })


    -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
    vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
    vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
end

return M
