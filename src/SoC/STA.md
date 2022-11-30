<div style="text-align:right; font-size:3em;">2022.11.01</div>

# Static Timing Analysis (STA)

## Terminologies

* Clock Signal
* Design Objects
* Clock Latency

  Time delay between the **source of generation** and the **destination**.
  Including:

  * Clock Skew

    two different flip flops receive the clock signal at slightly different time due to difference in clock net length

  * Clock Jitter

    on the same flip flop but the position of clock edge moves edge to edge due to some noise in oscillator.

* Clock Domain

  a group of logic circuits operating on single clock or
  derived clocks that are synchronous to each other.

* 
