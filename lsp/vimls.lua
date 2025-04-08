return {
	name = "vimls",
	cmd = { "vim-language-server", "--stdio" },
	filetypes = { "vim" },
	init_options = { isNeovim = true },
}
