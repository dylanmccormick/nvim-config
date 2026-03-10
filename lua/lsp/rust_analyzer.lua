return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	settings = {
		rust_analyzer = {
			cargo = { allFeatures = true },
			checkOnSave = { command = "clippy" },
		},
	},
}
