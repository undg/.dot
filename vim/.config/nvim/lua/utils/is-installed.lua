return function(app_name)
	local os_name = package.config:sub(1, 1)
	if os_name == "\\" then
		-- Windows
		return os.execute("where " .. app_name .. " > nul 2>&1") == 0
	else
		-- Unix/Linux/Mac
		return os.execute("which " .. app_name .. " > /dev/null 2>&1") == 0
	end
end
