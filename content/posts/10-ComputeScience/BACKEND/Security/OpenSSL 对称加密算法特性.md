原文链接：[http://chenxuhua.com/blog/openssl-crypto-method/](http://chenxuhua.com/blog/openssl-crypto-method/)

---

在选择加密算法，面对一大长串的选项时，大家都有这样的疑问，究竟哪种加密方式是最好的呢？

对于加密方式、算法来说，一般安全性与性能呈负相关，越是安全的，对性能要求则更高。

现在主流的加密协议的安全性均能达到标准，因此这里主要讨论的最好便是加密性能的优良。

对于 OpenSSL 而言，有三种常见的加密方式：RC4、AES、ChaCha。

单看这三种加密方式，都是非常具有代表性，可以说每种都有优缺点。

# AEAD

在传统的对称加密协议中，最大的缺陷就是没有对数据包完整性进行校验，再加上流加密的特点，导致了攻击者可以通过穷举的方式修改密文进行基于服务器行为的主动探测。

在通常的密码学应用中，Confidentiality（保密）用加密实现，消息认证用 MAC（Message Authentication Code，消息验证码）实现。这两种算法的配合方式，引发了很多安全漏洞，过去曾经有 3 种方法：

1. Encrypt-and-MAC (E&M)
2. MAC-then-Encrypt (MtE) <- 即 OTA 的做法
3. Encrypt-then-MAC (EtM) <- 新协议的做法

然而后来人们发现，E&M 和 MtE 都是有安全问题的，所以 2008 年起， 逐渐提出了「用一个算法在内部同时实现加密和认证」的反法，称为 AEAD (Authenticated Encryption with Associated Data)。在 AEAD 这种概念里，`cipher + MAC` 的模式被一个 AEAD 算法替换。

使用了 AEAD 算法的新协议本质上就是更完善的 `stream cipher + authentication`，虽然它依然使用的是流加密（StreamCipher），但是通过更完善的**数据包完整性验证**机制杜绝了上面所述的可被篡改密文的可能性。

目前以下加密方式支持 AEAD 算法：

- AES-128-GCM
- AES-192-GCM
- AES-256-GCM
- ChaCha20-IETF-Poly1305
- XChaCha20-IETF-Poly1305

但如果是用在路由器上，因为很多路由器 CPU 速度都在 500MHz 以下，并且不支持 AES 硬解，因为在路由器等计算能力弱的设备上使用 AES 加密方式会造成性能影响，所以，之前使用在路由器上的加密方式一般都选 ChaCha20 算法或 RC4-MD5 （特别是 MIPS 架构的处理器）。

# 性能

支持 AES 指令集情况下：

- 更快（Fast）
- RC4-MD5
- AES-256-CFB
- AES-256-GCM
- ChaCha20
- ChaCha20-IETF-Poly1305
- XChaCha20-IETF-Poly1305
- 更慢（Slow）

不支持 AES 指令集情况下：

- 更快（Fast）
- RC4-MD5
- ChaCha20
- ChaCha20-IETF-Poly1305
- XChaCha20-IETF-Poly1305
- AES-256-CFB
- AES-256-GCM
- 更慢（Slow）

在各类处理器的测试数据：

| Chip | AES-128-GCM 速度 | ChaCha20-Poly1305 速度 |
| --- | --- | --- |
| OMAP 4460 | 24.1 MB/s | 75.3 MB/s |
| Snapdragon S4 Pro | 41.5 MB/s | 130.9 MB/s |
| Sandy Bridge Xeon (AES-NI) | 900 MB/s | 500 MB/s |

# RC4 加密

速度最快，加密简单易破解，适合内网、低性能设备，推荐使用 RC4-MD5。

- RC4-MD5：使用 RC4 加密 MD5 校验。

# AES 加密

块加密算法，兼顾效率和安全，适合在拥有 AES 指令集的 CPU 上，推荐使用 AES-256-GCM 。

| 区别 | AES-XXX-CFB | AES-XXX-CTR | AES-XXX-GCM |
| --- | --- | --- | --- |
| 区别 | 仅加密 | 仅加密 | 加密+消息完整性校验 |
| 优点 | 加密可并行 | 加密解密均可并行计算 | 加密解密均可并行计算 |
| 缺点 | 解密串行 |  |  |

- AES-256-CFB：密码反馈模式（Cipher FeedBack Mode），仅加密无完整性校验。
- AES-256-CTR：计算器模式（Counter Mode），仅加密无完整性校验。
- AES-256-GCM：伽罗瓦 / 计数器模式（Galois / Counter Mode）支持 AEAD 认证加密，同时完成加密和完整性校验。

# ChaCha 加密

新型的流加密算法，兼顾效率和安全，适合在没有 AES 指令集的 CPU 上，效率比 AES 高，推荐使用 XChaCha20-IETF-Poly1305 。

- ChaCha20：Salsa20 算法的改良，仅加密无完整性校验。
- ChaCha20-IETF-Poly1305：支持 AEAD 认证加密，同时完成加密和完整性校验。
- XChaCha20-IETF-Poly1305：是前者的升级版，拥有更大的随机数以防碰撞攻击，支持 AEAD 认证加密，同时完成加密和完整性校验。

# 总结

- 在具备 AES 加速的 CPU（例如桌面、服务器）上，建议使用 AES-256-GCM 系列。
- 在移动设备（例如手机、路由器等非 x86 架构的 CPU）上则建议使用 ChaCha20-IETF-Poly1305 系列。
- 如果你是在内网（LAN 或 IPLC 线路）使用，则不必过多担心安全性问题，RC4-MD5 加密协议将是非常节省性能的选择。

文章来自：[chenxuhua.com](http://chenxuhua.com)
