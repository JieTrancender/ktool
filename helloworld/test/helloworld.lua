local ltask = require "ltask"

local worker = ltask.worker_id()
print (string.format("helloworld %d in worker %d", ltask.self(), worker))
ltask.worker_bind(worker)	-- bind to current worker thread


-- local ltask = require "ltask"

local S = {}

function S.PING()
    print "helloworld PING"
    return "PONG"
end

function S.Sum(nMin, nMax)
    local nResult = 0
    for i = nMin, nMax do
        nResult = nResult + i
    end
    
    return nResult
end

function S.quit()
    ltask.quit()
end

return S
