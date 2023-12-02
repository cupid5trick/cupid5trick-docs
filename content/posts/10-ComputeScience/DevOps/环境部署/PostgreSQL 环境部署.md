---
title: PostgreSQL 环境部署
author: cupid5trick
created: 2023-03-27 14:12
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




# Centos 7

[PostgreSQL: Downloads](https://www.postgresql.org/download/): <https://www.postgresql.org/download/>

通过 postgreSQL 官方 rpm 源下载。

```bash
sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm  
sudo yum install -y postgresql13-server  
sudo /usr/pgsql-13/bin/postgresql-13-setup initdb  
sudo systemctl enable postgresql-13  
sudo systemctl start postgresql-13
```

直接下载手动安装。

[RPM Chart - PostgreSQL YUM Repository](https://yum.postgresql.org/rpmchart/): <https://yum.postgresql.org/rpmchart/>

# 管理与配置

PostgreSQL 的配置文件在数据库的数据目录，一般是 `/var/lib/pgsql/13/data/` 。例如 `postgresql.conf` `pg_hba.conf` 。

运行 PostgreSQL 的命令需要使用 postgres 用户，可以通过 `sudo -u postgres` 解决。例如创建一个 `cq_ods` 数据库，然后连接到该数据库：
```bash
sudo -u postgres /usr/pgsql/13/bin/createdb cq_ods
sudo -u postgres psql cq_ods
```

[16. Installation from Binaries](https://www.postgresql.org/docs/current/install-binaries.html)

[17. Installation from Source Code](https://www.postgresql.org/docs/current/installation.html)

[18. Installation from Source Code on Windows](https://www.postgresql.org/docs/current/install-windows.html)

[19. Server Setup and Operation](https://www.postgresql.org/docs/current/runtime.html)

[20. Server Configuration](https://www.postgresql.org/docs/current/runtime-config.html)

# 在 ClickHouse 使用 PostgreSQL 表引擎

[Connecting ClickHouse to PostgreSQL | ClickHouse Docs](https://clickhouse.com/docs/en/integrations/postgresql): <https://clickhouse.com/docs/en/integrations/postgresql>

# PostgreSQL 迁移到 ClickHouse

[scottpersinger/pgwarehouse: Easily sync your Postgres database to a Snowflake or Clickhouse warehouse](https://github.com/scottpersinger/pgwarehouse): <https://github.com/scottpersinger/pgwarehouse>
