-- Author: Evan Sheehan <darth_mall@pm.me>
-- Description: NeoVim autocommands
-- vim: set fdm=marker fdl=0 ts=2 sw=2 noet tw=80 :

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Treat some files as HTML
vim.api.nvim_create_autocmd({"BufNewFile", "BufReadPost"}, {
	pattern = {"*.svelte", "*.njk", "*.webc"},
	command = "set syntax=html",
})

-- Turn on spell-checking and soft line wrapping
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gitcommit", "markdown" },
	callback = function ()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Autoformat Python files
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.py" },
	callback = function() vim.lsp.buf.format { async = true } end
})
