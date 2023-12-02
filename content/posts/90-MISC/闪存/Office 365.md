---
draft: true
categories: ["misc"]
---

# Office 365

[启动 Office 应用程序时出现 0xC0000142 错误](https://support.microsoft.com/zh-cn/office/启动-office-应用程序时出现-0xc0000142-错误-64b3a500-ee74-4b66-b370-9d607ef92b6c)

# 启动 Excel 提示“操作系统当前的配置不能运行此应用程序”

[(218条消息) excel一直显示“操作系统当前的配置不能运行此应用程序”_操作系统当前的配置不能运行excel_Ciito的博客-CSDN博客](https://blog.csdn.net/weixin_45672928/article/details/116951908): <https://blog.csdn.net/weixin_45672928/article/details/116951908>

改过注册表的系统一般是因为 `xllex.dll` 找不到。从 office 安装目录找到对应的 `dll` 文件复制到安装位置的根目录下即可（例如：`C:\Program Files\Microsoft Office\root\Office16\1033\XLLEX.DLL`）。

# 启动 Office 应用程序时出现 0xC0000142 错误

启动 Office 应用程序时可能会看到 Error 0xC0000142 错误。若要解决此问题，请尝试以下解决方案。我们首先列出了最常见的解决方案，因此请按照列出的步骤依次进行尝试。

## 解决方案 1 - 更新 Office

确保 Office 已更新到版本 2102（内部版本 13801.20808）或更高版本。如果未设置自动更新，请执行以下操作：

**注意:** 如果你的 IT 管理员管理 Office 更新，你可能无法执行以下步骤。请与管理员联系以获取有关此错误的帮助。如果你是管理员并且需要帮助管理组织中的更新，请参阅 [选择如何管理更新](https://docs.microsoft.com/deployoffice/plan-microsoft-365-apps#step-2---choose-how-to-manage-updates)。

1. 在任务栏上的搜索框中，键入 **任务计划程序**。
2. 展开“**任务计划程序库**”，然后选择“**Microsoft**”>“**Office**”。
3. 在中间窗口中，查找 **Office 自动更新 2.0**。右键单击它，然后选择“**运行**”。

如果以这种方式更新 Office 不起作用，请尝试以下其他选项。

## 解决方案 2 - 从控制面板修复 Office

操作系统决定了修复工具的获取方式。从下面的下拉列表中选择操作系统。

[选择操作系统](javascript:)

## 解决方案 3 - 运行 Windows 更新

检查是否正在运行最新版本的 Windows 10。请参阅 [Windows 10 更新](https://support.microsoft.com/zh-cn/windows/更新-windows-3c5ae7fc-9fb6-9af1-1984-b5e0412c556a)。

## 解决方案 4 - 确保 Office 软件保护平台正在运行

1. 在 Windows 10 的搜索栏中键入“**服务**”并打开应用。
2. 在“服务”列表中查找名为“**Office 软件保护平台**”的服务，右键单击并选择“**属性**”。

   **注意:** 如果列表未显示“Office 软件保护平台”，则代表你正在使用不使用此服务的较新版本 Office。请继续执行下一个建议。

3. 确认启动类型已设置为“**自动**”，**服务状态** 已设置为“**正在运行**”。
4. 如果 **服务状态** 显示为“**已停止**”，请选择“**启动**”以启动服务。

## 解决方案 5 - 卸载并重新安装 Office

如果上述解决方案未解决此问题，则可能需要完全卸载然后重新安装 Office。请按照下列步骤操作。

**提示:** 卸载 Office 只会从计算机中删除 Office 应用程序，不会删除使用应用创建的任何文件、文档或工作簿。

1. 选择以下按钮，下载并安装 Office 卸载支持工具。

   [下载](https://aka.ms/SaRA-officeUninstallFromPC)

2. 按照以下步骤下载对应于你的浏览器的卸载支持工具。

   **提示:** 该工具可能需要几分钟才能下载并安装。完成安装后，会打开卸载 Office 产品窗口。

   **Microsoft Edge 或 Chrome**

   - 在左下角，右键单击“**SetupProd_OffScrub.exe**”>“**打开**”。

   **MIcrosoft Edge（之前版本）或 Internet Explorer**

   - 在浏览器窗口底部，选择“**运行**”以启动 **SetupProd_OffScrub.exe**。

   **Firefox**

   - 在弹出窗口，选择“**保存文件**”，然后在浏览器窗口的右上角，选择“下载”箭头 > **SetupProd_OffScrub.exe**。

3. 选择要卸载的版本，然后选择“下一步”。
4. 执行剩余屏幕上的操作，在出现提示时，重启计算机。

   重启计算机后，卸载工具会自动重新打开以完成卸载过程的最后一步。按照剩余提示操作。

5. 选择要安装或重新安装的 Office 版本的步骤。关闭卸载工具。

   [Microsoft 365](https://support.office.com/article/4414eaaf-0478-48be-9c42-23adc4716658?wt.mc_id=UninstallPC_262f265f-4c5e-4c46-852f-2a3890829d34) | [Office 2021](https://support.office.com/article/4414eaaf-0478-48be-9c42-23adc4716658?wt.mc_id=UninstallPC_262f265f-4c5e-4c46-852f-2a3890829d34) | [Office 2019](https://support.office.com/article/7c695b06-6d1a-4917-809c-98ce43f86479?wt.mc_id=UninstallPC_262f265f-4c5e-4c46-852f-2a3890829d34) | [Office 2016](https://support.office.com/article/7c695b06-6d1a-4917-809c-98ce43f86479?wt.mc_id=UninstallPC_262f265f-4c5e-4c46-852f-2a3890829d34) | [Office 2013](https://support.office.com/article/7c695b06-6d1a-4917-809c-98ce43f86479?wt.mc_id=UninstallPC_262f265f-4c5e-4c46-852f-2a3890829d34) | [Office 2010](https://support.office.com/article/1b8f3c9b-bdd2-4a4f-8c88-aa756546529d?wt.mc_id=UninstallPC_262f265f-4c5e-4c46-852f-2a3890829d34) | [Office 2007](https://support.office.com/article/88a8e329-3335-4f82-abb2-ecea3e319657?wt.mc_id=SCL_UninstallPC_262f265f-4c5e-4c46-852f-2a3890829d34)

# Office 2019/365 修改默认安装路径及激活方法

## **原文：**

[Office 2019/365 修改默认安装路径及激活方法qianling.pw/office-link/](https://link.zhihu.com/?target=https%3A//qianling.pw/office-link/)

## 视频教程：

[Office 2019/365 修改默认安装路径，不改注册表！_哔哩哔哩 (゜-゜)つロ 干杯~-bilibiliwww.bilibili.com/video/av98160006/![img](img-8.jpg)](https://link.zhihu.com/?target=https%3A//www.bilibili.com/video/av98160006/)

请按正文顺序执行操作喔~

视频教程一切详细 :）

## 修改安装路径

1. 打开 `C:\Program Files`，查看是否有 `Microsoft Office` 文件夹，如有则删除；若先前已安装 Office，则将其卸载后删除该文件夹，如不重新安装直接剪切文件夹将无法使用 OneDrive 并持续报错，注：32 位系统对应目录为 `C:\Program Files (x86)`
2. 在想要存放的位置新建名为 `Microsoft Office` 的文件夹，下以 `D:\Program Files` 为例
3. 以管理员权限打开命令提示符：开始菜单 -Windows 系统 - 命令提示符 - 右键 - 更多 - 以管理员身份运行
4. 右键粘贴并回车执行这条命令 `mklink /j "C:\Program Files\Microsoft Office" "D:\Program Files\Microsoft Office"`
5. `C:\Program Files` 出现带箭头文件夹图标即成功链接文件夹
6. 注：`C:\Program Files\Microsoft Office 15` 也是安装目录，但占用空间小，可不理会，下面进入安装阶段

## 下载并安装

<https://github.com/YerongAI/Office-Tool/releases/>

**无法改变安装路径，只能安装在系统盘：**

[[ASK] 有没办法改变安装目录 · Issue #478 · YerongAI/Office-Tool](https://github.com/YerongAI/Office-Tool/issues/478)

1. 下载 Office Tool：[官方网站](https://link.zhihu.com/?target=https%3A//otp.landian.vip/)
2. 打开 Office Tool，在部署里添加产品，勾选安装设置中的［安装完成后创建桌面快捷方式］，安装方式［先下载再安装］，安装模块［Office Tool Plus］
3. 建议安装 Office 365，有零售版没有的高级功能，如设计灵感、OneDrive 自动保存
4. 下载完成后会自动安装，依正常流程安装，下面进入激活阶段

## 激活

## 激活 Office 365

1. 关闭 Window 实时保护：设置 - 更新和安全 -Windows 安全中心 - 病毒和威胁防护 -“病毒和威胁防护”设置 - 实时保护
2. 下载激活脚本：[地址](https://link.zhihu.com/?target=http%3A//t.cn/A6zjQVxL)
3. 右键以管理员身份运行脚本，连接服务器成功并激活后输入 `N` 即可

### 申请教育版 Office 365 账号

\1. 此方法可使用 365 全部功能

\2. 步骤简单，请看教程：[2分钟白嫖office365账户_哔哩哔哩 (゜-゜)つロ 干杯~-bilibili](https://link.zhihu.com/?target=https%3A//www.bilibili.com/video/av97045177)

\3. 关键词：`nCoV Office gy`

## 激活 Office 零售版

1. 使用 Office Tool 激活即可

## 思路扩展

1. 其它不支持设置安装路径的软件均可依此方法安装，知晓其默认安装路径后 卸载 - 创建文件夹链接 - 重新安装 即可。如：哔哩哔哩投稿工具、XMind ZEN
2. 很多软件的数据文件强制保存于系统盘下，打开 `C:\Users\你的名字\AppData\Local`、`C:\Users\你的名字\AppData\Roaming` 手动查看占用大小，将较大的文件夹剪切到其他位置，创建链接即可，但不可将 `Local` 或 `Roaming` 全部剪切，会造成系统问题。
3. mklink 高级应用：[使用 mklink 指令释放 C 盘空间](https://link.zhihu.com/?target=https%3A//qianling.pw/mklink)
