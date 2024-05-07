<div style="text-align:right; font-size:3em;">2023.11.20</div>

## Q: 分离式前端？

THZ：分支预测与ICache是否分离。
是否分离主要看：跳转密度和指令是否变长。
现在X86是分离式，M1是非分离式。
用microbench可以测，看大连连续的跳转指令是否会误预测，会则分离，否则非分离。
