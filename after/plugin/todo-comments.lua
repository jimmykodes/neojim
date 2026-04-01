local icons = require("icons")

require("todo-comments").setup({
	keywords = {
		MARK = {
			icon = icons.ui.BookMark,
			color = "hint"
		},
	},
	highlight = {
		keyword = "bg",
		pattern = [[.*<(KEYWORDS)[^:]*:]],
	},
	search = {
		pattern = [[\b(KEYWORDS)(?:\(\w*\)|):]],
	},
})
