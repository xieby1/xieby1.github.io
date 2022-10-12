<div style="text-align:right; font-size:3em;">2022.07.05</div>

# Cache in Gem5

No out-of-box l3cache support in se.py, only l1&l2cache.

## tag/data/response latency

src/mem/cache/Cache.py:

```python
tag_latency = Param.Cycles("Tag lookup latency")
data_latency = Param.Cycles("Data access latency")
response_latency = Param.Cycles("Latency for the return path on a miss");
```

### recvTimingReq

* src/mem/cache/cache.cc:

  ```cpp
  void Cache::recvTimingReq(PacketPtr pkt) {
    /// TODO:
    // a cache above us (but not where the packet came from) is
    // responding to the request, in other words it has the line
    // in Modified or Owned state
    BaseCache::recvTimingReq(pkt);
  }
  ```

  * src/mem/cache/base.cc:

    ```cpp
    void BaseCache::recvTimingReq(PacketPtr pkt) {
      ...
      Cycles lat;
      CacheBlk *blk = nullptr;
      bool satisfied = false;
      {
          PacketList writebacks;
          // Note that lat is passed by reference here. The function
          // access() will set the lat value.
          satisfied = access(pkt, blk, lat, writebacks);
          // After the evicted blocks are selected, they must be forwarded
          // to the write buffer to ensure they logically precede anything
          // happening below
          doWritebacks(writebacks, clockEdge(lat + forwardLatency));
      }
      ...
    }
    ```

    * src/mem/cache/base.cc:

      ```cpp
      bool BaseCache::access(PacketPtr pkt, CacheBlk *&blk, Cycles &lat, PacketList &writebacks) {
        ...
        Cycles tag_latency(0);
        blk = tags->accessBlock(pkt, tag_latency);
        ...
        if (pkt->isRead()) {
          lat = calculateAccessLatency(blk, pkt->headerDelay, tag_latency);
          ...
        }
      }
      ```

      Firstly, `tag_latency` is calculated in `accessBlock` as below.
      Then, access latency is calculated.

      * src/mem/cache/tags/base_set_assoc.hh:

        ```cpp
        CacheBlk* accessBlock(const PacketPtr pkt, Cycles &lat) override {
          CacheBlk *blk = findBlock(pkt->getAddr(), pkt->isSecure());
          ...
          lat = lookupLatency;
          return blk;
        }
        ```

# Coherence Protocol

Ref:
2011.consistency_coherence..slca..pdf

2 classes of coherence protocols

* snooping

  > Snooping protocols are based on one idea: all coherence controllers observe (snoop) coherence re-
  > quests in the same order and collectively “do the right thing” to maintain coherence.

* directory
