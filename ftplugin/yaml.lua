if vim.bo.filetype == "yaml.docker-compose" then
	require('jk.ftplugin.docker_compose').setup()
	require('jk.ftplugin.yaml').setup()
elseif vim.bo.filetype == "helm" then
	require('jk.ftplugin.helm').setup()
else
	require('jk.ftplugin.yaml').setup()
end
