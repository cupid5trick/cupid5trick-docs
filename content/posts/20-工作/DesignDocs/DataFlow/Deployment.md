---
scope: work
draft: true
---
# dataflow-deploy
 Dataflow 测试环境部署文档。



# 软件版本

|             | 版本            | 下载地址 |
| ----------- | --------------- | -------- |
| oracle jdk | jdk-8u321 | [jdk-8u301-linux-x64.tar.gz](https://download.oracle.com/otn/java/jdk/8u301-b09/d3c52aa6bfa54d3ca74e617f18309292/jdk-8u301-linux-x64.tar.gz) |
| scala | Scala code runner version 2.12.10 -- Copyright 2002-2019, LAMP/EPFL and Lightbend, Inc. (scala -version). | [All Available Versions - The Scala Programming Language](https://www.scala-lang.org/download/all.html) |
| mysql | 5.7.37 | [MySQL :: Download MySQL Community Server (Archived Versions)](https://downloads.mysql.com/archives/community/) |
| redis | Redis server v=6.2.6 sha=00000000:0 malloc=jemalloc-5.1.0 bits=64 build=1527eab61b27d3bf | [Index of /releases/](https://download.redis.io/releases/) |
| clickhouse | ClickHouse server version 21.10.2.15 (official build). | [ClickHouse - Fast Open-Source OLAP DBMS](https://clickhouse.com/#quick-start) |
| hadoop | 2.7.3 | [Index of /dist/hadoop/common](https://archive.apache.org/dist/hadoop/common/) |
| spark | 3.0.0-bin-hadoop2.7 | [Index of /dist/spark](https://archive.apache.org/dist/spark/) |
| hudi | 0.9.0 | [Download - Apache Hudi](https://hudi.apache.org/releases/download) |
| python | 3.7.10 | https://www.python.org/ftp/python/3.7.10/Python-3.7.10.tgz |
| airflow | airflow version 2.3.2. | [Running Airflow locally — Airflow Documentation](https://airflow.apache.org/docs/apache-airflow/stable/start/local.html) |
|             |                 |          |







# ClickHouse

## 通过 tgz 压缩包安装

在 centos7.9.2009 镜像中用 yum 安装 ClickHouse 之后无法启动，所以改为使用 tgz压缩包安装。

```bash
curl -O "https://packages.clickhouse.com/tgz/stable/clickhouse-common-static-21.10.5.3.tgz"
curl -O "https://packages.clickhouse.com/tgz/stable/clickhouse-common-static-dbg-21.10.5.3.tgz"
curl -O "https://packages.clickhouse.com/tgz/stable/clickhouse-server-21.10.5.3.tgz"
curl -O "https://packages.clickhouse.com/tgz/stable/clickhouse-client-21.10.5.3.tgz"

tar -xzvf "clickhouse-common-static-21.10.5.3.tgz"
tar -xzvf "clickhouse-common-static-dbg-21.10.5.3.tgz"
tar -xzvf "clickhouse-server-21.10.5.3.tgz"
tar -xzvf "clickhouse-client-21.10.5.3.tgz"

"clickhouse-common-static-21.10.5.3/install/doinst.sh"
"clickhouse-common-static-dbg-21.10.5.3/install/doinst.sh"
"clickhouse-server-21.10.5.3/install/doinst.sh"
/etc/init.d/clickhouse-server start
"clickhouse-client-21.10.5.3/install/doinst.sh"

vim /etc/clickhouse-server/config.xml

## 调试 clickhouse 启动
su -s /bin/sh 'clickhouse' -c '/usr/bin/clickhouse-server --config-file /etc/clickhouse-server/config.xml --pid-file /var/run/clickhouse-server/clickhouse-server.pid'
```



## 配置文件

主要修改 监听 IP 和数据路径

```xml
<yandex>
    <logger>
        <level>trace</level>
        <log>/var/log/clickhouse-server/clickhouse-server.log</log>
        <errorlog>/var/log/clickhouse-server/clickhouse-server.err.log</errorlog>
        <size>1000M</size>
        <count>10</count>
    </logger>
    <listen_host>192.168.153.129</listen_host>
   	<http_port>8123</http_port>
    <tcp_port>9000</tcp_port>
    <mysql_port>9004</mysql_port>
    <postgresql_port>9005</postgresql_port>
    <interserver_http_port>9009</interserver_http_port>
    <path>/var/lib/clickhouse-server/</path>
    <tmp_path>/var/lib/clickhouse/tmp/</tmp_path>
</yandex>
```







## 迁移数据

[记一次 ClickHouse 数据迁移 - 知乎](https://zhuanlan.zhihu.com/p/220172155)

记录一下 ClickHouse 迁移数据的几种方法。网络上总结的一般有四种方法：

- 拷贝数据目录。需要对ClickHouse数据目录有一定了解，风险比较大，但是熟悉之后比较方便。
- remote 表函数。需要提前建表才能 SELECT INTO，手工操作比较多。
- ClickHouse-copier。官方比较推荐，安装了ClickHouse的机器上都有这个程序，功能也很强大。
- ClickHouse-backup。社区贡献的工具，可以像MySQL的mysqldump一样工作，需要下载且仅支持MergeTree系列的表。

### 拷贝数据目录

使用这种方法需要先了解一下 ClickHouse 数据目录的结构。例如 `/var/lib/clickhouse-server/`，需要关注的是 `data`、`metadata`、`store` 这三个文件夹。

可以使用 tree 命令查看一下目录结构：

```bash
tree -L 3 data metadata
data
├── dataflow
│   ├── car_sales_transactions -> /var/lib/clickhouse/store/7bb/7bb8b615-3756-4941-bbb8-b61537569941/
│   └── promotion_leases_transactions -> /var/lib/clickhouse/store/ad6/ad673427-ff04-4512-ad67-3427ff041512/
├── default
│   ├── 016c651c%2D75a5%2D4cf2%2D80e0%2D16d31bc2647d -> /var/lib/clickhouse/store/b36/b36c6a0d-7a51-427a-b36c-6a0d7a51927a/
│   ├── 0557354f%2De2ec%2D4e5e%2Dbb0d%2D06704c959156 -> /var/lib/clickhouse/store/54e/54eda3ba-075d-40e9-94ed-a3ba075dc0e9/
......
metadata
├── default -> /var/lib/clickhouse/store/86a/86ac973e-36e2-443c-86ac-973e36e2643c/
├── default.sql
├── system -> /var/lib/clickhouse/store/379/3798dce3-3258-4497-b798-dce33258d497/
├── system.sql
├── test -> /var/lib/clickhouse/store/01b/01b73247-ad9f-4a59-81b7-3247ad9f1a59/
└── test.sql
......
```

- `data` 目录是按照 `<database>/<table>` 组织的，通过软连接指向 `store` 目录，保存表数据。
- `metadata` 目录也是同样的结构，只是数据库的目录下面以同名的 `.sql` 文件保存了建库和建表的 DDL 语句，建表的 `.sql` 文件放在软连接指向的 `store` 目录下。



这样一来在迁移数据是就只需要拷贝这两个目录，复制完以后重启一下目标机器的ClickHouse服务端就可以了。但是要小心处理软连接，一旦数据目录下错误的链接和正常数据文件混杂就比较难解决了。

操作流程如下：

1. 在源集群的硬盘上打包好对应数据库或表的 data 和 metadata 数据
2. 拷贝到目标集群对应的数据目录
3. 重启 clickhouse-server

尝试过的一种方式是 tar 命令，其他的 cp 等命令应该也有相应的功能。把 data和metadata 目录打包到 clickhoue_data.tgz（使用 gzip方式压缩），同时通过 -h 参数跟踪软连接。

```bash
cd /var/lib/clickhouse-server
tar -zcpvhf /root/clickhouse_data.tgz data metadata
```





### remote 表函数

ClickHouse 除了查询常规的表，还能使用表函数来构建一些特殊的「表」，其中 [remote 函数](https://link.zhihu.com/?target=https%3A//clickhouse.tech/docs/en/sql-reference/table-functions/remote/) 可用于查询另一个 ClickHouse 的表。

使用方式很简单:

```sql
SELECT * FROM remote('addresses_expr', db, table, 'user', 'password') LIMIT 10;
```

因此，可以借助这个功能实现数据迁移：

```sql
INSERT INTO <local_database>.<local_table>
SELECT * FROM remote('remote_clickhouse_addr', <remote_database>, <remote_table>, '<remote_user>', '<remote_password>')
```

使用 `remote` 函数还能实现更多特性：

- 对于分区表，可逐个分区进行同步，这样实际上同步的最小单位是分区，可以实现增量同步
- 可方便集成数据完整性（行数对比）检查，自动重新同步更新过的表

操作流程

1. 在源集群的 `system.tables` 表查询出数据库、表、DDL、分区、表引擎等信息
2. 在目标集群上，运行 DDL 创建表，然后运行上述迁移语句复制数据
3. 遍历所有表，执行 2



### ClickHouse copier

[Clickhouse-copier in practice – Altinity | The Real Time Data Company](https://altinity.com/blog/2018/8/22/clickhouse-copier-in-practice)



[Clickhouse-copier](https://link.zhihu.com/?target=https%3A//clickhouse.tech/docs/en/operations/utilities/clickhouse-copier/) 是 ClickHouse 官方提供的一款数据迁移工具，可用于把表从一个集群迁移到另一个（也可以是同一个）集群。Clickhouse-copier 使用 Zookeeper 来管理同步任务，可以同时运行多个 clickhouse-copier 实例。

使用方式:

```bash
clickhouse-copier --daemon --config zookeeper.xml --task-path /task/path --base-dir /path/to/dir
```

其中 `--config zookeeper.xml` 是 Zookeeper 的连接信息，`--task-path /task/path` 是 Zookeeper 里任务配置的节点路径。在使用时，需要先定义一个 XML 格式的任务配置文件，上传到 `/task/path/description` 里。同步任务是表级别的，可以配置的内容还比较多。Clickhouse-copier 可以监听 `/task/path/description` 的变化，动态加载新的配置而不需要重启。

操作流程

1. 创建 `zookeeper.xml`
2. 创建任务配置文件，格式见官方文档，每个表都要配置（可使用代码自动生成）
3. 把配置文件内容上传到 Zookeeper
4. 启动 clickhouse-copier 进程

理论上 clickhouse-copier 运行在源集群或目标集群的环境都可以，官方文档推进在源集群，这样可以节省带宽。

### ClickHouse bakcup

[clickhouse-backup](https://link.zhihu.com/?target=https%3A//github.com/AlexAkulov/clickhouse-backup) 是社区开源的一个 ClickHouse 备份工具，可用于实现数据迁移。其原理是先创建一个备份，然后从备份导入数据，类似 MySQL 的 mysqldump + SOURCE。这个工具可以作为常规的异地冷备方案，不过有个局限是只支持 MergeTree 系列的表。

操作流程

1. 在源集群使用 `clickhouse-backup create` 创建备份
2. 把备份文件压缩拷贝到目标集群
3. 在目标集群使用 `clickhouse-backup restore` 恢复





# Redis

[CentOS 7 源码编译安装 Redis - 晓晨Master - 博客园](https://www.cnblogs.com/stulzq/p/9288401.html)

## 编译安装 redis-6.2.6

```bash
yum groupinstall -y "Development Tools"
yum install -y gcc gcc-c++ kernel-devevl
cd /usr/local/redis-6.2.6
make
make PREFIX=/opt/redis install

ln -s /opt/redis/bin/redis-server /usr/bin/redis-server; \
ln -s /opt/redis/bin/redis-cli /usr/bin/redis-cli

# 启动 redis
redis-server redis.conf
```



## 配置文件

主要修改 监听的 IP和端口，数据路径、连接密码。

```
appendonly yes
bind 192.168.153.129
port 6379
dir /var/lib/redis
pidfile /var/run/redis_6379.pid
logfile "/var/log/redis/redis.log"
requirepass bdilab@1308

```



使用 命令行连接 redis

```bash
redis-cli -a bdilab@1308
```





# MySQL



[linux shell脚本 mysql多行命令执行_willa要努力奋斗的博客-CSDN博客_linux mysql 多行](https://blog.csdn.net/u014295667/article/details/46966293#:~:text=%E5%9C%A8linux%E7%BB%88%E7%AB%AF%E6%89%A7%E8%A1%8Cmysql%E5%91%BD%E4%BB%A4%E6%97%B6%EF%BC%8C%E9%A6%96%E5%85%88%E9%9C%80%E8%A6%81%E4%BB%8E%E7%BB%88%E7%AB%AF%E8%BF%9B%E5%85%A5%E5%88%B0mysql%E5%91%BD%E4%BB%A4%E8%A1%8C%E7%8A%B6%E6%80%81%EF%BC%8C%E5%9C%A8%E8%84%9A%E6%9C%AC%E7%BC%96%E5%86%99%E6%97%B6%EF%BC%8C%E8%A6%81%E7%94%A8%E5%88%B0EOF%EF%BC%88end,of%20file%EF%BC%89%E3%80%82)

[学会4种备份MySQL数据库（基本备份方面没问题了） - 数据帝 - 博客园](https://www.cnblogs.com/SQL888/p/5751631.html#:~:text=MySQL%E5%A4%87%E4%BB%BD%E6%95%B0%E6%8D%AE%E7%9A%84%E6%96%B9%E5%BC%8F%201%20MyISAM%20%E7%83%AD%E5%A4%87%20%C3%97%20%E6%B8%A9%E5%A4%87%20%E2%88%9A%20%E5%86%B7%E5%A4%87,%E8%BE%BE%E5%88%B0%E5%A4%87%E4%BB%BD%E7%9A%84%E6%95%88%E6%9E%9C%20%E9%80%BB%E8%BE%91%E5%A4%87%E4%BB%BD%E4%B8%80%E8%88%AC%E5%B0%B1%E6%98%AF%20%E9%80%9A%E8%BF%87%E7%89%B9%E5%AE%9A%E5%B7%A5%E5%85%B7%E4%BB%8E%E6%95%B0%E6%8D%AE%E5%BA%93%E4%B8%AD%E5%AF%BC%E5%87%BA%E6%95%B0%E6%8D%AE%E5%B9%B6%E5%8F%A6%E5%AD%98%E5%A4%87%E4%BB%BD%20%28%E9%80%BB%E8%BE%91%E5%A4%87%E4%BB%BD%E4%BC%9A%E4%B8%A2%E5%A4%B1%E6%95%B0%E6%8D%AE%E7%B2%BE%E5%BA%A6%29%203%20%E7%89%A9%E7%90%86%E5%A4%87%E4%BB%BD%204%20%E9%80%BB%E8%BE%91%E5%A4%87%E4%BB%BD)

[MySQL mysqldump备份数据库（附带实例）](http://c.biancheng.net/view/7373.html)

[MySql 中文文档 - 4.3.3 mysql.server — MySQL 服务器启动脚本 | Docs4dev](https://www.docs4dev.com/docs/zh/mysql/5.7/reference/mysql-server.html)

[mysql生产环境安装部署配置（专业版） - 腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1785872)

```bash
mysqldump -uroot -pbdilab@1308 -h 172.31.121.149 --databases dataflow >/root/dataflow/mysql_dump.sql
```



## 从二进制文件的压缩包安装



```bash
# 把MySQL 解压到/opt/mysql57
tar -zxvf mysql-5.7.37-linux-glibc2.12-x86_64.tar.gz -C /opt/
mv /opt/mysql-5.7.37-linux-glibc2.12-x86_64 /opt/mysql57

# 准备用户和MySQL 数据、日志路径，修改权限
groupadd mysql; \
useradd -r -g mysql mysql; \
mkdir -p  /var/lib/mysql; \
chown mysql:mysql -R /var/lib/mysql; \
mkdir -m 755 /var/log/mysql; \
chown mysql:mysql /var/log/mysql;

# 直接初始化时提示缺少 libaio、numa
yum install -y libaio numactl;

ln -s  /opt/mysql57/bin/mysql    /usr/bin/; 
cp /opt/mysql57/support-files/mysql.server /etc/init.d/mysql;
# 把 my.cnf 连接到 mysql/mysqld.cnf，mysql start 时选择默认的my.cnf 配置文件
ln -s /etc/mysql/mysqld.cnf /etc/my.cnf;

# 初始化后生成临时密码
/opt/mysql57/bin/mysqld --defaults-file=/etc/mysql/mysqld.cnf --basedir=/opt/mysql57 --datadir=/var/lib/mysql --user=mysql --initialize
pass=$(grep 'temporary password' /var/log/mysql/mysql.err|tail -n 1)
pass=${pass: -12}

echo "initialized MySQL with temporary password: $pass"

/etc/init.d/mysql start

# 给 root 用户设置新的密码，并允许 root 远程登录
echo 'Begin setting password and PRIVILEGES for root user...'
mysql -uroot -p"$pass" --connect-expired-password <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY 'bdilab@1308' PASSWORD EXPIRE NEVER;
use mysql;     #访问mysql库
update user set host = '%' where user = 'root';   #使root用户能在任何IP进行访问
FLUSH PRIVILEGES;
EOF
echo 'MySQL setup successfully.'

```

## 配置文件

```
[client]
default-character-set=utf8

[mysql]
default-character-set=utf8

[mysqld]

skip-name-resolve
default-time_zone='+8:00'
bind-address=192.168.153.129
port=3306
user=mysql

# mysql安装目录
basedir=/opt/mysql57
# 数据目录
datadir=/var/lib/mysql
socket=/tmp/mysql.sock

## 日志
log_error=/var/log/mysql/mysql.err
server_id=1
log_bin=/var/log/mysql/binlog
#自动删除过期日志的天数
expire_logs_days = 10
#限制单个文件大小
max_binlog_size = 100M
general_log=1
general_log_file=/var/log/mysql/query.log
slow_query_log=1
slow_query_log_file=/var/log/mysql/slow_query.log

pid-file=/var/lib/mysql/mysql.pid

## character config
character_set_server=utf8mb4
symbolic-links=0
explicit_defaults_for_timestamp=true

```





# NginX

[nginx: Linux packages](https://nginx.org/en/linux_packages.html#RHEL-CentOS)

[CentOS 7 下 yum 安装和配置 Nginx - Zhanming's blog](https://qizhanming.com/blog/2018/08/06/how-to-install-nginx-on-centos-7)

## 安装 NginX

## 步骤

### 步骤 1: 添加 yum 源

Nginx 不在默认的 yum 源中，可以使用 epel 或者官网的 yum 源，本例使用官网的 yum 源。

```
$ sudo rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
```

安装完 yum 源之后，可以查看一下。

```
$ sudo yum repolist
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyun.com
 * extras: mirrors.aliyun.com
 * updates: mirrors.aliyun.com
repo id                          repo name                          status
base/7/x86_64                    CentOS-7 - Base                    9,911
extras/7/x86_64                  CentOS-7 - Extras                    368
nginx/x86_64                     nginx repo                           108
updates/7/x86_64                 CentOS-7 - Updates                 1,041
repolist: 11,428
```

可以发现 `nginx repo` 已经安装到本机了。

### 步骤 2: 安装

yum 安装 Nginx，非常简单，一条命令。

```
$ sudo yum install nginx
```

### 步骤 3: 配置 Nginx 服务

设置开机启动

```
$ sudo systemctl enable nginx
```

启动服务

```
$ sudo systemctl start nginx
```

停止服务

```
$ sudo systemctl restart nginx
```

重新加载，因为一般重新配置之后，不希望重启服务，这时可以使用重新加载。

```
$ sudo systemctl reload nginx
```

### 步骤 4: 打开防火墙端口

默认 CentOS7 使用的防火墙 firewalld 是关闭 http 服务的（打开 80 端口）。

```
$ sudo firewall-cmd --zone=public --permanent --add-service=http
success
$ sudo firewall-cmd --reload
success
```

打开之后，可以查看一下防火墙打开的所有的服务

```
$ sudo firewall-cmd --list-service
ssh dhcpv6-client http
```

可以看到，系统已经打开了 http 服务。

### 反向代理

Nginx 是一个很方便的反向代理，配置反向代理可以参考 [Module ngx_http_proxy_module](http://nginx.org/en/docs/http/ngx_http_proxy_module.html) 。本文不做累述。

需要指出的是 CentOS 7 的 SELinux，使用反向代理需要打开网络访问权限。

```
$ sudo setsebool -P httpd_can_network_connect on 
```

打开网络权限之后，反向代理可以使用了。

### 绑定其他端口

Nginx 默认绑定的端口是 http 协议的默认端口，端口号为：`80`，如果需要绑定其他端口，需要注意 SELinux 的配置

例如：绑定 8081 端口，但是会发现无法启动，一般的报错如下

```
YYYY/MM/DD hh:mm:ss [emerg] 46123#0: bind() to 0.0.0.0:8081 failed (13: Permission denied)
```

此时需要更改 SELinux 的设置。我们使用 SELinux 的管理工具 `semanage` 进行操作，比较方便。

安装 `semanage` 使用如下命令

```
$ sudo yum install policycoreutils-python
```

然后查看是否有其他协议类型使用了此端口

```
$ sudo semanage port -l | grep 8081
transproxy_port_t              tcp      8081
```

返回了结果，表明已经被其他类型占用了，类型为 `transproxy_port_t`。

我们还要查看一下 Nginx 的在 SELinux 中的类型 `http_port_t` 绑定的端口

```
$ sudo semanage port -l | grep http_port_t
http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
```

第一行 `http_port_t` 中没有包含 `8081` 这个端口。因此需要修改 `8081` 端口到 `http_port_t` 类型中。

```
$ sudo semanage port -m -p tcp -t http_port_t 8081
```

如果没有其他协议类型使用想要绑定的端口，如 `8001`，则我们只要新增到 SELinux 中即可。

```
$ sudo semanage port -l | grep 8001
$ sudo semanage port -a -p tcp -t http_port_t 8001
```

此时，重新启动 Nginx 即可。



## 配置文件

主要修改前后端应用的 IP、端口，日志位置（error_log、access_log），两个location root。

下面是这些配置项的位置。

```
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

http {
    access_log  /var/log/nginx/access.log  main;
    
    server {
    	listen       80;
        listen       [::]:80;
        server_name  192.168.153.129;

		location / {
            root /opt/dataflow/front/dist_zq;
            index index.html index.htm;
        }
    }
    
    server {
        listen       3333;
        server_name  192.168.153.129;
        location / {
            root  /opt/dataflow/front/dist;
            index index.html index.htm;
        }
    }
}
```





# Airflow

## 编译安装 Python3

Centos7只有自带的Python2.7，所以要手动安装一下Python3。由于 Airflow 只支持 python 3.7-3.10，所以选择了 Python-3.7.10。同时直接使用`yum install`方式安装Python3.6可能会和系统自带的Python 2.7冲突所以采用源代码编译安装方式，如果编译时缺少了依赖的库文件，可能会安装成一个**不完整**的Python环境，且没有错误提示，会导致部分标准Python库无法使用。 步骤如下：

### 安装编译环境

```bash
yum -y groupinstall "Development tools"
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel
```

### 下载python安装包

```bash
wget https://www.python.org/ftp/python/3.7.10/Python-3.7.10.tar.xz
# 解压包
tar -xvf Python-3.7.10.tar.xz
```

### 安装python

```bash
# 进入解压目录
cd Python-3.7.10

# 生成MakeFile
sudo ./configure --prefix=/usr/local/python_3.7.10 --enable-optimizations

# 安装 使用make atinstall避免替换默认的python执行文件
sudo make altinstall
```

### 设置软连接到/user/bin/文件夹

```bash
7sudo ln -s /usr/local/python3.7.10/bin/python3.6 /usr/bin/python3
sudo ln -s /usr/local/python3.7.10/bin/pip3.7 /usr/bin/pip3

## 更新 pip
python3 -m pip install --upgrade --user pip setuptools
```

### pypi 镜像使用帮助 (清华镜像源)

pypi 镜像在每次同步成功后间隔 5 分钟同步一次。

#### 临时使用

```
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple some-package
```

注意，`simple` 不能少, 是 `https` 而不是 `http`

#### 设为默认

升级 pip 到最新的版本 (>=10.0.0) 后进行配置：

```
python -m pip install --upgrade pip
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

如果您到 pip 默认源的网络连接较差，临时使用本镜像站来升级 pip：

```
python -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip
```

### 删除 Python

```bash
rm -f /usr/bin/{python3,pip3};
rm -rf /opt/python_3.7.10;
```



## 安装配置 Airflow

### 部署本体

安装命令解释

[Running Airflow locally — Airflow Documentation](https://airflow.apache.org/docs/apache-airflow/stable/start/local.html)

[Configuration Reference — Airflow Documentation](https://airflow.apache.org/docs/apache-airflow/stable/configurations-ref.html)

```bash

# Install Airflow using the constraints file
AIRFLOW_VERSION=2.3.2
# Airflow needs a home. `~/airflow` is the default, but you can put it
# somewhere else if you prefer (optional)
export AIRFLOW_HOME=/opt/airflow-${AIRFLOW_VERSION}
PYTHON_VERSION="$(python3 --version | cut -d " " -f 2 | cut -d "." -f 1-2)"
# For example: 3.7
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
# For example: https://raw.githubusercontent.com/apache/airflow/constraints-2.3.2/constraints-3.7.txt
python3 -m pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# The Standalone command will initialise the database, make a user,
# and start all components for you.
airflow standalone

# Visit localhost:8080 in the browser and use the admin account details
# shown on the terminal to login.
# Enable the example_bash_operator dag in the home page
```

安装脚本

```bash
AIRFLOW_VERSION=2.3.2
export AIRFLOW_HOME=/opt/airflow-${AIRFLOW_VERSION}
PYTHON_VERSION="$(python3 --version | cut -d " " -f 2 | cut -d "." -f 1-2)"
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"

# 网络问题使用清华镜像下载
python3 -m pip install --proxy 127.0.0.1:10809 "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

airflow standalone
```

Airflow 将创建 $AIRFLOW_HOME 文件夹并使用默认值创建“airflow.cfg”文件，这将使您快速运行。您可以使用环境变量覆盖默认值，请参阅配置参考。

您可以在 $AIRFLOW_HOME/airflow.cfg 中或通过 Admin->Configuration 菜单中的 UI 检查该文件。网络服务器的 PID 文件将存储在 $AIRFLOW_HOME/airflow-webserver.pid 或 /run/airflow/webserver.pid 如果由 systemd 启动。

### 启动和关闭命令

因为每次修改配置文件后都要重新启动 Airflow，这里需要解释一下启动关闭命令。

关闭 Airflow：

每次重启服务必须删除文件夹中的`.pid`文件，因为启动服务时，会优先检查pid是否匹配以执行服务，如果不删除就会报这个错。所以每次关闭都要先 kill 然后 删除 .pid 文件。

> The scheduler does not appear to be running. Last heartbeat was received 5 days ago.
>
> The DAGs list may not update, and new tasks will not be scheduled.



```bash
# 稍微解释一下
# ps 查看进程信息，-e等价于-A 表示全部，-f显示所有列信息
# | 是进程间通信的 “管道”，将上一个进程(此处为 ps -ef的所有输出) 传输给下一个进程 (此处为grep)
# grep是一个文本分析工具 其从接受的输入中匹配后面的模式，此处为匹配所有带"airflow-webserver" 的行
# grep 的-v 意为反向，不带-v即输出匹配到模式内容的行， 带-v即输出没有匹配到模式内容的行，此处为输出不带"grep"的行
# awk awk是一个文本分析工具，他可以把文件逐行的读入，以空格为默认分隔符将每行切片，切开的部分再进行各种分析处理，$2 是指第二个切片。print $2是打印第二个切片的值。
# xargs 命令的作用，是将标准输入转为命令行参数，-i表示将标准输入一行一行传入{}指定的位置，每行执行一次 
ps -ef | grep airflow-webserver | grep -v grep | awk '{print $2}' |xargs -i kill -9 {}

ps -ef | grep airflow-scheduler | grep -v grep | awk '{print $2}' |xargs -i kill -9 {}

# 仔细检查路径，别删除错了 rm -rf命令非常危险
rm -rf /root/airflow/*.pid
```



启动 Airflow：

```bash
airflow scheduler -D
airflow webserver -D
```



### 配置文件



Airflow 默认端口是 8080，需要修改端口。

默认的SQLite 数据库与仅按顺序运行任务实例的 SequentialExecutor 结合使用，无法实现并行化。需要配置MySQL 数据库。

```properties
[core]
# 修改本地执行器
executor = LocalExecutor
# 设置 元数据所用的数据库

sql_alchemy_conn = mysql+mysqlconnector://root:bdilab@1308@47.105.133.193:3306/airflow
# The encoding for the databases
sql_engine_encoding = utf-8
[cli]
endpoint_url = http://localhost:8083
[webserver]
base_url = http://localhost:8083
web_server_host = 0.0.0.0
web_server_port = 8083
default_ui_timezone = Asia/Shanghai

```

### 创建管理员用户

先不要启动airflow，在命令行创建管理员用户。

```bash
# 初始化数据库
airflow db init

# 注意这里 firstname lastname email 都可以随便输入，但是role一定不能错
airflow users create \
    --username admin \
    --password 123456 \
    --firstname z \
    --lastname m \
    --role Admin \
    --email spiderman@superhero.org

# 启动 调度器和web服务器
airflow scheduler -D
airflow webserver -D

```





# 运行 DataFlow



## 修改后端应用配置文件

```
java -jar -Dspring.config.location=/path/to/application.yml start-module.jar
```



## 前端打包



目前 前端源码在 Gitee 仓库 [dataflow-clone: 项目为监测项目和dataflow的整合版](https://gitee.com/xd-bdilab/dataflow-clone)，部署时通过 `npm run build` 生成构建产物，复制到需要部署的机器上即可。

下面是操作流程：

- 进入项目根目录，没有重命名的话就是 dataflow-clone
- 先执行 `npm install` ，然后执行 `npm run build`。构建成功后把build 目录复制为 build_zq。
- 然后构建 子应用，进入 src/dataflow。最好先执行一下 `npm cache clear --force`。
- 同样的方式生成 dataflow的 build目录。

把上面生成的两个目录复制到要部署的机器上，然后在 NginX 配置文件中对应地修改两个 root 路径。

前端项目的简介和注意事项：

1. 这个项目是复用已有create-react-app项目作为主应用，使用飞冰icejs开发的dataflow项目作为子应用。
2. 子应用就是工作区/仪表盘部分，主应用是其他部分
3. 项目的App.js里面registerMicroApps函数中有entry值，如果是本地调试，请改成localhost:3333，如果需要部署，请改成47.104.202.153:3333
4. 推荐node版本 v14(不要太高 可能会报错)
5. 装包:npm install即可(注意进入src/dataflow这个子应用文件夹之后还需npm install一次)，总共2次，不要用cnpm! 会有问题
