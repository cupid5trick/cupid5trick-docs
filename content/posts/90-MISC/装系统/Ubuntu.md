配置 GNOME 扩展

gnome shell integration: <https://wiki.gnome.org/action/show/Projects/GnomeShellIntegration/Installation>

gnome browser extension: Chrome 插件商店

# 基本工具

## 输入法

### 百度输入法

8/23/2023

百度Linux输入法-支持全拼、双拼、五笔: <https://srf.baidu.com/site/guanwang_linux/index.html>

apt - qt5-default not in Ubuntu 21.04 - Ask Ubuntu: <https://askubuntu.com/questions/1335184/qt5-default-not-in-ubuntu-21-04>

按照百度输入法官网下载的压缩包中，附带的 docx 安装手册操作即可。

一定要安装好 qt，否则输入法候选词和录入的字都是乱码：

```bash
apt install -y qt5-default qtcreator qml-module-qtquick-controls2
```

**问题解决**

No candidate version found for qt5-default:

apt - qt5-default not in Ubuntu 21.04 - Ask Ubuntu: <https://askubuntu.com/questions/1335184/qt5-default-not-in-ubuntu-21-04>

## 终端设置

8/24/2023

如何更改 Ubuntu 的终端的颜色-腾讯云开发者社区-腾讯云: <https://cloud.tencent.com/developer/article/1898006>

# 社交软件

## 微信

8/23/2023

Ubuntu22.04 下使用wine 安装微信 - 掘金: <https://juejin.cn/post/7159597506567864327>

注意创建 win32 架构的 wine 环境，下载 32 位的微信安装包。

win64 架构的微信还没有尝试成功。

## QQ

# 内核

8/23/2023

Linux | UBuntu22.04编译内核 - 掘金: <https://juejin.cn/post/7245668131011838011>
