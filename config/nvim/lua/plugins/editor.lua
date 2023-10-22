return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			exclude = { filetypes = { "help", "alpha", "Trouble", "lazy" } },
		},
	},
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		config = function(_, opts)
			require("mini.pairs").setup(opts)
		end,
	},
	{
		"echasnovski/mini.surround",
		keys = function(plugin, keys)
      -- Populate the keys based on the user's options
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      return vim.list_extend(mappings, keys)
		end,
		opts = {
			-- Copy settings from vim-surround
			mappings = {
				add = "ms",
				delete = "md",
				find = "mf",
				find_left = "mF",
				highlight = "mh",
				replace = "mc",
				update_n_lines = "mn",
			},
		},
		config = function(_, opts)
			require("mini.surround").setup(opts)
		end,
	},
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		config = function(_, opts)
			require("mini.comment").setup(opts)
		end,
	},
	-- TODO: mini.ai for better text objects?
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		opts = {
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

				map("n", "]h", gs.next_hunk, "Next hunk")
				map("n", "[h", gs.prev_hunk, "Prev hunk")
				map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
				map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
				map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
				map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
				map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
				map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
				map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
				map("n", "<leader>ghd", gs.diffthis, "Diff This")
				map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
			end,
		},
		config = function(_, opts)
			require("gitsigns").setup(opts)
		end,
	},
	{ "L3MON4D3/LuaSnip" },
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		opts = {
			ensure_installed = {
				"black",
				"emmet-ls",
				"flake8",
				"isort",
				"prettier",
				"shellcheck",
				"shfmt",
				"stylelint-lsp",
				"stylua",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local registry = require("mason-registry")
			for _, name in ipairs(opts.ensure_installed) do
				local pkg = registry.get_package(name)
				if not pkg:is_installed() then
					pkg:install()
				end
			end
		end,
	},
}
