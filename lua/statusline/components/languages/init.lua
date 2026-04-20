local languages = {
	python = require('statusline.components.languages.python'),
	go = require('statusline.components.languages.go'),
}
return {
	hl = function()
		local component = languages[vim.bo.filetype] or {}
		if component.hl ~= nil then
			return component.hl()
		end
	end,
	show = function()
		local component = languages[vim.bo.filetype] or {}
		if component.show == nil then
			return false
		end
		return component.show()
	end,
	render = function()
		local component = languages[vim.bo.filetype] or {}
		if component == nil then
			return ""
		end
		return component.render()
	end
}
