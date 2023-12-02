---
scope: learn
draft: true
---

SSL/TLS 协议、OpenSSL

- [SSL/TLS原理详解 - 云+社区 - 腾讯云](https://cloud.tencent.com/developer/article/1115445)
- [OpenSSL Home](https://www.openssl.org/)
- [Ivan Ristić, the creator of https://ssllabs.com - OpenSSL Cookbook](https://www.feistyduck.com/books/openssl-cookbook/)
- [SSL与TLS的区别以及介绍](http://kb.cnblogs.com/page/197396/)
- [SSL/TLS协议运行机制的概述](http://www.ruanyifeng.com/blog/2014/02/ssl_tls.html)
- [传输层安全协议](http://zh.wikipedia.org/wiki/传输层安全协议)
- [Survival guides - TLS/SSL and SSL (X.509) Certificates](http://www.zytrax.com/tech/survival/ssl.html)
- [HTTPS 详解一：附带最精美详尽的 HTTPS 原理图](https://segmentfault.com/a/1190000021494676)
- [HTTPS 详解二：SSL / TLS 工作原理和详细握手过程](https://segmentfault.com/a/1190000021559557?_ea=29659396)

[RSA算法原理（一） - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2013/06/rsa_algorithm_part_one.html): <https://www.ruanyifeng.com/blog/2013/06/rsa_algorithm_part_one.html>

[RSA算法原理（二） - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2013/07/rsa_algorithm_part_two.html): <https://www.ruanyifeng.com/blog/2013/07/rsa_algorithm_part_two.html>

[GPG入门教程 - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2013/07/gpg.html): <https://www.ruanyifeng.com/blog/2013/07/gpg.html>

# Netfilter/Iptables

- [netfilter.org project homepage](https://www.netfilter.org/documentation/index.html)
- The [iptables tutorial](https://www.frozentux.net/iptables-tutorial/iptables-tutorial.html) by Oskar Andreasson
- [Secure use of iptables and connection tracking helpers](https://home.regit.org/netfilter-en/secure-use-of-helpers/) by Eric Leblond
- [Set up an gateway for home or office with iptables ](http://www.yolinux.com/TUTORIALS/LinuxTutorialNetworkGateway.html) by YoLinux

# 自主实验

- Openssl加密库的使用 - OpenSSL 自签证书：[Creating Self-Signed Certificates and CSRs (Certificate Signing Requests)](http://www.zytrax.com/tech/survival/ss.html#root-ca)
- 在虚拟机上，安装Linux操作系统。基于Linux系统的iptables工具，在Netfilter机制之上构建防火墙，实施防火墙的规则列表，并配置iptables来执行这些规则。：[Set up an gateway for home or office with iptables ](http://www.yolinux.com/TUTORIALS/LinuxTutorialNetworkGateway.html)

# OpenSSL 自签证书

## 实验原理

建立自签证书有很多种方法，这里为了充分理解数字证书的目的，采用根 CA - 从属 CA - 终端证书的方式，适合个人或小型组织内部使用，而且与公共 证书授权机构的模式相似。

OpenSSL 提供了建立私有 CA 和自签发证书的所有功能，建立 CA 只要准备好相关配置文件和目录结构、初始化秘钥文件，最后生成根证书和私钥。利用OpenSSL关于 CA 的操作命令，可以建立从属 CA 和签发终端实体证书。

OpenSSL 的操作流程参考了 [OpenSSL cookbook - Creating a Private Certification Authority](https://www.feistyduck.com/library/openssl-cookbook/)，用到了书中提供的两个配置文件 [OpenSSL CA configuration templates](https://github.com/ivanr/bulletproof-tls/tree/master/private-ca) 。

### 建立根 CA

#### 1. 根 CA 配置文件 （root-ca.conf）

`root-ca.conf` 的内容分为四部分。第一部分是`[ default ]` 和 `[ ca_dn ]` 两项，包含了 CA 基本信息（例如名称、URL 和专有名称 ( distinguished name ) 的各项字段）。

第二部分是 `[ ca_default ]` 和 `[ policy_c_o_match ]` 两项。`[ ca_default ]` 提供了 `ca` 命令必要的默认参数（在命令行执行 `man ca` 可以查看详细解释）。`[ policy_c_o_match ]` 配置为此 CA 颁发的所有证书都继承相同的 *countryName* 和 *organizationName* ，通常公共 CA 不会这样做，但是适合私有 CA 。

第三部分的 `[ req ]` 和 `[ ca_ext ]` 包含了 `req` 命令的配置，在创建自签发根证书的过程中使用。最重要的配置项是 `[ ca_ext ]`，*basicConstraints* 表明是一个 CA 证书，*keyUsage* 包含了相应的使用场景。

第四部分（`[ sub_ca_ext ]`、`[ crl_info ]`、`[ issuer_info ]`、`[ name_constraints ]`）提供了根 CA 证书签发其他证书所用的信息。*basicConstraints* 表明所有签发的证书也是 CA ，*但是pathlen* 为 0 意味着签发的证书不允许再签发从属 CA 证书。从属 CA 证书通过 *extended-keyUsage* 和 *nameConstraints* 限制：1. `extended-keyUsage` 的 *clientAuth* 和 *serverAuth* 表明从属 CA 签发的子证书只能用于 TLS 客户端和服务端之间的认证。2. `nameConstraints` 把允许的域名限制在 *example.com* 和 *example.org*。

第五部分`[ ocsp_ext ]` 指定了用于 OCSP 响应签名 的配置。

#### 2. 建立目录结构

创建目录结构，初始化秘钥文件。

- `certs/` 目录下保存证书文件
- `db/` 目录用来保存数据库文件和维护下一个证书 CRL 序列号文件。OpenSSL 也会创建其他的必要文件。
- `private/` 目录保存私钥，一个 CA 证书私钥、一个OCSP 响应的私钥。

```bash
mkdir root-ca/{certs,db,private} -p
cd root-ca
chmod 700 private
touch db/index
openssl rand -hex 16 > db/serial
echo 1001 > db/crlnumber
```

#### 3. 生成 CA 根证书

通过两步生成 CA 根证书：

- 生成秘钥和 CSR (Certificate Signing Request)
- 创建自签证书

```bash
# 秘钥和 CSR
openssl req -new \
-config root-ca.conf \
-out root-ca.csr \
-keyout private/root-ca.key

# 创建自签证书
openssl ca -selfsign \
-config root-ca.conf \
-in root-ca.csr \
-out root-ca.crt \
-extensions ca_ext
```

然后为 OCSP 签名生成证书：

- 生成 OCSP responder 的秘钥和 CSR
- 用根证书来给 OCSP 颁发证书

```bash
openssl req -new \
-newkey rsa:2048 \
-subj "/C=GB/O=Example/CN=OCSP Root Responder" \
-keyout private/root-ocsp.key \
-out root-ocsp.csr

openssl ca \
-config root-ca.conf \
-in root-ocsp.csr \
-out root-ocsp.crt \
-extensions ocsp_ext \
-days 30

openssl ocsp \
-port 9080 \
-index db/index \
-rsigner root-ocsp.crt \
-rkey private/root-ocsp.key \
-CA root-ca.crt \
-text
```

可以通过 `ocsp` 命令测试 OCSP responder：

```bash
openssl ocsp \
-issuer root-ca.crt \
-CAfile root-ca.crt \
-cert root-ocsp.crt \
-url http://127.0.0.1:9080
```

命令的输出中*OK* 表示数字签名验证正确，*good* 表示证书未被撤销。

![image-20211204225406473](image-20211204225406473.png)

### 建立从属 CA

#### 1. 从属 CA 配置文件（`sub-ca.conf`）

`sub-ca.conf` 在`root-ca.conf` 基础上做了一些改动。CA 名称改为 *sub-ca* 、使用不同的专有名称、OCSP 端口从 9080 改为 9081 （因为 OCSP 命令不识别虚拟主机，如果使用 web 服务器作为 OCSP responder 就可以避免同一个端口的问题）。

`[ ca_default ]` 设置证书默认有效期为 365 天，每 30 天刷新一次 CRL 。把 *copy_extentions* 设为 *copy* 后，如果配置中没有某项设置，就会把 CSR 中 *extentions* 的相应内容复制到证书中。这样准备 CSR 的人员就可以把所需的别名加入证书中。

![image-20211204233416140](image-20211204233416140.png)

在配置文件最后加入了两个新的配置项，一个客户端证书一个服务端证书。唯一不同的地方就是 *keyUsage* 和 *extendedKeyUsage* 。*basicConstraints* 中设置 `CA` 为 `false`。

![image-20211204233430162](image-20211204233430162.png)

#### 2. 生成从属 CA

先生成秘钥和 CSR ：

```bash
openssl req -new \
-config sub-ca.conf \
-out sub-ca.csr \
-keyout private/sub-ca.key
```

然后用根证书颁发给从属 CA 颁发证书：

```bash
openssl ca \
-config root-ca.conf \
-in sub-ca.csr \
-out sub-ca.crt \
-extensions sub_ca_ext
```

#### 3. 颁发终端实体证书

最后可以使用从属证书颁发两个终端实体证书：

```bash
openssl req -new \
-config sub-ca.conf \
-out server.csr \
-extensions server_ext \
-keyout private/server.key

openssl ca \
-config sub-ca.conf \
-in server.csr \
-out server.crt \
-extensions server_ext

openssl req -new \
-config sub-ca.conf \
-out client.csr \
-extensions client_ext \
-keyout private/client.key

openssl ca \
-config sub-ca.conf \
-in client.csr \
-out client.crt \
-extensions client_ext
```

## 实验结果

- 生成根 CA 的秘钥和 CSR

![image-20211204235032998](image-20211204235032998.png)

- 生成根 CA 证书

![image-20211204235125163](image-20211204235125163.png)

- 生成 OCSP responder 的秘钥和 CSR

![image-20211204235655104](image-20211204235655104.png)

- 用根证书来给 OCSP 颁发证书

![image-20211204235823709](image-20211204235823709.png)

- 用 ocsp 命令验证证书

![image-20211205000219262](image-20211205000219262.png)

![image-20211205000142296](image-20211205000142296.png)

- 生成从属 CA 的秘钥和 CSR

![image-20211205000446873](image-20211205000446873.png)

- 生成从属 CA 证书

![image-20211205000759777](image-20211205000759777.png)

- 生成服务端证书和客户端证书

![image-20211205002018504](image-20211205002018504.png)

![image-20211205002215126](image-20211205002215126.png)

## 总结与收获

通过建立两层的私有 CA 结构，并签发终端实体证书，对数字证书及其原理有了更深的理解。

# Iptables 构建防火墙

## 实验原理

iptables 是集成在 Linux 内核中的包过滤防火墙系统。使用 iptables 可以添加、删除具体的过滤规则，iptables 默认维护着 4 个表和 5 个链，所有的防火墙策略规则都被分别写入这些表与链中。

当主机收到一个数据包后，数据包先在内核空间中处理，若发现目的地址是自身，则传到用户空间中交给对应的应用程序处理，若发现目的不是自身，则会将包丢弃或进行转发。iptables 中定义了 `PREROUTING`、`INPUT`、`OUTPUT`、`POSTROUTING`、`FORWARD` 五条链（本质是钩子函数）来匹配网络包处理的不同阶段，和四张表 `raw`、`nat`、`filter`、`mangle`来提供不同的包处理功能（优先级 `raw` > `mangle` > `nat` > `filter`）。iptables 的包处理逻辑如下图：

![img](https://www.frozentux.net/iptables-tutorial/images/tables_traverse.jpg)

| raw        | mangle      | nat         | filter  |
| ---------- | ----------- | ----------- | ------- |
| PREROUTING | PREROUTING  | PREROUTING  |         |
|            | INPUT       |             | INPUT   |
| OUTPUT     | OUTPUT      | OUTPUT      | OUTPUT  |
|            | POSTROUTING | POSTROUTING |         |
|            | FORWARD     |             | FORWARD |

这个实验中会安装 iptables 服务，并使用 iptables 替代 firewalld 防火墙、实现 SSH 服务的端口转发。

### 安装、启动 Iptables

先关闭 firewalld 防火墙：

```bash
systemctl stop firewalld
systemctl disable firewalld
```

安装并启动 iptables 作为防火墙：

```bash
yum install iptables iptables-services
```

### 启动端口转发

通过 iptables 命令匹配请求目标端口为 422 的 tcp 包，修改目标端口为 22：

```bash
iptables -t nat -A PREROUTING -p tcp --dport 422 -j REDIRECT --to-ports 22
```

在另一台机器上测试使用 422 端口登录 SSH。

## 实验结果

- 安装、启动 iptables

![image-20211205215629751](10-ComputeScience/BACKEND/Security/_attachments/SSLTLS%20协议%20-%20OpenSSL/image-20211205215629751.png)

- 启动端口转发

![image-20211205215732310](10-ComputeScience/BACKEND/Security/_attachments/SSLTLS%20协议%20-%20OpenSSL/image-20211205215732310.png)

- 测试 SSH 连接

![image-20211205215804383](10-ComputeScience/BACKEND/Security/_attachments/SSLTLS%20协议%20-%20OpenSSL/image-20211205215804383.png)

## 总结与收获

通过 使用 iptables 的网络包过滤和处理的功能来实现端口转发，理解了 iptables/netfilter 的网络包处理模型，对计算机网络有了更多的理解。

# SSL/TLS

SSL/TLS 是网络模型中位于应用层和传输层之间的一个可选层，为应用层安全通信提供支持。

## 简介

SSL（Secure Socket Layer，安全套接字层）是NetScape 公司开发的，用来保障互联网的数据传输安全。当前版本为 3.0，已经广泛应用于Web浏览器和服务器之间的身份认证和加密通信中。SSL协议分为记录协议（SSL Record Protocol）和握手协议（SSL Handshake Protocol）两个子层，记录协议在传输层协议基础上提供数据封装、压缩、加密等基本功能，握手协议在记录协议之上为应用层建立安全会话提供必要支持：通信双方的身份认证、协商加密算法、交换会话秘钥等。

TLS（Transport Layer Security，传输层安全协议）是由IETF（Internet Engineering Task Force，Internet工程任务组）制定的。TLS 建立在SSL 3.0 协议之上，通常被认为是SSL 3.0 的后续版本。TLS 同样包含记录协议和握手协议两个子层。目前广泛应用的是TLS 1.2（[RFC 5246](https://tools.ietf.org/html/rfc5246)，2008年） 和 TLS 1.3（[RFC 8446](https://tools.ietf.org/html/rfc8446)，2018年）。

SSL/TLS协议经历了从SSL 1.0到SSL 3.0、从TLS 1.0到 TLS 1.3的版本升级：

- 1994年，NetScape公司设计了SSL协议（Secure Sockets Layer）的1.0版，但是未发布。
- 1995年，NetScape公司发布SSL 2.0版，很快发现有严重漏洞。于2011年弃用。
- 1996年，SSL 3.0版问世，得到大规模应用。于2015年弃用。
- 1999年，互联网标准化组织ISOC接替NetScape公司，发布了SSL的升级版TLS 1.0版。
- 2006年和2008年，TLS进行了两次升级，分别为TLS 1.1版和TLS 1.2版。
- 2018年8月， [RFC 8446](https://tools.ietf.org/html/rfc8446) 中发布了TLS 1.3版本。TLS 1.0和TLS 1.1也在2021年弃用。

## SSL/TLS 工作原理

SSL/TLS 协议通常被看做位于应用层和传输层之间的一个可选的中间层，它主要包括两方面的功能：

- 一方面在通信双方建立一个经过身份认证和加密的安全连接。
- 另一方面，使用这个安全连接从发送方到接收方传输高层协议数据。SSL/TLS 协议把上层数据切分成可管理的分组，单独处理每个分组。更确切地说，每个分组都可选地经过压缩、认证、加密、填充首部，最终传输给接收方。这样的分组就形成一个SSL/TLS 记录：SSL/TLS 记录包含类型、版本、长度和分组数据四个字段，分组字段就包含了上层协议数据。在接收端数据，SSL/TLS 记录以相反的顺序被解密、验证、解压缩、组装，然后交付给应用层协议处理。

SSL/TLS 协议的位置如图所示，它由两个子层构成，包含一些子协议。

![image-20211201174251485](image-20211201174251485.png)

- 较低层的记录协议在面向连接的可靠性传输层协议之上工作，例如TCP。它主要负责高层协议数据的封装。
- 较高层协议在记录协议之上工作，包含握手协议（Handshake Protocol）、Change Cipher Suite Spec Protocol、Alert Protocol、 Application Data Protocol。Handshake Protocol 是SSL/TLS 的核心，用于建立安全连接，在握手阶段双方协商通信过程中的密码组合和压缩方式等细节。应用数据协议负责把应用层数据封装进记录协议中保证加密和安全传输。

### 会话、连接及其状态

连接是服务器和客户端之间以加密和可选的压缩格式传输数据的媒介，因此还包含了一些加密参数等信息。多个连接可以共享一个会话。

SSL 会话指通信双方通过SSL 握手协议建立的联系，定义了一组相关连接所用的加密参数。SSL 会话可以在多个连接之间共享，会话的主要目的就是避免每个SSL 连接都要重复协商新的参数。

SSL 会话和状态都是有状态的，客户端和服务器都需要保存一些状态信息。SSL 握手协议负责建立和协调会话状态、连接状态，以确保服务端和客户端协议协调运行。会话状态和连接状态包含的数据如下：

**SSL 会话状态**

| 数据项             | 说明                                                         |
| ------------------ | ------------------------------------------------------------ |
| session identifier | 由服务器随机选择的任意字节序列（最大长度32 字节），标识活跃或可重用会话状态。 |
| peer certificate   | X.509v3 格式的对端证书。                                     |
| compression method | 使用的压缩算法（先于加密）。                                 |
| cipher spec        | 数据加密算法、MAC 算法以及一些加密参数。                     |
| master secret      | 48 字节长度的主密，服务端和客户端之间共享。                  |
| is resumable       | 标识会话是否可以重启，意味着这个回话能否发起新连接。         |

**SSL 连接状态**

| 数据项                   | 说明                                                         |
| ------------------------ | ------------------------------------------------------------ |
| server and client random | 服务端和客户端给每个连接选取的字节序列，用于生成秘钥。       |
| server write MAC key     | 服务端每次写入数据时在MAC操作中所用的秘钥。                  |
| client write MAC key     | 客户端每次写入数据时在MAC操作中所用的秘钥。                  |
| server write key         | 服务端加密数据、客户端解密数据所用的秘钥。                   |
| client write key         | 客户端加密数据、服务端解密数据所用的秘钥。                   |
| initialization vectors   | 如果有CBC 模式的块密码用于数据加密，每个秘钥都要维护一个初始向量IV 。这个字段由 SSL 握手协议初始化，之后每个SSL 记录的最后一个密文块用作下一个记录的IV 。 |
| sequence numbers         | 客户端和服务端对特定连接都要维护发送或接收消息的序列号。每个序列号长度为64 比特，范围从 0 到 $2^{64} - 1$。 一旦发送或接收到 `CHANGECIPHERSPEC` 消息就要把序列号置零。 |

SSL 协议单独维护四种状态：`pending`和`current`、`write`和`rend`构成四种状态。`CHANGECIPHERSPEC`消息会触发状态转变，规则如下：

- 发送`CHANGECIPHERSPEC`消息时，要把`pending write`状态复制到`current write`状态。`read`状态不改变。
- 接收到`CHANGECIPHERSPEC`消息时，要把`pending read`状态复制到`current read`状态，`write`状态不改变。

### 秘钥生成

握手过程中利用公钥进行身份认证，并生成对称秘钥。先利用密钥交换算法生成 48 字节的预主密 (premaster secret)，之后利用预主密、双方产生的两个随机数（`ClientHello.random` 和`ServerHello.random`）生成主密，保存在会话状态中。一旦主密已经生成，预主密就从内存中安全删除。

![image-20211201203131246](image-20211201203131246.png)

‘+’指的是连接运算，SHA指的是SHA-1 函数，‘A’,’BB’,’CCC’指的是0x41, 0x4242, 0x434343，由于MD5 的哈希值是 16 字节，最终得到 48 字节的主密 master secret。

SSL 协议有三种秘钥交换算法（RSA、Diffie-Hellman、FORTEZZA），但是从预主密计算主密的过程都是一样的。

得到主密以后，利用主密和客户端服务端双方的随机数加盐填充其他加密参数和秘钥。

- client_write_MAC_secret
- server_write_MAC_secret
- client_write_key
- server_write_key
- client_write_IV
- server_write_IV

计算公式和主密计算十分相似，一次迭代增加16 字节，直到长度足够填充剩余6 个字段。MD5 哈希函数的输出截断到合适的大小，丢弃低位。

![image-20211201205152954](image-20211201205152954.png)

### 握手协议

握手协议负责在客户端和服务器之间建立起安全会话，在这个过程中双方彼此认证身份、协商密码组和压缩方式等参数。

握手过程的消息流如图所示。

![image-20211201184912236](image-20211201184912236.png)

握手协议的过程中客户端和服务器之间交换四组消息，每一组都通过单独的TCP分组来传输。除去典型的四组消息之外，还有服务器发送给客户端来发起SSL 握手的`HELLOREQUEST`消息(type 0)，但这个消息实际中很少使用。不论是四组消息还是五组消息的握手模式，这些消息都必需按照规定的顺序发送。

- 第一组消息：客户端向服务器发送`CLIENTHELLO`消息(type 1)。
- 服务端向客户端发送第二组消息，包含2-5条消息。

  1. `SERVERHELLO`消息(type 2) 作为对`CLIENTHELLO`消息的回应。
  2. 如果服务器要认证自己的身份，会向客户端发送一条`CERTIFICATE`消息(type 11)。通常都会发送服务器证书。
  3. 有时服务器会发送`SERVERKEYEXCHANGE`消息(type 12)
  4. 如果服务器要求客户端认证身份会向客户端发送`CERTIFICATEREQUEST`消息(type 13)。
  5. 服务端最终发送`SERVERHELLODONE`消息(type 14)。

  在交换了`CLIENTHELLO`和`SERVERHELLO`之后，客户端和服务器就已经协商好了协议版本、会话ID、密码组和压缩方式。同时还生成了两个随机数`CLIENTHELLO.random`和`SERVERHELLO.random`，将用于生成秘钥。

- 客户端向服务器发送第三组消息，包含3-5条消息。

  1. 如果服务器要求客户端认证身份（发送了`CERTIFICATEREQUEST`消息），客户端就要发送`CERTIFICATE`消息(type 11) 给服务器，提供客户端的证书。
  2. 客户端发送`CLIENTKEYEXCHANGE`消息(type 16) 给服务器，这是协议中主要的一步。这条消息的内容依选用的密钥交换算法而不同。
  3. 如果客户端给服务器发送了证书，也必须发送一条`CERTIFICATEVERIFY`消息(type 15) 。这条消息包含用证书的公钥所对应私钥签发的数字签名。
  4. 客户端给服务器发送一条`CHANGECIPHERSPEC`消息（这不是握手协议中的消息类型，而是一条Change Cipher Spec Protocol的消息，content type = 20）。之后把客户端的`pending write`会话状态复制到`current write`会话状态。
  5. 客户端发送一条`FINISHED`消息(type 20)。`FINISHED`是第一条使用新密码组加密的消息。

- 服务端向客户端发送第四组消息（包含2 条消息）：

  1. 服务器向客户端发送另一条`CHANGECIPHERSPEC`消息，并把服务器的`pending write`会话状态复制到`current write`会话状态。
  2. 最后，服务器发送`FINISHED`消息(type 20) 。这条消息也是使用新的密码组加密。

到此为止，SSL/TLS 握手过程结束，通信过程由 Application Data Protocol 接手，让客户端和服务器之间传输应用数据。

## RSA 算法

[RSA算法原理（一） - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2013/06/rsa_algorithm_part_one.html): <https://www.ruanyifeng.com/blog/2013/06/rsa_algorithm_part_one.html>

[RSA算法原理（二） - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2013/07/rsa_algorithm_part_two.html): <https://www.ruanyifeng.com/blog/2013/07/rsa_algorithm_part_two.html>

[25行代码实现完整的RSA算法_北門大官人的博客-CSDN博客_rsa算法代码](https://blog.csdn.net/bian_h_f612701198412/article/details/79358771): <https://blog.csdn.net/bian_h_f612701198412/article/details/79358771>

[GPG入门教程 - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2013/07/gpg.html): <https://www.ruanyifeng.com/blog/2013/07/gpg.html>

# 数字证书

数字证书是用于公钥基础设施建设的电子文件，用来证明公钥拥有者的身份。这个文件包含了公钥信息、拥有者身份信息、以及[数字证书认证机构](https://zh.wikipedia.org/wiki/数字证书认证机构)（发行者）对这份文件的数字签名，如果信任签发证书的机构就可以信任证书上的公钥，通过公钥建立与证书主体的安全通信。

使用者通过信任数字证书认证机构的[根证书](https://zh.wikipedia.org/wiki/根证书)、使用包含公钥的数字证书与证书主体通信，形成一个信任链架构。这也是互联网安全协议 TLS 的基本思路，驱动了HTTPS、SMTPS等诸多应用层应用。

基于数字证书的安全通信，其优势之一就是证书主体不必过度披露个人敏感信息即可证实自己的身份，对网络通信双方都有好处。

## 证书种类

**根证书**是数字证书身份认证体系中最重要的一种证书，它由公认的权威机构签发，比如政府机关、证书签发机构（[DigiCert](https://zh.wikipedia.org/wiki/DigiCert)等）、非营利组织（如[Let's Encrypt](https://zh.wikipedia.org/wiki/Let's_Encrypt)）等，与各大软件商通过严谨的认证程序最终被部署到各种软件上。根证书通常已预装在操作系统、浏览器等软件中。根证书签发和部署复杂，获得广泛认可，一张根证书的有效期可能长达 20 年以上。有的企业也会在内部安装自签的根证书一直吃内部网络的企业级应用，但这种证书不被广泛认可，仅限内部使用。

除此以外还有用于小范围测试的自签证书、中介证书、授权证书、终端实体证书、通配符证书、TLS 服务器证书、TLS 客户端证书。

| 证书类型       | 说明                                                         |
| -------------- | ------------------------------------------------------------ |
| 中介证书       | 数字证书认证机构负责为客户签发证书，一般这类权威机构都有自己的根证书，根证书对应的私钥即可签发其他证书。但出于秘钥管理和行政的角度考虑，会先签发各种中介证书，根据客户的类别使用不同的中介证书来为客户签发证书。中介证书的有效期碧根证书短。 |
| 授权证书       | 授权证书本身没有公钥，必须依附于一份有效的数字证书才有意义，因此又叫做属性证书。授权证书的作用是赋予签发终端实体证书的权力，如果在短期内授予证书机构签发权力，就使用授权证书，而不会改变机构本身所有证书的有效期。 |
| 终端实体证书   | 其他不具有签发其他证书权力的证书都是终端实体证书。终端实体证书在实际的软件中部署，以便创建安全通信。 |
| 通配符证书     | 如果服务器证书上通用名称（或主题别名）有通配符前缀，该证书就可以用于旗下所有子域名。适合具有一定规模或拥有多个子网站的机构一次性申领，用于多个服务器上，即使未来创建新的子域名也可以使用。但是通配符不能用在拓展认证证书上。 |
| TLS 服务器证书 | 提供网络服务的服务器，其证书上的通用名称是提供服务的域名。服务器证书和私钥都安装在服务器上，用于客户端请求连接时进行身份认证和协商加密细节，如果客户端浏览器未能确定加密通道的安全性例如证书上的主体名称不对应网站域名、服务器使用了自签证书、或加密算法不够强），就会敬告用户。 |
| TLS 客户端证书 | 有些 TLS 服务器可能会要求客户端提供客户端证书。客户端证书包含邮件地址或个人姓名等，而不是主机名。客户端证书较为少见（受到技术和成本的限制），通常都是服务提供者负责验证客户身份。通常使用客户端证书的是企业内部应用，技术团队设立自己的根证书、在内部设备上安装客户端证书。 |
|                |                                                              |

## 审核级别

数字证书根据验证级别分为DV （域名验证）、OV（组织炎症）、EV（扩展验证）三种，越高级别的证书需要越严格的审核流程、需要付出更高昂的费用。

### 域名验证 （DV）

域名验证是最基本的审核级别，用于证明申领者拥有某域名的权利。认证机构通常自动审核域名拥有权，因此成本较低。

### 组织验证 （OV）

组织验证证明域名所有权的同时，保证相关组织是实际存在的法人。

### 扩展验证 （EV）

扩展验证是最严格的审核级别，审核过程可能涉及专业法律人员的调查及独立审计人员的确认，成本也自然更高。成功获得扩展验证证书的网站，浏览器通常会在地址栏以绿色标识相关机构的法人名称以及所属国家代码。扩展验证证书的主体名称或主体别名上不可以有通配符。

## 证书内容

数字证书内容遵守[X.509](https://zh.wikipedia.org/wiki/X.509)格式规范，它们以字段的方式表示[[12\]](https://zh.wikipedia.org/wiki/公開金鑰認證#cite_note-12)：

- **版本**：现行通用版本是 V3
- **序号**：用以识别每一张证书，特别在撤消证书的时候有用
- **[主体](https://zh.wikipedia.org/wiki/法律主體)**：拥有此证书的法人或自然人身份或机器，包括：
  - **国家**（C，Country）
  - **州/省**（S，State）
  - **地域/城市**（L，Location）
  - **组织/单位**（O，Organization）
  - **通用名称**（CN，Common Name）：在[TLS](https://zh.wikipedia.org/wiki/TLS)应用上，此字段一般是域名
- **[发行者](https://zh.wikipedia.org/wiki/数字证书认证机构)**：以数字签名形式签署此证书的数字证书认证机构
- **有效期开始时间**：此证书的有效开始时间，在此前该证书并未生效
- **有效期开始时间**：此证书的有效开始时间，在此前该证书并未生效
- **有效期结束时间**：此证书的有效结束时间，在此后该证书作废
- **公开密钥用途**：指定证书上公钥的用途，例如数字签名、服务器验证、客户端验证等
- **[公开密钥](https://zh.wikipedia.org/wiki/公開金鑰加密)**
- **[公开密钥指纹](https://zh.wikipedia.org/wiki/公开密钥指纹)**
- **[数字签名](https://zh.wikipedia.org/wiki/數位簽章)**
- **[主体别名](https://zh.wikipedia.org/w/index.php?title=主體別名&action=edit&redlink=1)**：例如一个网站可能会有多个域名（<www.wikipedia.org>, zh.wikipedia.org, zh.m.wikipedia.org 都是[维基百科](https://zh.wikipedia.org/wiki/維基百科)）、一个组织可能会有多个网站（*.wikipedia.org, *.wikibooks.org, *.wikidata.org 都是[维基媒体基金会](https://zh.wikipedia.org/wiki/維基媒體基金會)旗下的网域），不同的域名可以一并使用同一张证书，方便实现应用及管理

数字证书可以以二进制或Base64格式存储，常见的文件拓展名有 .cer、.crt、.der和.pem。如果把证书和私钥一起存储，则可以使用PKCS#12（.p12）格式。

- DER用于二进制DER编码的证书。
- PEM用于不同类型的X.509v3文件，是以“ - BEGIN ...”前缀的ASCII（Base64）数据。
- CER和CRT几乎同义，证书可以被编码为二进制DER或ASCII PEM。
- PKCS7 文件，也被称为 P7B，通常用于 Java Keystores 和 [Microsoft IIS](https://zh.wikipedia.org/wiki/Microsoft_IIS)（Windows）。它们是 ASCII 文件，可以包含证书和 CA 证书。
- PKCS12 文件，也被称为 PFX 文件，通常用于在 Micrsoft IIS（Windows）中导入和导出证书链。
