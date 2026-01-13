function ColorMyPencils()
	vim.cmd.colorscheme("catppuccin-macchiato")
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
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
