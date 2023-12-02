---
scope: work
draft: true
---
# Flink related operators

- [Test Featurizer (NLP)](https://gondola.einblick.ai/operators/predictive-analytics/text-featurizer)
- [Statistical Test](https://gondola.einblick.ai/operators/descriptive-analytics/statistical-test)
- [Mutual Information](https://gondola.einblick.ai/operators/predictive-analytics/mutual-information)

其他相关操作符：

- [**Correlation**](https://gondola.einblick.ai/operators/descriptive-analytics/correlation-operator)
- [Key Driver Analysis (KDA)](https://gondola.einblick.ai/operators/descriptive-analytics/key-driver-analysis-kda)
- 

# Flink Connectors

https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/connectors/datastream/overview/

## Bundled Connectors 

Connectors provide code for interfacing with various third-party systems. Currently these systems are supported:

- [Apache Kafka](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/connectors/datastream/kafka/) (source/sink)
- [Apache Cassandra](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/connectors/datastream/cassandra/) (sink)
- [Amazon Kinesis Streams](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/connectors/datastream/kinesis/) (source/sink)
- [Elasticsearch](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/connectors/datastream/elasticsearch/) (sink)
- [FileSystem (Hadoop included) - Streaming only sink](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/connectors/datastream/streamfile_sink/) (sink)
- [FileSystem (Hadoop included) - Streaming and Batch sink](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/connectors/datastream/file_sink/) (sink)
- [FileSystem (Hadoop included) - Batch source] (//nightlies.apache.org/flink/flink-docs-release-1.14/docs/connectors/datastream/formats/) (source)
- [RabbitMQ](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/connectors/datastream/rabbitmq/) (source/sink)
- [Google PubSub](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/connectors/datastream/pubsub/) (source/sink)
- [Hybrid Source](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/connectors/datastream/hybridsource/) (source)
- [Apache NiFi](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/connectors/datastream/nifi/) (source/sink)
- [Apache Pulsar](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/connectors/datastream/pulsar/) (source)
- [Twitter Streaming API](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/connectors/datastream/twitter/) (source)
- [JDBC](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/connectors/datastream/jdbc/) (sink)

## Connectors in Apache Bahir

Additional streaming connectors for Flink are being released through [Apache Bahir](https://bahir.apache.org/), including:

- [Apache ActiveMQ](https://bahir.apache.org/docs/flink/current/flink-streaming-activemq/) (source/sink)
- [Apache Flume](https://bahir.apache.org/docs/flink/current/flink-streaming-flume/) (sink)
- [Redis](https://bahir.apache.org/docs/flink/current/flink-streaming-redis/) (sink)
- [Akka](https://bahir.apache.org/docs/flink/current/flink-streaming-akka/) (sink)
- [Netty](https://bahir.apache.org/docs/flink/current/flink-streaming-netty/) (source)

## Async I/O

通过 [Asynchronous I/O](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/dev/datastream/operators/asyncio/) 接口进行 `Map` 或 `flatMap` 之类的 data enrichment 操作，高效稳定。

## Queryable State

Flink 写数据庞大、多于数据读取时考虑让外部应用从 Flink 的 [Queryable State](https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/dev/datastream/fault-tolerance/queryable_state/) interface 按需获取数据。
