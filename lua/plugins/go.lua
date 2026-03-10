-- Ensure nvim-treesitter is loaded before go.nvim
vim.cmd.packadd("nvim-treesitter")

vim.pack.add({
	"https://github.com/ray-x/guihua.lua",
	{ src = "https://github.com/ray-x/go.nvim" },
})

-- Setup go.nvim with error handling
local go_ok, go = pcall(require, "go")
if go_ok then
	local setup_ok, err = pcall(go.setup)
	if not setup_ok then
		vim.notify("go.nvim setup failed: " .. tostring(err), vim.log.levels.WARN)
	end
else
	vim.notify("Failed to load go.nvim: " .. tostring(go), vim.log.levels.WARN)
end
