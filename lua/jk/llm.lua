local M = {

	---@type AutocmdDef[]
	cmds = {
		{
			event = { "BufWritePost" },
			opts = {
				group = "LLM",
				pattern = "md.llm",
				callback = function()

				end
			}
		}
	}
}

function M.setup()
	require("jk.autocmds").define_autocmds(M.cmds)
end

return M
