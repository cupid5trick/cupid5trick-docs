---
scope: work
draft: true
---



# 安装配置

- <github.com/coturn/conturn> 的安装配置 Wiki: [CoturnConfig](https://github.com/coturn/coturn/wiki/CoturnConfig)
- Wiki 下载页面: [Downloads](https://github.com/coturn/coturn/wiki/Downloads)

-   Main project page: [https://github.com/coturn/coturn/wiki/turnserver](https://github.com/coturn/coturn/wiki/turnserver)
    
-   Fully commented configuration file: [https://github.com/coturn/coturn/blob/master/examples/etc/turnserver.conf](https://github.com/coturn/coturn/blob/master/examples/etc/turnserver.conf)
    
-   Additional docs on configuration: [https://github.com/coturn/coturn/wiki/CoturnConfig](https://github.com/coturn/coturn/wiki/CoturnConfig)


```bash
wget https://coturn.net/turnserver/v4.5.2/turnserver-4.5.2.tar.gz
```


编译安装 Coturn 之前需要编译安装第三方库 libevent：

下载 libevent 最新稳定版本：

```bash
wget https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz
```

编译并安装：
```bash
tar xvfz libevent-2.0.21-stable.tar.gz
cd libevent-2.0.21-stable
./configure
make
make install

yum install -y openssl-devel sqlite sqlite-devel libevent libevent-devel postgresql-devel postgresql-server mysql-devel mysql-server hiredis hiredis-devel gcc
```


编译安装 Coturn：
```bash
tar xvfz turnserver-<...>.tar.gz
./configure
make
make install
```


# 使用 redis 作为用户数据库
