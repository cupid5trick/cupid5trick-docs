---
title: TabCopy
author: cupid5trick
created: 2023-04-25 01:09
tags: #<%,#tp.file.tags,#%>
categories: 
access: private
draft: true
lang:
- zh-cn
- en-us
abstract:
keywords:
---




## TabCopy
#### 工具推荐：TabCopy

TabCopy 是一个 Chrome 浏览器插件，支持运行在全功能的 Chrome 浏览器上使用。它的功能概括一句话概括：

> 拷贝浏览器当前页面的 URL 到剪切板，并支持「定制化」这个 URL 地址。

在 Obsidian 或者 Roam 中，当我们需要摘录一篇文章时，通常希望拷贝这篇文章的 Markdown 格式的 URL 地址，而且对于不同的 URL 我们还有不同的需求：

-   有时候我们仅需要当前页面的 URL。
-   有时候我们还需要当前页面的 Markdown 格式 URL。
-   有时候我们即需要需要当前页面的 Markdown 格式 URL，也需要根据当前页面的「标题」创建一个 Topic。

举个实际的例子，在 Chrome 中有一个页面。

例1：我需要摘录文章到一篇笔记中，如果我使用的是 Obsidian 这样的笔记软件，我需要拷贝符合 Markdown 格式的 URL 放到笔记中，此时需要的格式如下：

```markdown
[sspai-post-61092](https://sspai.com/post/61092)
```
[sspai-post-61092](https://sspai.com/post/61092)

例2：我需要摘录到文章到一篇笔记中，如果我使用的是 Obsidian 这样的笔记软件，我需要拷贝符合 Markdown 格式的 URL，同时我还希望用这个页面的「标题」创建一个笔记，即将当前笔记和这个新的笔记建立「双向链接」，还记得如何建立双向链接吗？（将一段文字包裹在 `[[]]`中），此时需要的格式如下：

![](15988547134164%201.png)

上图中，当我们处在 Obsidian 的「预览模式」时，点击这个「双向链接」，Obsidian 就会自动创建一个新的 Topic，Topic 的标题就是被 `[[]]` 包裹的文字，即「任务管理这件事 - 少数派」。

#### TabCopy 如何使用

TabCopy 通过设置，可以支持最多三种 URL 拷贝方式，如图：

![TabCopy 设置](TabCopy_设置%201.png)

TabCopy 设置

-   First Format：我选择的是 Markdown 格式，设置页面上也有事例，代表我们会拷贝出当前页面符合 Markdown 格式的 URL。
-   Second Format：我选择的是定制化格式，代表我希望拷贝 MarkDown 格式 URL，同时用一对方括号，将文章「标题」框起来，在 Obsidian 中代表用文章标题创建了一个 Topic，并建立了「双向链接」。
-   Third Fromat：这个最简单我希望直接拷贝当前页面的 URL。

使用时只需要在 Chrome 上点击 TabCopy 插件，在弹出界面，选择相应的 Tab 页，再点击「Copy xxx」即可完成拷贝，如图：

![TabCopy 使用](TabCopy_使用%201.jpg)

TabCopy 使用