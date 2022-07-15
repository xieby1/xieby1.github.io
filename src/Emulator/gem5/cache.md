<div style="text-align:right; font-size:3em;">2022.07.05</div>

# Cache in Gem5

No out-of-box l3cache support in se.py, only l1&l2cache.

# Coherence Protocol

Ref:
2011.consistency_coherence..slca..pdf

2 classes of coherence protocols

* snooping

  > Snooping protocols are based on one idea: all coherence controllers observe (snoop) coherence re-
  > quests in the same order and collectively “do the right thing” to maintain coherence.

* directory
