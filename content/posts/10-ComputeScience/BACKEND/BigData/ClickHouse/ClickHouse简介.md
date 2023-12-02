---
scope: learn
draft: true
---

# ClickHouse 简介

[ClickHouse简介](https://clickhouse.com/docs/en/#what-is-clickhouse)

ClickHouse是一个用于联机分析(OLAP)的列式数据库管理系统(DBMS)。

在传统的行式数据库系统中，数据按如下顺序存储：

| Row  | WatchID     | JavaEnable | Title              | GoodEvent | EventTime           |
| ---- | ----------- | ---------- | ------------------ | --------- | ------------------- |
| #0   | 89354350662 | 1          | Investor Relations | 1         | 2016-05-18 05:19:20 |
| #1   | 90329509958 | 0          | Contact us         | 1         | 2016-05-18 08:10:20 |
| #2   | 89953706054 | 1          | Mission            | 1         | 2016-05-18 07:38:00 |
| `#N`   | …           | …          | …                  | …         | …                   |

处于同一行中的数据总是被物理的存储在一起。

常见的行式数据库系统有：`MySQL`、`Postgres`和`MS SQL Server`。

在列式数据库系统中，数据按如下的顺序存储：

| Row:        | #0                  | #1                  | #2                  | `#N`   |
| ----------- | ------------------- | ------------------- | ------------------- | ---- |
| WatchID:    | 89354350662         | 90329509958         | 89953706054         | …    |
| JavaEnable: | 1                   | 0                   | 1                   | …    |
| Title:      | Investor Relations  | Contact us          | Mission             | …    |
| GoodEvent:  | 1                   | 1                   | 1                   | …    |
| EventTime:  | 2016-05-18 05:19:20 | 2016-05-18 08:10:20 | 2016-05-18 07:38:00 | …    |

这些示例只显示了数据的排列顺序。来自不同列的值被单独存储，来自同一列的数据被存储在一起。

常见的列式数据库有： Vertica、 Paraccel (Actian Matrix，Amazon Redshift)、 Sybase IQ、 Exasol、 Infobright、 InfiniDB、 MonetDB (VectorWise， Actian Vector)、 LucidDB、 SAP HANA、 Google Dremel、 Google PowerDrill、 Druid、 kdb+。

不同的数据存储方式适用不同的业务场景，数据访问的场景包括：进行了何种查询、多久查询一次以及各类查询的比例；每种类型的查询(行、列和字节)读取多少数据；读取数据和更新之间的关系；使用的数据集大小以及如何使用本地的数据集；是否使用事务,以及它们是如何进行隔离的；数据的复制机制与数据的完整性要求；每种类型的查询要求的延迟与吞吐量等等。

系统负载越高，依据使用场景进行定制化就越重要，并且定制将会变的越精细。没有一个系统能够同时适用所有不同的业务场景。如果系统适用于广泛的场景，在负载高的情况下，要兼顾所有的场景，那么将不得不做出选择。是要平衡还是要效率？

## OLAP场景的关键特征

[OLAP场景的关键特征](https://clickhouse.com/docs/en/#olapchang-jing-de-guan-jian-te-zheng)

- 绝大多数是读请求
- 数据以相当大的批次(> 1000行)更新，而不是单行更新; 或者根本没有更新。
- 已添加到数据库的数据不能修改。
- 对于读取，从数据库中提取相当多的行，但只提取列的一小部分。
- 宽表，即每个表包含着大量的列
- 查询相对较少(通常每台服务器每秒查询数百次或更少)
- 对于简单查询，允许延迟大约50毫秒
- 列中的数据相对较小：数字和短字符串(例如，每个URL 60个字节)
- 处理单个查询时需要高吞吐量(每台服务器每秒可达数十亿行)
- 事务不是必须的
- 对数据一致性要求低
- 每个查询有一个大表。除了他以外，其他的都很小。
- 查询结果明显小于源数据。换句话说，数据经过过滤或聚合，因此结果适合于单个服务器的RAM中

很容易可以看出，OLAP场景与其他通常业务场景(例如,OLTP在线事务处理或K/V键值对访问)有很大的不同， 因此想要使用OLTP或Key-Value数据库去高效的处理分析查询场景，并不是非常完美的适用方案。例如，使用OLAP数据库去处理分析请求通常要优于使用MongoDB或Redis去处理分析请求。

## 列式数据库更适合OLAP场景的原因

[列式数据库更适合OLAP场景的原因](https://clickhouse.com/docs/en/#lie-shi-shu-ju-ku-geng-gua-he-olapchang-jing-de-yuan-yin)

列式数据库更适合于OLAP场景(对于大多数查询而言，处理速度至少提高了100倍)，下面详细解释了原因(通过图片更有利于直观理解)：

**行式**

![Row oriented](row-oriented.gif)

**列式**

![Column oriented](column-oriented.gif)

看到差别了么？下面将详细介绍为什么会发生这种情况。

### 输入/输出

[输入/输出](https://clickhouse.com/docs/zh/#inputoutput)

1. 针对分析类查询，通常只需要读取表的一小部分列。在列式数据库中你可以只读取你需要的数据。例如，如果只需要读取100列中的5列，这将帮助你最少减少20倍的I/O消耗。
2. 由于数据总是打包成批量读取的，所以压缩是非常容易的。同时数据按列分别存储这也更容易压缩。这进一步降低了I/O的体积。
3. 由于I/O的降低，更多的数据能被系统缓存。

例如，查询«统计每个广告平台的记录数量»需要读取«广告平台ID»这一列，它在未压缩的情况下需要1个字节进行存储。如果大部分流量不是来自广告平台，那么这一列至少可以以十倍的压缩率被压缩。当采用快速压缩算法，它的解压速度最少在十亿字节(未压缩数据)每秒。换句话说，这个查询可以在单个服务器上以每秒大约几十亿行的速度进行处理。这个速度在实践中已经达到。

### CPU

[CPU](https://clickhouse.com/docs/zh/#cpu)

由于执行一个查询需要处理大量的行记录，在整个向量的粒度上分派所有操作或者实现一个几乎没有分派代价的列式查询引擎将对查询性能提升有帮助。如果不这样做，在磁盘子系统很普通的情况下，查询解释器不可避免地会暂停CPU（因为有巨量的不连续读磁盘）。在可能的情况下，把数据按列存储并按列处理查询显然是有意义的。

有两种方法可以做到这一点：

1. 向量引擎：所有的操作都是为向量而不是为单个值编写的。这意味着多个操作之间的不再需要频繁的调用，并且调用的成本基本可以忽略不计。操作代码包含一个优化的内部循环。
2. 代码生成：生成一段代码，包含查询中的所有操作。

这是不应该在一个通用数据库中实现的，因为这在运行简单查询时是没有意义的。但是也有例外，例如，MemSQL使用代码生成来减少处理SQL查询的延迟(只是为了比较，分析型数据库通常需要优化的是吞吐而不是延迟)。

请注意，为了提高CPU效率，查询语言必须是声明型的(SQL或MDX)， 或者至少一个向量(J，K)。 查询应该只包含隐式循环，允许进行优化。

## ClickHouse的特征

[ClickHouse的特征](https://clickhouse.com/docs/en/introduction/performance/#performance)

### 真正的列式数据库管理系统

[真正的列式数据库管理系统](https://clickhouse.com/docs/en/introduction/distinctive-features/#true-column-oriented-dbms)

在一个真正的列式数据库管理系统中，除了数据本身外不应该存在其他额外的数据。这意味着为了避免在值旁边存储它们的长度«number»，你必须支持固定长度数值类型。例如，10亿个8位无符号整数类型的数据在未压缩的情况下大约消耗1GB左右的空间，如果不是这样的话，这将对CPU的使用产生强烈影响（因为解压缩会占用CPU）。即使是在未压缩的情况下，紧凑的存储数据也是非常重要的，因为解压缩的速度主要取决于未压缩数据的大小。

这是非常值得注意的，因为在一些其他系统中也可以将不同的列分别进行存储，但由于对其他场景进行的优化，使其无法有效的处理分析查询。例如： HBase，BigTable，Cassandra，HyperTable。在这些系统中，你可以得到每秒数十万的吞吐能力，但是无法得到每秒几亿行的吞吐能力。

需要说明的是，ClickHouse不单单是一个数据库， 它是一个数据库管理系统。因为它允许在运行时创建表和数据库、加载数据和运行查询，而无需重新配置或重启服务。

### 数据压缩

[数据压缩](https://clickhouse.com/docs/en/introduction/distinctive-features/#data-compression)

在一些列式数据库管理系统中(例如：InfiniDB CE 和 MonetDB) 并没有使用数据压缩。但是, 若想达到比较优异的性能，数据压缩确实起到了至关重要的作用。

除了在磁盘空间和CPU消耗之间进行不同权衡的高效通用压缩编解码器之外，ClickHouse还提供针对特定类型数据的[专用编解码器](https://clickhouse.com/docs/zh/sql-reference/statements/create/#create-query-specialized-codecs)，这使得ClickHouse能够与更小的数据库(如时间序列数据库)竞争并超越它们。

### 数据的磁盘存储

[数据的磁盘存储](https://clickhouse.com/docs/en/introduction/distinctive-features/#disk-storage-of-data)

让数据按照主键物理有序使得在几十毫秒内提取有特定值或者值在特定范围内的数据成为可能。有些列式数据库（如 SAP HANA, Google PowerDrill）只能在内存中工作，这种方式导致实时分析业务中往往要分配更多的硬件设备预算。

而ClickHouse设计之初就是为了能在常规硬件上工作，也就是说每GB存储的价格较低，但是在SSD和RAM可用时也会尽可能充分利用。

### 多核机器上并行处理

[多核机器上并行处理](https://clickhouse.com/docs/en/introduction/distinctive-features/#parallel-processing-on-multiple-cores)

ClickHouse利用当前机器上所有可用的必要资源，使得大型查询并行化。

### 在多台机器上分布式处理

[在多台机器上分布式处理](https://clickhouse.com/docs/en/introduction/distinctive-features/#distributed-processing-on-multiple-servers)

在上述列式数据库系统中几乎没有支持分布式处理查询的。但在ClickHouse中，数据可以处于不同的shard上，每个shard可以是一组用来容错的冗余节点（replicas）。所有shard都是用来并行处理查询的，这对用户透明。

### SQL 支持

[SQL 支持](https://clickhouse.com/docs/en/introduction/distinctive-features/#sql-support)

ClickHouse支持一种[基于SQL的声明式查询语言](https://clickhouse.com/docs/zh/sql-reference/)，它在许多情况下与[ANSI SQL标准](https://clickhouse.com/docs/zh/sql-reference/ansi/)相同。

支持的查询包括[GROUP BY](https://clickhouse.com/docs/en/sql-reference/statements/select/group-by/), [ORDER BY](https://clickhouse.com/docs/en/sql-reference/statements/select/order-by/), 支持的子查询包括 [FROM](https://clickhouse.com/docs/en/sql-reference/statements/select/from/)，[JOIN](https://clickhouse.com/docs/en/sql-reference/statements/select/join/) 语句，[IN](https://clickhouse.com/docs/en/sql-reference/operators/in/) 操作符和标量查询（指子查询返回的是单一值的标量，如一个数字或一个字符串，也是子**查询**中最简单的返回形式）。

相关子查询和窗口函数在开发时还不支持，但是可能在未来可用。

### 向量引擎

[向量引擎](https://clickhouse.com/docs/en/introduction/distinctive-features/#xiang-liang-yin-qing)

为了高效的使用CPU，数据不仅仅按列存储，同时还按向量(列的一部分，分片的列)进行处理，这样可以更加高效地使用CPU。

### 实时的数据更新

[实时的数据更新](https://clickhouse.com/docs/en/introduction/distinctive-features/#shi-shi-de-shu-ju-geng-xin)

ClickHouse支持在表中定义主键。为了使查询能够快速在主键中进行范围查找，数据总是以增量的方式有序的存储在MergeTree中。因此，数据可以持续不断地高效的写入到表中，并且写入的过程中不会存在任何加锁的行为。

### 主键索引

[主键索引](https://clickhouse.com/docs/en/introduction/distinctive-features/#suo-yin)

按照主键对数据进行排序，这将帮助ClickHouse在几十毫秒以内完成对数据特定值或范围的查找。

### 辅助索引

[辅助索引](https://clickhouse.com/docs/en/introduction/distinctive-features/#secondary-indexes)

和其他数据库系统不同，ClickHouse中的辅助索引并不指向某一行或航范围，而是让数据库提前知晓数据分片内的所有航都不匹配查询的过滤条件，因此根本不会读取这部分数据。这种辅助索引被称作[data skipping indexes](https://clickhouse.com/docs/en/engines/table-engines/mergetree-family/mergetree/#table_engine-mergetree-data_skipping-indexes)。

### 适合在线查询

[适合在线查询](https://clickhouse.com/docs/en/introduction/distinctive-features/#suitable-for-online-queries)

大多数OLAP数据库并不以亚秒级延迟为目标。在其他在线查询系统中，报告建立时间达到几十秒甚至几分钟都被认为是可接受的。有时甚至会花费更长的时间。

在ClickHouse中，查询处理在用户感知中没有延迟、不需要预先计算，数据就在用户交互界面加载的同时可以显示到界面上。名副其实的在线处理。

### 支持近似计算

[支持近似计算](https://clickhouse.com/docs/en/introduction/distinctive-features/#support-for-approximated-calculations)

ClickHouse提供各种方式以可接受的准确率换取性能：

1. 用于近似计算的各类聚合函数，如：distinct values, medians, quantiles
2. 基于数据的部分样本进行近似查询。这时，仅会从磁盘检索少部分比例的数据。
3. 不使用全部的聚合条件，通过随机选择有限个数据聚合条件进行聚合。这在数据聚合条件满足某些分布条件下，在提供相当准确的聚合结果的同时降低了计算资源的使用。

### 自适应的表链接算法

[自适应的表链接算法](https://clickhouse.com/docs/en/introduction/distinctive-features/#adaptive-join-algorithm)

ClickHouse自适应地选取多表链接的方式。优先采用散列链接算法（hash-join），如果有多个大表，则回退到使用合并链接算法（merge-join）。

### 数据冗余和数据完整性支持

[数据冗余和数据完整性支持](https://clickhouse.com/docs/en/introduction/distinctive-features/#data-replication-and-data-integrity-support)

ClickHouse使用异步的多主冗余技术（multi-master replication）。数据写入任何一个可用副本后，其他所有副本都会在后台获得数据的拷贝。系统维护不同服本上数据的等价性。大多数故障之后的恢复都是自动的，后者在复杂情况下是半自动恢复。

### 基于角色的访问控制

[基于角色的访问控制](https://clickhouse.com/docs/en/introduction/distinctive-features/#role-based-access-control)

ClickHouse实现了用户账户管理的SQL接口，允许[基于角色的访问控制配置](https://clickhouse.com/docs/en/operations/access-rights/)，和ANSI SQL标准中的内容以及流行的关系数据库相似。

### 功能上的限制&劣势

[功能上的限制&劣势](https://clickhouse.com/docs/en/introduction/distinctive-features/#clickhouse-features-that-can-be-considered-disadvantages)

1. 没有完整的事务支持。No full-fledged transactions.
2. 缺乏快速、低延迟地修改或删除已存在数据的能力。只能批量清空或修改数据，但是符合[GDPR](https://gdpr-info.eu/).
3. 系数索引使得ClickHouse根据行建单点查询单行数据不够高效。

# Clickhouse 使用

8/25/2023

使用ClickHouse JDBC官方驱动，踩坑无数 - 掘金: <https://juejin.cn/post/7171068921565413407>

# 问题记录

## 主键可重复

Q:为什么clickhouse在设计的时候主键不具有唯一性约束呢？

A: 坦白讲，我也不清楚，因为我没看到过对此有官方的说明，我的理解是因为clickhouse采用的是稀疏索引，如果在插入的时候还要进行唯一性检查，将会额外的耗费一些时间，不像使用稠密索引的方式能够更快定位到重复，毕竟clickhouse的设计理念是为了一个“快”字，而且使用的场景更多的也是OLAP分析，因此不做去重检查也可以理解。

Q:如果主键没有唯一性约束，那它还有什么用处呢？

A: 用来建索引啊，快速查询就全靠它了。

Q:那我确实有些应用场景不希望包含重复的数据，咋整？？

A: clickhouse给你想了一个办法，就是建表的时候使用ReplacingMergeTree，也是MergeTree引擎的一种，它会在你合并分区数据的时候，按照指定的key分组，然后取组里的最后一条记录。

Q:好，可是按照什么方式分组呢？按照建表时设定的主键吗？

A: No,no，不是按照主键，而是按照order by的排序键，当然大部分情况下我们会把主键和排序键设成一样的。比如order by (id,code)，那么执行optimize手动触发合并的时候，同一分区内相同(id,code)的记录将会被合并，只保留最后一条。

Q: 可是，如果我不想保留最后一条呢？能否我自定义去重策略呢？

A: 答案是可以的，在使用Engine=ReplaceMergeTree(ver)的时候可以指定任意一个字段作为version，如果ver为空，则默认就是合并取最后一条，如果指定了的话，那么就是取组内ver字段取值最大的一条。

Q: 等等，你刚才一直强调说同一分区内？难道这个去重只是针对同一分区内的数据吗？

A: 你说对了，这个ReplaceMergeTree是以分区为单位删除重复数据的，如果不在同一个分区内则不会删除。所以在使用该引擎的时候，一定要考虑好分区键的设置，然后看看能不能满足你们的需求，不要盲目使用，比如你的场景只是在同一天内不允许出现重复的数据，那么就可以按照天来进行分区，然后使用该方法。

————————————————

版权声明：本文为CSDN博主「普普通通程序猿」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。

原文链接：<https://blog.csdn.net/weixin_40104766/article/details/121259801>
