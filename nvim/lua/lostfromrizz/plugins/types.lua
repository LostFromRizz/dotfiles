---@class lostfromrizz.plugins.Opts
---@field group integer

---@class lostfromrizz.plugins.PluginInterface
---@field plugin_list (string|vim.pack.Spec)[]
---@field build? fun(opts: vim.event.packchanged.data)
---@field setup fun(ev: lostfromrizz.plugins.Opts)
