---
title: Untitled
author: cupid5trick
created: 2023-04-03 17:28
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

# CentOS 编译安装

从 https://python.org 下载 python 源码。

安装编译环境。


[CentOS 快速安装Python3和pip3 - 腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1693084): <https://cloud.tencent.com/developer/article/1693084>

CentOS 是经常使用的 Linux 系统之一，特别是作为[服务器](https://cloud.tencent.com/product/cvm?from=20065&from_column=20065)使用，其只自带了 Python2，但是现在使用更广泛的是 Python3，因此需要自行安装，同时为了更方便地安装第三方库，还需要安装 pip3。

## 一、安装相关依赖

1. 安装环境依赖：

```
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
```

2. 安装 gcc 编译器（有可能已经安装）

## 二、安装 Python3

以 Python3.7 为例讲解。

1. 下载 Python 安装包

```bash
wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tgz
```

因为下载很慢，所以可以在本地通过更快的方式下载后再上传到服务器。

2. 将安装包移动到 `/usr/local` 文件夹下

```bash
mv Python-3.7.4.tgz /usr/local/
```

3. 在 local 目录下创建 Python3 目录

4. 进入的 Python 安装包压缩包所在的目录

5. 解压安装包

```bash
tar -xvf Python-3.7.4.tgz
```

6. 进入解压后的目录

```bash
cd /usr/local/Python-3.7.4/
```

7. 配置安装目录

```bash
./configure --prefix=/usr/local/python3
```

8. 编译源码

9. 执行源码安装

这一步可能会出现报错 `ModuleNotFoundError: No module named '_ctypes'` ，这是因为缺少依赖包 `libffi-devel` ，解决方法可参考 [https://blog.csdn.net/CUFEECR/article/details/103093951](https://blog.csdn.net/CUFEECR/article/details/103093951)。

10. 创建软连接

```bash
ln -s /usr/local/python3/bin/python3  /usr/bin/python3
```

11. 测试输入 `python3` 打印：

```bash
Python 3.7.4 (default, Sep  6 2020, 09:22:23) 
[GCC 4.8.5 20150623 (Red Hat 4.8.5-39)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> 
```

即说明 Python 安装成功。

## 二、安装 pip3

1. 安装依赖（非必要）

```bash
sudo yum install openssl-devel -y 
sudo yum install zlib-devel -y
```

2. 安装 setuptools

```bash
# 下载安装文件
wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-19.6.tar.gz#md5=c607dd118eae682c44ed146367a17e26

# 解压
tar -zxvf setuptools-19.6.tar.gz 
cd setuptools-19.6

# 执行安装
sudo python3 setup.py build 
sudo python3 setup.py install
```

3. 安装 pip3

```bash
# 下载安装文件
wget --no-check-certificate https://pypi.python.org/packages/source/p/pip/pip-20.2.2.tar.gz#md5=3a73c4188f8dbad6a1e6f6d44d117eeb
 
# 解压
tar -zxvf pip-20.2.2.tar.gz 
cd pip-20.2.2

# 执行安装
python3 setup.py build 
sudo python3 setup.py install
```

4. 测试安装完成后，输入 `pip3 -V` ，打印：

```bash
pip 20.2.2 from /usr/local/python3/lib/python3.7/site-packages/pip (python 3.7)
```

则说明安装成功，可以正常安装需要的第三方库了，需要注意： 在使用时应该是 `pip3 xxx` ，而不是 `pip xxx` ，使之与 Python2 相区别。

本文分享自作者个人站点/博客： https://blog.csdn.net/CUFEECR

