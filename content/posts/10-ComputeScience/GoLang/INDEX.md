---
title: INDEX
author: cupid5trick
created: -1
tags: 
- 提问的智慧
categories: 
access: private
draft: true
lang:
- zh-cn
- en-us
abstract:
keywords:
---

# 提问的智慧

[How-To-Ask-Questions-The-Smart-Way/README-zh_CN.md at main · ryanhanwu/How-To-Ask-Questions-The-Smart-Way · GitHub](https://github.com/ryanhanwu/How-To-Ask-Questions-The-Smart-Way/blob/main/README-zh_CN.md): <https://github.com/ryanhanwu/How-To-Ask-Questions-The-Smart-Way/blob/main/README-zh_CN.md>

[How To Ask Questions The Smart Way](http://www.catb.org/~esr/faqs/smart-questions.html): <http://www.catb.org/~esr/faqs/smart-questions.html>

# 资料汇总

## 基本语法

- Go 语言文档站首页：[Documentation - The Go Programming Language](https://go.dev/doc/): <https://go.dev/doc/>
- Go history 全面说明了语言主要特征和基本设计：<https://go.dev/doc/faq#history>
- A Tour of Go: <https://go.dev/tour/>
- How to write Go code <https://go.dev/doc/code.html>: This doc explains how to develop a simple set of Go packages inside a module, and it shows how to use the [`go` command](https://go.dev/cmd/go/) to build and test packages.
[A Tour of Go](https://go.dev/tour/)

An interactive introduction to Go in four sections. The first section covers basic syntax and data structures; the second discusses methods and interfaces; the third is about Generics; and the fourth introduces Go's concurrency primitives. Each section concludes with a few exercises so you can practice what you've learned. You can [take the tour online](https://go.dev/tour/) or install it locally with:

```
$ go install golang.org/x/website/tour@latest
```

This will place the `tour` binary in your [GOPATH](https://go.dev/cmd/go/#hdr-GOPATH_and_Modules)'s `bin` directory.

## 语言设计

- GoLang 源码：[go - Git at Google](https://go.googlesource.com/go/)
- 稳定维护的设计文档：[https://go.googlesource.com/proposal/](https://go.googlesource.com/proposal/)
- DesignDocuments: [https://github.com/golang/go/wiki/DesignDocuments](https://github.com/golang/go/wiki/DesignDocuments)
- PriorDiscussion: [https://github.com/golang/go/wiki/PriorDiscussion](https://github.com/golang/go/wiki/PriorDiscussion)
- Go Proposal 提案: [https://github.com/golang/proposal](https://github.com/golang/proposal)
- Go Community Slides: [https://github.com/golang/go/wiki/Go-Community-Slides](https://github.com/golang/go/wiki/Go-Community-Slides)
- ResearchPapers: [https://github.com/golang/go/wiki/ResearchPapers](https://github.com/golang/go/wiki/ResearchPapers)
- GoRoutine Scheduler: [http://code.google.com/p/go/source/browse/src/pkg/runtime/proc.c](http://code.google.com/p/go/source/browse/src/pkg/runtime/proc.c)
- Go 语言设计与实现：[https://draveness.me/golang/](https://draveness.me/golang/)
- The Workspace Proposal Prototype 开发工作流提案: [https://github.com/golang/go/wiki/The-Workspace-Proposal-Prototype](https://github.com/golang/go/wiki/The-Workspace-Proposal-Prototype)
- WebAssembly: [https://github.com/golang/go/wiki/WebAssembly](https://github.com/golang/go/wiki/WebAssembly)

# 语言基础

- [Effective Go - The Go Programming Language](https://go.dev/doc/effective_go): <https://go.dev/doc/effective_go>
- 依赖管理：[Managing dependencies - The Go Programming Language](https://go.dev/doc/modules/managing-dependencies): <https://go.dev/doc/modules/managing-dependencies>

# 垃圾回收

- [A Guide to the Go Garbage Collector - The Go Programming Language](https://go.dev/doc/gc-guide): <https://go.dev/doc/gc-guide>
- Go 语言内存模型：[The Go Memory Model - The Go Programming Language](https://go.dev/ref/mem): <https://go.dev/ref/mem>
- Getting to Go: The Journey of Go's Garbage Collector：[https://go.dev/blog/ismmkeynote](https://go.dev/blog/ismmkeynote)
- GC Pacer 算法的重新设计：[https://go.googlesource.com/proposal/+/refs/heads/master/design/44167-gc-pacer-redesign.md](https://go.googlesource.com/proposal/+/refs/heads/master/design/44167-gc-pacer-redesign.md)
- Go 1.5 concurrent garbage collector pacing：[https://docs.google.com/document/u/0/d/1wmjrocXIWTr1JxU-3EQBI6BK6KgtiFArkG47XK73xIQ/mobilebasic#heading=h.poxawxtiwajr](https://docs.google.com/document/u/0/d/1wmjrocXIWTr1JxU-3EQBI6BK6KgtiFArkG47XK73xIQ/mobilebasic#heading=h.poxawxtiwajr)
- Go 语言设计与实现 - 垃圾收集：[https://draveness.me/golang/docs/part3-runtime/ch07-memory/golang-garbage-collector/](https://draveness.me/golang/docs/part3-runtime/ch07-memory/golang-garbage-collector/)
- Go 语言设计与实现 - 内存分配：[https://draveness.me/golang/docs/part3-runtime/ch07-memory/golang-memory-allocator/](https://draveness.me/golang/docs/part3-runtime/ch07-memory/golang-memory-allocator/)
- Go 语言设计与实现 - 栈内存管理：[https://draveness.me/golang/docs/part3-runtime/ch07-memory/golang-stack-management/](https://draveness.me/golang/docs/part3-runtime/ch07-memory/golang-stack-management/)

# Go 语言项目

## 开源项目

GitHub - may-fly/mayfly-go: web 版 linux(终端 文件 脚本 进程)、数据库 (mysql pgsql)、redis(单机 哨兵 集群)、mongo 统一管理操作平台:

[https://github.com/may-fly/mayfly-go/](https://github.com/may-fly/mayfly-go/)

用 golang 开发自己的 prometheus exporter

<https://zhuanlan.zhihu.com/p/375401659?utm_id=0>

**数据库**

rosedb：

一个 Go 语言实现的数据库-腾讯云开发者社区-腾讯云

<https://cloud.tencent.com/developer/article/1848900>

rosedblabs/rosedb: Lightweight, fast and reliable key/value storage engine based on Bitcask.

<https://github.com/rosedblabs/rosedb>

## Makefile 项目管理

Go语言推荐的项目目录结构：[golang-standards/project-layout: Standard Go Project Layout](https://github.com/golang-standards/project-layout): <https://github.com/golang-standards/project-layout>

在Go语言中使用 Makefile：

[Go 项目使用 Makefile-makefile @@](https://www.51cto.com/article/709065.html): <https://www.51cto.com/article/709065.html>

[Using Makefile for Go - Go语言项目如何正确使用Makefile | Colynn.Liu](https://colynn.github.io/2020-03-03-using_makefile/): <https://colynn.github.io/2020-03-03-using_makefile/>

Makefile 基础学习与应用：

[通用Makefile的编写和在项目工程中使用Makefile - 陈木 - 博客园](https://www.cnblogs.com/muyi23333/articles/13528528.html): <https://www.cnblogs.com/muyi23333/articles/13528528.html>

[从零Makefile落地算法大项目，完整案例教程 - 知乎](https://zhuanlan.zhihu.com/p/396448133?utm_id=0): <https://zhuanlan.zhihu.com/p/396448133?utm_id=0>

# Idea

## 开发 Go 语言操作系统

[如何在裸机上跑go程序](https://groups.google.com/g/golang-china/c/I1sAcjpihoY?pli=1): <https://groups.google.com/g/golang-china/c/I1sAcjpihoY?pli=1>

[使用Go语言编写操作系统-前言 - 知乎](https://zhuanlan.zhihu.com/p/387299116): <https://zhuanlan.zhihu.com/p/387299116>

[Salus](https://salusec.io/audit): <https://salusec.io/audit>

## 基础架构

[字节跳动基础架构团队参会报告：一文看懂VLDB&#39;22技术趋势及精选论文 | Redian新闻](https://redian.news/wxnews/90225): <https://redian.news/wxnews/90225>

# Go 语法

8/2/2023

golang 括号用法总结 | 老麦的书房: <https://typonotes.com/posts/2021/09/09/golang-brackets/>

Go 泛型的括号选择：`[ ]` or `( )`？-腾讯云开发者社区-腾讯云: <https://cloud.tencent.com/developer/article/1667695>

8/16/2023

后端 - Go 1.18 泛型全面讲解：一篇讲清泛型的全部 - 个人文章 - SegmentFault 思否: <https://segmentfault.com/a/1190000041634906>

# Go 程序启动流程

[Golang 程序启动流程分析-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1905326): <https://cloud.tencent.com/developer/article/1905326>
