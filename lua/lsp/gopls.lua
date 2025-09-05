return {
	cmd = { 'gopls' },
	filetypes = { 'go' },
	settings = {
		gopls = {
			gofumpt = true,
			completeUnimported = true,
      semanticTokens = true,
		}
	}
}
