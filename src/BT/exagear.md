<div style="text-align:right; font-size:3em;">2021.07.26</div>

https://support.huaweicloud.com/ug-exagear-kunpengdevps/kunpengexagear_06_0005.html

华为确实有意识到4KB页问题。

> 1. 只支持Linux on x86应用，不支持Windows应用，不支持Linux 驱动、虚拟化平台等内核程序的翻译。
> 2. 支持x86通用指令和SSE、AVX扩展指令，不支持AVX-2和AVX 512指令。
> 3. 当前只支持CentOS 7、CentOS 8、Ubuntu18、Ubuntu20、OpenEuler 20.03。
> 4. x87（浮点）80位精度支持受限。
> 5. Linux on x86应用，在运行时涉及的文件或文件夹的绝对路径的字符串长度不大于4KB。
> 6. **在64KB page size的Linux系统上，部分Linux on x86应用可能存在4KB page size的兼容性问题。**
> 7. 不支持ExaGear for Server 和ExaGear for Docker同时部署在同一台机器上。

<div style="text-align:right; font-size:3em;">2021.06.17</div>

大概是exagear的官方发声平台，是4pda论坛的一个帖子https://4pda.to/forum/index.php?showtopic=992239

原文

> Начало проекта было положено *22 марта 2014* компанией Eltechs, основанной *17 февраля 2012* года, когда в Google Play был выпущено приложение *Heroes 3 Runner*, который впоследствии был доработан и перерос в *ExaGear Strategies*. За время разработки программа претерпела множество изменений и обзавелась поддержкой сотен олдскульных игр. *28 февраля 2019* проект был заморожен и вновь возобновлен *01 октября 2020* уже под маркой Huawei.

谷歌翻译

> 该项目由 Eltechs 于*2014 年 3 月 22 日*启动，成立*于 2012 年 2 月 17 日*，当时*Heroes 3 Runner*应用程序在 Google Play 上发布，后来被完善并发展为*ExaGear Strategies*。在开发过程中，该程序经历了许多变化，并获得了数百款老式游戏的支持。*2019 年 2 月 28 日，该*项目被冻结，并于*2020*年*10 月 1 日*恢复已经在华为品牌下。

应该是一个高效的二进制翻译器+WINE。华为拿去用之后，目前只使用了二进制翻译器部分。

知乎找到了这个：

https://news.ycombinator.com/item?id=25749490