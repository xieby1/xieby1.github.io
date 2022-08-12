<div style="text-align:right; font-size:3em;">2022.07.29</div>

# Clock in Gem5

Difference between `Tick`, `Cycle`

src/sim/clocked_object.hh:

```cpp
Tick
clockEdge(Cycles cycles=Cycles(0)) const
{
    // align tick to the next clock edge
    update();

    // figure out when this future cycle is
    return tick + clockPeriod() * cycles;
}
```

`clockEdge` is the a integral multiple of `cycle`.
