--- CheckHealth Lsp
vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", {})

-- Restart lsp
vim.api.nvim_create_user_command("RestartLsp", 
  function()
	for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		vim.lsp.enable(c.name, false)
		vim.lsp.enable(c.name, true)
		vim.notify(("Restarted %s"):format(c.name))
	end
end, {
	nargs = 0
})
