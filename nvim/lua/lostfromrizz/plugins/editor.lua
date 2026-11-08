local Utils = require("lostfromrizz.utils")

---@class lostfromrizz.plugins.Editor: lostfromrizz.plugins.PluginInterface

---@type lostfromrizz.plugins.Editor
local M = {
  plugin_list = {
    Utils.gh("nvim-telescope/telescope.nvim"),
    Utils.gh("nvim-lua/plenary.nvim"),
    Utils.gh("nvim-telescope/telescope-fzf-native.nvim"),
    Utils.gh("mbbill/undotree"),
  },

  build = function(opts)
    local name = opts.spec.name
    if name == "telescope-fzf-native.nvim" then
      vim.system({ 'make' }, { cwd = opts.path })
    end
  end,

  setup = function(_)
    require("telescope").setup()
    local builtin = require('telescope.builtin')
    local keymap = vim.keymap

    keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
    keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
    keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
    keymap.set("n", "<leader>T", "<cmd>UndotreeToggle<cr>", { desc = "Undo tree toggle" })
  end
}


return M
