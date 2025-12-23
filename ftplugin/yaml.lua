if vim.bo.filetype == "yaml.docker-compose" then
	require('ftplugin.docker_compose').setup()
end
