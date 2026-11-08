local ui = require("lostfromrizz.plugins.ui")
local editor = require("lostfromrizz.plugins.editor")
local lsp = require("lostfromrizz.plugins.lsp")
local treesitter = require("lostfromrizz.plugins.treesitter")

---@type (string|vim.pack.Spec)[]
local plugins = {}

vim.list_extend(plugins, ui.plugin_list)
vim.list_extend(plugins, editor.plugin_list)
vim.list_extend(plugins, lsp.plugin_list)
vim.list_extend(plugins, treesitter.plugin_list)

---@param plugin lostfromrizz.plugins.PluginInterface
---@param args vim.api.keyset.create_autocmd.callback_args
local function call_build(plugin, args)
  if plugin.build and (args.data.kind == "install" or args.data.kind == "update") then
    plugin.build(args.data)
  end
end

local plugin_group = vim.api.nvim_create_augroup("UserPlugins", { clear = true })

-- Build plugins
vim.api.nvim_create_autocmd("PackChanged", {
  group = plugin_group,
  callback = function(opts)
    call_build(ui, opts)
    call_build(editor, opts)
    call_build(lsp, opts)
    call_build(treesitter, opts)
  end,
})

vim.pack.add(plugins)

ui.setup({ group = plugin_group })
editor.setup({ group = plugin_group })
lsp.setup({ group = plugin_group })
treesitter.setup({ group = plugin_group })
