<div style="text-align:right; font-size:3em;">2024.05.04</div>

想使用headscale-ui，发现需要网页服务的反向代理。
看了看traefik的推荐配置，竟然要编程！
看了看caddy很简单。但是配了一个下午各种问题，最后还是没配好。

我要做的事情很简单

headscale的http端口为8080，headscale-ui的http端口为10080（比如用python http server）。
我想通过网页反向代理实现80端口/地址对应8080，8？端口/web/地址对应10080。
配置了caddy半天，勉强能在127.0.0.1实现。
但是caddy死活没办法在公网ip上运行。

<div style="text-align:right; font-size:3em;">2024.05.06</div>

在hn看到了推荐traefik的帖子https://j6b72.de/article/why-you-should-take-a-look-at-traefik/
