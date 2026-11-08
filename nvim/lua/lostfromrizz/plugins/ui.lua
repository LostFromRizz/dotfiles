local function source_material_you()
  local material_you_path = os.getenv("HOME")
      .. "/.config/nvim/colors/material_you.lua"

  local file, err = io.open(material_you_path, "r")

  if not file then
    return false, "Material You style file not found: " .. err
  end

  file:close()

  local ok, load_err = pcall(dofile, material_you_path)

  if not ok then
    return false, "Failed to load Material You colors: " .. tostring(load_err)
  end

  return true
end


---@class lostfromrizz.plugins.UI : lostfromrizz.plugins.PluginInterface

---@type lostfromrizz.plugins.UI
local M = {

  plugin_list = {},

  setup = function(ev)
    vim.api.nvim_create_autocmd("Signal", {
      pattern = "SIGUSR1",
      group = ev.group,
      callback = function()
        local ok, err = source_material_you()

        if not ok and err ~= nil then
          vim.notify(err, vim.log.levels.WARN)
        end
      end,
    })

    source_material_you()
  end

}

return M
