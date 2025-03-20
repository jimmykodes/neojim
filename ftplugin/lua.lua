---@type LSPEntry[]
local lsps = {
	"lua_ls"
}

require('jk.ft').setup("lua", {
	lsps = lsps,
})
