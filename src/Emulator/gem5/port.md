# Port Abstraction in Gem5

<div style="text-align:right; font-size:3em;">2022.07.08</div>

## Req/Resp

### Resp

```
CpuSidePort -> CacheResponsePort -> QueuedResponsePort -> ResponsePort -> Port
                                                                       -> AtomicResponseProtocol
                                                                       -> TimingResponseProtocol
                                                                       -> FunctionalResponseProtocol
```

I focus on `TimingResponseProtocol`.

Port

* reportUnbound
* getPeer
* name
* getId
* bind
* unbind
* isConnected
* takeOverFrom

TimingResponseProtocol

* snoop
  * sendSnoopReq
  * recvTimingSnoopResp
  * sendRetrySnoopResp
* normal
  * sendResp
  * tryTiming
  * recvRespRetry
  * recvTimingReq
  * sendRetryReq

ResponsePort

* snoop
  * isSnooping
  * sendAtomicSnoop
  * sendFunctionalSnoop
  * sendTimingSnoopReq
  * sendRetrySnoopResp
  * recvTimingSnoopResp
* normal
  * sendTimingResp
  * sendRetryReq
  * tryTiming
* backdoor
  * recvAtomicBackdoor
* other
  * unbind
  * bind
  * sendRangeChange
  * getAddrRanges
  * responderUnbind
  * responderBind

QueuedResponsePort

* normal
  * recvRespRetry
  * schedTimingResp
  * trySatisfyFunctional

CacheResponsePort

* block
  * isBlocked
  * clearBlocked
  * setBlocked
* normal
  * processSendRetry

CpuSidePort

* snoop
  * recvTimingSnoopResp
* normal
  * tryTiming
  * recvTimingReq
  * recvAtomic
  * recvFunctional
* other
  * getAddrRanges

```
MemSidePort -> CacheRequestPort -> QueuedRequestPort -> RequestPort -> Port
                                                                    -> AtomicRequestProtocol
                                                                    -> TimingRequestProtocol
                                                                    -> FunctionalRequestProtocol
```

Port

* reportUnbound
* getPeer
* name
* getId
* bind
* unbind
* isConnected
* takeOverFrom

TimingRequestProtocol

* snoop
  * sendSnoopResp
  * recvTimingSnoopReq
  * recvRetrySnoopResp
* normal
  * sendReq
  * trySend
  * sendRetryResp
  * recvTimingResp
  * recvReqRetry

RequestPort

* snoop
  * isSnooping
  * recvAtomicSnoop
  * recvFunctionalSnoop
  * recvTimingSnoopReq
  * recvRetrySnoopResp
  * sendTimingSnoopResp
* normal
  * sendAtomic
  * sendFunctional
  * sendTimingReq
  * tryTiming
  * sendRetryResp
* backdoor
  * sendAtomicBackdoor
* other
  * bind
  * unbind
  * getAddrRanges
  * recvRangeChange
  * printAddr

QueuedRequestPort

* snoop
  * recvRetrySnoopResp
  * schedTimingSnoopResp
* normal
  * recvReqRetry
  * schedTimingReq
  * trySatisfyFunctional

CacheRequestPort

* snoop
  * isSnooping
* schedSendEvent

MemSidePort

* snoop
  * recvTimingSnoopReq
  * recvAtomicSnoop
  * recvFunctionalSnoop
* normal
  * recvTimingResp

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
