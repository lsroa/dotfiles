P = function(var)
	print(vim.inspect(var))
	return var
end

RELOAD = function(...)
	return require('plenary.reload').reload_module(...)
end

R = function(name)
	RELOAD(name)
	return require(name)
end
