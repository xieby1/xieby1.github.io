<div style="text-align:right; font-size:3em;">2020.11.02</div>

## 安装

参考anbox的git仓库`docs/install.md`。

<div style="text-align:right; font-size:3em;">2020.11.03</div>

## 跨平台

houdini，intel做的将安卓ARM原生库在x86上运行的翻译层。

参考龙芯2015年硕士毕业的学长王振华，写基于双TLB的二进制翻译访存加速（A Dual-TLB Method to Accelerate the Memory Access of Binary Translation），写的[二进制翻译的漫谈](https://jackwish.net/2019/revisiting-vitrual-machine-and-dynamic-compiling.html#%E6%BC%AB%E8%B0%88)，引用部分关于houdini的如下，

> 离开学校后我加入了 Intel 亚太研发中心的 BiTS (Binary Translation Software，后更名为 Machine Learning and Translation) 项目组，参与了 [Houdini](https://www.networkworld.com/article/2360304/opensource-subnet/intel-confronts-a-big-mobile-challenge-native-compatibility.html) 项目。Houdini 是 Intel 研发的用于 Android 设备的虚拟机，它使得基于 ARM 的 Android 应用能在 Intel 设备（如 [Nexus Player](https://en.wikipedia.org/wiki/Nexus_Player) 和 [Chromebook](https://www.chromium.org/chromium-os/chrome-os-systems-supporting-android-apps)）上流畅运行。作为 *Intel + Android* 的核心技术，Houdini 已广泛应用于[移动设备](https://en.wikipedia.org/wiki/Asus_ZenFone#Second_generation_(2015))、[桌面](https://www.chromium.org/chromium-os/chrome-os-systems-supporting-android-apps)和[云计算](https://variety.com/2019/gaming/news/tencent-instant-play-cloud-gaming-service-1203150763/)等领域。NativeBridge 是 Intel 和 Google 一道设计的在 Android 中支持多种 ISA 的平台型技术（听说龙芯也在基于 NativeBridge 做相关工作）。

知乎也有相关讨论：[Intel Houdini 比 QEMU 快在哪里？](https://www.zhihu.com/question/48522805)。