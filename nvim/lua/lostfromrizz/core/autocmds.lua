local user_group = vim.api.nvim_create_augroup("UserConfig", { clear = true })


-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = user_group,
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Format the code on save
vim.api.nvim_create_autocmd(
	"BufWritePre", {
		group = user_group,
		callback = function(event)
			vim.lsp.buf.format({ bufnr = event.buf })
		end
	}
)

-- Stops active terminal job on current buffer leave 
vim.api.nvim_create_autocmd("BufWinLeave", {
	pattern = "term://*",
	group = user_group,
	callback = function(args)
		local chan = vim.bo[args.buf].channel
		if chan and chan > 0 then
			vim.fn.jobstop(chan)
		end
	end,
})
