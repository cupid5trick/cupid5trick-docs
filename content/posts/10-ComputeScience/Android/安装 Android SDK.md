# Linux 安装 Android SDK

[Linux安装Android Sdk「建议收藏」 - 腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/2108851): <https://cloud.tencent.com/developer/article/2108851>

常规思路，下载 sdk，安装之后修改环境。但是发现，网络上已经没有了 sdk 的下载资源，有的也只是很老的版本。查看 [Android开发文档——sdkmanager的使用指南](https://developer.android.google.cn/studio/command-line/sdkmanager)，发现可以使用 `sdkmanager` 这个[命令行工具](https://cloud.tencent.com/product/cli?from=20065&from_column=20065)进行下载。

在 Android 开发者文档中介绍了 sdk 这个命令行工具的功能。

`sdkmanager` 是一个命令行工具，您可以用它来查看、安装、更新和卸载 Android SDK 的软件包。如果使用 Android Studio，则无需使用此工具，而可以[从 IDE 管理 SDK 软件包](https://developer.android.google.cn/studio/intro/update?hl=zh-cn#sdk-manager)。

`sdkmanager` 工具在 [Android SDK 命令行工具](https://developer.android.google.cn/studio/command-line?hl=zh-cn#tools-sdk)软件包中提供。如需使用 SDK 管理器安装某个版本的命令行工具，请按以下步骤操作：

1.  从 [Android Studio 下载页面](https://developer.android.google.cn/studio?hl=zh-cn)中下载最新的“command line tools only”软件包，然后将其解压缩。
2.  将解压缩的 `cmdline-tools` 目录移至您选择的新目录，例如 android_sdk。这个新目录就是您的 Android SDK 目录。
3.  在解压缩的 `cmdline-tools` 目录中，创建一个名为 `latest` 的子目录。
4.  将原始 `cmdline-tools` 目录内容（包括 `lib` 目录、 `bin` 目录、 `NOTICE.txt` 文件和 `source.properties` 文件）移动到新创建的 `latest` 目录中。现在，您就可以从这个位置使用命令行工具了。
5.  （可选）如需安装旧版命令行工具，请运行以下命令：
    
    ```bash
    android_sdk/cmdline-tools/latest/bin/sdkmanager --install "cmdline-tools;version"
    
    ```
    将 `version` 替换为您要安装的版本，例如 `5.0` 。

## 用法

您可以使用 `sdkmanager` 列出已安装软件包和可用软件包、安装软件包以及更新软件包。如需了解详情，请参阅以下部分。

### 列出已安装和可用的软件包

如需列出已安装和可用的软件包，请使用以下语法：

```bash
sdkmanager --list [options] \
           [--channel=channel_id] // Channels: 0 (stable), 1 (beta), 2 (dev), or 3 (canary)

```

使用 `channel` 选项，纳入从某个渠道到 `channel_id` （含）的软件包。例如，指定 Canary 版渠道以列出所有渠道的软件包。

### 安装软件包

如需安装软件包，请使用以下语法：

```bash
sdkmanager packages [options]

```

Packages 参数是 `--list` 命令列出的 SDK 样式路径，该路径括在引号中。例如， `"build-tools;33.0.1"` 或 `"platforms;android-33"` 。

您可以传递多个软件包路径（用空格分隔），但各个路径必须括在各自的一组引号中。例如，下面展示了如何安装最新的平台工具以及适用于 API 级别 33 的 SDK 工具：

```bash
sdkmanager "platform-tools" "platforms;android-33"
```

或者，您也可以传递一个指定了所有软件包的文本文件：

```bash
sdkmanager --package_file=package_file [options]

```

Package_file 参数指定了文本文件所在的位置，该文件中的每一行都代表一个要安装的软件包的 SDK 样式路径（不带引号）。

如需卸载，请添加 `--uninstall` 标记：

```bash
sdkmanager --uninstall packages [options]
sdkmanager --uninstall --package_file=package_file [options]

```

如需安装 CMake 或 NDK，请使用以下语法：

```
sdkmanager --install           ["ndk;major.minor.build[suffix]" | "cmake;major.minor.micro.build"]           [--channel=channel_id] // NDK channels: 0 (stable), 1 (beta), or 3 (canary)
```

例如，使用以下命令安装指定 NDK 版本（无论其当前位于哪个渠道）：

```bash
sdkmanager --install "ndk;21.3.6528147" --channel=3 // Install the NDK from the canary channel (or below)sdkmanager --install "cmake;10.24988404" // Install a specific version of CMake
```

### 更新所有已安装的软件包

如需更新所有已安装的软件包，请使用以下语法：

```bash
sdkmanager --update [options]

```

### 接受许可

您必须为已安装的每个软件包接受必要的许可。当您通过 Android Studio 安装软件包时，就需要在安装过程中完成此步骤。

如果您未安装 Android Studio，或者它适用于 CI 服务器或其他未安装 GUI 的无头 Linux 设备，请在命令行中运行以下命令：

```bash
sdkmanager --licenses
```

系统会提示您接受所有尚未接受的许可。

## 选项

下表列出了上一部分中所列命令的可用选项：

| 选项                                              | 说明                                                                                                                              |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| `--sdk_root=**path**`                             | 使用指定的 SDK 路径，而不是包含此工具的 SDK。                                                                                     |
| `--channel=**channel_id**`                        | 纳入到 channel_id（含）的渠道中的软件包。可用的渠道包括： `0` （稳定版）、 `1` （Beta 版）、 `2` （开发版）和 `3` （Canary 版）。 |
| `--include_obsolete`                              | 在列出或更新软件包时纳入已过时的软件包。仅适用于 `--list` 和 `--update` 。                                                        |
| `--no_https`                                      | 强制所有连接使用 HTTP 而不是 HTTPS。                                                                                              |
| `--newer`                                         | 使用 `--list` 时，仅显示新的或可更新的软件包。                                                                                    |
| `--verbose`                                       | 详细输出模式。该模式会输出错误、警告和参考性消息。                                                                                |
| `--proxy={http | socks}`                          | 通过给定类型的代理建立连接：用 `http` 指定高层级协议（如 HTTP 或 FTP）的代理，或用 `socks` 指定 SOCKS（V4 或 V5）代理。           |
| `--proxy_host={**IP_address** | **DNS_address**}` | 要使用的代理的 IP 或 DNS 地址。                                                                                                   |
| `--proxy_port=**port_number**`                    | 要连接到的代理端口号。                                                                                                            |

# 配置环境变量

[设置环境变量 | 命令行工具](https://developer.android.google.cn/studio/command-line?hl=zh-cn#environment-variables): <https://developer.android.google.cn/studio/command-line?hl=zh-cn#environment-variables>

建议在命令行使用 android sdk 时设置环境变量。设置 `ANDROID_HOME` 指向 SDK 的安装目录，并加入系统搜索路径 （PATH）。


[环境变量  |  Android 开发者  |  Android Developers](https://developer.android.com/studio/command-line/variables?hl=zh-cn): <https://developer.android.com/studio/command-line/variables?hl=zh-cn>

```bash
export ANDROID_HOME=...
export PATH=$PATH:$ANDROID_HOME/tools/latest:$ANDROID_HOME/tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$VER
```

# Windows