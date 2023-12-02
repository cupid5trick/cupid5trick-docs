---
title: Untitled
author: cupid5trick
created: 2023-04-03 21:46
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

[Download and install - The Go Programming Language](https://go.dev/doc/install): <https://go.dev/doc/install>

# 配置GOROOT和GOPATH

远程linux安装go

```bash
wget https://golang.google.cn/dl/go1.17.3.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.17.3.linux-amd64.tar.gz
 
# 在 /etc/profile中设置环境变量
export GOROOT=/usr/local/go
export GOPATH=/usr/local/gopath
export PATH=$PATH:/$GOROOT/bin:$GOPATH/bin
 
source /etc/profile     # 加载环境变量
 
go version
 
#设置代理
go env -w GOPROXY=https://goproxy.cn,direct
#开启go mod管理
go env -w GO111MODULE=on
```
