return {
	name = "helmls",
	cmd = { "helm_ls", "serve" },
	filetypes = { "helm" },
	root_markers = { "Chart.yaml" },
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
	},
}
