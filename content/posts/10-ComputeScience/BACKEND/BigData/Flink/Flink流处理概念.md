---
scope: learn
draft: true
---
# 流处理概念

## 有状态流处理

### 1. 什么是状态 
[1. 什么是状态 ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/stateful-stream-processing/#what-is-state)

尽管数据流中很多操作一次只考察一个独立的事件，还是有一些操作需要记录跨越多个事件的信息（例如窗口操作符）。这些操作都是有状态的。

一些有状态操作的例子：

- 当一个应用搜索某种事件模式时，需要保存目前已经遇到的事件序列。
- 当按照分钟、小时、一天来汇总事件时，需要保存未计算完成的事件汇总。
- 当通过流数据训练机器学习模型时，需要保存模型参数的当前版本。
- 当需要管理历史数据时，状态允许高效访问过去已发生事件。

Flink为了能够通过检查点（[checkpoints](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/dev/datastream/fault-tolerance/checkpointing/)）和保存点（[savepoints](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/ops/state/savepoints/)）实现容错，需要有状态的概念。

状态概念允许调整Flink应用，意味着Flink负责在并行示例之间重新分发状态。

可查询状态（[Queryable state](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/dev/datastream/fault-tolerance/queryable_state/)）允许用户在Flink运行期间在集群外部访问状态。

当使用状态时，读过Flink状态后端（ [Flink’s state backends](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/ops/state/state_backends/)）可能会有用。Flink提供了指定状态存储方式和位置的不同状态后端。

###  2. Keyed State 
[ 2. Keyed State ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/stateful-stream-processing/#keyed-state)

键状态保存在嵌入式的键值对存储中。键和被有状态算子读取的流一起被严格分区和分发。因此，访问键值状态只有在带键流的场景下才可能，而且仅限于访问和当前键相关联的状态值。键和状态对齐确保了所有状态更新都是本地操作，保证一致性的同时没有带来事务开销。键和状态对齐也让Flink能透明的重新分发状态和调整流分区。

![State and Partitioning](State_and_Partitioning.svg)

键状态被进一步组织成键组（*Key Groups*）。键组是Flink重新分发键状态的原子单位，键组的数量和定义的最大并行度数量上严格相等。在执行过程中每个键操作符的并行实例操作一个或多个键组的键。

### 3. 状态持久化 
[3. 状态持久化 ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/stateful-stream-processing/#state-persistence)

Flink使用**流重现**和**检查点**的结合实现容错。检查点标记了每个输入流中的一个特殊点以及每个算子的对应状态。一个正在进行流处理的数据流可以通过恢复算子状态和从检查点重现流记录，在维护了一致性（严格一次处理语义）的同时从检查点重启。

检查点间隔是在执行过程中的容错开销和恢复时间（需要重现的流记录数量）之间权衡的一种方式。

容错机制持续地生成分布式数据流的快照。对于状态较小的流处理应用，这些快照十分轻量，可以被频繁生成而不对性能造成多少影响。流处理应用的状态保存位置可配置，通常是在分布式文件系统中。

为了避免机器故障、网络故障或者软件故障等带来的程序出错，Flink会停止数据流。然后重启算子将其重置到最新成功的检查点。然后输入流被重置到状态快照的位置。任何被作为重启的并行数据流一部分来处理的记录不会对之前的检查点状态有影响。

> 默认检查点功能被禁用。查看 [Checkpointing](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/dev/datastream/fault-tolerance/checkpointing/)来了解如何开启、配置检查点。

> 为了检查点机制能实现其全套保证，流数据源（例如消息队列或代理）需要能把流倒退到最近一个有定义的点。[Apache Kafka](http://kafka.apache.org/)有这个能力，Flink的Kafka连接器也使用了这个功能。查看[Fault Tolerance Guarantees of Data Sources and Sinks](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/connectors/datastream/guarantees/)了解Flink连接器所提供的保证。

> 因为Flink检查点是通过分布式的快照实现，我们等价的使用快照和检查点。我们也经常用快照这个术语来指代检查点或保存点。



#### 检查点  
[检查点  ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/stateful-stream-processing/#checkpointing)

Flink容错机制的中心部分就是对分布式数据流和算子状态生成一致性的快照。这些快照作为一致性检查点，一旦系统发生故障就回退到一个检查点。“[Lightweight Asynchronous Snapshots for Distributed Dataflows](http://arxiv.org/abs/1506.08603)”描述了Flink生成快照的机制。Flink快照机制灵感来源于标准的分布式快照算法[Chandy-Lamport algorithm](http://research.microsoft.com/en-us/um/people/lamport/pubs/chandy.pdf)，并专为Flink执行模型而设计。

要记住检查点的一切工作都可以异步进行。检查点障碍不在加锁步骤中进行，检查点操作也可以异步对状态设置快照。

从Flink1.11起，检查点可以不对齐。我们先来描述对齐式检查点。



##### 障碍 
[障碍 ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/stateful-stream-processing/#barriers)

Flink分布式快照的核心元素是流障碍（*Stream barriers*）。流障碍被注入数据流，和数据流中的记录一起流动。流障碍不会超过流记录，障碍会严格线性流动。流障碍把数据流中的记录分割成属于当前快照的记录和应该进入下一个快照的记录。每个障碍带有快照ID。障碍不会打断流数据流动，因此十分轻量。来自不同快照的多个障碍可能同时处于流中，这意味着各种快照可能同时发生。

![Checkpoint barriers in data streams](Checkpoint_barriers_in_data_streams.svg)

 

流障碍在流源头被注入到并行数据流中。快照n被注入的点是快照覆盖到的位置末端。例如在Apache Kafka中，诸如位置是分区中最后一个记录的偏移量。这个障碍注入位置将被报告给检查点协调器*checkpoint coordinator* (Flink的JobManager)。

之后流障碍沿着流流动。当一个中间算子从它的所有输入流接收到一个流障碍后，将给它所有输出流发出一个快照n的障碍。一旦接收器算子从所有输入流接收到快照n的障碍之后，通知检查点协调器快照n完成。在所有接收器都通知过快照之后，该快照被认为已经完成。

快照n完成之后，作业就不会再向源算子索取快照n之前的记录，因为此时这些记录已经通过了整个数据流拓扑。



![Aligning data streams at operators with multiple inputs](Aligning_data_streams_at_operators_with_multiple_inputs.svg)

接收多个输入流的算子需要在快照障碍处对齐输入流。上图展示了这一点：

- 算子从输入流接收到快照障碍n的那一刻起就不能再处理来自该流的后续记录，直到从其他输入流也接收到快照障碍n。否则，就有可能把属于快照n的记录和属于快照n+1的记录混淆。
- 一旦最后一个输入流的障碍n被接收，算子就会把所有等待发送的记录全部释放，然后再发送快照n的障碍。
- 快照保存状态，并重新开始处理所有输入流的记录，在从输入流中处理记录之前从输入流缓存中处理记录。
- 最终，算子把状态异步写入状态后端中。

注意所有多输入流的算子都需要对齐，`shuffle`操作之后的算子在其消费多个上游子任务的输出流时也需要对齐。





##### 快照保存算子状态 
[快照保存算子状态 ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/stateful-stream-processing/#snapshotting-operator-state)

当算子包含任何形式的状态时，状态也必须被快照保存。 

算子收到所有输入流的快照障碍之后，在把快照障碍发送给输出流之前，会及时保存状态。此时，所有来自障碍之前记录的状态更新已经完成，依赖于障碍之后记录的更新还没有执行。由于快照的状态可能很大，所以被保存在可配置的状态后端中（*[state backend](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/ops/state/state_backends/)*）。默认情况下，状态保存位置是JobManager的内存，但是生产环境中应该配置一个可靠的分布式存储（例如HDFS）。在保存好状态之后，算子通知检查点，然后把快照障碍释放给输出流，继续进行后续的处理。

保存后的快照包含以下内容：

- 每个并行流数据源在快照开始时的位置或偏移量
- 指向每个算子状态存储位置的指针，算子状态也是快照的一部分

![Illustration of the Checkpointing Mechanism](Illustration_of_the_Checkpointing_Mechanism.svg)



##### 恢复 
[恢复 ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/stateful-stream-processing/#recovery)

检查点机制下的恢复十分简单：当发生故障以后，Flink选择最近的完整检查点k。然后重新部署整个分布式数据流，给每个算子把状态恢复到检查点k的状态。数据源重新设置到从快照障碍k的位置开始读取数据。例如在Apache Kafka中系统会告知消费者从偏移量k的位置开始消费数据。

如果状态快照是增量式保存的，算子会从最新的全量快照开始恢复，在全量快照基础上做一系列增量式状态更新直至恢复到检查点k的状态。

查看重启策略（ [Restart Strategies](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/ops/state/task_failure_recovery/#restart-strategies)）了解更多信息。

#### 非对齐的检查点 Unaligned Checkpointing 
[非对齐的检查点 Unaligned Checkpointing ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/stateful-stream-processing/#unaligned-checkpointing)

检查点也可以以非对齐的方式进行。基本思想是只要缓冲区数据（in-flight data）成为算子状态的一部分，检查点就可以越过实时数据。

注意这种方法其实和[Chandy-Lamport algorithm ](http://research.microsoft.com/en-us/um/people/lamport/pubs/chandy.pdf)相近，但是Flink为了避免检查点协调器负载过重仍在数据源处注入快照障碍。

![Unaligned checkpointing](Unaligned_checkpointing.svg)

上图说明了算子如何处理非对齐式检查点障碍：

- 算子只处理第一个在其输入缓冲区中的障碍
- 接收到障碍后立刻将其附加到输出流缓冲区的末端，从而转发给下游算子
- 算子把所有被障碍越过的记录标记为需要被异步保存，并创建自身状态的一个快照

因此，算子只需要暂停处理输入记录，标记缓冲区、转发障碍、创建自身状态的快照。

非对齐式检查点确保了障碍能尽可能快地到达接收器。这种检查点尤其适合计算流中至少有一个数据移动极其缓慢的路径的应用程序（对齐时间可能达到几小时）。但是，由于非对齐式检查点增加了额外的IO压力，在状态后端的IO成为瓶颈时就无法起到作用。查看运维部分（[ops](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/ops/state/checkpoints/#unaligned-checkpoints)）寻求检查点其他限制的深入讨论。

注意保存点总是对齐式的。

###### 非对齐式恢复 
[非对齐式恢复 ](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/concepts/stateful-stream-processing/#unaligned-recovery)

在非对齐式状态恢复中，算子在开始处理来自上游算子的任何数据之前，首先会恢复缓冲区数据（in-flight data）。除吃以外，非对齐式状态恢复的流程和对齐式检查点恢复过程（[recovery of aligned checkpoints](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/concepts/stateful-stream-processing/#recovery)）一致。

#### 状态后端 State Backends 
[状态后端 State Backends ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/stateful-stream-processing/#state-backends)

键值对索引被保存所用的确切数据结构依赖于所选的状态后端（[state backend](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/ops/state/state_backends/)）。可能一种状态后端把数据存储在内存中的哈希表中，另一种则使用[RocksDB](http://rocksdb.org/)作为键值对存储。除了定义保存数据所用的数据结构，状态后端也要实现保存键值对状态时间点快照的逻辑、把快照保存为检查点一部分共检查点使用的逻辑。状态后端可以在不改变应用逻辑的前提下配置。

![checkpoints and snapshots](checkpoints_and_snapshots.svg)

#### 保存点 Savepoints 
[保存点 Savepoints ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/stateful-stream-processing/#savepoints)

所有使用检查点的程序都从**保存点**来重启程序的执行。保存点允许用户在不损失状态的情况下就能更新程序或Flink集群。

保存点（[Savepoints](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/ops/state/savepoints/)）是**手动触发的检查点**。保存点保存程序的快照、将其写入一个状态后端，依赖于常规的检查点机制。

保存点除了由用户触发、不会自动过期之外和检查点十分相似。

#### Exactly Once vs. At Least Once 
[Exactly Once vs. At Least Once ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/stateful-stream-processing/#exactly-once-vs-at-least-once)

检查点的对齐步骤可能给流处理程序增加额外的延迟。这部分额外延迟通常是在毫秒级，但是也有延迟显著提高的异常情况。对于所有流记录都要求极低延迟的应用，可以选择在设置检查点过程中跳过流数据对齐。跳过检查点对齐后，算子在每个输入流一遇到检查点障碍还是会保存检查点的快照。

跳过对齐后，即使检查点n的障碍到达，算子还是急需处理输入。这样一来算子在检查点n的快照完成之前可能也处理了属于检查点n+1的数据。在恢复过程中，这些未对齐的数据记录就会重复出现，因为它们不仅在检查点n的状态快照中，也会在检查点n之后的状态快找数据中重现。

> 对齐只发生在有多个输入（流关联的场景）或者多个输出（流重新分区或shuffle之后）。由于这个原因，只有并行流操作的数据流即使在*at least once*模式下也有了严格一次消费的保证。



### 4. 批处理程序的状态和容错  
[4. 批处理程序的状态和容错  ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/stateful-stream-processing/#state-and-fault-tolerance-in-batch-programs)

Flink把批处理程序（[batch programs](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/dev/dataset/overview/)）作为流处理程序的特例来执行，这时流是有界的（只有有限数量的元素）。`DataSet`在Flink内部被作为有限数据的数据流来处理。因此上述概念和流处理一样适用于批处理程序，只有微小的差别：

- 批处理程序的容错（[Fault tolerance for batch programs](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/ops/state/task_failure_recovery/)）不使用检查点机制。恢复是通过流数据的全量重现来实现的。这种方案使得恢复代价更高，但减小了正常处理的开销，因为避免了设置检查点。
- `DataSet API`有状态操作的状态保存使用简化的内存或out-of-core数据结构，而不是键值对索引。

- `DataSet` API引入了专门的同步式迭代（基于superstep），仅对有界流可用。查看迭代文档（[iteration docs](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/dev/dataset/iterations/)）了解详情。



## 及时流处理 
[及时流处理 ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/time/#timely-stream-processing)

及时流处理是[有状态流处理](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/stateful-stream-processing/)得扩展，这种场景下时间在计算中扮演着重要角色。除此以外，也十分符合你做时间序列分析、基于某种时间窗口做聚合、或者事件处理时发生时间十分重要的场景。

下面重点介绍一些及时流处理开发时应该考虑的话题。

### 1. 时间的表示：事件时间和处理时间  
[1. 时间的表示：事件时间和处理时间  ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/time/#notions-of-time-event-time-and-processing-time)

在流处理应用中引用时间时（例如定义时间窗口），需要明确时间的不通表示：

- **处理时间**：指执行相应操作的机器的系统时间。

  当流处理应用使用处理时间时，所有像时间窗口这类基于时间的操作都将使用运行相应算子的机器系统时钟。一个每小时处理一次的时间窗口内将包含在系统时钟所表达的一整个小时内到达某个算子的所有流记录。例如，一个应用在上午9:15启动，那么第一个按小时处理事件的时间窗口将包含在9:15-10:00被处理的所有事件，下一个窗口的时间周期则是10:00-11:00，以此类推。

  处理事件是最简单的时间表示，不需要流和机器之间的协调。使用处理事件将带来最好的性能和低延迟。但是，在分布式的和异步的环境中，处理时间是不确定的。因为处理时间容易受到流记录（比如从消息队列）抵达系统速度的影响、流记录在系统内算子之间流动速度的影响，以及不论是意外还是预先安排的设备停机的影响。

- **事件时间**：事件时间是每个独立的事件在其所处设备上发生的时间。事件时间经常是在抵达Flink系统时就已经嵌入流记录，相应事件发生时间的时间戳可以从流记录数据中被提取。在事件发生时间的模式下，事件的进程依赖于数据，而不依赖于任何设备时钟。使用事件发生时间的程序必须指定如何生成*事件时间水印*（*Event Time Watermarks*），这是标志着时间事件进展的机制。将在后面的部分：事件时间和水印（[Event Time and Watermarks #](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/concepts/time/#event-time-and-watermarks)）提到。

  理想情况下，事件时间处理需要得出完全一致性的、确定性的结果，不论事件何时到达、他们的顺序如何。但是除非能够预知所有事件都将按照时间戳的顺序到达，否则事件时间处理必须在等待失序事件时产生一些延迟。因为对失序事件只能等待一段确定的时间，这就对事件时间处理应用的一致性、确定性程度施加了一些限制。

  假定所有数据已经到达，或者在重新处理历史数据时，即使有失序事件或迟到事件，事件时间处理应用也能够按照预期运行、产生正确的、一致性的结果。例如当所有数据已经到达时，不论以何种顺序到达、事件何时被处理，在一小时大小的事件时间窗口将包含所有时间戳落入一小时范围的流记录。（查看迟到事件部分 [late events](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/concepts/time/#late-elements)了解更多信息）

  注意有时事件时间程序处理实施的在线数据时，程序会使用一些处理时间操作来保证事件被及时处理。

  ![Event Time and Processing Time](Event_Time_and_Processing_Time.svg)

### 2. 事件时间和水印 
[2. 事件时间和水印 ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/time/#event-time-and-watermarks)

*注意: Flink 实现了许多来自Dataflow Model的技术。 事件时间和水印的介绍请看下面两篇文章：*

- [Streaming 101](https://www.oreilly.com/ideas/the-world-beyond-batch-streaming-101) by Tyler Akidau
- The [Dataflow Model paper](https://research.google.com/pubs/archive/43864.pdf)

支持事件时间的流处理器需要一种方法来衡量事件时间的进展。例如，一小时窗口大小的窗口算子需要在事件时间超出一小时范畴时得到通知，以便其关闭当前正在处理的窗口。

事件时间有可能独立于时钟所衡量的处理时间而进展。例如，考虑接收事件的延迟后，一个程序中算子当前的*事件时间*可能会稍微落后于*处理时间*，尽管两者都以同样的速度流逝。另一方面，还有一些流处理程序可能通过快速转发缓存在Kafka话题或其他消息队列中的历史数据，处理着跨越数周的事件而只需要几秒钟的处理时间。



Flink中衡量事件时间进展的机制是**水印**。水印随着流数据作为流的一部分流动，带着时间戳t。时间戳为t的水印`Watermark(t)`声明流中的事件时间已经达到时间t，也就是说该流中在水印之后不应该再有时间戳小于t的事件到达。

下图显示了一个带有逻辑时间戳的事件流，水印随时间一起线性流动。这个例子中所有事件都是按时间戳有序的，就是说水印现在只是周期性的标志。

![A data stream with events (in order) and watermarks](10-ComputeScience/BACKEND/BigData/Flink/_attachments/Flink流处理概念/A_data_stream_with_events_(in_order)_and_watermarks.svg)

如下图所示，水印对事件没有按时间戳有序的失序事件流至关重要。总的来说水印声明到水印那一点为止，所有水印时间戳代表的时间之前的事件都已经到达。一旦水印到达算子，算子就可以将其内部时钟前进到水印时间戳的位置。

![A data stream with events (out of order) and watermarks](10-ComputeScience/BACKEND/BigData/Flink/_attachments/Flink流处理概念/A_data_stream_with_events_(out_of_order)_and_watermarks.svg)



#### 并行流的水印 
[并行流的水印 ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/time/#watermarks-in-parallel-streams)

水印是在原函数处生成的。每个源函数的并行子任务通常独立生成自己的水印。这些水印定义了该并行源函数处的事件时间。

随着水印沿流处理程序流动，水印在经过的算子处更新时间戳。在算子更新其事件时间时，给其下游的后续算子生成了新的水印。

有些算子消费多个输入流，例如`union()`，或者`keyBy()`、`partition()`函数后面的算子。这样的算子当前事件时间是其所有输入流事件时间的最小值。当输入流更新它们的事件时间时，算子也一样更新。

下图展示了并行数据流中的事件和水印，以及算子跟踪事件时间的方式。

![Parallel data streams and operators with events and watermarks](Parallel_data_streams_and_operators_with_events_and_watermarks.svg)



### 3. 延迟 
[3. 延迟 ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/time/#lateness)

有可能会有流元素违反水印的条件：水印`Watermark(t)`之后还是有时间戳小于等于t的事件到来。事实上在很多真实情况下，事件可能被延迟任意长的时间，不可能截止某个时间所有之前的事件都已经到达。进一步说，即使事件延迟是必然的，过多地推迟水印也不是想要的结果，因为这会造成事件时间窗口的计算被严重推迟。

由于这个原因，流处理程序总会遇到迟到的硫元素。迟到元素是系统事件时间时钟（由水印所表示）已经超出该元素时间戳的元素。查看 允许延迟([Allowed Lateness](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/dev/datastream/operators/windows/#allowed-lateness))了解事件时间窗口如何处理迟到的流元素。

### 4. 窗口  
[4. 窗口  ](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/time/#windowing)

对流进行像计数、求和这样的事件汇总操作和批处理中不同。例如流通常是无限的（无界的），所以对整个流的所有元素计数根本不可能。而对流的计数、求和等汇总操作被限制在**窗口**的范围上。例如对过去5分钟计数、对之前100个元素求和。

窗口可以是时间驱动的（比如每30秒）或者数据驱动的（比如每100个元素）。人们通常能够区分不同类型的窗口，如滚动窗口(没有重叠)、滑动窗口(有重叠)和会话窗口(以不活跃的时间间隔来分隔)。

![Time- and Count Windows](Time-_and_Count_Windows.svg)  

Please check out this [blog post](https://flink.apache.org/news/2015/12/04/Introducing-windows.html) for additional examples of windows or take a look a [window documentation](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/dev/datastream/operators/windows/) of the DataStream API.

