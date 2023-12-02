---
title: Untitled
author: cupid5trick
created: 2023-03-21 17:28
tags: 
categories: 
access: private
draft: true
lang:
- zh-cn
- en-us
abstract:
keywords:
---


考虑到在代码中加载用户提供的第三方 jar 包，然后通过反射调用的情况，或者类似 online judge 的应用场景，可以总结出一类业务场景：调用方提供类的文件系统路径或者在网络上的 URL，程序通过类加载器加载需要调用的类，然后通过反射调用该类的方法。每个不同的调用之间需要有环境隔离，至少不能和程序本身共用一个环境（避免用户提供的代码破坏程序逻辑或运行环境）。

# 附录
## Java 编译器接口

[JavaCompiler (Java Platform SE 7 )](https://docs.oracle.com/javase/7/docs/api/javax/tools/JavaCompiler.html): <https://docs.oracle.com/javase/7/docs/api/javax/tools/JavaCompiler.html>