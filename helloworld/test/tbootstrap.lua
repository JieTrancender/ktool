local ltask = require "ltask"

local nMaxValue = 1 * 10000 * 10000 * 15
local nMaxService = 10
local nAverage = math.floor(nMaxValue / nMaxService)
local tbService = {}
local tbTask = {}
local nAddr

for i = 1, nMaxService do
    nAddr = ltask.spawn("helloworld")
    table.insert(tbService, nAddr)
end


for i = 1, nMaxService do
    nAddr = tbService[i]
    table.insert(tbTask, {ltask.call, nAddr, "Sum", nAverage * (i - 1) + 1, i*nAverage, id = i})
end

local nSum = 0
for req, resp in ltask.parallel(tbTask) do
    print("req", req.id, req[2], req[4], req[5], resp[1])
    nSum = nSum + resp[1]
end
print("result", nSum)

local nRightSum = 0
for i = 1, nMaxValue do
    nRightSum = nRightSum + i
end
print("right value", nSum, nRightSum, nSum == nRightSum)


for _, nAddr in ipairs(tbService) do
    ltask.send(nAddr, "quit")
end
