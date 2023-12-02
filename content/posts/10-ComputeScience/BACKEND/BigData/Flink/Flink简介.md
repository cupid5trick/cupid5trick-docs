---
scope: learn
draft: true
---
# Flink简介

Apache Flink因可拓展的功能集合而成为开发、运行各种应用的好选择。Flink的功能包括流批处理、复杂状态管理、事件时间处理语义、严格一次处理的状态一致性保证。

部署方面，Flink可以部署在Yarn、Apache Mesos、Kubernetes等多种基础设施上，以及在单主机上构成独立集群。配置了高可用之后，Flink将没有单点失效问题。Flink已经被证明能够拓展到几千个核心和几个TB的状态数据，能够高吞吐、低延迟地交付数据。在实际应用中，Flink已经在驱动着一些世界上流处理要求极高的应用。



# 应用场景
[应用场景](https://flink.apache.org/usecases.html)

## 事件驱动应用（Event-driven Applications）

事件驱动应用是一种有状态应用。从一个或多个事件流接受事件，并以触发计算、状态更新或外部行为等方式对到来的事件做出响应。

事件驱动应用是传统的计算、存储层分离架构的演进。传统架构中，应用从远程事务数据库读取数据、固化数据到远程数据库。而事件驱动应用则是基于有状态流处理应用。在这种设计下，数据和计算处于同一物理位置，收获的是数据本地化访问。通过周期性向远程固化存储写入检查点实现容错。下图显示了传统应用架构和事件驱动应用之间的区别。

![img](img.png)



### 1. 事件驱动应用的优势

事件驱动应用访问本地数据，收获了性能，带来的是高吞吐和低延迟。周期性检查点的任务可以异步或渐进的完成，因而对常规事件处理影响极小。

### 2. Flink对事件驱动应用的支持

事件驱动应用的限制是由流处理器对时间和状态的处理能力决定的。许多Flink功能都是以这些概念为中心的。Flink提供丰富的状态原语，可以管理极大的数据量（多达几TB），同时有严格一次的一致性保证（exact-once consistency guarantees）。由`ProcessFunction`提供的事件时间语义、高度可定制的窗口逻辑和细粒度的时间控制让应用能够实现复杂的高级业务逻辑。还有复杂事件处理库（CEP）可以检测数据流中的模式。

但是，Flink 对于事件驱动应用程序的突出特性是保存点（savepoint）。保存点是一致的状态图像，可用作兼容应用程序的起点。给定一个保存点，可以更新应用程序或调整其规模，或者可以启动应用程序的多个版本进行 A/B 测试。

### 3. 什么是典型的事件驱动应用程序？

- [欺诈识别](https://sf-2017.flink-forward.org/kb_sessions/streaming-models-how-ing-adds-models-at-runtime-to-catch-fraudsters/)
- [异常检测](https://sf-2017.flink-forward.org/kb_sessions/building-a-real-time-anomaly-detection-system-with-flink-mux/)
- [基于规则的警报](https://sf-2017.flink-forward.org/kb_sessions/dynamically-configured-stream-processing-using-flink-kafka/)
- [业务流程监控](https://jobs.zalando.com/tech/blog/complex-event-generation-for-business-process-monitoring-using-apache-flink/)
- [网络应用程序（社交网络）](https://berlin-2017.flink-forward.org/kb_sessions/drivetribes-kappa-architecture-with-apache-flink/)

## 数据分析应用（Data Analytics Applications）

数据分析工作从原始数据提取信息或获取见解。传统的数据分析是在绑定的数据集上进行查询或运行程序。为了把最新数据融入被分析数据集，不得不重新执行一遍查询或运行一遍应用。分析结果写入存储系统或产出报告。

有了复杂的流处理引擎之后，分析任务可以以实时模式开展。流式查询或流处理应用接受实时事件流，在事件消费时生成或更新结果，不再需要读取文件。分析结果可以写入外部数据库，也可以作为应用内部状态被维护。仪表盘应用可以从外部数据库读取最新分析结果或者直接查询内部状态数据。

如下图所示，Flink既支持流处理也支持批处理。

![img](img-2.png)



### 1. 流式分析应用的优势

由于消除了定期导入和查询执行，连续流分析与批处理分析相比的优势不仅限于从事件到洞察的延迟要低得多。与批处理查询相反，流查询不必处理输入数据中由周期性导入和输入的有界性质引起的人为边界。

另一方面是更简单的应用程序架构。批处理分析管道由几个独立的组件组成，用于定期安排数据摄取和查询执行。可靠地操作这样的管道并非易事，因为一个组件的故障会影响管道的后续步骤。相比之下，在 Flink 等复杂流处理器上运行的流分析应用程序包含从数据摄取到连续结果计算的所有步骤。因此，分析工作流的可靠运行维护可以依靠引擎的故障恢复机制。

### 2. Flink对数据分析应用的支持

Flink对流处理和批处理应用都能够很好的支持。Flink专门提供了兼容ANSI SQL的SQL接口，对于流处理和批处理应用有统一的语义。不论是运行在静态数据集还是实时的事件流，Flink的SQL查询都能计算得到相同的结果。对用户自定义函数的丰富支持确保了自定义的代码能以SQL查询的形式工作。即使有自定义逻辑的要求，Flink的DataStream API和DataSet API也能提供底层控制。此外，Flink的Gelly库为批数据集上大规模高性能的凸分析提供了算法和构建块。



### 3. 什么是典型的数据分析应用程序？

- [电信网络质量监控](http://2016.flink-forward.org/kb_sessions/a-brief-history-of-time-with-apache-flink-real-time-monitoring-and-analysis-with-flink-kafka-hb/)
- 移动应用[产品更新与实验评估分析](https://techblog.king.com/rbea-scalable-real-time-analytics-king/)
- 消费者技术[中实时数据的临时分析](https://eng.uber.com/athenax/)
- 大规模图形分析

## 数据流水线应用（Data Pipeline Applications）

Extract-transform-load（ETL）是在存储系统之间变换和移动数据的常见手段。通常是周期性出发ETL作业，从事务性数据库移动数据到分析型数据库或数据仓库。

数据流水线能起到和ETL相似的作用。数据流水线变换、丰富数据，可以把数据从一个存储系统移动到另一个存储系统。但是，流水线以持续性流处理模式工作而不是周期性触发。因此可以从持续产生数据的数据源读取数据，以低延迟巴淑菊迁移到目标数据源。例如，一个数据流水线应用可能会监控文件系统路径下是否有新文件，把数据写入事件日志。另一个应用把事件流日志固化到数据库，或者建立、优化索引。

下图显示了周期性ETL和持续性数据流水线之间的区别。



![img](img-1.png)

### 1. 数据流水线的优势

持续数据流水线相比周期性ETL作业的明显优势是降低了迁移数据的延迟。此外，数据管道更加通用，可以用于更多应用场景，因为它们能够持续消耗和发出数据。

### 2. Flink对数据流水线的支持

许多常见的数据转换或扩充任务都可以通过 Flink 的 SQL 接口（或 Table API）及其对用户定义函数的支持来解决。要求更高的数据管道可以通过更通用的DataStream API来实现。Flink为各种存储系统提供了丰富的连接器，例如Kafka、Kinesis、ElasticSearch和JDBC数据库系统。还有监控文件系统路径的持续流式数据源和以时间段方式写文件的接收器。

### 3. 典型的数据管道应用程序？

- 电子商务中[的实时搜索索引构建](https://ververica.com/blog/blink-flink-alibaba-search)
- 电子商务中的[持续 ETL](https://jobs.zalando.com/tech/blog/apache-showdown-flink-vs.-spark/)



- 





# Flink架构 
[Flink架构 ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/flink-architecture/#flink-architecture)

Flink 是一个分布式系统，需要有效分配和管理计算资源才能执行流应用程序。它集成了所有常见的集群资源管理器，例如[Hadoop YARN](https://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-site/YARN.html)、[Apache Mesos](https://mesos.apache.org/)和[Kubernetes](https://kubernetes.io/)，但也可以设置作为独立集群甚至库运行。

本节概述了 Flink 架构，并且描述了其主要组件之间如何交互以执行应用程序和从故障中恢复。

## Flink集群剖析 
[Flink集群剖析 ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/flink-architecture/#anatomy-of-a-flink-cluster)

Flink运行时包含两种类型的进程：一个***JobManager***和一个或多个***TaskManager***。

![The processes involved in executing a Flink dataflow](The_processes_involved_in_executing_a_Flink_dataflow.svg)



*Client*并不是运行时和程序执行的一部分，但是被用来准备和发送数据流给***JobManager***。之后，客户端可以断开连接（*detach mode*），或保持连接来接收进程报告（*attach mode*）。客户端可以作为触发执行 Java/Scala 程序的一部分运行，也可以在命令行进程`./bin/flink run ...`中运行。

可以通过多种方式启动 JobManager 和 TaskManager：直接在机器上作为[standalone 集群](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/deployment/resource-providers/standalone/overview/)启动、在容器中启动、或者通过[YARN](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/deployment/resource-providers/yarn/)或[Mesos](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/deployment/resource-providers/mesos/)等资源框架管理并启动。TaskManager 连接到 JobManagers，宣布自己可用，并被分配工作。

### JobManager 
[JobManager ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/flink-architecture/#jobmanager)

*JobManager*有很多和协调Flink应用程序分布式执行相关的职责：决定合适调度下一个任务或任务集合、对完成的任务或执行失败做出回应、协调检查点、协调故障恢复等等。这个进程包含三个不同组件：

- **ResourceManager**

  *ResourceManager* 负责Flink集群中的资源提供和资源分配、回收：管理作为Flink集群中资源调度及本单位的**task slots**(see [TaskManagers](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/flink-architecture/#taskmanagers)). Flink 针对不同环境和资源提供者实现了多种ResourceManger：YARN, Mesos, Kubernetes 和standalone部署。在 standalone 设置中，ResourceManager 只能分配可用 TaskManager 的 slots，而不能自行启动新的 TaskManager。

- **Dispatcher**

  *Dispatcher* 提供了一个 REST 接口，用来提交 Flink 应用程序执行，并为每个提交的作业启动一个新的 JobMaster。它还运行 Flink WebUI 用来提供作业执行信息。

- **JobMaster**

  *JobMaster* 负责管理单个[JobGraph](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/glossary/#logical-graph)的执行。Flink 集群中可以同时运行多个作业，每个作业都有自己的 JobMaster。

Flink集群中至少有一个JobManager。在使用高可用配置时集群中可能有多个JobManager，其中一个始终是 *leader*，其他的则是 *standby*（请参考 [高可用（HA）](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/deployment/ha/overview/)）。

### TaskManagers 
[TaskManagers ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/flink-architecture/#taskmanagers)

*TaskManager*（也称为 *worker*）执行作业流的 task，并且缓存和交换数据流。

必须始终至少有一个 TaskManager。在 TaskManager 中资源调度的最小单位是 task *slot*。TaskManager 中 task slot 的数量表示并发处理 task 的数量。**注意**一个*task slot*中可以执行多个*operator* (see [Tasks and Operator Chains](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/flink-architecture/#tasks-and-operator-chains))。

## 任务和Operator Chains 
[任务和Operator Chains ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/flink-architecture/#tasks-and-operator-chains)

对于分布式执行，Flink采用链接技术把operator子任务链接成task，每个task都在一个线程内执行。把operator链接成task是一个有用的优化：降低了线程之间切换和缓冲的开销，降低延迟的同时增加了总体吞吐量。**链接行为可以配置**，详情参考 [chaining docs](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/dev/datastream/operators/overview/#task-chaining-and-resource-groups)。

图中的示例数据流是以五个子任务执行的，因此有五个并行的线程。

![Operator chaining into Tasks](Operator_chaining_into_Tasks.svg)

## Task slot和资源 
[Task slot和资源 ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/flink-architecture/#task-slots-and-resources)

每个 worker（TaskManager）都是一个 *JVM 进程*，可以在单独的线程中执行一个或多个 subtask。为了控制一个 TaskManager 中接受多少个 task，就有了所谓的 **task slots**（至少一个）。

每个*task slot* 代表 TaskManager 中资源的固定子集。例如，具有 3 个 slot 的 TaskManager，会将其托管内存 1/3 用于每个 slot。资源空槽化意味着当前子任务 不会与来自其他作业的 子任务竞争托管内存，而是具有一定数量的预留内存。注意此处没有发生 CPU 隔离；当前 slot 仅分离 task 的托管内存。

通过调整 task slot 的数量，用户可以定义 subtask 如何互相隔离。每个 TaskManager 有一个 slot，这意味着每个 task 组都在单独的 JVM 中运行（例如，可以在单独的容器中启动）。具有多个 slot 意味着更多子任务共享同一 JVM。同一 JVM 中的 task 共享 TCP 连接（通过多路复用，multiplexing）和心跳信息。它们还可以共享数据集和数据结构，从而减少了每个 task 的开销。

![A TaskManager with Task Slots and Tasks](A_TaskManager_with_Task_Slots_and_Tasks.svg)

默认情况下，Flink 允许子任务共享 slot，即便它们属于不同的task，只要是来自同一作业即可。结果就是一个 slot 可以容纳整个作业的流程。允许 *slot 共享*有两个主要优点：

- Flink集群所需的task slot数量和作业中使用的最大并行度恰好一致。不需要计算一个程序总共包含多少task（不同task之间并行度不同）。
- 更容易提升资源利用效率。不采用共享slot的情况下，非资源密集型的*source/map()* 子任务将占用和资源密集型window子任务同样多的资源。而有了共享slot，把示例中基准并行度从2增加到6就获取了充分的资源利用，同时确保了重量级的子任务公平的分布在TaskManager中间。

![TaskManagers with shared Task Slots](TaskManagers_with_shared_Task_Slots.svg)

## Flink应用执行 
[Flink应用执行 ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/flink-architecture/#flink-application-execution)

Flink应用是在主方法中生成一个或多个Flink作业的用户程序。这些作业的执行可以是在本地JVM中 (`LocalEnvironment`) 或者在拥有多台机器的远程集群中 (`RemoteEnvironment`)。对于每个程序， `ExecutionEnvironment` 都提供了控制作业执行（例如设置并行度）和与外界交互的方法(see [Anatomy of a Flink Program](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/dev/datastream/overview/#anatomy-of-a-flink-program))。

Flink应用中的作业可以被提交到长期运行的会话集群[Flink Session Cluster](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/glossary/#flink-session-cluster)、专有的作业集群 [Flink Job Cluster](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/glossary/#flink-job-cluster)或者应用集群 [Flink Application Cluster](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/glossary/#flink-application-cluster)。三种选项的区别于集群生命周期和资源隔离度保证有关。

### Flink Session Cluster 
[Flink Session Cluster ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/flink-architecture/#flink-session-cluster)

- 集群生命周期：会话集群中，客户端连接到一个预先存在的、长期运行的，并且能够接受多个作业提交的集群。即使在所有提交的作业都完成之后，集群和JobManager都会一直运行到手动关闭会话为止。因此，Flink Session Cluster的生命周期不绑定于任何Flink Job。
- 资源隔离度：TaskManager的slot在作业提交的那一刻被ResourceManager分配，一旦作业完成资源就被释放。因为所有作业都处于同一个集群，会存在集群资源竞争：例如提交作业阶段的网络带宽。这种共享式设置的一个限制是：如果一个TaskManager崩溃，所有在这个TaskManager运行了task的作业都会失败；与之相似，如果JobManager上发生了致命错误，也会影响集群上运行的所有作业。
- 其他考虑：维护一个预先存在的集群可以节省大量申请资源和启动TaskManager的时间。这一点在一些作业执行时间很短、同时较长的启动时间将对端到端用户体验产生消极影响的场景下十分重要。正如交互式短查询的场景中，我们很希望利用现有资源快速执行作业中的计算。

> 以前，Flink Session 集群也被称为 *session 模式*下的 Flink 集群。



### Flink Job Cluster 
[Flink Job Cluster ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/flink-architecture/#flink-job-cluster)

- 集群生命周期：在作业集群中，可用的集群管理器（比如YARN）给每个提交的作业启动一个集群，这个集群只对被提交的那一个作业可用。这里，客户端首先从集群管理器请求资源来启动JobManager，然后向JobManager进程内运行的Dispatcher提交作业。然后根据作业的资源要求惰性地分配TaskManager。一旦作业完成，作业集群也被拆除。
- 资源隔离度：JobManager发生致命错误后只会影响在作业集群上运行的一个作业。
- 其他考虑：由于资源管理器ResourceManager需要申请资源、等待外部资源管理组件激动TaskManager进程、分配资源，作业集群更适合需要长时间运行、有高稳定性要求、对长启动时间不敏感的大型作业。

> 以前，Flink Job 集群也被称为 *job (or per-job) 模式*下的 Flink 集群。

> Kubernetes 不支持 Flink Job 集群。 请参考 [Standalone Kubernetes](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/deployment/resource-providers/standalone/kubernetes/#per-job-cluster-mode) 和 [Native Kubernetes](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/deployment/resource-providers/native_kubernetes/#per-job-cluster-mode)。



### Flink Application Cluster 
[Flink Application Cluster ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/flink-architecture/#flink-application-cluster)

- 集群生命周期：应用集群是一个只执行来自特定Flink应用的专有集群，Flink应用的主方法也只在集群上运行而不是在客户端上运行。作业提交是一个只有一步的过程：不需要先启动Flink集群，然后给集群会话提交作业；而是把应用逻辑和依赖打包成JAR，集群入口程序 (`ApplicationClusterEntryPoint`) 负责调用应用的主方法、提取作业图JobGraph。例如，这允许你像在 Kubernetes 上部署任何其他应用程序一样部署 Flink 应用程序。因此，Flink Application 集群的生命周期与 Flink 应用程序的生命周期相绑定。
- 资源隔离度：在 Flink Application 集群中，ResourceManager 和 Dispatcher的工作范围缩小到单个的 Flink 应用程序，相比于 Flink Session 集群，它提供了更好的隔离。



Flink Job 集群可以看做是 Flink Application 集群”客户端运行“的替代方案。

------

# Flink API 
[Flink API ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/overview/#flinks-apis)

Flink给流批处理应用开发提供了不同层次的抽象。

![Programming levels of abstraction](Programming_levels_of_abstraction.svg)

- 最底层抽象仅提供有状态流处理（Stateful Stream Processing [#](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/stateful-stream-processing/#stateful-stream-processing)）和及时流处理（Timely Stream Processing [#](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/time/#timely-stream-processing)）功能。这些功能通过处理函数（ [Process Function](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/dev/datastream/operators/process_function/)）被嵌入到数据流API（[DataStream API](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/dev/datastream/overview/) ）。允许用户自由地从一个或多个流处理事件，提供了一致性的、容错的***状态***。除此以外，用户可以注册事件时间和处理时间回调，这让应用程序能够实现复杂计算。

- 实践中很多应用不需要上述底层抽象，这时可以转而利用***Core API***：[DataStream API](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/dev/datastream/overview/) （绑定/非绑定流）和 [DataSet API](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/dev/dataset/overview/)（绑定数据集）。这些流畅的API提供了数据处理的常见要素：各种形式的用户定义变换、链接、聚合、窗口、状态等( transformations, joins, aggregations, windows, state, etc)。这些API中处理的数据类型按照相应编程语言中的类来呈现。

  *Process Function*这类底层抽象和*DataStream API*相互集成，让用户能在有需要时选用底层API。*DataSet API*则额外对绑定数据集提供了像循环、迭代这样的原语。

- Flink API 第三层抽象是 **Table API**。**Table API** 是以表（Table）为中心的声明式编程（DSL）API，例如在流式数据场景下，它可以表示一张正在动态改变的表。 [Table API](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/dev/table/overview/)遵循扩展的关系模型：Table API的表和关系数据库中的表相似，有相应的关系模式，也有和关系数据库相似的操作，例如select, project, join, group-by, aggregate等。Table API 程序是以声明的方式定义*应执行的逻辑操作*，而不是确切地指定程序*应该执行的代码*。尽管 Table API 使用起来很简洁并且可以由各种类型的用户自定义函数扩展功能，但还是比 Core API 的表达能力差，不那么简洁易用。此外，Table API 程序在执行之前还会使用优化器中的优化规则对用户编写的表达式进行优化。

  表和 *DataStream*/*DataSet* 可以进行无缝切换，Flink 允许用户在编写应用程序时将 *Table API* 与 *DataStream*/*DataSet* API 混合使用。

- Flink API 最顶层抽象是 **SQL**。这层抽象在语义和程序表达式上都类似于 *Table API*，但是其程序实现都是 SQL 查询表达式。 [SQL](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/dev/table/overview/#sql) 抽象和Table API之间联系紧密，SQL查询也可以在Table API中定义的表上执行。



# 部署 
[部署 ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/deployment/overview/#deployment)

## 概述和参考架构 
[概述和参考架构 ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/deployment/overview/#overview-and-reference-architecture)

## 部署模式 
[部署模式 ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/deployment/overview/#deployment-modes)

## 基础环境列表 
[基础环境列表 ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/deployment/overview/#vendor-solutions)

