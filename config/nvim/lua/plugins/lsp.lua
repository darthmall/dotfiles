local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
return {
	{ "L3MON4D3/LuaSnip" },
	{ -- auto completion
		"hrsh7th/nvim-cmp",
		version = false,
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
		},
		opts = function()
			local cmp = require("cmp")
			return {
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
				experimental = {
					-- TODO: What this do?
					ghost_text = {
						hl_group = "LspCodeLens",
					},
				},
			}
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			-- TODO: folke/neoconf.nvim for project local config?
			-- TODO: "folke/neodev.nvim" for NeoVim lua completions? Needs cmp-nvim-lsp?
		},
		keys = {
			{ "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
			{ "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
			{ "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition" },
			{ "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
			{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
			{ "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
			{ "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto Type Definition" },
			{ "K", vim.lsp.buf.hover, desc = "Hover" },
			-- { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
			-- { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
			{ "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
			{ "[d", vim.diagnostic.goto_prev, desc = "Prev Diagnostic" },
			{ "]e", function () vim.diagnostic.goto_next({ severity = "ERROR" }) end, desc = "Next Error" },
			{ "[e", function () vim.diagnostic.goto_prev({ severity = "ERROR" }) end, desc = "Prev Error" },
			{ "]w", function () vim.diagnostic.goto_next({ severity = "WARN" }) end, desc = "Next Warning" },
			{ "[w", function () vim.diagnostic.goto_prev({ severity = "WARN" }) end, desc = "Prev Warning" },
			-- { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
			-- { "<leader>cf", format, desc = "Format Document", has = "documentFormatting" },
			-- { "<leader>cf", format, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
			{ "<leader>cr", vim.lsp.buf.rename, expr = true, desc = "Rename" },
		},
		opts = {
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = { spacing = 4, prefix = "●" },
				severity_sort = true,
			},
			servers = {
				"bashls",
				"cssls",
				"dockerls",
				"eslint",
				"emmet_ls",
				"html",
				"jsonls",
				"pyright",
				"svelte",
				"taplo", -- TOML
				"tsserver",
				"vimls",
				"yamlls",
			},
			setup = {
				-- setup handlers for mason-lspconfig
			}
		},
		config = function(plugin, opts)
			vim.diagnostic.config(opts.diagnostics)

			-- TODO: Configure autoformat

			local servers = opts.servers

			local function setup(server)
				local server_opts = servers[server] or {}

				require("lspconfig")[server].setup(server_opts)
			end

			local mlsp = require("mason-lspconfig")
			mlsp.setup({ ensure_installed = servers })
			mlsp.setup_handlers({ setup })
		end,
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "BufReadPre",
		dependencies = { "williamboman/mason.nvim" },
		opts = function()
			local nls = require("null-ls")
			return {
				sources = {
					nls.builtins.diagnostics.flake8,
					nls.builtins.formatting.black,
					nls.builtins.formatting.eslint,
					nls.builtins.formatting.isort,
					nls.builtins.formatting.prettier,
					nls.builtins.formatting.stylua,
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr })
							end,
            })
        end
				end,
			}
		end,
	},

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
