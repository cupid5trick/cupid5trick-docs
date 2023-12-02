---
scope: learn
draft: true
---
# Java 远程调试
## 1 概述

原理：本机和远程主机的两个 VM 之间使用 Debug 协议通过 [Socket](https://so.csdn.net/so/search?q=Socket&spm=1001.2101.3001.7020) 通信，传递调试指令和调试信息。  
被调试程序的远程虚拟机：作为 Debug 服务端，监听 Debug 调试指令。Jdwp 是 Java Debug Wire Protocol 的缩写。  
调试程序的本地虚拟机：IDEA 中配置的 Remote Server，指定 Debug 服务器的 Host: Port，以供 Debug 客户端程序连接。

## 2 设置

### 2.1 IDEA 中指定 Debug 服务器

-   点击主窗口菜单 `Run / Edit Configurations` ，打开“Run/Debug Configurations”窗口；
-   点击工具栏上的“+”按钮，下拉菜单中选择“Remote”；
-   设置 Host 为远程服务器的域名或 IP，保持 Port=5005 无需调整；
-   复制命令行参数，形如 `-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005`

![](https://kefeng.wang/images/idea-remote-debug/configurations.png)

### 2.2 远程服务中开启 Debug 服务

#### 2.2.1 对于 SpringBoot

命令行添加选项，并重启：

```
## 注意新参数必须在 -jar 之前
jar -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 -jar test.jar
```

#### 2.2.2 对于 Tomcat

启动脚本中添加选项，并重启：

```bash
## sudo vim $CATALINA_HOME/bin/catalina.sh
JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
```

### 2.3 远程服务器防火墙端口放行

```bash
### sudo vim /etc/sysconfig/iptables
-A INPUT -m state --state NEW -m tcp -p tcp --dport 5005 -j ACCEPT
### 重启生效: sudo systemctl restart iptables
```

## 3 开始调试

-   要求：双方代码一致，否则远程调试无法启动；
-   本地启动刚刚配置的 Remote Server，正常时会看到日志: `Connected to the target VM, address: 'xxx:5005', transport: 'socket'`
-   本地 IDEA 代码中设置断点
-   浏览器或手机 HTTP 访问服务器
-   IDEA 即可在断点暂停并跟踪

## 4 关闭调试

服务器上多开放个端口是不安全的，调试完毕后可恢复防火墙设置。  
而 Java 服务器开启 Debug 服务器的功能可以保留，以便之后再次调试。
# Java MockIt
[Mockito framework site](https://site.mockito.org/)
[Mockito (Mockito 4.6.1 API)](https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/Mockito.html)
MockIt 最新文档地址：[Mockito - mockito-core 4.6.1 javadoc](https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/Mockito.html)

# Mock 数据
javafaker：[DiUS/java-faker: Brings the popular ruby faker gem to Java](https://github.com/DiUS/java-faker)
common random：[yindz/common-random: 简单易用的随机数据生成器，支持各类中国特色本地化的数据格式。](https://github.com/yindz/common-random)

# FastJson

[JSON最佳实践 | kimmking's blog](http://i.kimmking.cn/2017/06/06/json-best-practice/#8-5_JSONObject_u7684_u4F7F_u7528)
[fastjson 1.2.68 bypass autotype - Y4er的博客](https://y4er.com/post/fastjson-bypass-autotype-1268/)
![](image-20220727233515836.png)

