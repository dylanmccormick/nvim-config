return {
	cmd = { "vscode-json-languageserver", "--stdio" },
	filetypes = { 'json' },
	init_options = {
		provideFormatter = true
	}
}
