root = "./"
project_name = "helloworld"

lua_path = root.."3rd/ltask/lualib/?.lua;"..root.."3rd/ltask/?.lua;"..root.."lualib/?.lua;"..root..project_name.."/?.lua;"
lua_cpath = root.."3rd/ltask/?.so;"
package.path = lua_path..package.path
package.cpath = lua_cpath..package.cpath

local function searchltaskpath(name)
	return assert(package.searchpath(name, "3rd/ltask/lualib/?.lua"))
end

local function readall(path)
	local f <close> = assert(io.open(path))
	return f:read "a"
end

local config = {
    core = {
        debuglog = "=", -- stdout
    },
    service_path = root.."3rd/ltask/service/?.lua;"..root.."3rd/ltask/test/?.lua;"..root..project_name.."/service/?.lua;",
    bootstrap = {
        {
            name = "timer",
            unique = true,
        },
        {
            name = "logger",
            unique = true,
        },
        {
            name = "sockevent",
            unique = true,
        },
        {
            name = "bootstrap",
        },
    },
}

local servicepath = searchltaskpath "service"
local root_config = {
    bootstrap = config.bootstrap,
    service_source = readall(servicepath),
    service_chunkname = "@"..servicepath,
    initfunc = ([=[
local name = ...
package.path = [[${lua_path}]]
package.cpath = [[${lua_cpath}]]
local filename, err = package.searchpath(name, "${service_path}")
if not filename then
	return nil, err
end
return loadfile(filename)
]=]):gsub("%$%{([^}]*)%}", {
	lua_path = package.path,
	lua_cpath = package.cpath,
	service_path = config.service_path,
}),
}

local boot = require "ltask.bootstrap"
boot.init_socket()

local bootstrap = require "bootstrap"
local ctx = bootstrap.start {
    core = config.core or {},
    root = root_config,
    root_initfunc = root_config.initfunc,
    mainthread = config.mainthread,
}

local message = string.format("( ltask.bootstrap ) %s", "main start")
boot.pushlog(boot.pack("info", message))
bootstrap.wait(ctx)
