---
scope: learn
draft: true
---
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

第四部分（`[ sub_ca_ext ]`、`[ crl_info ]`、`[ issuer_info ]`、`[ name_constraints ]`）提供了根 CA 证书签发其他证书所用的信息。*basicConstraints*  表明所有签发的证书也是 CA ，*但是pathlen* 为 0 意味着签发的证书不允许再签发从属 CA 证书。从属 CA 证书通过 *extended-keyUsage* 和 *nameConstraints* 限制：1. `extended-keyUsage` 的 *clientAuth* 和 *serverAuth* 表明从属 CA 签发的子证书只能用于 TLS 客户端和服务端之间的认证。2. `nameConstraints` 把允许的域名限制在 *example.com* 和 *example.org*。

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

