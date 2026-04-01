require("dap-python").setup("uv")

table.insert(require("dap").configurations.python or {}, {
	name = "Remote Airflow",
	type = "python",
	request = "attach",
	connect = {
		host = "localhost",
		port = 5678,
	},
	pathMappings = {
		{
			localRoot = "${workspaceFolder}/venv/lib/python3.11/site-packages",
			remoteRoot = "/home/airflow/.local/lib/python3.11/site-packages"
		},
		{
			localRoot = "${workspaceFolder}/dags",
			remoteRoot = "/opt/airflow/dags/repo/dags",
		}
	},
	justMyCode = false,
})

table.insert(require("dap").configurations.python, {
	name = "Docker",
	type = "python",
	request = "attach",
	connect = {
		host = "localhost",
		port = 5678,
	},
	pathMappings = {
		{
			localRoot = "${workspaceFolder}",
			remoteRoot = "/app"
		}
	},
	justMyCode = false,
})
