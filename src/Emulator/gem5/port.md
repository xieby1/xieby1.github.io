# Port Abstraction in Gem5

<div style="text-align:right; font-size:3em;">2022.07.08</div>

## Req/Resp

### Resp

```
CacheResponsePort -> QueuedResponsePort -> ResponsePort -> Port
                                                        -> AtomicResponseProtocol
                                                        -> TimingResponseProtocol
                                                        -> FunctionalResponseProtocol
```

I focus on `TimingResponseProtocol`.

TimingResponseProtocol

* snoop
  * sendSnoopReq
  * recvTimingSnoopResp
  * sendRetrySnoopResp
* normal
  * recvTimingReq
  * sendRetryReq
  * sendResp
  * recvRespRetry
  * tryTiming


<div style="text-align:right; font-size:3em;">2022.07.05</div>

## bind & unbind

* Q: How port connection in config(python) is translated into runtime(cpp)?
  This question appears when learning `BaseCache::CpuSidePort`.

Inheritage

* `gem5::BaseCache::CpuSidePort`
  * `gem5::BaseCache::CacheResponsePort`
    * `gem5::QueuedResponsePort`
      * `gem5::ResponsePort`
        * `gem5::Port`
          * virtual `virtual void bind (Port &peer)`
          * virtual `void bind (Port &peer)`
        * `gem5::AtomicResponseProtocol`
        * `gem5::TimingResponseProtocol`
        * `gem5::FunctionalResponseProtocol`
        * override `void unbind () override`
        * override `void bind (Port &peer) override`

TODO: How python will call bind/unbind.
