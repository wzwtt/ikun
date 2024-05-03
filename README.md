# 欢迎各位 IKUN ！
这里收集各种 IKUN 专属表情包，耗费时长两年半。欢迎各位真爱粉（不欢迎小黑子）自取，更欢迎各位贡献自己所收集或制作的 IKUN 表情包。感谢制作这些表情包的**全民制作人**。

[IKUN 表情包一览](https://ikun.wzwtt.cf)（目前仅提供静态图片的预览）

**注意：这里出现的各种图片名称文字仅作为谐音梗使用，在其他场合请使用规范汉字书写。**

如果您的 GitHub 无法打开、加载缓慢或无法显示图片，建议使用 [Watt Toolkit](https://github.com/BeyondDimension/SteamTools) 工具加速访问。使用 [Github 镜像站](https://github.ttmirrors.eu.org/wzwtt/ikun)或 [Gitee](https://gitee.com/wzwtt/ikun) 也可查看本项目。

## 目录说明
still —— 静态表情包

gif —— 动态表情包

head_portrait —— 头像

help —— 帮助文档

## 贡献
没错，您已经踏上了成为一名资深 IKUN 的旅程。

我们深知，个人收集的能力是有限的，但社区的力量是无限的，因此，我希望该项目能由社区驱动。您可以为历史上数量最多、使用量最大的表情包系列贡献一份力量。非常欢迎各位 IKUN 贡献自己在任何平台所收集的 IKUN 表情包。

当然，若您有更好的点子或者一些疑问，欢迎提 [Issues](https://github.com/wzwtt/ikun/issues) ；若您需要讨论，请到 [Discussions](https://github.com/wzwtt/ikun/discussions) ；若您有开发能力，欢迎贡献！

每个人的力量都很重要。如果这是您第一次参与开源社区，请查阅有关资料，了解如何为开源社区贡献您的力量。我们深知略显复杂的操作可能会给作为入门者的您带来重重困难。尽管道路崎岖，但我们坚信有关详细的资料以及您对咯咯的爱，一定会为您扫除一切障碍。

[Github 镜像站](https://github.ttmirrors.eu.org/wzwtt/ikun)和 [Gitee](https://gitee.com/wzwtt/ikun) 仅作镜像使用，请务必在 [Github](https://github.com/wzwtt/ikun) 上提交贡献。

建议使用 Git 版本控制工具上传并提交 Pull requests 。

**注意：在上传前请检查您所贡献的表情包是否他人未曾上传过，确认文件是否根据[命名规则](/help/name_rules.md)正确命名并且已经放置在正确的分类文件夹内。**

让我们一起创造历史。

### 文档
#### [如何导出表情包](/help/export.md)

### 鸣谢
[xipulasiCPLUS](https://github.com/xipulasiCPLUS) 和 [ThreeManager785](https://github.com/ThreeManager785) 的 ikun 军火库为本图库提供了大量的表情包，在此表示感谢！

## 构建
gallery.sh 脚本用于构建 IKUN 相册网页。[这是由 GitHub Actions 自动构建的 Demo](https://ikun.wzwtt.cf/) 。以下示例命令为在 Ubuntu 下构建本地 IKUN 相册网页。

```bash
sudo apt install imagemagick jhead git
git clone https://github.com/wzwtt/ikun.git
cd ikun
bash gallery.sh
```

输出的网页文件将保存在与 ikun 目录同级的 output 目录中。

## 说明
本项目中所收录的表情包均为各全民制作人网友制作，表情包图片中的所有信息（如水印等）均原版保留。如果您发现这里收录了您的作品，但您不希望它被收录的，请发 Pull requests 说明并删除。

仓库中 gallery.sh 文件源代码修改自 [gallery_shell](https://github.com/Cyclenerd/gallery_shell) 项目，按照 [gallery_shell](https://github.com/Cyclenerd/gallery_shell) 的开源许可证要求，本项目遵循 GNU General Public License v3.0 协议。

