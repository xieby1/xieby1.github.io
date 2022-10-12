<div style="text-align:right; font-size:3em;">2022.09.14</div>

# Micro Cache Adapter in Gem5

Micro Cache Adapter (MCA, UCA)

git commit: 95d7c1d

configs/common/Caches.py:

```python
class L1Cache(Cache):
    assoc = 2
    tag_latency = 2
    data_latency = 2
    response_latency = 2
    mshrs = 4
    tgts_per_mshr = 20

class L1_ICache(L1Cache):
    is_read_only = True
    # Writeback clean lines as well
    writeback_clean = True
```

icache的查询延迟和数据均为2。
为和原gem5对照，将UCA的延迟设置为icache的延迟2+2=4。
指令发射分布的数据如下，

gem5-orig

```
system.cpu.numIssuedDist::samples              309598                       # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::mean               2.450507                       # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::stdev              2.065197                       # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::underflows                0      0.00%      0.00% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::0                     72040     23.27%     23.27% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::1                     46305     14.96%     38.23% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::2                     55312     17.87%     56.09% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::3                     46645     15.07%     71.16% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::4                     31274     10.10%     81.26% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::5                     23686      7.65%     88.91% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::6                     24134      7.80%     96.70% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::7                      8138      2.63%     99.33% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::8                      2064      0.67%    100.00% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::overflows                 0      0.00%    100.00% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::min_value                 0                       # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::max_value                 8                       # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::total                309598                       # Number of insts issued each cycle (Count)
```

xa64-bt

```
system.cpu.numIssuedDist::samples             1629797                       # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::mean               0.334398                       # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::stdev              0.501654                       # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::underflows                0      0.00%      0.00% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::0                   1106546     67.89%     67.89% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::1                    502574     30.84%     98.73% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::2                     20204      1.24%     99.97% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::3                       132      0.01%     99.98% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::4                        94      0.01%     99.98% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::5                       238      0.01%    100.00% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::6                         7      0.00%    100.00% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::7                         1      0.00%    100.00% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::8                         1      0.00%    100.00% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::overflows                 0      0.00%    100.00% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::min_value                 0                       # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::max_value                 8                       # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::total               1629797                       # Number of insts issued each cycle (Count)
```

xa64-bt比gem5-orig慢，是其7.328115001倍。
由此推测主要性能瓶颈在这里。
采用预取来缓解。

<div style="text-align:right; font-size:3em;">2022.09.15</div>

每次取8条左右的uop，性能变为

```
system.cpu.numIssuedDist::samples              466450                       # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::mean               1.204727                       # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::stdev              1.267099                       # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::underflows                0      0.00%      0.00% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::0                    182367     39.10%     39.10% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::1                    115977     24.86%     63.96% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::2                     95149     20.40%     84.36% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::3                     42788      9.17%     93.53% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::4                     24408      5.23%     98.76% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::5                      4947      1.06%     99.83% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::6                       762      0.16%     99.99% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::7                        49      0.01%    100.00% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::8                         3      0.00%    100.00% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::overflows                 0      0.00%    100.00% # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::min_value                 0                       # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::max_value                 8                       # Number of insts issued each cycle (Count)
system.cpu.numIssuedDist::total                466450                       # Number of insts issued each cycle (Count)
```

平均发射数由0.334398变为1.204727，3.6倍。
性能变为3.47倍。

目前是原生x86性能的70%。
平均发射率仍然不高，才1.204727，原生2.450507。
原生fetch stall周期数69007，xa64-bt fetch stall周期数345589+2788=348377，为原生的5倍！
squashCycles也较高，但我觉得主要矛盾仍然是fetch发射平均数。
十分有必要加入针对ucache的预取机制。
