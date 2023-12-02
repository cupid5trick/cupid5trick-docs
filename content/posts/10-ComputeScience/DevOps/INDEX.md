---
title: Untitled
author: cupid5trick
created: 2023-04-05 12:33
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

# Linux 安装 Llvm-toolset-7

需要先安装一个 meta package：

```bash
yum install -y centos-release-scl-rh
```

然后才能解析到 llvm-toolset-7 这个软件包：

```bash
yum install -y llvm-toolset-7
```

# Maven 临时代理

通过 Java 的命令行变量设置即可, 根本上是 JVM 的配置选项。

```bash
mvn package ... -Dhttps.proxyHost=<HOST> -Dhttps.proxyPort=<PORT>
```

# Redis

[在CentOS7上从源码编译安装redis，并做成服务程序 - 蜀中孤鹰 - 博客园](https://www.cnblogs.com/gocode/p/install-redis-by-source-code.html#4.%E6%B3%A8%E5%86%8Credis%E6%9C%8D%E5%8A%A1): <https://www.cnblogs.com/gocode/p/install-redis-by-source-code.html#4.%E6%B3%A8%E5%86%8Credis%E6%9C%8D%E5%8A%A1>
