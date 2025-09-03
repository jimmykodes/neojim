local M = {}

local source_names = {
	nvim_lsp = "(LSP)",
	path = "(Path)",
	calc = "(Calc)",
	buffer = "(Buffer)",
	treesitter = "(TreeSitter)",
}

local source_hl = {
	nvim_lsp = "Special",
	path = "Keyword",
	calc = "Boolean",
	buffer = "String",
	treesitter = "Number",
}

function M.setup()
	local cmp = require('cmp')

	cmp.setup({
		snippet = {
			expand = function(args)
				vim.snippet.expand(args.body)
			end,
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert({
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.abort(),
			['<Tab>'] = cmp.mapping.select_next_item(),
			['<S-Tab>'] = cmp.mapping.select_prev_item(),
			['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		}),
		formatting = {
			format = function(entry, vim_item)
				vim_item.menu = source_names[entry.source.name]
				vim_item.kind_hl_group = source_hl[entry.source.name]
				return vim_item
			end
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "treesitter" },
			{ name = "path" },
			{ name = "calc" },
		}, {
			{ name = 'buffer' },
		})
	})

	-- Use buffer source for `/` and `?`
	cmp.setup.cmdline({ '/', '?' }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = 'buffer' }
		}
	})

	-- Use cmdline & path source for ':'
	cmp.setup.cmdline(':', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = 'path' }
		}, {
			{ name = 'cmdline' }
		}),
		matching = { disallow_symbol_nonprefix_matching = false }
	})
end

return M
