local Utils = require("lostfromrizz.utils")

local ensureInstalled = {
  "c",
  "cpp",
  "diff",
  "html",
  "javascript",
  "jsdoc",
  "json",
  -- "jsonc",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "printf",
  "python",
  "query",
  "regex",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
  "rust",
  "dart",
  "qmljs",
}

local function install_parsers()
  local TS = require("nvim-treesitter")

  local alreadyInstalled = TS.get_installed()
  local parsersToInstall = vim.iter(ensureInstalled):filter(function(parser)
    return not vim.tbl_contains(alreadyInstalled, parser)
  end):totable()

  if not vim.tbl_isempty(parsersToInstall) then
    TS.install(parsersToInstall)
  end
end


---@class lostfromrizz.plugins.Treesitter: lostfromrizz.plugins.PluginInterface

---@type lostfromrizz.plugins.Treesitter
local M = {
  plugin_list = { Utils.gh("nvim-treesitter/nvim-treesitter") },

  build = function(opts)
    local name = opts.spec.name
    if name == "nvim-treesitter" then
      if not opts.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,

  setup = function(ev)
    -- Wait for mason to finish before compiling parsers
    if vim.fn.executable("tree-sitter") == 1 then
      install_parsers()
    else
      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonUpdateCompleted",
        once = true,
        callback = install_parsers,
      })
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = ev.group,
      callback = function(event)
        local lang = vim.treesitter.language.get_lang(event.match)
        if not lang then
          return
        end

        local ok = pcall(vim.treesitter.language.add, lang)
        if not ok then
          return
        end

        vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end
}

return M
