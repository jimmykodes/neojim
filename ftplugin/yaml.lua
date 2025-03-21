if vim.bo.filetype == "yaml.docker-compose" then
	require('jk.ftplugin.docker_compose').setup()
end
require('jk.ftplugin.yaml').setup()
