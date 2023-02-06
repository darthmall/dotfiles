-- Author: Evan Sheehan <darth_mall@pm.me>
-- Description: NeoVim configuration
-- vim: set fdm=marker fdl=0 ts=2 sw=2 noet tw=80 :

require("options");

-- Bootstrap lazy.nvim {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	-- Install lazy.nvim
	vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable",
			lazypath,
		})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {
	colorsheme = "nord",
})
-- }}}

require("autocmds");
require("keymaps");

-- HTML/CSS/JS
vim.g["prettier#autoformat_config_present"] = 1
-- }}}

-- Local config {{{
local ok, local_config = pcall(require, "config/local")
if ok then
  print("Loaded local config")
end
-- }}}
