---
scope: learn
draft: true
---
# Iptables 构建防火墙

- [netfilter.org project homepage](https://www.netfilter.org/documentation/index.html)

- The [Iptables tutorial](https://www.frozentux.net/Iptables-tutorial/Iptables-tutorial.html) by Oskar Andreasson
- [Secure use of Iptables and connection tracking helpers](https://home.regit.org/netfilter-en/secure-use-of-helpers/) by Eric Leblond
- [Set up an gateway for home or office with Iptables ](http://www.yolinux.com/TUTORIALS/LinuxTutorialNetworkGateway.html) by YoLinux

- 

## 实验原理

Iptables 是集成在 Linux 内核中的包过滤防火墙系统。使用 Iptables 可以添加、删除具体的过滤规则，Iptables 默认维护着 4 个表和 5 个链，所有的防火墙策略规则都被分别写入这些表与链中。

当主机收到一个数据包后，数据包先在内核空间中处理，若发现目的地址是自身，则传到用户空间中交给对应的应用程序处理，若发现目的不是自身，则会将包丢弃或进行转发。Iptables 中定义了 `PREROUTING`、`INPUT`、`OUTPUT`、`POSTROUTING`、`FORWARD` 五条链（本质是钩子函数）来匹配网络包处理的不同阶段，和四张表 `raw`、`nat`、`filter`、`mangle`来提供不同的包处理功能（优先级 `raw` > `mangle` > `nat` > `filter`）。Iptables 的包处理逻辑如下图：

![img](https://www.frozentux.net/Iptables-tutorial/images/tables_traverse.jpg)

| raw        | mangle      | nat         | filter  |
| ---------- | ----------- | ----------- | ------- |
| PREROUTING | PREROUTING  | PREROUTING  |         |
|            | INPUT       |             | INPUT   |
| OUTPUT     | OUTPUT      | OUTPUT      | OUTPUT  |
|            | POSTROUTING | POSTROUTING |         |
|            | FORWARD     |             | FORWARD |



这个实验中会安装 Iptables 服务，并使用 Iptables 替代 firewalld 防火墙、实现 SSH 服务的端口转发。

### 安装、启动 Iptables

先关闭 firewalld 防火墙：

```bash
systemctl stop firewalld
systemctl disable firewalld
```

安装并启动 Iptables 作为防火墙：

```bash
yum install Iptables Iptables-services
```



### 启动端口转发

通过 Iptables 命令匹配请求目标端口为 422 的 tcp 包，修改目标端口为 22：

```bash
Iptables -t nat -A PREROUTING -p tcp --dport 422 -j REDIRECT --to-ports 22
```

在另一台机器上测试使用 422 端口登录 SSH。

 

## 实验结果

- 安装、启动 Iptables

![image-20211205215629751](10-ComputeScience/BACKEND/Security/_attachments/Iptables%20构建防火墙/image-20211205215629751.png)

- 启动端口转发

![image-20211205215732310](10-ComputeScience/BACKEND/Security/_attachments/Iptables%20构建防火墙/image-20211205215732310.png)

- 测试 SSH 连接

![image-20211205215804383](10-ComputeScience/BACKEND/Security/_attachments/Iptables%20构建防火墙/image-20211205215804383.png)

## 总结与收获

通过 使用 Iptables 的网络包过滤和处理的功能来实现端口转发，理解了 Iptables/netfilter 的网络包处理模型，对计算机网络有了更多的理解。

