if vim.bo.filetype == "yaml.docker-compose" then
	require('ftplugin.docker_compose').setup()
elseif vim.bo.filetype == "yaml.github" then
	require('ftplugin.github_action').setup()
end
