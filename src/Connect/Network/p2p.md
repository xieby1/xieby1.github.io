2021.06.06：**结论**：最通用的解决办法需要用中继服务器！

<div style="text-align:right; font-size:3em;">2021.06.05</div>

* 安卓上的资源分享软件[Wikipedia: Resilio Sync](https://en.wikipedia.org/wiki/Resilio_Sync)
  * [Wikipedia: BitTorrent](https://en.wikipedia.org/wiki/BitTorrent)
    * tracker就是我一直想寻找的中间服务器[Wikipedia: BitTorrent tracker](https://en.wikipedia.org/wiki/BitTorrent_tracker)

以上都没有提到NAT问题？再次搜索，

* [Quora: How does BitTorrent deal with people behind NAT?](https://www.quora.com/How-does-BitTorrent-deal-with-people-behind-NAT)
  * [Wikipedia: STUN](https://en.wikipedia.org/wiki/STUN)，STUN不能解决所有NAT，
    * 最通用的是[Traversal Using Relay NAT](https://en.wikipedia.org/wiki/Traversal_Using_Relay_NAT) (TURN)，即需要中继！Relay！

<div style="text-align:right; font-size:3em;">2021.06.06</div>

* Github搜索p2p stream
  * [webtorrent](https://github.com/webtorrent/webtorrent)
    * 主页[webtorrent.io](https://webtorrent.io/)
    * 一个实例：[instant.io](https://instant.io/)
    * 它的[FAQ](https://webtorrent.io/faq)相当于技术简介
      * 基于[WebRTC](https://en.wikipedia.org/wiki/WebRTC)
* 搜索"webrtc need relay"
  * [TURN server | WebRTC](https://webrtc.org/getting-started/turn-server)
  * 还没仔细阅读[Why Does Your WebRTC Product Need a TURN Server?](https://www.callstats.io/blog/2017/10/26/webrtc-product-turn-server)

所以WebRTC还是需要中继！！！

