return {
	{ -- neotest
		"nvim-neotest/neotest",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-python"
		},
		keys = {
			{ "<leader>tt", function() require("neotest").run.run() end, desc = "Run Nearest Test" },
			{ "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run All Tests in File" },
		},
		config = function(_, opts)
			require("neotest").setup({
				adapters = {
					require("neotest-python"),
				},
			})
		end,
	},

	-- TODO: nvim-dap for debugging?
}
