-- https://github.com/folke/trouble.nvim
return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
	keys = {
		{ "<leader>tt", "<cmd>TroubleToggle<CR>" },
		{ "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<CR>" },
		{ "<leader>td", "<cmd>TroubleToggle document_diagnostics<CR>" },
		{ "<leader>tq", "<cmd>TroubleToggle quickfix<CR>" },
		{ "<leader>tl", "<cmd>TroubleToggle loclist<CR>" },
		{ "<leader>to", "<cmd>ToDoTrouble<CR>" },
	},
}
