<div style="text-align:right; font-size:3em;">2023.10.30</div>

Paperless-ngx更适合管理没有层次结构的文档

consume文件夹会删除仍进去的文件

参考[Reddit: Paperless-ngx is not what I thought it was.](https://www.reddit.com/r/selfhosted/comments/vxqvh9/paperlessngx_is_not_what_i_thought_it_was/)

> Paperless is meant to take input from a scanner.
>
> You feed it documents that were paper at some point (the consume folder is meant to be where your scanner dumps pdfs). Paperless OCRs, indexes, and scuttles it away. If you need it later you use search and don't care about folders anymore.

可用NixOS配置

```nix
services.paperless = {
  enable = true;
  passwordFile = /home/xieby1/Gist/Config/passwordFile;
};
```
