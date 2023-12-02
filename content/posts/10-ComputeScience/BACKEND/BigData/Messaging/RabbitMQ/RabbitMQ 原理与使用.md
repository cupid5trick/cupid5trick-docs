---
title: Untitled
author: cupid5trick
created: -1
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

文档主页：[Documentation: Table of Contents — RabbitMQ](https://www.rabbitmq.com/documentation.html): <https://www.rabbitmq.com/documentation.html>

# 连接 Rabbitmq

通过 `ConnectionFactory` 建立连接。

```java
ConnectionFactory factory = new ConnectionFactory();
/// ConnectionFactory 默认会创建一个线程池建立连接，也可以传入自定义的线程池
/// 默认的线程池在连接断开时自动调用其 shutdown() 方法销毁线程池，自定义线程池则需要手动销毁，否则 JVM 无法退出
/// 自定义线程池只有在消费者执行回调方法成为主要瓶颈时使用，如果消费者回调方法较少，默认创建的线程池就足够使用了。
ExecutorService es = Executors.newFixedThreadPool(20);
Connection conn = factory.newConnection(es);
```

声明交换机（exchange）

exchange 和 queue 的声明操作会保证存在相应名称的exchange/queue 存在，如果不存在则创建。如果已经存在，但是类型等属性不一致则会导致整个 channel 发生异常，必须重新创建 channel或者从异常状态恢复过来。

```java
// a durable, non-autodelete exchange of "direct" type
// channal.exchangeDeclare(exchangeName, exchangeType, durable, autoDelete, properties)
channel.exchangeDeclare(exchangeName, "direct", true);
```

声明消息队列：

```java
// a durable, non-exclusive, non-autodelete queue with a well-known name
channel.queueDeclare(queueName, true, false, false, properties);
// 绑定交换机
channel.queueBind(queueName, exchangeName, routingKey);
```

发布消息：

```java
channel.basicPublish(exchangeName, routingKey, properties, messageBodyBytes);
```

注册消费者，最简单的是使用 `Consumer` 接口， 也可以使用 `DeliverCallback` 接口：

```java
// Consumer 接口用法
boolean autoAck = false;
channel.basicConsume(queueName, autoAck, "myConsumerTag",
     new DefaultConsumer(channel) {
         @Override
         public void handleDelivery(String consumerTag,
                                    Envelope envelope,
                                    AMQP.BasicProperties properties,
                                    byte[] body)
             throws IOException
         {
             String routingKey = envelope.getRoutingKey();
             String contentType = properties.getContentType();
             long deliveryTag = envelope.getDeliveryTag();
             // (process the message components here ...)
             channel.basicAck(deliveryTag, false);
         }
     });

// DeliveryCallback 接口用法
DeliverCallback deliverCallback = (consumerTag, delivery) -> {
    String message = new String(delivery.getBody(), "UTF-8");
    System.out.println(" [x] Received '" + message + "'");
};
CancelCallback cancelCallback = consumerTag -> {
};
channel.basicConsume(queueName, autoAck, deliverCallback, cancelCallback);
```

# Queue and Consumer Features

- [Queues guide](https://www.rabbitmq.com/queues.html)
- [Consumers guide](https://www.rabbitmq.com/consumers.html)
- [Queue and Message TTL](https://www.rabbitmq.com/ttl.html)
- [Queue Length Limits](https://www.rabbitmq.com/maxlength.html)
- [Lazy Queues](https://www.rabbitmq.com/lazy-queues.html)
- [Dead Lettering](https://www.rabbitmq.com/dlx.html)
- [Priority Queues](https://www.rabbitmq.com/priority.html)
- [Consumer Cancellation Notifications](https://www.rabbitmq.com/consumer-cancel.html)
- [Consumer Prefetch](https://www.rabbitmq.com/consumer-prefetch.html)
- [Consumer Priorities](https://www.rabbitmq.com/consumer-priority.html)
- [Streams](https://www.rabbitmq.com/streams.html)

# Publisher Features

- [Publishers guide](https://www.rabbitmq.com/publishers.html)
- [Exchange-to-Exchange Bindings](https://www.rabbitmq.com/e2e.html)
- [Alternate Exchanges](https://www.rabbitmq.com/ae.html)
- [Sender-Selected Distribution](https://www.rabbitmq.com/sender-selected.html)

# STOMP, MQTT, WebSockets

- [Client Connections](https://www.rabbitmq.com/connections.html)
- [STOMP](https://www.rabbitmq.com/stomp.html)
- [MQTT](https://www.rabbitmq.com/mqtt.html)
- [STOMP over WebSockets](https://www.rabbitmq.com/web-stomp.html)
- [MQTT over WebSockets](https://www.rabbitmq.com/web-mqtt.html)

# Configuration

- [Configuration](https://www.rabbitmq.com/configure.html)
- [File and Directory Locations](https://www.rabbitmq.com/relocate.html)
- [Logging](https://www.rabbitmq.com/logging.html)
- [Policies and Runtime Parameters](https://www.rabbitmq.com/parameters.html)
- [Schema Definitions](https://www.rabbitmq.com/definitions.html)
- [Per Virtual Host Limits](https://www.rabbitmq.com/vhosts.html)
- [Client Connection Heartbeats](https://www.rabbitmq.com/heartbeats.html)
- [Inter-node Connection Heartbeats](https://www.rabbitmq.com/nettick.html)
- [Runtime Tuning](https://www.rabbitmq.com/runtime.html)
- [Queue and Message TTL](https://www.rabbitmq.com/ttl.html)

# Guidance

- [Monitoring](https://www.rabbitmq.com/monitoring.html)
- [Production Checklist](https://www.rabbitmq.com/production-checklist.html)
- [Backup and Restore](https://www.rabbitmq.com/backup.html)
- [Troubleshooting guidance](https://www.rabbitmq.com/troubleshooting.html)
- [Reliable Message Delivery](https://www.rabbitmq.com/reliability.html)

# 生产环境注意事项

[Production Checklist — RabbitMQ](https://www.rabbitmq.com/production-checklist.html): <https://www.rabbitmq.com/production-checklist.html>
