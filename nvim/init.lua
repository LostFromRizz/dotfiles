if vim.loader then
  vim.loader.enable()
end

require("lostfromrizz.core.options")
require("lostfromrizz.core.keymaps")
require("lostfromrizz.core.autocmds")
require("lostfromrizz.core.usercmds")

require("lostfromrizz.plugins")
