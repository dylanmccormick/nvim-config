require("typst-preview").setup({
	-- keep defaults; this ensures dependencies are downloaded/updated
	open_cmd = nil,
	dependencies_bin = {
		-- Use your system tinymist (already installed).
		-- If you later switch to Mason's tinymist, keep this as 'tinymist'.
		["tinymist"] = "tinymist",
	},
})
