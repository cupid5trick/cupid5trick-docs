---
title: Flink 上手使用
type: docs
bookToc: true
weight: 2
aliases:
---

# 概述 [#](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/learn-flink/overview/#learn-flink-hands-on-training)

## 流处理范式 [#](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/learn-flink/overview/#stream-processing)

流是数据天然的存在形式。不论是来自web服务器的事件、股票市场的交易还是来自工厂机器传感器读取的数据，都是作为流的一部分存在的。但是在进行数据分析时，可以选择对绑定流还是非绑定流施加分析程序，而你选择哪一种范式（流处理还是批处理范式？）将对分析业务产生深远影响（profound consequences）。

![Bounded vs Unbounded](https://nightlies.apache.org/flink/flink-docs-release-1.13/fig/learn-flink/bounded-unbounded.png)

**批处理**是对绑定数据流进行分析的一种工作范式。这种模式下你先摄取了完整数据集然后才生成结果，这意味着可以预先排序、计算全局统计量、或者生成输入数据的汇总报告。

**流处理**则要处理非绑定流。至少直观上输入数据无穷无尽，必须持续不断地在数据到来时对其进行处理。

Flink应用程序有**streaming dataflows**组成，数据流可以被用户定义算子**operators**在其上施加变换。这些数据流形成了始于一个或多个数据源(**sources**)，止于一个或多个接收器(**sinks**)的有向图。

![Program Dataflow](https://nightlies.apache.org/flink/flink-docs-release-1.13/fig/learn-flink/program_dataflow.svg)

通常程序中的变换和数据流中的算子存在一一对应的关系，但是有时一个变换也可能由多个算子构成。

Flink 应用程序可以消费来自消息队列或分布式日志这类流式数据源（例如 Apache Kafka 或 Kinesis）的实时数据，也可以从各种的数据源中消费有界的历史数据。同样，Flink 应用程序生成的结果流也可以发送到能作为接收器连接的系统中。

![Flink Application Sources and Sinks](https://nightlies.apache.org/flink/flink-docs-release-1.13/fig/learn-flink/flink-application-sources-sinks.png)

## 并行数据流 [#](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/learn-flink/overview/#parallel-dataflows)

Flink中的应用本质上就是并行和分布式的。执行过程中，一个流可能有多个流分区（**stream partitions**），每个算子可能有一个或多个算子子任务。算子子任务（**operator subtasks**）之间彼此独立，可能在不同机器或不同容器上的不同线程中执行。

算子子任务的数量是该算子的并行度（**parallelism**）。同一个程序的不同算子可能并行度不同。

![Parallel Dataflow](https://nightlies.apache.org/flink/flink-docs-release-1.13/fig/learn-flink/parallel_dataflow.svg)

数据流可以在两个算子之间可以以一对一（转发）模式或者重分发（`redistributing`）模式传输数据：

- **一对一流**（例如数据源`Source`和`map()`操作之间）保留分区和元素顺序。也就是说`map()`操作的子任务`[1]`看到的元素和`Source`的子任务`[1]`的元素顺序相同。
- **重分发流**（例如图中`map()`和`keyBy/window`之间，以及`keyBy/window`和`Sink`之间）会改变流的分区。当你在程序中选择使用不同的 *transformation*，每个*算子子任务*也会根据不同的 transformation 将数据发送到不同的目标子任务。例如以下这几种 transformation 和其对应分发数据的模式：*keyBy()*（通过散列键重新分区）、*broadcast()*（广播）或 *rebalance()*（随机重新分发）。在*重新分发*数据的过程中，元素只有在每对输出和输入子任务之间才能保留其之间的顺序信息（例如，*keyBy/window* 的 subtask[2] 接收到的 *map()* 的 subtask[1] 中的元素都是有序的）。因此，上图所示的 *keyBy/window* 和 *Sink* 算子之间数据的重新分发时，不同键（key）的聚合结果到达 Sink 的顺序是不确定的。

## 及时流处理 Timely Stream Processing [#](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/learn-flink/overview/#timely-stream-processing)

对于大多数流处理应用，能够用处理实时数据的代码重新处理历史数据并产生确定的、一致的结果十分有价值。

关注事件发生时间而不是处理时间，并有能力推断出事件在何时结束（或者应当在何时结束）也是十分重要的。例如电子商务交易或金融交易中涉及到的事件集合。

这些对及时流处理的要求可以通过使用数据流中记录的事件时间水印来满足，而不是使用处理数据的机器本地时钟。

## 有状态流处理 [#](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/learn-flink/overview/#stateful-stream-processing)

Flink中的操作可以是有状态的。这意味着一个事件具体如何被处理将依赖于所有在其之前到达事件的累计效果。状态可以被用在一些简单的计算每分钟到达事件数量并在仪表盘展示的场景，或者复杂些的场景（例如计算诈骗检测模式的特征）。

Flink应用在分布式集群上并行运行。一个特定算子的各种并行实例总体来说运行在不同机器上，在单独的线程中独立运行。

有状态算子的并行实例集合在存储其对应状态时通常是按照键（key）进行分片存储的。每个并行实例负责处理一组特定键的事件数据，并且这组键对应的状态会保存在本地。

如下图的Flink 作业，其前三个算子的并行度为 2，最后一个 sink 算子的并行度为 1，其中第三个算子是有状态的，并且你可以看到第二个算子和第三个算子之间是全互联的（fully-connected），它们之间通过网络进行数据分发。通常情况下，实现这种类型的 Flink 程序是为了通过某些键对数据流进行分区，以便将需要一起处理的事件进行汇合，然后做统一计算处理。

![State is sharded](https://nightlies.apache.org/flink/flink-docs-release-1.13/fig/parallel-job.png)

Flink 应用程序的状态访问都在本地进行，因为这有助于其提高吞吐量和降低延迟。通常情况下 Flink 应用程序都是将状态存储在 JVM 堆上，但如果状态太大，我们也可以选择将其以结构化数据格式存储在高速磁盘中。

![State is local](https://nightlies.apache.org/flink/flink-docs-release-1.13/fig/local-state.png)



## 通过状态快照实现容错 [#](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/learn-flink/overview/#fault-tolerance-via-state-snapshots)

Flink可以通过状态快照和流重现提供容错和严格一次语义。这些快照捕获整个分布式管道的状态，会将数据源中消费数据的偏移量记录下来，并将整个 job graph 中算子获取到该数据（记录的偏移量对应的数据）时的状态记录并存储下来。

当发生故障时，Flink 作业会恢复上次存储的状态，重置数据源从状态中记录的上次消费的偏移量开始重新进行消费处理。而且状态快照在执行时会异步获取状态并存储，并不会阻塞正在进行的数据处理逻辑。

# DataStream API简介  [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/datastream_api/#intro-to-the-datastream-api)

## 流处理对象 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/datastream_api/#what-can-be-streamed)

Flink的DataStream API允许处理任何能够序列化的数据类型。Flink自己的序列化支持：

- 基本类型：String, Long, Integer, Boolean, Array
- 复合类型：元组、POJO、和Scala样例类（[Scala case classes](https://docs.scala-lang.org/tour/case-classes.html)）

对于其他类型Flink回退到Kryo作为序列化器。也可以使用其他序列化器，Avro就支持的很好。

### Java元组和POJO

Flink的本地序列化器可以对元组和POJO高效操作。

Java语言中Flink定义了从`Tuple0`到`Tuple25`类型。

```java
Tuple2<String, Integer> person = Tuple2.of("Fred", 35);

// zero based index!  
String name = person.f0;
Integer age = person.f1;
```

如果以下条件满足，Flink会把数据类型识别为POJO：

- 类是公有且独立的（没有非静态内部类）
- 有一个公有的无参构造函数
- 该类及其所有超类的所有非静态（static）、非临时字段（[transient](https://www.cnblogs.com/chenpi/p/6185773.html#:~:text=Java%E4%B8%ADtra,%E9%9C%80%E8%A6%81%E8%A2%AB%E5%BA%8F%E5%88%97%E5%8C%96%E5%91%A2%EF%BC%9F)）要么有公有访问属性、要么有遵守Java bean命名习惯的getter和setter方法

例如：

```java
public class Person {
    public String name;  
    public Integer age;  
    public Person() {}
    public Person(String name, Integer age) {  
        . . .
    }
}  

Person person = new Person("Fred Flintstone", 35);
```



## 完整示例 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/datastream_api/#a-complete-example)

```java
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.api.common.functions.FilterFunction;

public class Example {

    public static void main(String[] args) throws Exception {
        final StreamExecutionEnvironment env =
                StreamExecutionEnvironment.getExecutionEnvironment();

        DataStream<Person> flintstones = env.fromElements(
                new Person("Fred", 35),
                new Person("Wilma", 35),
                new Person("Pebbles", 2));

        DataStream<Person> adults = flintstones.filter(new FilterFunction<Person>() {
            @Override
            public boolean filter(Person person) throws Exception {
                return person.age >= 18;
            }
        });

        adults.print();

        env.execute();
    }

    public static class Person {
        public String name;
        public Integer age;
        public Person() {}

        public Person(String name, Integer age) {
            this.name = name;
            this.age = age;
        }

        public String toString() {
            return this.name.toString() + ": age " + this.age.toString();
        }
    }
}
```

### 流执行环境，Stream execution environment [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/datastream_api/#stream-execution-environment)

每个Flink应用都需要执行环境，流处理应用需要使用`StreamExecutionEnvironment`。

用户应用中的DataStream API调用会建立一个附加在`StreamExecutionEnvironment`上的作业图。当`env.execute()`被调用时作业图被打包起来发送到JobManager，JobManager把提交的作业并行化、形成多个任务分发给TaskManager来执行。提交作业的每一个并行划分都在一个task slot中被执行。

注意如果不调用`env.execute()`，流处理应用就不会运行。

![Flink runtime: client, job manager, task managers](https://nightlies.apache.org/flink/flink-docs-release-1.14/fig/distributed-runtime.svg)

此分布式运行时取决于你的应用是否是可序列化的。它还要求所有依赖对集群中的每个节点均可用。



### 基本流数据源，Basic stream sources [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/datastream_api/#basic-stream-sources)

上述示例用 `env.fromElements(...)` 方法构造 `DataStream<Person>` 。这样将简单的流放在一起是为了方便用于原型或测试。`StreamExecutionEnvironment` 上还有一个 `fromCollection(Collection)` 方法。因此，你可以这样做：

```java
List<Person> people = new ArrayList<Person>();

people.add(new Person("Fred", 35));
people.add(new Person("Wilma", 35));
people.add(new Person("Pebbles", 2));

DataStream<Person> flintstones = env.fromCollection(people);
```

另一个获取数据到流中的便捷方法是用 socket

```java
DataStream<String> lines = env.socketTextStream("localhost", 9999)
```

或读取文件

```java
DataStream<String> lines = env.readTextFile("file:///path");
```

真实应用中最常用的数据源是那些支持低延迟、高吞吐并行读取同时能够倒退和重复（高性能和容错的先决条件）的数据源，例如Apache Kafka、Kinesis和各种文件系统。REST API和数据库也常用在数据增强的流处理中。



### 基本流接收器，Basic stream sinks [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/datastream_api/#basic-stream-sinks)

上面的示例中使用`adults.print()`来把结果打印到task manager的日志中（当运行在集成开发环境时，结果会显示在集成开发环境终端上）。对流的每个数据元素都会调用`toString`方法。

输出看起来类似于

```
1> Fred: age 35
2> Wilma: age 35
```

1> 和 2> 指出输出来自哪个 sub-task（即 thread）

生产环境中常用的接收器包括`StreamingFileSink`、各种数据库和分发订阅系统。

### 调试 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/datastream_api/#debugging)

在生产环境中，应用程序将在远程集群或一组容器中运行。如果集群或容器挂了，这就属于远程失败。JobManager 和 TaskManager 日志对于调试此类故障非常有用，但更简单的是 Flink 支持在 IDE 内部进行本地调试。你可以设置断点，检查局部变量，并逐行执行代码。如果想了解 Flink 的工作原理和内部细节，查看 Flink 源码也是非常好的方法。

## 上手练习 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/datastream_api/#hands-on)

At this point you know enough to get started coding and running a simple DataStream application. Clone the [flink-training-repo ](https://github.com/apache/flink-training/tree/release-1.14/), and after following the instructions in the README, do the first exercise: [Filtering a Stream (Ride Cleansing) ](https://github.com/apache/flink-training/blob/release-1.14//ride-cleansing).



## 更多阅读 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/zh/docs/learn-flink/datastream_api/#更多阅读)

- [Flink Serialization Tuning Vol. 1: Choosing your Serializer — if you can](https://flink.apache.org/news/2020/04/15/flink-serialization-tuning-vol-1.html)
- [Anatomy of a Flink Program](https://nightlies.apache.org/flink/flink-docs-release-1.14/zh/docs/dev/datastream/overview/#anatomy-of-a-flink-program)
- [Data Sources](https://nightlies.apache.org/flink/flink-docs-release-1.14/zh/docs/dev/datastream/overview/#data-sources)
- [Data Sinks](https://nightlies.apache.org/flink/flink-docs-release-1.14/zh/docs/dev/datastream/overview/#data-sinks)
- [DataStream Connectors](https://nightlies.apache.org/flink/flink-docs-release-1.14/zh/docs/connectors/datastream/overview/)





# 数据管道和ETL [#](https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/learn-flink/etl/#data-pipelines--etl)



## 无状态变换

无状态变换部分介绍了`map()`和`flatmap()`两种基本操作。用到了 [flink-training-repo ](https://github.com/apache/flink-training/tree/release-1.14/)中的Taxi Rdie数据。

### `map()` [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/etl/#map)

`map()`是`MapFunction`所定义的操作，可以对流数据进行逐元素的数据变换。

例如示例代码把`TaxiRide`变换为`EnrichedRide`：

```java
public static class Enrichment implements MapFunction<TaxiRide, EnrichedRide> {

    @Override
    public EnrichedRide map(TaxiRide taxiRide) throws Exception {
        return new EnrichedRide(taxiRide);
    }
}
```

### `flatmap()` [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/etl/#flatmap)

`MapFunction`只适合逐元素变换的情况，对每个盗来的数据元素都会进行一次`map()`操作。否则，如果变换前和变换后数据元素数量不等，就应该考虑使用`flatmap()`。

`flatmap()`提供了`Collector`， 可以触发任意数量的流数据元素。

```java
blic static class NYCEnrichment implements FlatMapFunction<TaxiRide, EnrichedRide> {

    @Override
    public void flatMap(TaxiRide taxiRide, Collector<EnrichedRide> out) throws Exception {
        FilterFunction<TaxiRide> valid = new RideCleansing.NYCFilter();
        if (valid.filter(taxiRide)) {
            out.collect(new EnrichedRide(taxiRide));
        }
    }
}
```

## 带有键的流 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/etl/#keyed-streams)

### `keyBy()` [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/etl/#keyby)

把流根据一个属性值进行划分，使得所有具有同一属性值的时间处于同一个分区很有意义。例如你想找出从每个网格出发的最长出租车行程。就SQL查询而言，需要对`startCell`进行`GROUP BY`操作，而Flink可以通过`keyby(keySelector)`来实现这个操作。

```java
rides
    .flatMap(new NYCEnrichment())
    .keyBy(enrichedRide -> enrichedRide.startCell);
```

每个`keyBy`操作都会触发对流重新分区的网络`shuffle`操作。总的来说这个操作开销很大，因为涉及到了网络通信和序列化、反序列化。

![keyBy and network shuffle](https://nightlies.apache.org/flink/flink-docs-release-1.14/fig/keyBy.png)



### 键可以是计算结果 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/etl/#keys-are-computed)

键选择器不仅限于从事件提取键，也可以以用户希望的方式计算键，只要最终键的计算结果是确定的、有正确的`hashcode()`和`equals()`实现。这样的限制排除了生成随机数或者返回枚举数组的键选择器，但是可以使用元组或POJO等复合键，只要复合键的每个元素都满足上面的规则即可。

键必须以确定的方式产生，因为一旦有需要就会重新计算键，键并不是依附于每一条流数据记录的。





### 在带有键的流上进行聚合操作 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/etl/#aggregations-on-keyed-streams)

下面这段代码创建了包含`startCell`和行程分钟数的流：

```java
import org.joda.time.Interval;

DataStream<Tuple2<Integer, Minutes>> minutesByStartCell = enrichedNYCRides
    .flatMap(new FlatMapFunction<EnrichedRide, Tuple2<Integer, Minutes>>() {

        @Override
        public void flatMap(EnrichedRide ride,
                            Collector<Tuple2<Integer, Minutes>> out) throws Exception {
            if (!ride.isStart) {
                Interval rideInterval = new Interval(ride.startTime, ride.endTime);
                Minutes duration = rideInterval.toDuration().toStandardMinutes();
                out.collect(new Tuple2<>(ride.startCell, duration));
            }
        }
    });
```

现在可以生成一个截止事件处理为止花费时间最长的行程的构成的流。

有各种能够表达作为键字段的方式。使用POJO可以通过字段名来指定作为键的字段，而这里用的是Java元组，使用元组内的下标来指定键。

```java
minutesByStartCell
  .keyBy(value -> value.f0) // .keyBy(value -> value.startCell)
  .maxBy(1) // duration
  .print();
```

输出流对每个起点网格每次行程时间达到最大值时都会产生一条记录：

```
...
4> (64549,5M)
4> (46298,18M)
1> (51549,14M)
1> (53043,13M)
1> (56031,22M)
1> (50797,6M)
...
1> (50797,8M)
...
1> (50797,11M)
...
1> (50797,12M)
```



###  隐状态 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/etl/#implicit-state)



尽管Flink中状态处理是透明的，在这个例子中Flink还是得跟踪每个不同键的最大行程时间。

只要应用中涉及到状态，就应该考虑状态规模可能的大小。如果键空间变得无限大，那么Flink状态的数量也得是无限的。

流处理应用中，考虑在有限窗口上的聚合计算要比在整个流上聚合计算有意义得多。





### `reduce()` and other aggregators [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/etl/#reduce-and-other-aggregators)

上面用到的`maxBy()`只是Flink`KeyedStream`中聚合函数的一种，还有更加通用的`reduce()`函数可以用来实现自定义聚合。



## 有状态变换 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/etl/#stateful-transformations)

### Flink为什么参与状态管理? [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/etl/#why-is-flink-involved-in-managing-state)

应用即使没有Flink来管理状态一样能够使用状态，但是Flink对其管理的状态提供了一些引人注目的功能：

- **本地性**：Flink状态保存在处理状态的机器本地，可以以内存速度访问
- **持久性**：Flink状态是容错的，以规定间隔设置检查点，一旦出错就会恢复
- **纵向可扩展性**: Flink 状态可以存储在集成的 RocksDB 实例中，这种方式下可以通过增加本地磁盘来扩展空间
- **横向可扩展性**: Flink 状态可以随着集群的扩展、收缩重新分发
- **可查询性**：Flink状态可以通过状态查询API [Queryable State API](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/dev/datastream/fault-tolerance/queryable_state/)从外部查询

这部分介绍如何使用Flink API管理键的状态。

### Rich Functions [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/zh/docs/learn-flink/etl/#rich-functions)

至此，你已经看到了 Flink 的几种函数接口，包括 `FilterFunction`， `MapFunction`，和 `FlatMapFunction`。这些都是单一抽象方法模式。

对其中的每一个接口，Flink 同样提供了一个所谓 “rich” 的变体，如 `RichFlatMapFunction`，其中增加了以下方法，包括：

- `open(Configuration c)`
- `close()`
- `getRuntimeContext()`

`open()` 仅在算子初始化时调用一次。可以用来加载一些静态数据，或者建立外部服务的链接等。

`getRuntimeContext()` 为整套状态管理提供了一个访问途径，可以创建、访问由Flink管理的状态。

### 键状态的示例  [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/etl/#an-example-with-keyed-state)

想象有一个事件流，需要去重，使得只有每个键的第一个事件被保留。下面的代码实现了这个需求，用到了叫作`Deduplicator`的`RichFlatMapFunction`：

```java
private static class Event {
    public final String key;
    public final long timestamp;
    ...
}

public static void main(String[] args) throws Exception {
    StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
  
    env.addSource(new EventSource())
        .keyBy(e -> e.key)
        .flatMap(new Deduplicator())
        .print();
  
    env.execute();
}
```

为了实现这个功能，`Deduplicator` 需要记录每个键是否已经有了相应的记录。它将通过使用 Flink 的 *keyed state* 接口来做这件事。

当你使用像这样的 keyed stream 的时候，Flink 会为每个状态中管理的条目维护一个键值存储。

Flink 支持几种不同方式的 keyed state，这个例子使用的是最简单的一个，叫做 `ValueState`。意思是对于 *每个键* ，Flink 将存储一个单一的对象 —— 在这个例子中，存储的是一个 `Boolean` 类型的对象。

我们的 `Deduplicator` 类有两个方法：`open()` 和 `flatMap()`。`open()` 方法通过定义 `ValueStateDescriptor<Boolean>` 建立了管理状态的使用。构造器的参数定义了这个状态的名字（“keyHasBeenSeen”），并且为如何序列化这些对象提供了信息（在这个例子中的 `Types.BOOLEAN`）。

```java
public static class Deduplicator extends RichFlatMapFunction<Event, Event> {
    ValueState<Boolean> keyHasBeenSeen;

    @Override
    public void open(Configuration conf) {
        ValueStateDescriptor<Boolean> desc = new ValueStateDescriptor<>("keyHasBeenSeen", Types.BOOLEAN);
        keyHasBeenSeen = getRuntimeContext().getState(desc);
    }

    @Override
    public void flatMap(Event event, Collector<Event> out) throws Exception {
        if (keyHasBeenSeen.value() == null) {
            out.collect(event);
            keyHasBeenSeen.update(true);
        }
    }
}
```

当 flatMap 方法调用 `keyHasBeenSeen.value()` 时，Flink 会在 当前键的上下文 中检索状态值，只有当状态为 `null` 时，才会输出当前事件。这种情况下，它同时也将更新 `keyHasBeenSeen` 为 `true`。

这种访问、更新键状态的机制也许看起来非常神奇，因为键在`Deduplicator`类的实现中不是显式可见的。当Flink运行时调用`RickFlatMapFunction`的`open`方法时，上下文中还没有事件、也没有键。但是调用`flatMap`方法时，被处理事件的键对运行时可用，Flink将在幕后通过键来确定操作Flink状态后端中哪个条目。

在分布式集群上部署Flink时，有许多`Deduplicator`的实例，每个实例负责处理整个键空间的一个独立子集。之后，应用程序就能够访问到`ValueState`的一个项目，例如：

```java
ValueState<Boolean> keyHasBeenSeen;
```

要理解`ValueState`不只是代表一个`Boolean`变量，而是一个分布式的、共享的键值存储。

### 清空状态  [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/etl/#clearing-state)

上面例子有个潜在问题：如果键空间无限会怎么样？Flink要给每个不同的键在某个空间存储一个`Boolean`类型的对象。在键集合无限增长的应用中，有必要把不需要的键状态清空。通过调用状态对象的`clear`方法来清空状态：

```java
keyHasBeenSeen.clear();
```

例如在某个键有一段时间不活跃之后，你可能想要清空其状态。当学习 `ProcessFunction` 的相关章节时，你将看到在事件驱动的应用中怎么用定时器来清空键状态。

也可以用状态描述符的 [State Time-to-Live (TTL)](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/dev/datastream/fault-tolerance/state/#state-time-to-live-ttl) 选项来指定键状态多久之后被自动清空。

### Non-keyed State [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/etl/#non-keyed-state)

在不带键的情境下也可以使用托管状态。有时被称作算子状态[operator state](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/dev/datastream/fault-tolerance/state/#operator-state)。不带键的状态其涉及的接口有些出入，用户定义函数中用到不带键状态的情况也不多。通常用在数据源和接收器的实现源码中。

## 链接流，Connected Streams [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/etl/#connected-streams)

有时并不是像下面一样是加一个预定义变换：

![simple transformation](https://nightlies.apache.org/flink/flink-docs-release-1.14/fig/transformation.svg)

而是希望动态调整流变换的某些方面，例如阈值、规则或其他参数。Flink 支持这种需求的模式称为 *connected streams* ，一个单独的算子有两个输入流。

![connected streams](https://nightlies.apache.org/flink/flink-docs-release-1.14/fig/connected-streams.svg)

链接流也可以用来实现流之间的关联。

### 示例 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/etl/#example)

例子中有一个控制流用来指定哪些单词必须从`streamOfWords`流中过滤掉。叫作`ControlFunction`的`RichCoFlatMapFunction`被施加到控制流上来实现过滤功能。

```java
public static void main(String[] args) throws Exception {
    StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

    DataStream<String> control = env
        .fromElements("DROP", "IGNORE")
        .keyBy(x -> x);

    DataStream<String> streamOfWords = env
        .fromElements("Apache", "DROP", "Flink", "IGNORE")
        .keyBy(x -> x);
  
    control
        .connect(streamOfWords)
        .flatMap(new ControlFunction())
        .print();

    env.execute();
}
```

要注意两个被链接的流必须设置兼容的键。`keyBy`的作用是给流数据分区，当两个带键的流链接时，必须都以相同的方式分区。分区保证了两个流中键相同的所有事件都会被发送到相同的实例。于是，根据同样的键关联两个流成为可能。

在这个例子中两个流都是`DataStream<String>`类型，都根据字符串分区。如下面代码所示，`RichCoFlatMapFunction`在键状态中存储了`Boolean`类型的值，这个值被两个流共享。

```java
public static class ControlFunction extends RichCoFlatMapFunction<String, String, String> {
    private ValueState<Boolean> blocked;
      
    @Override
    public void open(Configuration config) {
        blocked = getRuntimeContext()
            .getState(new ValueStateDescriptor<>("blocked", Boolean.class));
    }
      
    @Override
    public void flatMap1(String control_value, Collector<String> out) throws Exception {
        blocked.update(Boolean.TRUE);
    }
      
    @Override
    public void flatMap2(String data_value, Collector<String> out) throws Exception {
        if (blocked.value() == null) {
            out.collect(data_value);
        }
    }
}
```

`RichCoFlatMapFunction`是一种可以应用在一对链接流上的`FlatMapFunction`，同时可以访问rich function interface。这意味着可以应用在有状态流处理中。

布尔变量`blocked`用来标记在控制流中出现过的键，相应的单词将被从`streamOfWords`中过滤掉。这些变量是键状态，被两个流共享，这也是两个流必须共享同一个键空间的原因。

`flatMap1`和`flatMap2`被Flink运行时调用，在示例中控制流的数据会被传递给`flatMap1`，`streamOfWords`流中的数据会被传递给`flatMap2`。流数据和映射函数之间的对应关系是由两个流之间的连接顺序确定的： `control.connect(streamOfWords)`。

需要认识到程序员对`flatMap1`和`flatMap2`被调用的顺序是无法控制的，这一点很重要。Flink运行时将根据从链接流中消费到的事件来调用相应的方法。在必须考虑事件处理时间或顺序的场景中，可能有必要把事件缓存在Flink托管状态中直到应用可以处理事件。如果缓存还是不适合你的需求，也可以使用自定义算子实现`InputSelectable`接口，对双输入算子消费其数据的顺序加以限制。

## Further Reading [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/etl/#further-reading)

- [DataStream Transformations](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/dev/datastream/operators/overview/#datastream-transformations)介绍了数据流变换操作、物理分区和任务链接
- [Stateful Stream Processing](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/concepts/stateful-stream-processing/)（流处理概念：有状态流处理）

# 流分析 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#streaming-analytics)

## 事件时间和水印 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#event-time-and-watermarks)

### 简介 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#introduction)

Flink显式支持三种时间表达：

- 事件时间：即时间发生时间，由产生事件的设备记录
- 达到时间：Flink在消费事件时记录的时间戳
- 处理时间：数据管道中某个算子正在处理事件时的时间

为了产生可复现结果，应该使用事件发生时间（例如计算某个股票交易日前一小时某只股票的最大份额）。使用事件发生时间时，产生的结果不依赖于计算何时执行。这种实时应用有时使用处理时间，但是结果将由那一小时内被处理的事件决定，而不是那一小时内发生的事件。基于处理时间计算数据分析会造成不一致、给重新分析历史数据或测试信实现带来困难。

### 使用事件发生时间 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#working-with-event-time)

如果想使用事件发生时间，需要提供时间戳提取器（Timestamp Extractor）和Flink用来跟踪事件时间进展的水印生成器（Watermark Generator）。这些内容将在使用水印（[Working with Watermarks](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#working-with-watermarks)）讲到，首先需要解释一下什么是水印。

### 水印 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#watermarks)

先看一个例子，解释了水印的必要性和工作原理。

在这个例子中有一个加了时间戳的失序流，如下所示。下面的数字表示事件真实发生的时间。第一个到达的事件发生时间是4，随后到来的是一个发生更早的事件（发生时间是2）：

··· 23 19 22 24 21 14 17 13 12 15 9 11 7 2 4 →

现在假设要创建一个对流进行排序的程序。这意味着我们的程序从事件流处理每一个到来的事件，产生一个按照事件发生时间的时间戳排序的新事件流。

明确一些观察得出的结论：

（1）现在事件流第一个元素发生时间是4，但还不能立刻将其放入新流作为第一个元素。流的事件有可能是失序的，还有更早发生的事件可能还没有到来。如果以上帝视角来看这个事件流，就会知道程序至少得等待时间点2发生的时间到来才能处理事件。

*在这里缓冲和延迟成为必要*。

（2）如果不能合适的处理延迟，就可能陷入无限等待之中。首先程序看到来自时间点4的事件，然后来自时间点2的事件到来。会有早于时间点2发生的事件到来吗？可能会，可能不会。有可能一直等待却没有发生于时间点1的事件到来。

*最终还是得做出决断，把2放入新流作为有序流的起始元素*。

（3）接下来需要的是某种策略，对于任何时间戳的事件，必须能够确定何时停止等待更早的事件到来。

*而这就是水印所完成的工作：它定义了什么时候停止等待更早的事件*。

Flink中的事件时间处理依赖于水印生成器，它在事件流中注入设置了专门时间戳的元素（叫做水印）。时间t的水印断言事件流截止时间t为止已经（或者很可能）完成，不会再有早于时间t的事件到来。

那么程序应该什么时候停止等待，并把事件2推送到排序的流中？显而易见是当大于等于2的水印到来时。

（4）可以预料会有不同的水印生成策略。

每个时间在一定的延迟之后到达，这些延迟也可能是变化的，所以有些事件的延迟可能会比其他事件大。一种简单方法是假定延迟最大不超过某个界限。Flink把这种策略叫做有界限失序水印（bounded-out-of-orderness watermarking）。容易想到更多复杂的水印生成方法，但是对大多数应用而言固定的延迟已经足够。



### 延迟和完备性，Latency vs. Completeness [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#latency-vs-completeness)

另一种考虑水印的方法是把延迟和完备性之间的权衡程度交给流应用开发人员去控制。流应用不像批处理应用，开发者在产生结果之前就能对输入数据有完整的了解。在流处理应用中，必须停止等待潜在的输入并产生某种结果。

要么你可以配置水印为较短的延迟界限，虽然较快的产生结果，同样也就冒着产生错误结果的风险。或者可以选择等待更长的时间，产生对的数据完备性利用程度更高的结果。

此外，也可以实现快速生成起始结果，然后当额外数据到来时对结果进行更新的混合式解决方案。这也是有些应用场景的好方法。

### Lateness [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#lateness)

延迟是相对于水印来定义的。`watermark(t)`断言事件流截止时间t已经完成，任何后来到达的时间戳小于t的事件都是迟到的。



### 使用水印 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#working-with-watermarks)

为了进行基于事件发生时间的事件处理，Flink需要知道每个事件相关联的时间，同样也需要使用水印。

可以通过实现一个从时间中提取时间戳以及在需要时生成水印的类来使程序能够进行基于事件时间的事件处理。最简单的方法就是使用`WatermarkStrategy`：

```java
DataStream<Event> stream = ...

WatermarkStrategy<Event> strategy = WatermarkStrategy
        .<Event>forBoundedOutOfOrderness(Duration.ofSeconds(20))
        .withTimestampAssigner((event, timestamp) -> event.timestamp);

DataStream<Event> withTimestampsAndWatermarks =
    stream.assignTimestampsAndWatermarks(strategy);
```













## 窗口 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#windows)

Flink的一大亮点就是富有表达力的窗口语义。这个部分介绍：

- 如何使用窗口在无界限流上进行聚合计算
- Flink支持哪些类型的窗口
- 如何实现一个支持窗口聚合计算的`DataStream`数据流程序

### 窗口简介 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#introduction-1)

在进行流处理时为了像下面这样的问题很自然地需要在流的有限子集上计算聚合分析：

- 每分钟的页面浏览量
- 每个用户每周的会话次数
- 每个传感器每分钟的最高温度

用Flink计算窗口化的数据分析依赖两个基本抽象：把事件分配给窗口的窗口分配器`Window Assigner`和被施加在已分配事件上的窗口函数`Window Function`

Flink窗口API也有用来确定何时调用窗口函数的触发器`Triggers`和能够从窗口中移除被收集元素的消除器`Evictors`。

对带键的流应用窗口的基本形式如下：

```java
stream.
    .keyBy(<key selector>)
    .window(<window assigner>)
    .reduce|aggregate|process(<window function>);
```

也可以对不带键的流应用窗口，但是要记住这种情况下流处理就不是并行了：

```java
stream.
    .windowAll(<window assigner>)
    .reduce|aggregate|process(<window function>);
```





### 窗口分配器 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#window-assigners)

Flink有几种内置的窗口分配器，展示如下：

![Window assigners](https://nightlies.apache.org/flink/flink-docs-release-1.14/fig/window-assigners.svg)

以下是一些窗口分配器的用例和使用方法：

- 滚动时间窗口
  - *每分钟页面浏览量*
  - `TumblingEventTimeWindows.of(Time.minutes(1))`
- 滑动时间窗口
  - *每10秒钟计算前1分钟的页面浏览量*
  - `SlidingEventTimeWindows.of(Time.minutes(1), Time.seconds(10))`
- 会话窗口
  - *每个会话的网页浏览量，其中会话之间的间隔至少为30分钟*
  - `EventTimeSessionWindows.withGap(Time.minutes(30))`

以下都是一些可以使用的间隔时间 `Time.milliseconds(n)`, `Time.seconds(n)`, `Time.minutes(n)`, `Time.hours(n)`, 和 `Time.days(n)`。

基于时间的窗口分配器（包括会话时间）既可以处理 `事件时间`，也可以处理 `处理时间`。这两种基于时间的处理没有哪一个更好，我们必须折衷。使用 `处理时间`，我们必须接受以下限制：

- 无法正确处理历史数据,
- 无法正确处理超过最大无序边界的数据,
- 结果将是不确定的,

但是有自己的优势，较低的延迟。

使用基于计数的窗口时，请记住只有窗口内的事件数量到达窗口要求的数值时，这些窗口才会触发计算。尽管可以使用自定义触发器自己实现该行为，但无法应对超时和处理不完整窗口。

可能在有些场景下，想使用全局 window assigner 将每个事件（相同的 key）都分配给某一个指定的全局窗口。这只有在你想要实现一个带有自定义触发器的定制窗口时才有用。很多情况下，一个比较好的建议是使用 `ProcessFunction`，具体介绍在[这里](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/event_driven/#process-functions)。

### 窗口函数 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#window-functions)

对于如何处理窗口内数据有三种选择：

1. 以批处理模式，`ProcessWindowFunction` 会缓存 `Iterable` 和窗口内容，供接下来全量计算；
2. 流处理模式，每一次有事件被分配到窗口时，都会调用 `ReduceFunction` 或者 `AggregateFunction` 来增量计算；
3. 或者结合两者，`ReduceFunction` 或者 `AggregateFunction` 预聚合的计算结果在触发窗口时， 提供给 `ProcessWindowFunction` 做全量计算。

接下来展示一段 1 和 3 的示例，每一个实现都是计算传感器的最大值。在每一个一分钟大小的事件时间窗口内, 生成包含 `(key,end-of-window-timestamp, max_value)` 的一组结果。

#### `ProcessWindowFunction`的示例 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#processwindowfunction-example)

```java
DataStream<SensorReading> input = ...

input
    .keyBy(x -> x.key)
    .window(TumblingEventTimeWindows.of(Time.minutes(1)))
    .process(new MyWastefulMax());

public static class MyWastefulMax extends ProcessWindowFunction<
        SensorReading,                  // input type
        Tuple3<String, Long, Integer>,  // output type
        String,                         // key type
        TimeWindow> {                   // window type
    
    @Override
    public void process(
            String key,
            Context context, 
            Iterable<SensorReading> events,
            Collector<Tuple3<String, Long, Integer>> out) {

        int max = 0;
        for (SensorReading event : events) {
            max = Math.max(event.value, max);
        }
        out.collect(Tuple3.of(key, context.window().getEnd(), max));
    }
}
```

这个实现中有几点要注意：

- 分配到窗口的所有事件都要被缓存在Flink键状态中直到窗口被触发计算。这个开销可能会很大。
-  `ProcessWindowFunction`接受一个包含窗口信息的`Context`对象。`Context`的接口
-  展示大致如下:

```java
public abstract class Context implements java.io.Serializable {
    public abstract W window();

    public abstract long currentProcessingTime();
    public abstract long currentWatermark();

    public abstract KeyedStateStore windowState();
    public abstract KeyedStateStore globalState();
}
```

`windowState`和`globalState`可以存储窗口或键的信息。这在我们需要记录当前窗口信息，并在处理后续窗口时使用这些信息的情况下很有用。



#### 增量聚合的示例 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#incremental-aggregation-example)

```java
DataStream<SensorReading> input = ...

input
    .keyBy(x -> x.key)
    .window(TumblingEventTimeWindows.of(Time.minutes(1)))
    .reduce(new MyReducingMax(), new MyWindowFunction());

private static class MyReducingMax implements ReduceFunction<SensorReading> {
    public SensorReading reduce(SensorReading r1, SensorReading r2) {
        return r1.value() > r2.value() ? r1 : r2;
    }
}

private static class MyWindowFunction extends ProcessWindowFunction<
    SensorReading, Tuple3<String, Long, SensorReading>, String, TimeWindow> {

    @Override
    public void process(
            String key,
            Context context,
            Iterable<SensorReading> maxReading,
            Collector<Tuple3<String, Long, SensorReading>> out) {

        SensorReading max = maxReading.iterator().next();
        out.collect(Tuple3.of(key, context.window().getEnd(), max));
    }
}
```

请注意 `Iterable<SensorReading>` 将只包含一个读数 – `MyReducingMax` 计算出的预先汇总的最大值。

### 迟到事件 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#late-events)

默认在使用事件时间窗口时，吃到时间会被丢弃。窗口API中控制持刀事件处理行为的有两个可选部分。

可以使用叫做旁路输出（[Side Outputs](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/event_driven/#side-outputs)）的机制，把将要被丢弃的时间收集到另一个输出流中。这里是一个示例:

```java
OutputTag<Event> lateTag = new OutputTag<Event>("late"){};

SingleOutputStreamOperator<Event> result = stream.
    .keyBy(...)
    .window(...)
    .sideOutputLateData(lateTag)
    .process(...);

DataStream<Event> lateStream = result.getSideOutput(lateTag);
```

还可以指定 *允许的延迟(allowed lateness)* 的间隔，在这个间隔时间内，延迟的事件将会继续分配给窗口（同时状态会被保留），默认状态下，每个延迟事件都会导致窗口函数被再次调用（有时也称之为 *late firing* ）。

默认允许延迟是0，也就是说水印之后的元素将被丢弃（或被发送到旁路输出流）。例如：

```java
stream.
    .keyBy(...)
    .window(...)
    .allowedLateness(Time.seconds(10))
    .process(...);
```

当允许的延迟大于零时，只有那些超过最大无序边界以至于会被丢弃的事件才会被发送到侧输出流（如果已配置最大无序边界的话）。

### 一些和开发者预期不一致的窗口行为 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#surprises)

Flink 的窗口 API 某些方面有一些奇怪的行为，可能和我们预期的行为不一致。 根据 [Flink 用户邮件列表](https://flink.apache.org/community.html#mailing-lists) 和其他地方一些频繁被问起的问题, 以下是一些有关 Windows 的底层事实，这些信息可能会让您感到惊讶。

#### 滑动窗口会制造事件副本 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#sliding-windows-make-copies)

滑动窗口分配器会创建很多窗口对象，会把事件复制给每个相关的事件。例如如果你每15分钟就产生一个14小时的滑动窗口，那么每个事件会有4 * 24 = 96个副本。

#### 时间窗口对齐方式 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#time-windows-are-aligned-to-the-epoch)

假设使用一小时的时间窗口，并在12:05启动程序，第一个窗口并不是在1:05关闭，而是在1:00关闭。时间窗口对齐并不是从程序开始运行的那一刻算起顺延一个窗口的时间，而是默认对齐到时间窗口大小的倍数。

不过滚动时间窗口和滑动时间窗口接受一个可选的偏移量参数，可以用来改变时间窗口对齐的时间。详情查看[Tumbling Windows](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/dev/datastream/operators/windows/#tumbling-windows) and [Sliding Windows](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/dev/datastream/operators/windows/#sliding-windows)。

#### 窗口后面可以接窗口 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#windows-can-follow-windows)

比如说:

```java
stream
    .keyBy(t -> t.key)
    .window(<window assigner>)
    .reduce(<reduce function>)
    .windowAll(<same window assigner>)
    .reduce(<same reduce function>)
```

开发者可能会认为Flink运行时智能的处理了并行预聚合（前提是使用`ReduceFunction`或`AggregateFunction`），但并不是。

上面代码可行的原因是时间窗口产生的事件都被分配了标志着时间窗口结束时间的时间戳。任何消费这些事件的后续窗口应该和前一个窗口具有同样的窗口大小或者是之前窗口大小的倍数。

#### 空时间窗口不会产生结果 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#no-results-for-empty-timewindows)

只有在事件到来并被分配时窗口才被创建。所以如果一个给定的时序内没有事件，就不会产生结果。

#### Late Events Can Cause Late Merges [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#late-events-can-cause-late-merges)

会话窗口是基于可合并窗口的抽象。每个元素初始都被分配到一个单独的窗口中，之后只要窗口之间间隔小于设定的会话窗口大小就会被合并。这样，迟到的时间就有可能把两个本来独立的会话窗口串联起来，产生延迟合并的情况。

## Hands-on [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#hands-on)

The hands-on exercise that goes with this section is the [Hourly Tips Exercise ](https://github.com/apache/flink-training/blob/release-1.14//hourly-tips).

## Further Reading [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/streaming_analytics/#further-reading)

- [Timely Stream Processing](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/concepts/time/)：及时流处理的概念
- [Windows](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/dev/datastream/operators/windows/)：窗口的详细介绍。窗口生命周期、带键流和无键流的窗口、窗口分配器、窗口函数、Triggers、Evictors、允许延迟……

# 事件驱动应用 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/event_driven/#event-driven-applications)









# 容错 [#](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/learn-flink/fault_tolerance/#fault-tolerance-via-state-snapshots)

