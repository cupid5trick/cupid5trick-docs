# 参考链接

[The OpenJDK Developers' Guide – OpenJDK Developers’ Guide](https://openjdk.org/guide/#): <https://openjdk.org/guide/#>

[Building the JDK | OpenJDK Developers’ Guide](https://openjdk.org/guide/#building-the-jdk): <https://openjdk.org/guide/#building-the-jdk>

[Building the JDK](https://openjdk.org/groups/build/doc/building.html): <https://openjdk.org/groups/build/doc/building.html>

# 了解编译过程

编译 jdk 是一个十分复杂的过程。构建 JDK 时需要用到 make 命令，还有一些其他的工具，都必须在编译之前提前安装好。

**增量编译**

JDK 支持 “增量编译”，也就是说：如果之前已经完整编译成功一次 JDK，之后如果只是对 JDK 的一小部分做了改动（例如修改了某一个模块，或者 JVM 的部分代码），那么只有修改的部分需要重新编译。因此，后续的编译过程会加快，而且你总能够利用一个 make target 来编译出完整的 JDK 镜像，而不需要担心每次都编译整个 JDK 的代码。但是，需要注意 JDK 的增量编译有一些限制，并不总能够准确理解程序员对代码做了哪些改动。所以，如果你修改了一些可能被其他 JDK 的其他部分隐式依赖的模块代码，make 程序可能并不能准确地知道。这种情况下就需要重新编译多个模块，或者稳妥起见：重新编译 JDK 的所有代码。

下面有几个例子来简要说明构建 JDK 源码的步骤。参考[克隆 JDK 源码](https://openjdk.org/guide/#cloning-the-jdk) 这一章来了解下载 JDK 源码的方式。除此之外需要着重记住一点，JDK 编译过程中需要用到低版本的 JDK 来编译 java 代码，需要安装低一版本的 JDK。例如，编译 JDK17 就需要提前准备好 JDK16 的开发环境。

## 编译配置项

JDK 的编译系统十分灵活，可配置项很多。这里只给出最基本的配置项：

- `--with-boot-jdk` : 设置编译 Java 类库所用的 JDK 路径，boot-jdk 的版本必须比要编译的 JDK 低一个版本。例如编译 JDK17 就设置 boot-jdk 为 JDK16 所在的路径。
- `--with-debug-level` : 设置 JVM/JDK 的 debug-level，可配置的调试级别有 `release`， `fastdebug`， `slowdebug`， `optimized`。

## Make Targets

通过上面例子中用到的 `make images` 命令，构建出的 JDK 是和我们平常从 JDK 发布页面下载到的 JDK 最为接近。除此之外还有其他几种 make targets 可供选择，这取决于想要编译出什么样的目标产物。下表包括了一些比较常用的 make targets。

| make tagets      | 编译动作                                                                                                                                                                                                                                                                                   |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `exploded-image` | 当不加参数地调用 make 命令时，采用的默认 make target                                                                                                                                                                                                                                       |
| `image`          | 完整编译 JDK 的所有组件。如果想要编译通用性的 JDK，或者想在和发布版相近的 JDK 配置下做一些测试，最好选择 image 作为 make target。如果做一些可能有构建方面的事情，这也是一个很好的目标。（This can also be a good target to use if doing something which might have a build aspect to it.） |
| `<name>-image`   | 仅构建 JDK 某一部分组件的镜像。包括 jdk, test, docs, symbols 等。                                                                                                                                                                                                                          |
| `reconfigure`    | 再次运行和上次编译相同参数的配置脚本。                                                                                                                                                                                                                                                     |
| `demos`          | 构建演示代码，例如帮助测试 UI 相关功能的代码。                                                                                                                                                                                                                                             |
| `docs`           | 构建 javadoc。注意该编译过程中会生成很多 javadoc API 相关的类，所以 `make docs` 并不等价于调用一次 javadoc，生成的构建产物取决于具体的构建状态。                                                                                                                                           |
| `java.base`      | 构建 Java 源码的基本模块。可以通过 `make <module>` 单独构建任意模块的源码。                                                                                                                                                                                                                |
| `hotspot`        | 构建 hotspot 虚拟机。由于虚拟机也依赖 JDK 的其他部分，所以 `hotspot` 的构建产物并不只会包括 JVM。具体的构建产物取决于当时的构建配置。                                                                                                                                                      |
| `clean`          | 删除除 `configure` 命令所产生文件之外的，由 `make` 命令生成的所有文件。如果进行了大量重命名和代码修改操作，这时候 `make clean` 就很有用。也可以通过 `make clean-<module>` 指令，仅删除某个模块的历史构建产物。                                                                             |
| `dist-clean`     | 删除构建过程中生成的所有文件，包括 `configure` 命令所产生的所有文件都会被删除。                                                                                                                                                                                                            |

除去表中所列之外，还有很多 make targets。可以查阅 `make help` 了解。

# 构建 JDK 的前置条件

JDK 是个极其庞大的项目。要完成编译过程乃至在比较合理的时间限制内完成编译，需要配置性能较高的物理机器。

## 参考链接

- [Build Hardware Requirements](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#build-hardware-requirements)
    - [Building on x86](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#building-on-x86)
     - [Building on aarch64](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#building-on-aarch64)
     - [Building on 32-bit arm](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#building-on-32-bit-arm)
- [Operating System Requirements](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#operating-system-requirements)
    - [Windows](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#windows)
     - [macOS](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#macos)
     - [Linux](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#linux)
     - [AIX](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#aix)
- [Native Compiler (Toolchain) Requirements](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#native-compiler-toolchain-requirements)
    - [gcc](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#gcc)
     - [clang](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#clang)
     - [Apple Xcode](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#apple-xcode)
     - [Microsoft Visual Studio](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#microsoft-visual-studio)
     - [IBM XL C/C++](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#ibm-xl-cc)
- [Boot JDK Requirements](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#boot-jdk-requirements)
    - [Getting JDK binaries](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#getting-jdk-binaries)
- [External Library Requirements](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#external-library-requirements)
    - [FreeType](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#freetype)
     - [CUPS](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#cups)
     - [X11](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#x11)
     - [ALSA](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#alsa)
     - [libffi](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#libffi)
- [Build Tools Requirements](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#build-tools-requirements)
    - [Autoconf](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#autoconf)
     - [GNU Make](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#gnu-make)
     - [GNU Bash](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#gnu-bash)

## 硬件要求

### X64 机器

至少要有 2-4 CPU 核心，以及 2-4GB 内存，核心数越大所需的内存就越多。要求至少有 6GB 以上的磁盘空间可用。

即使在编译 32 位 JDK 镜像时，同样推荐使用 64 位机器，只需在编译的 make 命令加一个 `--with-target-bits=32` 即可。

### Aarch64 机器

要求至少有 6 核心 CPU，以及 8GB 内存，核心数越大所需的内存就越多。要求至少有 6GB 以上的磁盘空间可用。

如果没有足够高性能的硬件可用，也可以通过[交叉编译](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#cross-compiling) 在其他平台上编译 aarch64 架构的 JDK。

### Arm32 机器

不推荐使用 arm32 架构的机器编译 JDK。需要[交叉编译](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#cross-compiling)。

### 关于分支保护

如果要使用虚拟机的分支保护特性，要在 `make` 命令中加上 `--enable-branch-protection` 标志。该选项对 C++编译器的版本有要求：GCC 9.1.0+ or Clang 10+。开启分支保护后，不论硬件是否支持分支保护，JDK 都能在相应的硬件平台上正常运行。但只有 Linux 平台的 JDK 支持分支保护。

## 操作系统要求

JDK 主线项目支持 Linux、macOS、windows 和 AIX 操作系统。对 BSD 之类其他操作系统的支持在单独的移植版 (port) 项目中提供。

总体来说 JDK 能够支持大部分主流操作系统。但如果你非要使用日度更新的 JDK 源码来做测试，那难免会遇到问题。

下表列出了 Oracle 用来编译 JDK 的操作系统版本。这类信息难以保证不会变化，不过在手册撰写之时是最新的。

The double version numbers for Linux are due to the hybrid model used at Oracle, where header files and external libraries from an older version are used when building on a more modern version of the OS.

The Build Group has a wiki page with [Supported Build Platforms](https://wiki.openjdk.org/display/Build/Supported+Build+Platforms). From time to time, this is updated by contributors to list successes or failures of building on different platforms.

### Windows 系统

JDK 不支持在 windows XP 系统上编译，但 XP 之后的 Windows 操作系统大抵都能够成功编译 JDK。

在 Windows 平台上编译 JDK 时，要特别注意 [Special Considerations](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#special-considerations) 所提到的内容，建议仔细阅读。

Windows 是 JDK 所支持的操作系统中唯一一个非 POSIX api 的操作系统，正因如此，需要格外注意一些额外工作：在 Windows 系统上安装一层 POSIX api 支持。目前，具有这种功能的软件只有 Cygwin，WSL 和 MSYS2。（MSYS 由于 bash 程序过时已经不再支持 POSIX；尽管 JDK 也能在 MSYS2 上编译，但仍属于试验特性，因此编译失败或者不明错误并不少见。）

在支持 POSIX api 的编译系统内部，所有路径表示都采用 Unix 风格，例如代表 `C:\git\jdk\Makefile` 的路径应该是 `/cygdrive/c/git/jdk/Makefile` （假设使用 Cygwin）。这种规则对编译系统的输入同样适用，比如 `configure` 命令的参数。所以正确的参数应当是 `--with-msvcr-dll=/cygdrive/c/msvcr100.dll` ，不是 `--with-msvcr-dll=c:\msvcr100.dll` 。要详细了解这种惯例，参考 [Fixpath](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#fixpath)。

#### Cygwin

#### Linux 子系统 （WSL）

### MacOS

### Linux

在 Linux 系统上编译 JDK 通常没有那么多问题。唯一一条通用的建议是使用操作系统相应分发版的编译器、外部库和头文件。

基本工具通常都已经包括在操作系统中，不过你也很可能需要安装一些开发者软件包。

For apt-based distributions (Debian, Ubuntu, etc), try this:

```bash
sudo apt-get install build-essential
```

For rpm-based distributions (Fedora, Red Hat, etc), try this:

```bash
sudo yum groupinstall "Development Tools"
```

For Alpine Linux, aside from basic tooling, install the GNU versions of some programs:

```bash
sudo apk add build-base bash grep zip
```

### AIX

参考 OpenJDK 构建的 wiki 页面 [Supported Build Platforms](https://wiki.openjdk.org/display/Build/Supported+Build+Platforms) 中 AIX 系统所在的章节详细了解受支持的 AIX 操作系统。

## 本地编译工具链

JDK 的一大部分都由本地代码构成，必须编译成机器代码才能在目标平台上运行。理论上编译工具链和操作系统是两个独立的因素，但实践中两者或多或少存在一些相关性。目前已经有工作致力于解耦编译工具和操作系统之间的绑定（参考 [JDK-8288293](https://bugs.openjdk.org/browse/JDK-8288293)），但要实现这个目标还有很长的路要走。

| 操作系统 | 支持的编译工具            |
| -------- | ------------------------- |
| Linux    | gcc, clang                |
| macOS    | Apple Xcode (using clang) |
| AIX      | IBM XL C/C++              |
| Windows  | Microsoft Visual Studio   |

参考每个工具的专门章节了解其版本建议。下面给出的是截至手册撰写之时， Oracle 每日构建版 JDK 所用的编译器版本。这些版本作为参考即可，使用较新或较老版本的编译器都能编译 JDK。不过拟采用的编译器版本和下述列表越接近，编译时遇到未知问题的概率就越小。

| 操作系统 | 编译工具版本                               |
| -------- | ------------------------------------------ |
| Linux    | gcc 11.2.0                                 |
| macOS    | Apple Xcode 10.1 (using clang 10.0.0)      |
| Windows  | Microsoft Visual Studio 2022 update 17.1.0 |

所有编译器都必须能支持 C99 语言标准，因为 JDK 源代码中使用了一些 C99 语言特性。

Microsoft Visual Studio doesn't fully support C99 so in practice shared code is limited to using C99 features that it does support.

### Gcc

### Clang

### MacOS Xcode

### Microsoft Visual Studio

### IBM XL C/C++

## 引导 JDK

## 外部依赖库

- **FreeType** ([The FreeType Project](http://www.freetype.org/)): FreeType2 from The FreeType Project is not required on any platform. The exception is **on Unix-based platforms when configuring such that the build artifacts will reference a system installed library**, rather than bundling the JDK's own copy.
- **Fontconfig** ([freedesktop.org Fontconfig](http://fontconfig.org/)): 除 windows 和 macOS之外的平台都需要
- **CUPS** ([Common Unix Printing System](http://www.cups.org/)): CUPS header files are required on all platforms, except Windows. Often these files are provided by your operating system
- **X11**: Certain X11 libraries and include files are required on Linux.
- **ALSA** ([Advanced Linux Sound Architecture](https://www.alsa-project.org/)): ALSA is required on Linux. At least version 0.9.1 of ALSA is required.
- **libffi** ([Portable Foreign Function Interface Library](http://sourceware.org/libffi)): libffi is required when building the Zero version of Hotspot.

**apt-based Linux**

```bash
apt-get install -y libfreetype6-dev libfontconfig-dev libcups2-dev libx11-dev libxext-dev libxrender-dev libxrandr-dev libxtst-dev libxt-dev libasound2-dev libffi-dev
```

**rpm-based Linux**

```bash
yum install -y freetype-devel fontconfig-devel cups-devel libXtst-devel libXt-devel libXrender-devel libXrandr-devel libXi-devel alsa-lib-devel libffi-devel
```

**alpine Linux**

```bash
# 好像不能通过 apk 直接安装 fontconfig
apk add freetype-dev cups-dev libx11-dev libxext-dev libxrender-dev libxrandr-dev libxtst-dev libxt-dev alsa-lib-dev libffi-dev
```

**macOS**

```bash
# macOS 不需要安装 fontconfig x11 alsa, cups 系统自带, libffi 不清楚
brew install freetype 
```

## 其他编译工具

- **Autoconf**: The JDK requires Autoconf on **all platforms**. At least version 2.69 is required.
- **GNU Make**: No other flavors of make are supported. At least version 3.81 of GNU Make must be used. For distributions supporting GNU Make 4.0 or above, we strongly recommend it. GNU Make 4.0 contains useful functionality to handle parallel building (supported by `--with-output-sync`) and speed and stability improvements.
- **GNU Bash**: The JDK requires GNU Bash. No other shells are supported. At least version 3.2 of GNU Bash must be used.

## 关于交叉编译

### 参考链接

- [Cross-compiling](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#cross-compiling)
    - [Cross compiling the easy way with OpenJDK devkits](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#cross-compiling-the-easy-way-with-openjdk-devkits)
     - [Boot JDK and Build JDK](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#boot-jdk-and-build-jdk)
     - [Specifying the Target Platform](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#specifying-the-target-platform)
     - [Toolchain Considerations](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#toolchain-considerations)
     - [Native Libraries](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#native-libraries)
     - [Cross compiling with Debian sysroots](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#cross-compiling-with-debian-sysroots)
     - [Building for ARM/aarch64](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#building-for-armaarch64)
     - [Building for musl](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#building-for-musl)
     - [Verifying the Build](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#verifying-the-build)

# Configure 选项

`configure [options]` 命令会创建一个包含编译配置的路径，并准备好存放构建产物的位置。该目录通常类似于 `build/linux-x64-server-release`，实际产生的目录名称取决于具体的编译配置。也可以直接设置该目录的路径，查看[Using Multiple Configurations](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#using-multiple-configurations) 了解详情。

[Common Configure Arguments](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#common-configure-arguments)

[Configure Control Variables](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#configure-control-variables)

# Make 过程

[Running Make](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#running-make)

# Reproducible Builds

[Reproducible Builds](https://htmlpreview.github.io/?https://raw.githubusercontent.com/openjdk/jdk/master/doc/building.html#reproducible-builds)
