# ktool


### 编译
```
cd 3rd/ltask && make
```

### 测试并行任务
分别使用10个VM并发计算和单独VM计算1-15\*10000\*1000总和。
```
---helloworld/test/tbootstrap.lua
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

[2024-06-21 11:32:57.10][INFO ]( tbootstrap ) req       10      15      1350000001      1500000000      213750000075000000
[2024-06-21 11:32:57.12][INFO ]( tbootstrap ) req       1       6       1       150000000       11250000075000000
[2024-06-21 11:32:57.12][INFO ]( tbootstrap ) req       7       12      900000001       1050000000      146250000075000000
[2024-06-21 11:32:57.12][INFO ]( tbootstrap ) req       5       10      600000001       750000000       101250000075000000
[2024-06-21 11:32:57.13][INFO ]( tbootstrap ) req       6       11      750000001       900000000       123750000075000000
[2024-06-21 11:32:57.13][INFO ]( tbootstrap ) req       4       9       450000001       600000000       78750000075000000
[2024-06-21 11:32:57.13][INFO ]( tbootstrap ) req       8       13      1050000001      1200000000      168750000075000000
[2024-06-21 11:32:57.14][INFO ]( tbootstrap ) req       2       7       150000001       300000000       33750000075000000
[2024-06-21 11:32:57.15][INFO ]( tbootstrap ) req       3       8       300000001       450000000       56250000075000000
[2024-06-21 11:32:57.15][INFO ]( tbootstrap ) req       9       14      1200000001      1350000000      191250000075000000
[2024-06-21 11:32:57.15][INFO ]( tbootstrap ) result    1125000000750000000
[2024-06-21 11:33:01.50][INFO ]( tbootstrap ) right value       1125000000750000000     1125000000750000000     true

```