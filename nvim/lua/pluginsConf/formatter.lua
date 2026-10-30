require("conform").setup({
	formatters_by_ft = {
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		svelte = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		graphql = { "prettier" },
		lua = { "stylua" },
		handlebars = { "djlint" },
	},
})

if vim.fn.has("mac") == 1 then
	require("conform").formatters_by_ft.php = { "php-cs-fixer" }
	require("conform").formatters["php-cs-fixer"] = {
		command = "php-cs-fixer",
		args = { "fix", "--config=" .. vim.fn.expand("~/.php-cs-fixer.php"), "$FILENAME" },
		stdin = false,
	}
end
