---
title: ClickHouse 集群
author: cupid5trick
created: 2023-05-04 21:20
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

# 部署配置

# 使用方式

[Distributed Table Engine | ClickHouse Docs](https://clickhouse.com/docs/en/engines/table-engines/special/distributed)

配置 ClickHouse 集群后可以通过 `Distributed` 表引擎使用分布式查询功能。

```SQL
CREATE TABLE IF NOT EXISTS all_hits ON CLUSTER cluster (p Date, i Int32) ENGINE = Distributed(cluster, default, hits)
```

性能问题

## 关于分布式子查询

[IN Operators | ClickHouse Docs](https://clickhouse.com/docs/en/sql-reference/operators/in#distributed-subqueries)

## 关于分布式 Join

# Clickhouse 应用程序热更新

[Self-managed Upgrade | ClickHouse Docs](https://clickhouse.com/docs/en/operations/update#recommended-plan): <https://clickhouse.com/docs/en/operations/update#recommended-plan>
