# Issue, Execute and Writeback in Gem5

<div style="text-align:right; font-size:3em;">2022.07.15</div>

* Q: how next pc (predPC) is generated?

TODO:

`StaticInst` contains

```cpp
advancePC(*next_pc)
```

`X86StaticInst` overrides `advancePC` from `StaticInst`.

`X86ISA::MacroopBase` and `X86ISA::X86MicroopBase` override `advancePC` from `StaticInst`.

