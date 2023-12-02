---
scope: learn
draft: true
---
# Java环境部署

# 一、环境

Linux系统版本：CentOS Linux release 7.6.1810

jdk版本：[jdk-8u181-linux-x64](https://repo.huaweicloud.com/java/jdk/8u181-b13/)

# 二、安装步骤

## 1. 安装包上传并解压

使用xftp 将jdk-8u181-linux-x64.tar.gz传入服务器的/usr/local/mng目录下，并解压

```bash
//解压
tar -zxvf /usr/local/mng/jdk-8u181-linux-x64.tar.gz
//改名
mv /usr/local/mng/jdk1.8.0_181 /usr/local/mng/java8
```

![image-20211009222529636](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211009222529636.png)

## 2. 配置环境变量

```bash
vi /etc/profile
```

将下面几行加入最下面

```bash
export JAVA_HOME=/usr/local/mng/java8
export PATH=$PATH:$JAVA_HOME/bin
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export JRE_HOME=$JAVA_HOME/jre
```

![image-20211009223426873](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211009223426873.png)

让配置文件生效

```bash
source /etc/profile
```

查看安装情况

```bash
java -version
```

![image-20211009223448347](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211009223448347.png)

