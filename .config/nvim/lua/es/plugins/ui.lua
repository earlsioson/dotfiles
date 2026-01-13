return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "night",
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},
	{
		"echasnovski/mini.icons",
		version = false,
		opts = {},
		config = function(_, opts)
			require("mini.icons").setup(opts)
			require("mini.icons").mock_nvim_web_devicons()
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "echasnovski/mini.icons" },
		cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeClose", "NvimTreeOpen", "NvimTreeFocus" },
		opts = {
			view = {
				width = 50,
				relativenumber = true,
			},
		},
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "echasnovski/mini.icons" },
		cmd = "Oil",
		opts = {
			columns = {
				"icon",
				{ "permissions", highlight = "Comment" },
				"size",
				"mtime",
				"preview",
			},
			preview_win = {
				update_on_cursor_moved = true,
				preview_method = "fast_scratch",
			},
		},
		-- Oil keymaps are centralized in es.keymaps
	},
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {
			input = {
				relative = "editor",
				min_width = 0.9,
				win_options = {
					winblend = 0,
				},
			},
			select = {
				backend = { "builtin" },
				builtin = {
					relative = "editor",
					min_width = 0.99,
					win_options = {
						winblend = 0,
					},
				},
			},
		},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "echasnovski/mini.icons" },
		event = "VeryLazy",
		config = function()
			require("lualine").setup({
				extensions = { "fugitive", "nvim-dap-ui", "quickfix" },
				sections = {
					lualine_b = { "FugitiveHead" },
					lualine_c = {
						{
							"filename",
							path = 1,
						},
					},
				},
			})
		end,
	},
	{
		"ellisonleao/glow.nvim",
		cmd = "Glow",
		opts = {
			border = "rounded",
		},
		-- Glow keymaps are centralized in es.keymaps
	},
	{
		"karb94/neoscroll.nvim",
		event = "VeryLazy",
		opts = {
			duration_multiplier = 2.0,
		},
	},
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		opts = {
			theme = "hyper",
			config = {
				week_header = {
					enable = true,
				},
				shortcut = {
					{ desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
					{
						icon = " ",
						icon_hl = "@variable",
						desc = "Files",
						group = "Label",
						action = "Telescope find_files",
						key = "f",
					},
					{
						icon = " ",
						icon_hl = "@variable",
						desc = "Search",
						group = "Label",
						action = "Telescope live_grep_args",
						key = "s",
					},
					{
						icon = "󰀶 ",
						icon_hl = "@variable",
						desc = "Browse",
						group = "Label",
						action = "Telescope file_browser",
						key = "b",
					},
				},
				project = {
					enable = false,
				},
			},
		},
	},
}
