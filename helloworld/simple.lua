root = "./"
project_name = "helloworld"

lua_path = root.."3rd/ltask/lualib/?.lua;"..root.."3rd/ltask/?.lua;"..root.."lualib/?.lua;"..root..project_name.."/?.lua;"
lua_cpath = root.."3rd/ltask/?.so;"
package.path = lua_path..package.path
package.cpath = lua_cpath..package.cpath


local boot = require "ltask.bootstrap"
boot.init_socket()

local function searchltaskpath(name)
	return assert(package.searchpath(name, "3rd/ltask/lualib/?.lua"))
end

local function readall(path)
	local f <close> = assert(io.open(path))
	return f:read "a"
end

local servicepath = searchltaskpath "service"
local service_path = root.."3rd/ltask/service/?.lua;"..root.."3rd/ltask/test/?.lua;"..root..project_name.."/service/?.lua;"..root..project_name.."/test/?.lua;"

local initfunc = ([=[
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
        service_path = service_path,
    }
)

local bootstrap = require "bootstrap"
local ctx = bootstrap.start {
    core = {
        debuglog = "="
    },
    root = {
        service_source = readall(servicepath),
        service_chunkname = "@"..servicepath,
        bootstrap = {
            {
                name = "logger",
                unique = true,
            },
            {
                name = "timer",
                unique = true,
            },
            {
                name = "sockevent",
                unique = true,
            },
            -- {
            --     name = "bootstrap",
            -- },
            {
                name = "tbootstrap",
                -- unique = true,  -- 不设置为true
            }
        },
        initfunc = initfunc,
    },
    root_initfunc = initfunc,
    mainthread = nil,
}

bootstrap.wait(ctx)
