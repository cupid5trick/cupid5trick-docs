---
draft: true
categories: ["misc"]
---
## 安装激活
[sublime_text_4126_x64 激活及安装_Despareter_Yong的博客-CSDN博客](https://blog.csdn.net/qq_35361859/article/details/125565305)

[聊聊Sublime中怎么关闭自动更新（图文介绍）-sublime-PHP中文网](https://www.php.cn/tool/sublime/489206.html#:~:text=Sublime%20Text%20%E5%85%B3%E9%97%AD%E8%87%AA%E5%8A%A8%E6%9B%B4%E6%96%B0%201%E3%80%81%E6%89%93%E5%BC%80Sublime%20Text%203,%E8%BD%AF%E4%BB%B6%E4%BC%9A%E5%BC%B9%E5%87%BA%E2%80%9CUpdate%20Available%E2%80%9D%E5%AF%B9%E8%AF%9D%E6%A1%86%EF%BC%8C%E7%82%B9%E5%87%BB%E2%80%9CCancel%E2%80%9D%E6%8C%89%E9%92%AE%E5%8F%96%E6%B6%88%EF%BC%9B%202%E3%80%81%E7%82%B9%E5%87%BB%E8%8F%9C%E5%8D%95%E6%A0%8F%E2%80%9CPreferences%E2%80%9D%3D%3E%20%22Settings-User%22%20%E8%BF%9B%E5%85%A5%E4%B8%AA%E4%BA%BA%E5%8F%82%E6%95%B0%E8%AE%BE%E7%BD%AE%E9%A1%B5%E9%9D%A2%EF%BC%9B%203%E3%80%81%E8%BF%9B%E5%85%A5%E5%8F%82%E6%95%B0%E8%AE%BE%E7%BD%AE%E7%95%8C%E9%9D%A2%E5%90%8E%EF%BC%8C%E6%89%BE%E5%88%B0%E5%A4%A7%E6%8B%AC%E5%8F%B7%E2%80%9C%EF%BD%9B%EF%BD%9D%E2%80%9D%E7%9A%84%E4%BD%8D%E7%BD%AE%EF%BC%9B)

## Sublime Text 样式配置
### 字体
[哪些字体在Sublime上特别好看？ - 知乎](https://www.zhihu.com/question/31980899)
先说一下 Sublime Text 怎么设置字体：在 `Preferences/Settings`。打开以后在右侧的 JSON文件里设置 `font_face` 这一项就可以，比如 `"font_face": "Consolas"`，这就是 Sublime Text 默认的熟悉的 Consolas。
由于 Sublime Text 代码编辑器只能支持一种全局字体，在编辑中文比较多的文件时默认的 Consolas 往往很丑，为了美化代码编辑器的中文渲染同时不影响编写英文的代码，选择起来确实比较困难。

#### 混合字体
网络上有尝试混合字体的，比如 `YaHei Monaco Hybird`、`YaHei Consolas Hybird`。下载字体并设置以后看一下效果，质量确实太差了，很多字都花了。有点粗制滥造的感觉，在系统安装上字体以后显示的"Hybrid"拼写都是错的：`YaHei Monaco Hybird`。附上链接：[Tags · maxsky/Yahei-Monaco-Hybrid-Font](https://github.com/maxsky/Yahei-Monaco-Hybrid-Font)
![](image-20220725005825045.png)

#### 中文的等宽字体
换掉 `YaHei Monaco Hybird` 之后，在我积累的字体里面筛选了一下发现更纱系列有等宽字体是支持中文的，比如 `Sarasa Mono TC`。换上以后可以看到质量确实可以，虽然英文的展示有点奇怪但至少不丑不花。暂时可以用了。
更纱等宽 TC 的展示效果：`Sarasa Mono TC`
![](image-20220725010550163.png)




## Sublime Text 增效设置
### Sublime Text 快捷键设置
[sublime自定义快捷键 - 知乎](https://zhuanlan.zhihu.com/p/165975156)
简单来说就是在 `Preferences/Key Bindings` 修改快捷键的 JSON 配置文件，左边有的命令直接复制过来修改即可。如果左侧窗口没有需要的命令的话，就需要先获取到图形化界面上的操作对应什么命令名称。

首先要打开 sublime text 的控制台，可以使用快捷键 “ Ctrl + \` ” , 或者直接点击左下角的一个叫 switch panel 的小图标，然后点击 console 即可。 然后在控制台中输入命令 `sublime.log_commands(True)` 回车。从现在开始,你的所有动作的日志 (log) 都会被打印到控制台上。 此时开始使用一次translate-CN,每次操作的日志都被打印在了控制台上：

> command: drag\_select {"event": {"button": 1, "x": 221.3, "y": 284.5}} command: context\_menu {"event": {"button": 2, "x": 284.5, "y": 285.3}} command: translate\_text {"event": {"x": 284.5, "y": 285.3}}

获取到操作的命令名称以后就可以在右边设置它对应的快捷键了。
![](image-20220724215955272.png)
### 给 Sublime Text 添加右键菜单

#### 方法一（推荐）

把以下代码，复制到Sublime Text3的安装目录，然后重命名为：sublime\_addright.inf，然后右击安装就可以了。  
PS：重命名文件之前，需要先在工具–文件夹选项，查看中，把隐藏已知文件类型的扩展名前边的复选框不勾选。

```makefile
[Version]
Signature="$Windows NT$"

[DefaultInstall]
AddReg=Sublime Text3

[Sublime Text3]
hkcr,"*\\shell\\Sublime Text3",,,"用 Sublime Text3 打开"
hkcr,"*\\shell\\Sublime Text3\\command",,,"""%1%\sublime_text.exe"" ""%%1"" %%*"
hkcr,"Directory\shell\Sublime Text3",,,"用 Sublime Text3 打开"
hkcr,"*\\shell\\Sublime Text3","Icon",0x20000,"%1%\sublime_text.exe, 0"
hkcr,"Directory\shell\Sublime Text3\command",,,"""%1%\sublime_text.exe"" ""%%1"""
```

#### 方法二

把以下代码，复制到Sublime Text3的安装目录，然后重命名为：sublime\_addright.reg，然后双击就可以了。

PS:需要把里边的Sublime的安装目录，替换成实际的Sublime安装目录。

```INF
Windows Registry Editor Version 5.00
[HKEY_CLASSES_ROOT\*\shell\Sublime Text3]@="用 Sublime Text3 打开"
"Icon"="D:\\Program Files\\Sublime Text 3\\sublime_text.exe,0"

[HKEY_CLASSES_ROOT\*\shell\Sublime Text3\command]@="D:\\Program Files\\Sublime Text 3\\sublime_text.exe %1"

[HKEY_CLASSES_ROOT\Directory\shell\Sublime Text3]@="用 Sublime Text3 打开"
"Icon"="D:\\Program Files\\Sublime Text 3\\sublime_text.exe,0"

[HKEY_CLASSES_ROOT\Directory\shell\Sublime Text3\command]@="D:\\Program Files\\Sublime Text 3\\sublime_text.exe %1"
```

最后，附一个删除右键菜单的脚本。

把以下代码，复制到Sublime Text3的安装目录，然后重命名为：sublime\_delright.reg，然后双击就可以。

```INF
Windows Registry Editor Version 5.00
[-HKEY_CLASSES_ROOT\*\shell\Sublime Text3][-HKEY_CLASSES_ROOT\Directory\shell\Sublime Text3]
```
## 行为配置
### 显示隐藏文件和文件夹
[macos - Show hidden folders in sublime text? (Mac osx) - Stack Overflow](https://stackoverflow.com/questions/16640097/show-hidden-folders-in-sublime-text-mac-osx)
## Sublime Text 插件
### 编程语言
[Markdown Extended - Packages - Package Control](https://packagecontrol.io/packages/Markdown%20Extended)
[Nodejs - Packages - Package Control](https://packagecontrol.io/packages/Nodejs)
[Javatar - Packages - Package Control](https://packagecontrol.io/packages/Javatar)
提供 WIndows 系统中 INI 和 注册表文件的语法高亮
[INI](https://packagecontrol.io/packages/INI)
[JSX](https://packagecontrol.io/packages/JSX)
[PowerShell](https://packagecontrol.io/packages/PowerShell)
[Python 3](https://packagecontrol.io/packages/Python%203)

### 文本编辑

[absop/ST-ChineseTokenizer: Sublime Text 3 的 jieba 分词库绑定，支持对中文更精确地选词、删词和按词移动光标](https://github.com/absop/ST-ChineseTokenizer): <https://github.com/absop/ST-ChineseTokenizer>
Sublime Text 3 的 jieba 分词库绑定，支持对中文更精确地选词、删词和按词移动光标。

### VCS
[Git](https://packagecontrol.io/packages/Git)
[GitGutter](https://packagecontrol.io/packages/GitGutter)

### 语言提示
-   SublimeLinter settings: [http://sublimelinter.com/en/latest/settings.html](http://sublimelinter.com/en/latest/settings.html)
-   Linter settings: [http://sublimelinter.com/en/latest/linter\_settings.html](http://sublimelinter.com/en/latest/linter_settings.html)

[EditorConfig - Packages - Package Control](https://packagecontrol.io/packages/EditorConfig)
[ESLint - Packages - Package Control](https://packagecontrol.io/packages/ESLint)
[SublimeLinter-csslint](https://packagecontrol.io/packages/SublimeLinter-csslint)
[SublimeLinter-eslint](https://packagecontrol.io/packages/SublimeLinter-eslint)
[SublimeLinter-jshint](https://packagecontrol.io/packages/SublimeLinter-jshint)
[SublimeLinter-php](https://packagecontrol.io/packages/SublimeLinter-php)
[LESS](https://packagecontrol.io/packages/LESS)
[React Templates](https://packagecontrol.io/packages/React%20Templates)
[Sass](https://packagecontrol.io/packages/Sass)
[SCSS](https://packagecontrol.io/packages/SCSS)
[TypeScript](https://packagecontrol.io/packages/TypeScript)
[Emmet](https://packagecontrol.io/packages/Emmet)


### 文档化
[DocBlockr - Packages - Package Control](https://packagecontrol.io/packages/DocBlockr)


### 主题
[Materialize - Packages - Package Control](https://packagecontrol.io/packages/Materialize)
[Material Theme](https://packagecontrol.io/packages/Material%20Theme)

### Language Server Protocol
[Language Server Protocol - Wikipedia](https://en.wikipedia.org/wiki/Language_Server_Protocol)