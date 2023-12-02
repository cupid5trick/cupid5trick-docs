---
title: Templater
author: cupid5trick
created: 2023-01-16 14:44
tags: 
- obsidian
- templater
categories: 
access: private
draft: true
lang:
- zh-cn
- en-us
abstract:
keywords:
---


# `Templater`
[Introduction - Templater](https://silentvoid13.github.io/Templater/introduction.html)
[一文掌握Obsidian模板 - 简书](https://www.jianshu.com/p/ba63900433c7)
# `Templater` 能做什么？
使用 `Templater` 可以在笔记或文章中插入变量的值或者函数、脚本、命令的执行结果。所以说掌握 Obsidian `Templater` 也就是从了解基本语法开始，然后了解 Obsidian 的内置变量、内置函数，学会使用用户自定义脚本、使用系统命令。等到掌握了这几个基本技能点之后，你就成为 Obsidian 模板的高级选手了。

现在我们知道了如何学习 `Templater` ：
- `Templater` 是一种让用户能在笔记中插入变量值或者函数执行结果的模板语言，需要掌握 `Templater` 的基本语法结构
- 
- 
下面是一个简单实例。
```Templater
---
creation date: <% tp.file.creation_date() %>
modification date: <% tp.file.last_modified_date("dddd Do MMMM YYYY HH:mm:ss") %>
---
<< [[<% tp.date.now("YYYY-MM-DD", -1) %>]] | [[<% tp.date.now("YYYY-MM-DD", 1) %>]] >>
# <% tp.file.title %>
<% tp.web.daily_quote() %>
```
# `Templater` 有哪些玩法？
## 模板语言特性
我们上面知道了 `Templater` 对于单个模板来说，可以在模板中使用内置的变量、内置函数，用户也可以自己写脚本定义函数、或者使用系统命令。系统命令就是命令行，比如 Windows 的 `cmd`、`powershell`，Linux 的 `Shell` 脚本。不管是用户脚本还是系统命令，它们在使用是都是作为 `tp` 这个对象下面的一个函数来被调用。系统命令是需要在 `Templater` 设置界面手动开启的。
## 配置和使用
在配置和使用层面，用户除了可以自己指定一个固定的目录来存放模板以外，还可以选择性地对笔记归档中某几个目录指定他们特有的模板。对文件夹设置了 folder template 之后，只要这些文件夹下创建了新的笔记，就会自动套用设置的模板。这些模板就叫做文件夹模板 ( folder template )，而且文件夹模板的设置是一个嵌套结构，在匹配模板时使用路径最深的模板。比如我们对 `/passage/Q1` 指定一个 `q1.template` ， `Q1` 的所有子文件夹都会采用 `q1` 模板。然后我们再对 `/passage/Q1/feb` 设置一个 `febrary.template` 的话， `feb` 模板就会覆盖掉 `q1` 模板成为 `/passage/Q1/feb` 文件夹的模板。
# "命令"的概念
`Templater` 采用的是 [Eta](https://eta.js.org/) 模板引擎，模板中除去文字以外就只有 **命令** 这一种元素。命令是一种声明，告诉 `Templater` 我们需要把变量的值或者函数调用、系统命令执行的结果替换，填充到文本中间，形成实际的文章内容。他的语法结构很简单，就是由一对 `<%` 和 `%>` 这样的括号包围起来。比如 `<% tp.date.now() %>` 被替换以后就是当前的日期。

总结下来 模板中的命令要么是一些内置变量，要么就是各种函数，不管是内置的还是自己编写 JavaScript 脚本或者用系统命令实现的函数。
## 三种命令类型（三种 Tag）
-   `<%`: Raw display command. It will just output the expression that's inside.
-   `<%~`: Interpolation command. Same as the raw display tag, but adds some character escaping.
-   `<%*`: It will execute the JavaScript code that's inside. It does not output anything by default. [It will execute the JavaScript code that's inside. It does not output anything by default.](https://silentvoid13.github.io/Templater/commands/execution-command.html)
The closing tag for a command is always the same: `%>`
## 动态命令工具和空格控制工具
In addition to the 3 different types of commands, you can also use command utilities. They are also declared in the opening tag of the command, and they work with all the command types. Available command utilities are:
- [Dynamic Commands](https://silentvoid13.github.io/Templater/commands/dynamic-command.html)
动态命令只在进入预览模式才被执行（解析），通过在开始标签后面跟上一个加号来声明动态命令。也就是说 `<%+` 、 `<%~+` 和 `<%*+` 这三种都是动态命令吧。
空格控制存在的意义应该是让写出来的模板文件结构清晰易读，这是空格控制的语法规则：
-   An underscore `_` at the **beginning** of a tag (`<%_`) will trim **all** whitespaces **before** the command
-   An underscore `_` at the **end** of a tag (`_%>`) will trim **all** whitespaces **after** the command
-   A dash `-` at the **beginning** of a tag (`<%-`) will trim **one** newline **before** the command
-   A dash `-` at the **end** of a tag (`-%>`) will trim **one** newline **after** the command.

## 函数调用
`Templater` 文档对函数调用也只是做了简单介绍，主要是方便会编程的玩家。没有编程经验的用户学习起来就有点难度了。这里对编程用户可能有用的是 `Templater` 内置函数的文档语法，记录一下方便学习吧：
The documentation for the internal functions of `Templater` are using the following syntax:

```Templater
tp.<my_function>(arg1_name: type, arg2_name?: type, arg3_name: type = <default_value>, arg4_name: type1|type2, ...)
```

Where:
-   `arg_name` represents a **symbolic** name for the argument, to understand what it is.
-   `type` represents the expected type for the argument. This type must be respected when calling the internal function, or it will throw an error.
If an argument is optional, it will be appended with a question mark `?`, e.g. `arg2_name?: type`
If an argument has a default value, it will be specified using an equal sign `=`, e.g. `arg3_name: type = <default_value>`.
If an argument can have different types, it will be specified using a pipe `|`, e.g. `arg4_name: type1|type2`
这里来一个具体的例子，便于理解，感觉应该是 `TypeScript` 的语法吧。
```Templater
tp.date.now(format: string = "YYYY-MM-DD", offset?: number|string, reference?: string, reference_format?: string)
```

## 使用全局对象
这里有一个需要注意的点是不管是用户自己写的函数还是普通的 JavaScript 脚本执行命令 (`<%**%>` 这种形式)，在脚本中都可以访问全局对象包括 `tp`、`app`、`moment`等对象。
[Obsidian API declaration file](https://github.com/obsidianmd/obsidian-api/blob/master/obsidian.d.ts)

# 内置函数 API
[Internal Functions - Templater](https://silentvoid13.github.io/Templater/internal-functions/overview.html)

-  : `tp.config` [: `tp.config`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/config-module.html)
-  : `tp.date` [: `tp.date`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/date-module.html)
-  : `tp.file` [: `tp.file`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html)
-  : `tp.frontmatter` [: `tp.frontmatter`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/frontmatter-module.html)
-  : `tp.obsidian` [: `tp.obsidian`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/obsidian-module.html)
-  : `tp.system` [: `tp.system`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/system-module.html)
-  : `tp.web` [: `tp.web`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/web-module.html)
## 配置模块
在模板中读取 Templater 的运行时配置。
- [Documentation](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/config-module.html#documentation)
- [`tp.config.active_file?`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/config-module.html#tpconfigactive_file)
- [`tp.config.run_mode`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/config-module.html#tpconfigrun_mode)
- [`tp.config.target_file`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/config-module.html#tpconfigtarget_file)
- [`tp.file.template_file`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/config-module.html#tpfiletemplate_file)
## 日期模块
- [Documentation](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/date-module.html#documentation)
- [`tp.date.now(format: string = "YYYY-MM-DD", offset?: number⎮string, reference?: string, reference_format?: string)`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/date-module.html#tpdatenowformat-string--yyyy-mm-dd-offset-numberstring-reference-string-reference_format-string)
- [`tp.date.tomorrow(format: string = "YYYY-MM-DD")`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/date-module.html#tpdatetomorrowformat-string--yyyy-mm-dd)
- [`tp.date.weekday(format: string = "YYYY-MM-DD", weekday: number, reference?: string, reference_format?: string)`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/date-module.html#tpdateweekdayformat-string--yyyy-mm-dd-weekday-number-reference-string-reference_format-string)
- [`tp.date.yesterday(format: string = "YYYY-MM-DD")`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/date-module.html#tpdateyesterdayformat-string--yyyy-mm-dd)
- [Moment.js](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/date-module.html#momentjs)
- [Examples](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/date-module.html#examples)
## 文件模块
- [Documentation](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html#documentation)
- [`tp.file.content`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html#tpfilecontent)
- [`tp.file.create_new(template: TFile ⎮ string, filename?: string, open_new: boolean = false, folder?: TFolder)`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html#tpfilecreate_newtemplate-tfile--string-filename-string-open_new-boolean--false-folder-tfolder)
- [`tp.file.creation_date(format: string = "YYYY-MM-DD HH:mm")`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html#tpfilecreation_dateformat-string--yyyy-mm-dd-hhmm)
- [`tp.file.cursor(order?: number)`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html#tpfilecursororder-number)
- [`tp.file.cursor_append(content: string)`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html#tpfilecursor_appendcontent-string)
- [`tp.file.exists(filename: string)`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html#tpfileexistsfilename-string)
- [`tp.file.folder(relative: boolean = false)`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html#tpfilefolderrelative-boolean--false)
- [`tp.file.include(include_link: string ⎮ TFile)`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html#tpfileincludeinclude_link-string--tfile)
- [`tp.file.last_modified_date(format: string = "YYYY-MM-DD HH:mm")`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html#tpfilelast_modified_dateformat-string--yyyy-mm-dd-hhmm)
- [`tp.file.move(new_path: string)`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html#tpfilemovenew_path-string)
- [`tp.file.path(relative: boolean = false)`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html#tpfilepathrelative-boolean--false)
- [`tp.file.rename(new_title: string)`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html#tpfilerenamenew_title-string)
- [`tp.file.selection()`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html#tpfileselection)
- [`tp.file.tags`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html#tpfiletags)
- [`tp.file.title`](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html#tpfiletitle)
- [Examples](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html#examples)
## Frontmatter 模块
就是获取笔记导言区所定义的变量
通过对象属性或者字典的键的方式来获取变量的值，和 JavaScript 是一致的。

## Obsidian 模块需要研究 obsidian api 声明
[Obsidian API declaration file](https://github.com/obsidianmd/obsidian-api/blob/master/obsidian.d.ts)
## 系统模块
`system` 模块可以获取剪贴板(`system.clipbboard`)，弹出需要输入的对话框 （`prompt`）和可以选择选项的那种对话框（`suggester`）。
函数原型：
```JavaScript
tp.system.clipboard()
tp.system.prompt(prompt_text?: string, default_value?: string, throw_on_cancel: boolean = false)
tp.system.suggester(text_items: string[] | ((item: T) => string), items: T[], throw_on_cancel: boolean = false, placeholder: string = "", limit?: number = undefined)
```
示例模板：
```Templater
Clipboard content: <% tp.system.clipboard() %>
Entered value: <% tp.system.prompt("Please enter a value") %>
Mood today: <% tp.system.prompt("What is your mood today ?", "happy") %>
Mood today: <% tp.system.suggester(["Happy", "Sad", "Confused"], ["Happy", "Sad", "Confused"]) %>
Picked file: [[<% (await tp.system.suggester((item) => item.basename, app.vault.getMarkdownFiles())).basename %>]]
```
挺有意思，`web` 模块提供的 API 是"每日一句"（`daily_quote`）和 随机图片 (`random_picture`)。当然了，每日一句估计是英文的。

# JavaScript 脚本
[User Scripts - `Templater` ](https://silentvoid13.github.io/Templater/user-functions/script-user-functions.html)
# 系统命令
[System Commands - `Templater` ](https://silentvoid13.github.io/Templater/user-functions/system-user-functions.html)
# Trouble shot
## Unicode characters (emojis, ...) are not working on Windows ?
像表情之类的特殊字符在 Obsidian 中都是以 Unicode 编码来表示的，而像命令行、 `PowerShell` 这种程序都是不支持 Unicode 的。如果想把 Unicode 和系统命令结合起来就需要解决编码问题。Templater 文档中给出了两种解决方案：
[Unicode characters (emojis, ...) are not working on Windows ?](https://silentvoid13.github.io/Templater/internal-functions/internal-modules/file-module.html#unicode-characters-emojis--are-not-working-on-windows-)

`cmd.exe` and `powershell` on Windows are known to have problems with unicode characters.

You can check https://github. Com/SilentVoid13/Templater/issues/15 #issuecomment -824067020 for a solution.

Another good solution (probably the best) is to use and set it as the default shell in `Templater` 's setting. [and set it as the default shell in `Templater` 's setting.](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701)

Another resource containing solutions that could work for you: 
[Displaying Unicode in Powershell - Stack Overflow](https://stackoverflow.com/questions/49476326/displaying-unicode-in-powershell): <https://stackoverflow.com/questions/49476326/displaying-unicode-in-powershell>
