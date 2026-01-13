function ColorMyPencils()
	vim.cmd.colorscheme("catppuccin-macchiato")
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	local filename_hl = { bg = "#181825", fg = "#CDD6F5" }
	local inactive_hl = { bg = "#181825", fg = "#89B4FB" }

	vim.api.nvim_set_hl(0, "MiniStatuslineFilename", filename_hl)
	vim.api.nvim_set_hl(0, "MiniStatuslineInactive", inactive_hl)
end

return {
	"catppuccin/nvim",
	name = "catppuccin",
	config = function()
		require("catppuccin").setup({
			styles = {},
		})
		ColorMyPencils()
	end,
}
