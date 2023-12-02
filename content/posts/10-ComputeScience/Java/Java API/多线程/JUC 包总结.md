# JUC (java.util.concurrent)
[java.util.concurrent (Java Platform SE 8 )](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/package-summary.html)
https://docs.oracle.com/javase/tutorial/essential/concurrency/index.html

## 接口列表

| Interface                                    | Description                                                                                                                                                                                                 |
|----------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `BlockingDeque<E>`                             | A Deque that additionally supports blocking operations that wait for the deque to become non-empty when retrieving an element, and wait for space to become available in the deque when storing an element. |
| `BlockingQueue<E>`                             | A Queue that additionally supports operations that wait for the queue to become non-empty when retrieving an element, and wait for space to become available in the queue when storing an element.          |
| `Callable<V>`                                  | A task that returns a result and may throw an exception.                                                                                                                                                    |
| `CompletableFuture.AsynchronousCompletionTask` | A marker interface identifying asynchronous tasks produced by async methods.                                                                                                                                |
| `CompletionService<V>`                         | A service that decouples the production of new asynchronous tasks from the consumption of the results of completed tasks.                                                                                   |
| `CompletionStage<T>`                           | A stage of a possibly asynchronous computation, that performs an action or computes a value when another CompletionStage completes.                                                                         |
| `ConcurrentMap<K,V>`                           | A Map providing thread safety and atomicity guarantees.                                                                                                                                                     |
| `ConcurrentNavigableMap<K,V>`                  | A ConcurrentMap supporting NavigableMap operations, and recursively so for its navigable sub-maps.                                                                                                          |
| `Delayed`                                      | A mix-in style interface for marking objects that should be acted upon after a given delay.                                                                                                                 |
| `Executor`                                     | An object that executes submitted Runnable tasks.                                                                                                                                                           |
| `ExecutorService`                              | An Executor that provides methods to manage termination and methods that can produce a Future for tracking progress of one or more asynchronous tasks.                                                      |
| `ForkJoinPool.ForkJoinWorkerThreadFactory`     | Factory for creating new ForkJoinWorkerThreads.                                                                                                                                                             |
| `ForkJoinPool.ManagedBlocker`                  | Interface for extending managed parallelism for tasks running in ForkJoinPools.                                                                                                                             |
| `Future<V>`                                    | A Future represents the result of an asynchronous computation.                                                                                                                                              |
| `RejectedExecutionHandler`                     | A handler for tasks that cannot be executed by a ThreadPoolExecutor.                                                                                                                                        |
| `RunnableFuture<V>`                            | A Future that is Runnable.                                                                                                                                                                                  |
| `RunnableScheduledFuture<V>`                   | A ScheduledFuture that is Runnable.                                                                                                                                                                         |
| `ScheduledExecutorService`                     | An ExecutorService that can schedule commands to run after a given delay, or to execute periodically.                                                                                                       |
| `ScheduledFuture<V>`                           | A delayed result-bearing action that can be cancelled.                                                                                                                                                      |
| `ThreadFactory`                                | An object that creates new threads on demand.                                                                                                                                                               |
| `TransferQueue<E>`                             | A BlockingQueue in which producers may wait for consumers to receive elements.                                                                                                                              |


## 类列表
| Class                                  | Description                                                                                                                                                                                  |
|----------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `AbstractExecutorService`                | Provides default implementations of ExecutorService execution methods.                                                                                                                       |
| `ArrayBlockingQueue<E>`                  | A bounded blocking queue backed by an array.                                                                                                                                                 |
| `CompletableFuture<T>`                   | A Future that may be explicitly completed (setting its value and status), and may be used as a CompletionStage, supporting dependent functions and actions that trigger upon its completion. |
| `ConcurrentHashMap<K,V>`                 | A hash table supporting full concurrency of retrievals and high expected concurrency for updates.                                                                                            |
| `ConcurrentHashMap.KeySetView<K,V>`      | A view of a ConcurrentHashMap as a Set of keys, in which additions may optionally be enabled by mapping to a common value.                                                                   |
| `ConcurrentLinkedDeque<E>`               | An unbounded concurrent deque based on linked nodes.                                                                                                                                         |
| `ConcurrentLinkedQueue<E>`               | An unbounded thread-safe queue based on linked nodes.                                                                                                                                        |
| `ConcurrentSkipListMap<K,V>`             | A scalable concurrent ConcurrentNavigableMap implementation.                                                                                                                                 |
| `ConcurrentSkipListSet<E>`               | A scalable concurrent NavigableSet implementation based on a ConcurrentSkipListMap.                                                                                                          |
| `CopyOnWriteArrayList<E>`                | A thread-safe variant of ArrayList in which all mutative operations (add, set, and so on) are implemented by making a fresh copy of the underlying array.                                    |
| `CopyOnWriteArraySet<E>`                 | A Set that uses an internal CopyOnWriteArrayList for all of its operations.                                                                                                                  |
| `CountDownLatch`                         | A synchronization aid that allows one or more threads to wait until a set of operations being performed in other threads completes.                                                          |
| `CountedCompleter<T>`                    | A ForkJoinTask with a completion action performed when triggered and there are no remaining pending actions.                                                                                 |
| `CyclicBarrier`                          | A synchronization aid that allows a set of threads to all wait for each other to reach a common barrier point.                                                                               |
| `DelayQueue<E extends Delayed>`          | An unbounded blocking queue of Delayed elements, in which an element can only be taken when its delay has expired.                                                                           |
| `Exchanger<V>`                           | A synchronization point at which threads can pair and swap elements within pairs.                                                                                                            |
| `ExecutorCompletionService<V>`           | A CompletionService that uses a supplied Executor to execute tasks.                                                                                                                          |
| `Executors`                              | Factory and utility methods for Executor, ExecutorService, ScheduledExecutorService, ThreadFactory, and Callable classes defined in this package.                                            |
| `ForkJoinPool`                           | An ExecutorService for running ForkJoinTasks.                                                                                                                                                |
| `ForkJoinTask<V>`                        | Abstract base class for tasks that run within a ForkJoinPool.                                                                                                                                |
| `ForkJoinWorkerThread`                   | A thread managed by a ForkJoinPool, which executes ForkJoinTasks.                                                                                                                            |
| `FutureTask<V>`                          | A cancellable asynchronous computation.                                                                                                                                                      |
| `LinkedBlockingDeque<E>`                 | An optionally-bounded blocking deque based on linked nodes.                                                                                                                                  |
| `LinkedBlockingQueue<E>`                 | An optionally-bounded blocking queue based on linked nodes.                                                                                                                                  |
| `LinkedTransferQueue<E>`                 | An unbounded TransferQueue based on linked nodes.                                                                                                                                            |
| `Phaser`                                 | A reusable synchronization barrier, similar in functionality to CyclicBarrier and CountDownLatch but supporting more flexible usage.                                                         |
| `PriorityBlockingQueue<E>`               | An unbounded blocking queue that uses the same ordering rules as class PriorityQueue and supplies blocking retrieval operations.                                                             |
| `RecursiveAction`                        | A recursive resultless ForkJoinTask.                                                                                                                                                         |
| `RecursiveTask<V>`                       | A recursive result-bearing ForkJoinTask.                                                                                                                                                     |
| `ScheduledThreadPoolExecutor`            | A ThreadPoolExecutor that can additionally schedule commands to run after a given delay, or to execute periodically.                                                                         |
| `Semaphore`                              | A counting semaphore.                                                                                                                                                                        |
| `SynchronousQueue<E>`                    | A blocking queue in which each insert operation must wait for a corresponding remove operation by another thread, and vice versa.                                                            |
| `ThreadLocalRandom`                      | A random number generator isolated to the current thread.                                                                                                                                    |
| `ThreadPoolExecutor`                     | An ExecutorService that executes each submitted task using one of possibly several pooled threads, normally configured using Executors factory methods.                                      |
| `ThreadPoolExecutor.AbortPolicy`         | A handler for rejected tasks that throws a RejectedExecutionException.                                                                                                                       |
| `ThreadPoolExecutor.CallerRunsPolicy`    | A handler for rejected tasks that runs the rejected task directly in the calling thread of the execute method, unless the executor has been shut down, in which case the task is discarded.  |
| `ThreadPoolExecutor.DiscardOldestPolicy` | A handler for rejected tasks that discards the oldest unhandled request and then retries execute, unless the executor is shut down, in which case the task is discarded.                     |
| `ThreadPoolExecutor.DiscardPolicy`       | A handler for rejected tasks that silently discards the rejected task.                                                                                                                       |


## Enum 列表
| Enum     | Description                                                                                                                                                                          |
|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| TimeUnit | A TimeUnit represents time durations at a given unit of granularity and provides utility methods to convert across units, and to perform timing and delay operations in these units. |


## 异常列表
| Exception                  | Description                                                                                                                                          |
|----------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| BrokenBarrierException     | Exception thrown when a thread tries to wait upon a barrier that is in a broken state, or which enters the broken state while the thread is waiting. |
| CancellationException      | Exception indicating that the result of a value-producing task, such as a FutureTask, cannot be retrieved because the task was cancelled.            |
| CompletionException        | Exception thrown when an error or other exception is encountered in the course of completing a result or task.                                       |
| ExecutionException         | Exception thrown when attempting to retrieve the result of a task that aborted by throwing an exception.                                             |
| RejectedExecutionException | Exception thrown by an Executor when a task cannot be accepted for execution.                                                                        |
| TimeoutException           | Exception thrown when a blocking operation times out.                                                                                                |

## 程序包概述

Utility classes commonly useful in concurrent programming. This package includes a few small standardized extensible frameworks, as well as some classes that provide useful functionality and are otherwise tedious or difficult to implement. Here are brief descriptions of the main components. See also the [`java.util.concurrent.locks`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/package-summary.html) and [`java.util.concurrent.atomic`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/package-summary.html) packages.

## Executors

![](Pasted%20image%2020220715214245.png)


**Interfaces.** [`Executor`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Executor.html "interface in java.util.concurrent") is a simple standardized interface for defining custom thread-like subsystems, including thread pools, asynchronous I/O, and lightweight task frameworks. Depending on which concrete Executor class is being used, tasks may execute in a newly created thread, an existing task-execution thread, or the thread calling [`execute`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Executor.html#execute-java.lang.Runnable-), and may execute sequentially or concurrently. [`ExecutorService`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ExecutorService.html "interface in java.util.concurrent") provides a more complete asynchronous task execution framework. An ExecutorService manages queuing and scheduling of tasks, and allows controlled shutdown. The [`ScheduledExecutorService`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ScheduledExecutorService.html "interface in java.util.concurrent") subinterface and associated interfaces add support for delayed and periodic task execution. ExecutorServices provide methods arranging asynchronous execution of any function expressed as [`Callable`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Callable.html "interface in java.util.concurrent"), the result-bearing analog of [`Runnable`](https://docs.oracle.com/javase/8/docs/api/java/lang/Runnable.html "interface in java.lang"). A [`Future`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Future.html "interface in java.util.concurrent") returns the results of a function, allows determination of whether execution has completed, and provides a means to cancel execution. A [`RunnableFuture`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/RunnableFuture.html "interface in java.util.concurrent") is a `Future` that possesses a `run` method that upon execution, sets its results.

**Implementations.** Classes [`ThreadPoolExecutor`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ThreadPoolExecutor.html "class in java.util.concurrent") and [`ScheduledThreadPoolExecutor`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ScheduledThreadPoolExecutor.html "class in java.util.concurrent") provide tunable, flexible thread pools. The [`Executors`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Executors.html "class in java.util.concurrent") class provides factory methods for the most common kinds and configurations of Executors, as well as a few utility methods for using them. Other utilities based on `Executors` include the concrete class [`FutureTask`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/FutureTask.html "class in java.util.concurrent") providing a common extensible implementation of Futures, and [`ExecutorCompletionService`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ExecutorCompletionService.html "class in java.util.concurrent"), that assists in coordinating the processing of groups of asynchronous tasks.

Class [`ForkJoinPool`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ForkJoinPool.html "class in java.util.concurrent") provides an Executor primarily designed for processing instances of [`ForkJoinTask`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ForkJoinTask.html "class in java.util.concurrent") and its subclasses. These classes employ a work-stealing scheduler that attains high throughput for tasks conforming to restrictions that often hold in computation-intensive parallel processing.

## Queues

The [`ConcurrentLinkedQueue`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentLinkedQueue.html "class in java.util.concurrent") class supplies an efficient scalable thread-safe non-blocking FIFO queue. The [`ConcurrentLinkedDeque`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentLinkedDeque.html "class in java.util.concurrent") class is similar, but additionally supports the [`Deque`](https://docs.oracle.com/javase/8/docs/api/java/util/Deque.html "interface in java.util") interface.

Five implementations in `java.util.concurrent` support the extended [`BlockingQueue`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/BlockingQueue.html "interface in java.util.concurrent") interface, that defines blocking versions of put and take: [`LinkedBlockingQueue`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/LinkedBlockingQueue.html "class in java.util.concurrent"), [`ArrayBlockingQueue`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ArrayBlockingQueue.html "class in java.util.concurrent"), [`SynchronousQueue`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/SynchronousQueue.html "class in java.util.concurrent"), [`PriorityBlockingQueue`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/PriorityBlockingQueue.html "class in java.util.concurrent"), and [`DelayQueue`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/DelayQueue.html "class in java.util.concurrent"). The different classes cover the most common usage contexts for producer-consumer, messaging, parallel tasking, and related concurrent designs.

Extended interface [`TransferQueue`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/TransferQueue.html "interface in java.util.concurrent"), and implementation [`LinkedTransferQueue`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/LinkedTransferQueue.html "class in java.util.concurrent") introduce a synchronous `transfer` method (along with related features) in which a producer may optionally block awaiting its consumer.

The [`BlockingDeque`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/BlockingDeque.html "interface in java.util.concurrent") interface extends `BlockingQueue` to support both FIFO and LIFO (stack-based) operations. Class [`LinkedBlockingDeque`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/LinkedBlockingDeque.html "class in java.util.concurrent") provides an implementation.
## `Delayed` 对象
[Delayed (Java Platform SE 8 )](https://docs.oracle.com/javase/8/docs/api/index.html)

## Timing

The [`TimeUnit`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/TimeUnit.html "enum in java.util.concurrent") class provides multiple granularities (including nanoseconds) for specifying and controlling time-out based operations. Most classes in the package contain operations based on time-outs in addition to indefinite waits. In all cases that time-outs are used, the time-out specifies the minimum time that the method should wait before indicating that it timed-out. Implementations make a "best effort" to detect time-outs as soon as possible after they occur. However, an indefinite amount of time may elapse between a time-out being detected and a thread actually executing again after that time-out. All methods that accept timeout parameters treat values less than or equal to zero to mean not to wait at all. To wait "forever", you can use a value of `Long.MAX_VALUE`.

## Synchronizers

Five classes aid common special-purpose synchronization idioms.

-   [`Semaphore`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Semaphore.html "class in java.util.concurrent") is a classic concurrency tool.
-   [`CountDownLatch`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CountDownLatch.html "class in java.util.concurrent") is a very simple yet very common utility for blocking until a given number of signals, events, or conditions hold.
-   A [`CyclicBarrier`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CyclicBarrier.html "class in java.util.concurrent") is a resettable multiway synchronization point useful in some styles of parallel programming.
-   A [`Phaser`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Phaser.html "class in java.util.concurrent") provides a more flexible form of barrier that may be used to control phased computation among multiple threads.
-   An [`Exchanger`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Exchanger.html "class in java.util.concurrent") allows two threads to exchange objects at a rendezvous point, and is useful in several pipeline designs.

## Concurrent Collections

Besides Queues, this package supplies Collection implementations designed for use in multithreaded contexts: [`ConcurrentHashMap`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentHashMap.html "class in java.util.concurrent"), [`ConcurrentSkipListMap`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentSkipListMap.html "class in java.util.concurrent"), [`ConcurrentSkipListSet`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentSkipListSet.html "class in java.util.concurrent"), [`CopyOnWriteArrayList`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CopyOnWriteArrayList.html "class in java.util.concurrent"), and [`CopyOnWriteArraySet`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CopyOnWriteArraySet.html "class in java.util.concurrent"). When many threads are expected to access a given collection, a `ConcurrentHashMap` is normally preferable to a synchronized `HashMap`, and a `ConcurrentSkipListMap` is normally preferable to a synchronized `TreeMap`. A `CopyOnWriteArrayList` is preferable to a synchronized `ArrayList` when the expected number of reads and traversals greatly outnumber the number of updates to a list.

The "Concurrent" prefix used with some classes in this package is a shorthand indicating several differences from similar "synchronized" classes. For example `java.util.Hashtable` and `Collections.synchronizedMap(new HashMap())` are synchronized. But [`ConcurrentHashMap`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentHashMap.html "class in java.util.concurrent") is "concurrent". A concurrent collection is thread-safe, but not governed by a single exclusion lock. In the particular case of ConcurrentHashMap, it safely permits any number of concurrent reads as well as a tunable number of concurrent writes. "Synchronized" classes can be useful when you need to prevent all access to a collection via a single lock, at the expense of poorer scalability. In other cases in which multiple threads are expected to access a common collection, "concurrent" versions are normally preferable. And unsynchronized collections are preferable when either collections are unshared, or are accessible only when holding other locks.

Most concurrent Collection implementations (including most Queues) also differ from the usual `java.util` conventions in that their [Iterators](https://docs.oracle.com/javase/8/docs/api/java/util/Iterator.html "interface in java.util") and [Spliterators](https://docs.oracle.com/javase/8/docs/api/java/util/Spliterator.html "interface in java.util") provide _weakly consistent_ rather than fast-fail traversal:
-   they may proceed concurrently with other operations
-   they will never throw [`ConcurrentModificationException`](https://docs.oracle.com/javase/8/docs/api/java/util/ConcurrentModificationException.html "class in java.util")
-   they are guaranteed to traverse elements as they existed upon construction exactly once, and may (but are not guaranteed to) reflect any modifications subsequent to construction.

## 内存一致性（内存可见性）

[Chapter 17 of the Java Language Specification](https://docs.oracle.com/javase/specs/jls/se7/html/jls-17.html#jls-17.4.5) defines the _happens-before_ relation on memory operations such as reads and writes of shared variables. The results of a write by one thread are guaranteed to be visible to a read by another thread only if the write operation _happens-before_ the read operation. The `synchronized` and `volatile` constructs, as well as the `Thread.start()` and `Thread.join()` methods, can form _happens-before_ relationships. In particular:

-   Each action in a thread _happens-before_ every action in that thread that comes later in the program's order.
-   An unlock (`synchronized` block or method exit) of a monitor _happens-before_ every subsequent lock (`synchronized` block or method entry) of that same monitor. And because the _happens-before_ relation is transitive, all actions of a thread prior to unlocking _happen-before_ all actions subsequent to any thread locking that monitor.
-   A write to a `volatile` field _happens-before_ every subsequent read of that same field. Writes and reads of `volatile` fields have similar memory consistency effects as entering and exiting monitors, but do _not_ entail mutual exclusion locking.
-   A call to `start` on a thread _happens-before_ any action in the started thread.
-   All actions in a thread _happen-before_ any other thread successfully returns from a `join` on that thread.

The methods of all classes in `java.util.concurrent` and its subpackages extend these guarantees to higher-level synchronization. In particular:

-   Actions in a thread prior to placing an object into any concurrent collection _happen-before_ actions subsequent to the access or removal of that element from the collection in another thread.
-   Actions in a thread prior to the submission of a `Runnable` to an `Executor` _happen-before_ its execution begins. Similarly for `Callables` submitted to an `ExecutorService`.
-   Actions taken by the asynchronous computation represented by a `Future` _happen-before_ actions subsequent to the retrieval of the result via `Future.get()` in another thread.
-   Actions prior to "releasing" synchronizer methods such as `Lock.unlock`, `Semaphore.release`, and `CountDownLatch.countDown` _happen-before_ actions subsequent to a successful "acquiring" method such as `Lock.lock`, `Semaphore.acquire`, `Condition.await`, and `CountDownLatch.await` on the same synchronizer object in another thread.
-   For each pair of threads that successfully exchange objects via an `Exchanger`, actions prior to the `exchange()` in each thread _happen-before_ those subsequent to the corresponding `exchange()` in another thread.
-   Actions prior to calling `CyclicBarrier.await` and `Phaser.awaitAdvance` (as well as its variants) _happen-before_ actions performed by the barrier action, and actions performed by the barrier action _happen-before_ actions subsequent to a successful return from the corresponding `await` in other threads.

Since:

1.5

# Package Juc/atomic

A small toolkit of classes that support lock-free thread-safe programming on single variables.

See: [Description](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/package-summary.html#package.description)

支持无锁线程安全编程的一组工具类。本质上是通过一组原子操作的方法扩展了 volatile 标记的功能。
## `volatile` 标记的作用
[`volatile` 的作用及 正确使用模式](https://zhuanlan.zhihu.com/p/79602008)
`volatile` 的典型使用场景是一写多读。问题来源于计算机的三级存储层次，当多个线程分配到不同的 CPU 上运行时，因为每个 CPU 都有自己的局部缓存，这样就出现了数据不一致的问题。 `volatile` 用来让操作的变量放在内存中，当变量被更新后通知 CPU 缓存失效，后续再读取这个变量就直接从内存读取。

## 原子性强度
提供的方法可以分成三类：一类是有条件的原子更新操作例如 `boolean compareAndSet(expectedValue, updateValue)` 接受期望值和更新值两个参数，首先比较操作的对象是否和期望值相等，如果相等就更新，然后返回操作是否成功。整个过程都是原子的。
第二种是无条件更新操作。以原子的方式完成获取原始值设置新值或者更新后返回新值的过程。
第三种是原子性弱一些的有条件更新操作。例如 `weakCompareAndSet` ，这里 weaker 的含义是除去同样是 `weakCompareAndSet` 级别的操作外，和其他任何操作之间都没有 happens-before 的保证。

总体上这些接口规范让设计层面能够采用一些高效的机器指令，一般可以认为是非阻塞的操作。但是在某些特定平台的实现可能不得不采用某种形式的内部锁导致执行这些操作的线程阻塞。

原子访问和更新的内存一致性效果通常遵循 volatile 的规则，如 The Java Language Specification (17.4 Memory Model) 中所述：

- `get/set` 操作和 `volatile` 变量读写操作的一致性程度相同。
- `lazySet` 具有写入（分配） `volatile` 变量的记忆效应，除了它允许对后续（但不是先前）内存操作进行重新排序，这些操作本身不会对普通的非 `volatile` 写入施加重新排序约束。在其他场景中， `lazySet` 可能会在为垃圾收集而清空一个不再访问的引用时应用。
- `weakCompareAndSet` 原子地读取和有条件地写入一个变量，但不会创建任何发生前的顺序，因此不保证对除 `weakCompareAndSet` .
- `compareAndSet` 以及所有其他读取和更新操作，例如 `getAndIncrement` 具有读取和写入 `volatile` 变量的内存效应。
## 工具类作用总结
单个变量：
`AtomicBoolean` 、 `AtomicInteger` 、 `AtomicLong` 和 `AtomicReference` 这几个实现类是实现了单个原子变量的原子性操作。
对象属性：
`AtomicReferenceFieldUpdater` 、 `AtomicIntegerFieldUpdater` 、 `AtomicLongFieldUpdater` 这一组 Updater 是基于反射实现的，主要用在多个原子性的字段有各自独立的原子性约束时。这些类在如何以及何时使用原子更新方面提供了更大的灵活性，但代价是基于反射的设置更尴尬、使用更不方便和保证更弱。
数组元素：
`AtomicIntegerArray` 、 `AtomicLongArray` 、 `AtomicReferenceArray` 这一组实现类对数组元素的原子性访问提供支持，普通数组是不支持原子性的。
对象的标志字段：
`AtomicMarkableReference` 把一个对象引用和一个布尔类型的标志字段关联起来， `AtomicStampedReference` 则是把引用对象和一个整数值相关联，它们都是保证被引用对象和标志字段的状态改变保持一致。


## Class Summary

| Class                                                                                                                                        | Description                                                                                                              |
|:-------------------------------------------------------------------------------------------------------------------------------------------- |:------------------------------------------------------------------------------------------------------------------------ |
| [`AtomicBoolean`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicBoolean.html)                                  | A `boolean` value that may be updated atomically.                                                                        |
| [`AtomicInteger`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicInteger.html)                                  | An `int` value that may be updated atomically.                                                                           |
| [`AtomicIntegerArray`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicIntegerArray.html)                        | An `int` array in which elements may be updated atomically.                                                              |
| [`AtomicIntegerFieldUpdater<T>`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicIntegerFieldUpdater.html)       | A reflection-based utility that enables atomic updates to designated `volatile int` fields of designated classes.        |
| [`AtomicLong`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicLong.html)                                        | A `long` value that may be updated atomically.                                                                           |
| [`AtomicLongArray`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicLongArray.html)                              | A `long` array in which elements may be updated atomically.                                                              |
| [`AtomicLongFieldUpdater<T>`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicLongFieldUpdater.html)             | A reflection-based utility that enables atomic updates to designated `volatile long` fields of designated classes.       |
| [`AtomicMarkableReference<V>`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicMarkableReference.html)           | An `AtomicMarkableReference` maintains an object reference along with a mark bit, that can be updated atomically.        |
| [`AtomicReference<V>`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicReference.html)                           | An object reference that may be updated atomically.                                                                      |
| [`AtomicReferenceArray<E>`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicReferenceArray.html)                 | An array of object references in which elements may be updated atomically.                                               |
| [`AtomicReferenceFieldUpdater<T,V>`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicReferenceFieldUpdater.html) | A reflection-based utility that enables atomic updates to designated `volatile` reference fields of designated classes.  |
| [`AtomicStampedReference<V>`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicStampedReference.html)             | An `AtomicStampedReference` maintains an object reference along with an integer "stamp", that can be updated atomically. |
| [`DoubleAccumulator`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/DoubleAccumulator.html)                          | One or more variables that together maintain a running `double` value updated using a supplied function.                 |
| [`DoubleAdder`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/DoubleAdder.html)                                      | One or more variables that together maintain an initially zero `double` sum.                                             |
| [`LongAccumulator`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/LongAccumulator.html)                              | One or more variables that together maintain a running `long` value updated using a supplied function.                   |
| [`LongAdder`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/LongAdder.html)                                          | One or more variables that together maintain an initially zero `long` sum.                                               |



## Description

A small toolkit of classes that support lock-free thread-safe programming on single variables. In essence, the classes in this package extend the notion of `volatile` values, fields, and array elements to those that also provide an atomic conditional update operation of the form:

```Java
  boolean compareAndSet(expectedValue, updateValue);
```

This method (which varies in argument types across different classes) atomically sets a variable to the `updateValue` if it currently holds the `expectedValue` , reporting `true` on success. The classes in this package also contain methods to get and unconditionally set values, as well as a weaker conditional atomic update operation `weakCompareAndSet` described below.

The specifications of these methods enable implementations to employ efficient machine-level atomic instructions that are available on contemporary processors. However on some platforms, support may entail some form of internal locking. Thus the methods are not strictly guaranteed to be non-blocking -- a thread may block transiently before performing the operation.

Instances of classes [`AtomicBoolean`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicBoolean.html), [`AtomicInteger`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicInteger.html), [`AtomicLong`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicLong.html), and [`AtomicReference`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicReference.html) each provide access and updates to a single variable of the corresponding type. Each class also provides appropriate utility methods for that type. For example, classes `AtomicLong` and `AtomicInteger` provide atomic increment methods. One application is to generate sequence numbers, as in:

```Java
 class Sequencer {
   private final AtomicLong sequenceNumber
     = new AtomicLong(0);
   public long next() {
     return sequenceNumber.getAndIncrement();
   }
 }
```

It is straightforward to define new utility functions that, like `getAndIncrement`, apply a function to a value atomically. For example, given some transformation

```Java
  long transform(long input)
```

Write your utility method as follows:

```Java
 long getAndTransform(AtomicLong var) {
   long prev, next;
   do {
     prev = var.get();
     next = transform(prev);
   } while (!var.compareAndSet(prev, next));
   return prev; // return next; for transformAndGet
 }
```

The memory effects for accesses and updates of atomics generally follow the rules for volatiles, as stated in [The Java Language Specification (17.4 Memory Model)](https://docs.oracle.com/javase/specs/jls/se7/html/jls-17.html#jls-17.4):

- `get` has the memory effects of reading a `volatile` variable.
- `set` has the memory effects of writing (assigning) a `volatile` variable.
- `lazySet` has the memory effects of writing (assigning) a `volatile` variable except that it permits reorderings with subsequent (but not previous) memory actions that do not themselves impose reordering constraints with ordinary non-`volatile` writes. Among other usage contexts, `lazySet` may apply when nulling out, for the sake of garbage collection, a reference that is never accessed again.
- `weakCompareAndSet` atomically reads and conditionally writes a variable but does *not* create any happens-before orderings, so provides no guarantees with respect to previous or subsequent reads and writes of any variables other than the target of the `weakCompareAndSet`.
- `compareAndSet` and all other read-and-update operations such as `getAndIncrement` have the memory effects of both reading and writing `volatile` variables.

In addition to classes representing single values, this package contains *Updater* classes that can be used to obtain `compareAndSet` operations on any selected `volatile` field of any selected class. [`AtomicReferenceFieldUpdater`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicReferenceFieldUpdater.html), [`AtomicIntegerFieldUpdater`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicIntegerFieldUpdater.html), and [`AtomicLongFieldUpdater`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicLongFieldUpdater.html) are reflection-based utilities that provide access to the associated field types. These are mainly of use in atomic data structures in which several `volatile` fields of the same node (for example, the links of a tree node) are independently subject to atomic updates. These classes enable greater flexibility in how and when to use atomic updates, at the expense of more awkward reflection-based setup, less convenient usage, and weaker guarantees.

The [`AtomicIntegerArray`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicIntegerArray.html), [`AtomicLongArray`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicLongArray.html), and [`AtomicReferenceArray`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicReferenceArray.html) classes further extend atomic operation support to arrays of these types. These classes are also notable in providing `volatile` access semantics for their array elements, which is not supported for ordinary arrays.

The atomic classes also support method `weakCompareAndSet`, which has limited applicability. On some platforms, the weak version may be more efficient than `compareAndSet` in the normal case, but differs in that any given invocation of the `weakCompareAndSet` method may return `false` *spuriously* (that is, for no apparent reason). A `false` return means only that the operation may be retried if desired, relying on the guarantee that repeated invocation when the variable holds `expectedValue` and no other thread is also attempting to set the variable will eventually succeed. (Such spurious failures may for example be due to memory contention effects that are unrelated to whether the expected and current values are equal.) Additionally `weakCompareAndSet` does not provide ordering guarantees that are usually needed for synchronization control. However, the method may be useful for updating counters and statistics when such updates are unrelated to the other happens-before orderings of a program. When a thread sees an update to an atomic variable caused by a `weakCompareAndSet`, it does not necessarily see updates to any *other* variables that occurred before the `weakCompareAndSet`. This may be acceptable when, for example, updating performance statistics, but rarely otherwise.

The [`AtomicMarkableReference`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicMarkableReference.html) class associates a single boolean with a reference. For example, this bit might be used inside a data structure to mean that the object being referenced has logically been deleted. The [`AtomicStampedReference`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicStampedReference.html) class associates an integer value with a reference. This may be used for example, to represent version numbers corresponding to series of updates.

Atomic classes are designed primarily as building blocks for implementing non-blocking data structures and related infrastructure classes. The `compareAndSet` method is not a general replacement for locking. It applies only when critical updates for an object are confined to a *single* variable.

Atomic classes are not general purpose replacements for `java. Lang. Integer` and related classes. They do *not* define methods such as `equals`, `hashCode` and `compareTo`. (Because atomic variables are expected to be mutated, they are poor choices for hash table keys.) Additionally, classes are provided only for those types that are commonly useful in intended applications. For example, there is no atomic class for representing `byte`. In those infrequent cases where you would like to do so, you can use an `AtomicInteger` to hold `byte` values, and cast appropriately. You can also hold floats using [`Float.floatToRawIntBits(float)`](https://docs.oracle.com/javase/8/docs/api/java/lang/Float.html#floatToRawIntBits-float-) and [`Float.intBitsToFloat(int)`](https://docs.oracle.com/javase/8/docs/api/java/lang/Float.html#intBitsToFloat-int-) conversions, and doubles using [`Double.doubleToRawLongBits(double)`](https://docs.oracle.com/javase/8/docs/api/java/lang/Double.html#doubleToRawLongBits-double-) and [`Double.longBitsToDouble(long)`](https://docs.oracle.com/javase/8/docs/api/java/lang/Double.html#longBitsToDouble-long-) conversions.

- **Since:**

  1.5

# Package Juc/locks

Interfaces and classes providing a framework for locking and waiting for conditions that is distinct from built-in synchronization and monitors.

See: [Description](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/package-summary.html#package.description)


## 程序包概述
[JDK 1.8 Juc.locks 综述](https://www.cnblogs.com/joemsu/p/8543449.html)

（从 JDK-1.5 开始）提供了区别于 Java 内置同步和监视器（monitor）的加锁和等待条件变量功能。JUC／locks 框架允许更灵活的加锁和等待条件，代价是语法更难理解和掌握。


![Juc/locks 包的类结构]( https://images2018.cnblogs.com/blog/1256203/201805/1256203-20180506110949802-793090402.png "JUC／locks")
基本锁和读写锁接口：
 [`Lock`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/Lock.html) 接口支持各种语义不同的加锁规则， can be used in non-block-structured contexts including hand-over-hand and lock reordering algorithms。主要的实现类是  [`ReentrantLock`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/ReentrantLock.html)。

 读写锁接口  [`ReadWriteLock`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/ReadWriteLock.html) 定义了一写多读场景的 API，也就是可以在多个读者间共享但只能被一个写者占有。读写锁接口只有一个实现类： [`ReentrantReadWriteLock`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/ReentrantReadWriteLock.html)，它覆盖了大多数使用场景。但是遇到非标准的特殊场景开发人员就必须自己编写合适的实现类来满足需求。
条件变量：
 条件变量接口 [`Condition`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/Condition.html) 描述了通常和锁相关联的一类变量。他们在使用方式上跟使用 `Object. Wait` 方法获取到的内置的隐式监视器类似，但是一个锁对象可以有多个关联的 `Condition` 对象。与 Object 对象里不同的是，Condition 更加灵活，可以在一个 Lock 对象里创建多个 Condition 实例，有选择的进行线程通知，在线程调度上更加灵活。为了避免兼容问题，`Condition` 对象的方法和 `Object. Wait` 方法名称是不一样的。

一组抽象类：
Locks 包还提供了一组共三个抽象类，他们是实现各种锁的重要核心框架，一般被称作 AQS。 [`AbstractQueuedSynchronizer`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/AbstractQueuedSynchronizer.html) 类可以在编写处理阻塞式线程队列的锁或同步器时，作为一个有用的父类。他还有一个 `long` 版本的实现类叫做 [`AbstractQueuedLongSynchronizer`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/AbstractQueuedLongSynchronizer.html) ，不同之处就是扩展到支持 64 位（`long` 类型）的同步状态。这两个类都继承自 [`AbstractOwnableSynchronizer`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/AbstractOwnableSynchronizer.html)，这个类实现了记录当前独占同步资源的线程。
`LockSupport`
[`LockSupport`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/LockSupport.html) 类提供了底层的阻塞和非阻塞的支持，在程序员实现自定义的锁时很有用。
## Interface Summary

| Interface                                                    | Description                                                  |
  | :----------------------------------------------------------- | :----------------------------------------------------------- |
  | [Condition](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/Condition.html) | `Condition` factors out the `Object` monitor methods ([`wait`](https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html#wait--), [`notify`](https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html#notify--) and [`notifyAll`](https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html#notifyAll--)) into distinct objects to give the effect of having multiple wait-sets per object, by combining them with the use of arbitrary [`Lock`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/Lock.html) implementations. |
  | [Lock](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/Lock.html) | `Lock` implementations provide more extensive locking operations than can be obtained using `synchronized` methods and statements. |
  | [ReadWriteLock](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/ReadWriteLock.html) | A `ReadWriteLock` maintains a pair of associated [`locks`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/Lock.html), one for read-only operations and one for writing. |

## Class Summary

| Class                                                        | Description                                                  |
  | :----------------------------------------------------------- | :----------------------------------------------------------- |
  | [AbstractOwnableSynchronizer](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/AbstractOwnableSynchronizer.html) | A synchronizer that may be exclusively owned by a thread.    |
  | [AbstractQueuedLongSynchronizer](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/AbstractQueuedLongSynchronizer.html) | A version of [`AbstractQueuedSynchronizer`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/AbstractQueuedSynchronizer.html) in which synchronization state is maintained as a `long`. |
  | [AbstractQueuedSynchronizer](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/AbstractQueuedSynchronizer.html) | Provides a framework for implementing blocking locks and related synchronizers (semaphores, events, etc) that rely on first-in-first-out (FIFO) wait queues. |
  | [LockSupport](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/LockSupport.html) | Basic thread blocking primitives for creating locks and other synchronization classes. |
  | [ReentrantLock](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/ReentrantLock.html) | A reentrant mutual exclusion [`Lock`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/Lock.html) with the same basic behavior and semantics as the implicit monitor lock accessed using `synchronized` methods and statements, but with extended capabilities. |
  | [ReentrantReadWriteLock](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/ReentrantReadWriteLock.html) | An implementation of [`ReadWriteLock`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/ReadWriteLock.html) supporting similar semantics to [`ReentrantLock`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/ReentrantLock.html). |
  | [ReentrantReadWriteLock.ReadLock](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/ReentrantReadWriteLock.ReadLock.html) | The lock returned by method [`ReentrantReadWriteLock.readLock()`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/ReentrantReadWriteLock.html#readLock--). |
  | [ReentrantReadWriteLock.WriteLock](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/ReentrantReadWriteLock.WriteLock.html) | The lock returned by method [`ReentrantReadWriteLock.writeLock()`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/ReentrantReadWriteLock.html#writeLock--). |
  | [StampedLock](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/StampedLock.html) | A capability-based lock with three modes for controlling read/write access. |


## 基本锁（互斥锁）
在 JDK1.5 以后，添加了 Lock 接口，它用于实现与 Synchronized 关键字相同的锁操作，来实现多个线程控制对共享资源的访问。但是能提供更加灵活的结构，可能具有完全不同的属性，并且可能支持多个相关的 Condition 对象。基本用法如下：

```java
Lock l = ...;
l.lock();
try {
    // 访问被锁保护的资源
} finally {
    l.unlock();
}
```
### 接口 API
下面我们来简单看一下它下面的具体内容：

```java
public interface Lock {
    // 获得锁资源
    void lock();
    // 尝试获得锁，如果当前线程被调用了interrupted则中断，并抛出异常，否则就获得锁
    void lockInterruptibly() throws InterruptedException;
    // 判断能否获得锁，如果能获得，则获得锁，并返回true(此时已经获得了锁)
    boolean tryLock();
    // 保持给定的等待时间，如果期间能拿到锁，则获得锁，同样如果期间被中断，则抛异常
    boolean tryLock(long time, TimeUnit unit) throws InterruptedException;
    // 释放锁
    void unlock();
    // 返回与此Lock对象绑定Condition实例
    Condition newCondition();
}
```

其中，tryLock 只会尝试一次，如果返回 false，则走 false 的流程，不会一直让线程一直等待。
### 实现类：`ReentranceLock`
在之前的几篇中，我们回顾了锁框架中比较重要的几个类，他们为实现同步提供了基础支持，从现在开始到后面，就开始利用之前的几个类来进行各种锁的具体实现。今天来一起看下 ReentrantLock，首先来看一下 Java doc 上对 ReentrantLock 的解释：

> ReentrantLock，作为**可重入的互斥锁**，具有与使用 synchronized 方法和语句相同的基本行为和语义，但功能更强大。

对上面这句话的解释：

1.  拥有和 synchronized 关键字一样的行为，可重入互斥（注意，synchronized 也是可重入的）
2.  更强大的功能：比如支持公平锁和非公平锁，前面文章提到过的 Condition 的使用等。

关于 ReentrantLock 的使用例子，其实在第一篇将 Lock 的时候，就曾经有提到过，是 Java Doc 上提供的一个例子，典型的生产者-消费者模式，这里笔者就不赘述了。其实 ReentrantLock 关键的核心实现在于 AQS，AQS 仔细阅读的话，还是有很多值得推敲的地方，再一次觉得它的实现博大精深~最后谢谢各位园友观看，如果有描述不对的地方欢迎指正，与大家共同进步！

#### 2.1、成员变量

早在第一章 [JUC.Lock综述](https://www.cnblogs.com/joemsu/p/8543449.html)的时候，我们就大体看过 juc 包里的关系图，上面提到过，ReentrantLock 支持公平锁和非公平锁，其原因就是内部实现了两个内部类`FairSync`和`NonfairSync`，分别实现了对应的支持，先来看一下成员变量：

```java
public class ReentrantLock implements Lock, java.io.Serializable {
    private static final long serialVersionUID = 7373984872572414699L;
    private final Sync sync;
    
    public ReentrantLock() {
        sync = new NonfairSync();
    }

    /**
     * fair = true：公平锁， false:非公平锁
     */
    public ReentrantLock(boolean fair) {
        sync = fair ? new FairSync() : new NonfairSync();
    }
}
```

这里由于 final 关键字，方便理解，直接将构造方法也一并放了进来。

-   默认构造器在初始化的时候，实例化的是非公平锁，举个栗子，我去买蛋糕，蛋糕店刚好出炉了一个蛋糕，我刚好碰到买到了，那我就买回去了。
-   而带 fair 的构造器，为 true 的时候，实例化的是公平锁，再举个栗子，我去买蛋糕，蛋糕店刚好又出炉了一个，我想买，但是人家已经预定好了，要买就得排队等。

  

#### 2.2、内部类

![](https://images2018.cnblogs.com/blog/1256203/201808/1256203-20180811162911173-889301934.png)

前面提到的`FairSync`和`NonfairSync`都继承自`ReentrantLock`的内部类，而在 JUC 关系图中，`Sync`在大部分的锁框架中都各自进行了不同的实现，但是都继承自 AQS。

#### 2.2.1、Sync

一起来看一下`ReentrantLock`中的`Sync`实现：

```java
abstract static class Sync extends AbstractQueuedSynchronizer {
    private static final long serialVersionUID = -5179523762034025860L;

    abstract void lock();
    // 尝试获取非公平锁
    final boolean nonfairTryAcquire(int acquires) {
        final Thread current = Thread.currentThread();
        // AQS中的state成员变量，0表示没有线程持有锁
        int c = getState();
        if (c == 0) {
            // cas设置入锁次数，仅尝试一次，成功则设置当前线程为独占线程
            if (compareAndSetState(0, acquires)) {
                setExclusiveOwnerThread(current);
                return true;
            }
        }
        // 如果当前线程为独占线程，则重入次数叠加
        else if (current == getExclusiveOwnerThread()) {
            int nextc = c + acquires;
            if (nextc < 0) // overflow
                throw new Error("Maximum lock count exceeded");
            setState(nextc);
            return true;
        }
        // 否则尝试获取锁失败
        return false;
    }
// 释放锁
    protected final boolean tryRelease(int releases) {
        // 由于可重入性，所以获取当前重入次数，与releases相减
        int c = getState() - releases;
        if (Thread.currentThread() != getExclusiveOwnerThread())
            throw new IllegalMonitorStateException();
        boolean free = false;
        // 为0则说明已经全部释放，则清空持有状态
        if (c == 0) {
            free = true;
            setExclusiveOwnerThread(null);
        }
        setState(c);
        return free;
    }
    ...
}
```

`lock ()`的逻辑由继承的`NonfairSync`和`FairSync`自己实现。

这里笔者阅读的时候注意到一个问题：前面提到`FairSync`是公平锁，每个线程按照队列的顺序来获取，但是其父类却有`nonfairTryAcquire ()`方法来尝试直接获取锁，这一实现放在`NonfairSync`中不是更合适吗？为什么要放在父类中呢？

仔细查看代码后发现，`ReentrantLock`里有`tryLock ()`方法：允许线程尝试获取一次锁，有则获得锁，返回 true，没有则返回 false。

那么就可以解释的通了，因为这个是 ReentrantLock 的 public 方法，所以不论是公平锁还是非公平锁，都可以调用，所以说，`nonfairTryAcquire ()`方法放在的父类`Sync`当中。

  

#### 2.2.2、NonfairSync

下面是非公平锁的实现：

```java
static final class NonfairSync extends Sync {
    private static final long serialVersionUID = 7316153563782823691L;

    final void lock() {
        // cas 原子性操作将state设置为1，如果设置成功，则说明当前没有线程持有锁
        if (compareAndSetState(0, 1))
            //把当前线程设置为独占锁
            setExclusiveOwnerThread(Thread.currentThread());
        // 反之则锁已经被占用，或者set失败
        else
            // 调用父类AQS分析里提到过的方法，以独占模式获取对象，acquire会调用tryAcquire
            acquire(1);
    }

    protected final boolean tryAcquire(int acquires) {
        return nonfairTryAcquire(acquires);
    }
}
```

其实非公平锁核心实现在上一篇 AQS 之中就基本分析过了，所以这里的代码就相对简单。

但是为什么`lock ()`方法不直接调用`acquire (1)`，而是直接先尝试 CAS 操作设置呢，笔者暂时没有想明白，因为调用`acquire (1)`后，会进入`tryAcquire (1)`，里面的操作其实是一样的，估计就是为了更快尝试获取？

  

#### 2.2.3、FairSync

```java
static final class FairSync extends Sync {
    private static final long serialVersionUID = -3000897897090466540L;

    final void lock() {
        acquire(1);
    }

    protected final boolean tryAcquire(int acquires) {
        final Thread current = Thread.currentThread();
        int c = getState();
        if (c == 0) {
            // 公平锁的体现就在这段代码里，就算没有线程占有锁，也会尝试判断队列里的线程
            if (!hasQueuedPredecessors() &&
                compareAndSetState(0, acquires)) {
                setExclusiveOwnerThread(current);
                return true;
            }
        }
        // 可重入的操作设置
        else if (current == getExclusiveOwnerThread()) {
            int nextc = c + acquires;
            if (nextc < 0)
                throw new Error("Maximum lock count exceeded");
            setState(nextc);
            return true;
        }
        return false;
    }
}
```

与`NonfairSync`不同，公平锁的`tryAcquire`中，当发现当前没有线程持有锁的时候，会判断队列中有无前驱节点，之所以要判断的原因是：

在当前持有锁的线程调用`unlock ()`的的过程中，存在的这样一个过程：

![](https://images2018.cnblogs.com/blog/1256203/201808/1256203-20180811162933144-841491484.png)

在`tryRelease ()`到唤醒后继节点的过程中，可能有新的线程进来，这个时候，就需要判断队列是否有其他节点等待了，这就是公平锁的奥义吧。

详情查看`hasQueuedPredecessors`代码，查看当前线程前有没有前驱节点：

```java
public final boolean hasQueuedPredecessors() {
    Node t = tail;
    Node h = head;
    Node s;
    return h != t &&
        ((s = h.next) == null || s.thread != Thread.currentThread());
}
```

其中代码值得我们认真思考一下：

1.  为什么要先从 tail 开始赋值？
2.  说明时候h.next 为 null

这两点，我们要结合入队列时候的代码说起，在前面结束 AQS 的时候，分析过`enq ()`方法：

```java
private Node enq(final Node node) {
    for (;;) {
        Node t = tail;
        // 队列初始化
        if (t == null) {
            if (compareAndSetHead(new Node()))
                tail = head;
        // 重复执行插入直到return
        } else {
            node.prev = t;
            if (compareAndSetTail(t, node)) {
                t.next = node;
                return t;
            }
        }
    }
}
```

我们先假设从 head 开始赋值：

当第一个线程调用 enq 的时候，cpu 切换，进入了线程 t2 的 hasQueuedPredecessors，首先对 head 进行赋值，此时还没有到`compareAndSetHead (new Node ())`，那么此时 head = null，这个时候 cpu 切换，t1 继续执行，执行完了`tail == head`，再切换回 t2，继续执行`Node t = tail;`，这个时候，在 return 的时候，`h != t`成立，当调用`(s = h.next) == null`，h 为 null，报了空指针。

所以先从 tail 开始赋值，至少能保证在 tail 有值的时候，head 必然有值！

另外什么时候`h.next == null`，其实可以从`enq`的 else 里找到答案，也是第一次 enq 插入空队列的时候，当线程执行到`compareAndSetTail (t, node)`的时候，`head != tail`，但是此时`head. Next`还未开始赋值，所以为 null。



## 读写锁
读写锁与一般的互斥锁不同，它分为读锁和写锁，在同一时间里，可以有多个线程获取读锁来进行共享资源的访问。如果此时有线程获取了写锁，那么读锁的线程将等待，直到写锁释放掉，才能进行共享资源访问。简单来说就是读锁与写锁互斥。

读写锁比互斥锁允许对于共享数据更大程度的并发。每次只能有一个写线程，但是同时可以有多个线程并发地读数据。ReadWriteLock 适用于读多写少的并发情况。

```java
public interface ReadWriteLock {
    // 返回写锁
Lock writeLock();
    // 返回读锁
Lock readLock();
}
```

再看一下源码里提供的示例：

```java
class CachedData {
    Object data;
    volatile boolean cacheValid;
    final ReentrantReadWriteLock rwl = new ReentrantReadWriteLock();

    void processCachedData() {
        // 获得写锁
        rwl.readLock().lock();
        // 缓存无效，则重写数据
        if (!cacheValid) {
            // 在获得写锁之前，必须先释放读锁
            rwl.readLock().unlock();
            rwl.writeLock().lock();
            try {
                // 重写检查一次，因为其他线程可能在这段时间里获得了写锁，并且修改了状态
                if (!cacheValid) {
                    data = ...
                        cacheValid = true;
                }
                // 在释放写锁之前，通过获取读锁来降级。
                rwl.readLock().lock();
            } finally {
                // 释放写锁
                rwl.writeLock().unlock();
            }
        }
        // cacheValid，直接获取数据，并释放读锁
        try {
            use(data);
        } finally {
            rwl.readLock().unlock();
        }
    }
}
```

`ReentrantReadWriteLock` 中，读锁可以获取写锁，而返过来，写锁不能获得读锁，所以在上面代码中，要先释放写锁，再获取读锁，具体的源码分析后面再细说。

## 条件变量
Condition 与 Lock 要结合使用，使用 Condition 可以用来实现`wait ()`和`notify ()/notifyAll ()`类似的等待/通知模式。与 Object 对象里不同的是，Condition 更加灵活，可以在一个 Lock 对象里创建多个 Condition 实例，有选择的进行线程通知，在线程调度上更加灵活。使用 Condition 注释上的例子：

```java
class BoundedBuffer {
    final Lock lock = new ReentrantLock();
    final Condition notFull  = lock.newCondition(); 
    final Condition notEmpty = lock.newCondition(); 

    final Object[] items = new Object[100];
    int putptr, takeptr, count;

    public void put(Object x) throws InterruptedException {
        lock.lock();
        try {
            // 当count等于数组的大小时，当前线程等待，直到notFull通知，再进行生产
            while (count == items.length)
                notFull.await();
            items[putptr] = x;
            if (++putptr == items.length) putptr = 0;
            ++count;
            notEmpty.signal();
        } finally {
            lock.unlock();
        }
    }

    public Object take() throws InterruptedException {
        lock.lock();
        try {
            // 当count为0，进入等待，直到notEmpty通知，进行消费。
            while (count == 0)
                notEmpty.await();
            Object x = items[takeptr];
            if (++takeptr == items.length) takeptr = 0;
            --count;
            notFull.signal();
            return x;
        } finally {
            lock.unlock();
        }
    }
}
```

可以通过多个线程来调用 put 和 take 方法，来模拟生产者和消费者。  
我们来换成常规的 wait/notify 的实现方式：

```java
class BoundedBuffer {
   private final Object lock;
    
    public BoundedBuffer(Object lock) {
        this.lock = lock;
    }
    public void put(Object x) {
        try {
            synchronized (items) {
                while (count == items.length) {
                    items.wait();
                }
                items[putptr] = x;
                if (++putptr == items.length) putptr = 0;
                ++count;
                // items.notify();
                items.notifyAll();
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public Object take() {
        try {
            synchronized (items) {
                while (count == 0) {
                    items.wait();
                }
                Object x = items[takeptr];
                if (++takeptr == items.length) takeptr = 0;
                --count;
                // items.notify();
                items.notifyAll();
                return x;
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return null;
    }
}
```

如果将`items. NotifyAll ()`换成`items. Notify ()`，在多生产者和多消费者模式情况下，可能出现 take 唤醒了 take 的情况，导致生产者在等待消费者消费，而消费者等待生产者生产，最终导致程序无限等待，而用 notifyAll ()，则唤醒所有的生产者和消费者，不像 Condition 可以选择性的通知。下面我们来看一下它的源码：

```java
public interface Condition {
    // 让当前线程等待，直到被通知或者被中断
    void await() throws InterruptedException;
    // 与前者的区别是，当等待过程中被中断时，仍会继续等待，直到被唤醒，才会设置中断状态
    void awaitUninterruptibly();
    // 让当前线程等待，直到它被告知或中断，或指定的等待时间已经过。
    boolean await(long time, TimeUnit unit) throws InterruptedException;
    // 与上面的类似，让当前线程等待，不过时间单位是纳秒
    long awaitNanos(long nanosTimeout) throws InterruptedException;
    // 让当前线程等待到确切的指定时间，而不是时长
    boolean awaitUntil(Date deadline) throws InterruptedException;
    // 唤醒一个等待当前condition的线程，有多个则随机选一个
    void signal();
    // 唤醒所有等待当前condition的线程
    void signalAll();
}
```

## `LockSupport`
### LockSupport 成员变量分析

```java
public class LockSupport {
    private static final sun.misc.Unsafe UNSAFE;
    private static final long parkBlockerOffset;
    private static final long SEED;
    private static final long PROBE;
    private static final long SECONDARY;
    static {
        try {
            UNSAFE = sun.misc.Unsafe.getUnsafe();
            Class<?> tk = Thread.class;
            parkBlockerOffset = UNSAFE.objectFieldOffset
                (tk.getDeclaredField("parkBlocker"));
            SEED = UNSAFE.objectFieldOffset
                (tk.getDeclaredField("threadLocalRandomSeed"));
            PROBE = UNSAFE.objectFieldOffset
                (tk.getDeclaredField("threadLocalRandomProbe"));
            SECONDARY = UNSAFE.objectFieldOffset
                (tk.getDeclaredField("threadLocalRandomSecondarySeed"));
        } catch (Exception ex) { throw new Error(ex); }
    }
}
```

1.  首先要明确的就是 sun. Misc. Unsafe 这个类，它是一个 final class，里面有 100 多个方法，锁的实现也是依赖了这个类，其中基本上都是 native 方法。Java 避免了程序员直接操作内存，但这不是绝对的，通过使用 Unsafe 类，我们还是能够操作内存。笔者尝试阅读里面的 C++代码，奈何已经将知识都还给了老师。源码越看到后面，越觉得 C 和 C++的伟大，膝盖瑟瑟打抖，有兴趣的园友们可以尝试着阅读以下：[Unsafe C++源码](http://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/de8045923ad2/src/share/vm/prims/unsafe.cpp)。
    
2.  ParkBlockerOffset。从字面上看就是 parkBlocker 的偏移量，那么 parkBlocker 是干嘛的呢，从 static 代码块中可以看到，它属于 Thread 类，于是进去看看：
    

```java
/**
 * The argument supplied to the current call to
 * java.util.concurrent.locks.LockSupport.park.
 * Set by (private) java.util.concurrent.locks.LockSupport.setBlocker
 * Accessed using java.util.concurrent.locks.LockSupport.getBlocker
 */
volatile Object parkBlocker;
```

从注释上看，就是给 LockSupport 的 setBlocker 和 getBlocker 调用。另外在 LockSupport 的 java doc 中也写到：

> This object is recorded while the thread is blocked to permit monitoring and diagnostic tools to identify the reasons that threads are blocked. (Such tools may access blockers using method \[getBlocker (Thread).) The use of these forms rather than the original forms without this parameter is strongly encouraged. The normal argument to supply as a `blocker`within a lock implementation is `this`.

大致是说，parkBlocker 是当线程被阻塞的时候被记录，以便监视和诊断工具来识别线程被阻塞的原因。

Unsafe 类提供了获取某个字段相对 Java 对象的“起始地址”的偏移量的方法 objectFieldOffset，从而能够获取该字段的值。

那么为什么记录该 blocker 在对象中的偏移量，而不是直接调用 Thread. GetBlocker ()，这样不是更好，原因其实很好理解，当线程被阻塞（Blocked）的时候，线程是不会响应的。另外通过反射应该也可以拿到。

  

### LockSupport 的重要方法

类中的方法主要分为两类：`park`（阻塞线程）和`unpark`（解除阻塞）。

首先强调的一点事 park 方法**阻塞的是当前的线程**，也就是说在哪个线程中调用，那么哪个线程就被阻塞（在没有获得许可的情况下）。

重点讲其中的几个：

#### 3.1 park () 解析

```java
public static void park() {
    UNSAFE.park(false, 0L);
}
```

UNSAFE. Park 的两个参数，前一个为 true 的时候表示传入的是绝对时间，false 表示相对时间，即从当前时间开始算。后面的 long 类型的参数就是等待的时间，0L 表示永久等待。

根据 java doc 中的描述，调用 park 后有三种情况，能使线程继续执行下去：

1.  有某个线程调用了当前线程的 unpark。
2.  其他线程中断（interrupt）了当前线程
3.  该调用不合逻辑地（即毫无理由地）返回。

验证一：

```java
public class UnparkTest {
    public static void main(String[] args) throws InterruptedException {
        Thread ut = new Thread(new UnparkThread(Thread.currentThread()));
        ut.start();
        System.out.println("I'm going to call park");
        // Thread.sleep(1000L);
        LockSupport.park();
        System.out.println("oh, I'm running again");

    }
}

class UnparkThread implements Runnable {
    private final Thread t;
    UnparkThread(Thread t) {
        this.t = t;
    }

    @Override
    public void run() {
        try {
            Thread.sleep(1000L);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("I'm in unpark");
        LockSupport.unpark(t);
        System.out.println("I called unpark");
    }
}
```

结果：

```reStructuredText
I'm going to call park
I'm in unpark
I called unpark
oh, I'm running again
```

另外值得一提的是，LockSupport 对 park 和 unpark 的调用顺序并没有要求，将两个`Thread. Sleep (1000L);`注释切换一下就可以发现，先调用 unpark，再调用 park，依旧可以获得许可，让线程继续运行。这一点与 Object 的 wait 和 notify 要求固定的顺序不同，其实现原理可以看[这里](https://blog.csdn.net/hengyunabc/article/details/28126139)。

  

验证二：

```java
public class LockSupportInterrupt {
    public static void main(String[] args) throws InterruptedException {
        Thread t = new Thread(new InterruptThread());
        t.start();
        Thread.sleep(1000L);
        System.out.println("I'm going to interrupt");
        t.interrupt();
    }
}

class InterruptThread implements Runnable {
    @Override
    public void run() {
        System.out.println("I'm going to park");
        LockSupport.park();
        System.out.println("I'm going to again");
    }
}
```

运行结果：

```vhdl
I'm going to park
I'm going to interrupt
I'm going to again
```

LockSupport 的 park 能够能响应 interrupt 事件，且不会抛出 InterruptedException 异常。

  

#### 3.2 park (Object blocker)

Park 的另一个重载方法需要传入 blocker 对象：

```java
public static void park(Object blocker) {
    Thread t = Thread.currentThread();
    setBlocker(t, blocker);
    UNSAFE.park(false, 0L);
    setBlocker(t, null);
}
```

在理解了 parkBlocker 的作用后，这个方法里的代码就很好理解了。

1.  在调用 park 阻塞当前线程之前，先记录当前线程的 blocker。
2.  调用 park 阻塞当前线程
3.  当前面提到的三个让线程继续执行下去的情况时，再将 parkBlocker 设置为 null，因为当前线程已经没有被 blocker 住了，如果不设置为 null，那诊断工具获取被阻塞的原因就是错误的，这也是为什么要有两个 setBlocker 的原因。

再看一下 setBlocker 的代码：

```java
private static void setBlocker(Thread t, Object arg) {
    // Even though volatile, hotspot doesn't need a write barrier here.
    UNSAFE.putObject(t, parkBlockerOffset, arg);
}
```

方法是私有的，嗯，为了保证正确性，肯定不能被其他类调用。

另外就是利用了之前提到的偏移量以及 unsafe 对象将 blocker 值设置进了线程 t 当中。

  

#### 3.3 unpark (Thread thread)

```java
public static void unpark(Thread thread) {
    if (thread != null)
        UNSAFE.unpark(thread);
}
```

这就很简单了，判断是否为空，然后调用 unsafe 的 unpark 方法。由此更可见 unsafe 这个类的重要性。

  

### 各种例子

#### 4.1 jstack 查看 parkBlocker

前面提到 parkBlocker 提供了调试工具上面查找原因，所以我们来看一下在 jstack 上面是什么情况：

```java
public class JstackTest {
    public static void main(String[] args) {
        // 给main线程设置名字，好查找一点
        Thread.currentThread().setName("jstacktest");
        LockSupport.park("block");
    }
}
```

利用 park (blocker) 来阻塞 main 线程，传入 string 作为 parkBlocker。

运行之后，在 shell 里运行：

```shell
> jps
37137 Jps
4860 
37132 Launcher
37133 JstackTest
```

可以看到我们的 java 线程的 pid，JstackTest 这个类对应的是 37133，然后再利用 jstack 来查看：

```shell
> jstack -l 37133
"jstacktest" #1 prio=5 os_prio=31 tid=0x00007f7f07001800 nid=0x2903 waiting on condition [0x0000700000901000]
   java.lang.Thread.State: WAITING (parking)
        at sun.misc.Unsafe.park(Native Method)
        - parking to wait for  <0x000000079582f5d0> (a java.lang.String)
        at java.util.concurrent.locks.LockSupport.park(LockSupport.java:175)
        at lock.JstackTest.main(JstackTest.java:11)

   Locked ownable synchronizers:
        - None
```

省略了一部分，可以看到 jstacktest 线程的状态是 Waiting on condition（等待资源，或等待某个条件的发生），同事可以看到这样一句话：parking to wait for <0x000000079582f5d0> (a java. Lang. String)。

<0x000000079582f5d0>的类型是 String，也就是之前传入 park 里的 block 字符串。而 0x000000079582f5d0 估计就是其地址（待验证）。

  

#### 4.2 利用 LockSupport 实现先进先出锁

在来看一下 java doc 上提供的示例：

```java
class FIFOMutex {
    private final AtomicBoolean locked = new AtomicBoolean(false);
    private final Queue<Thread> waiters
        = new ConcurrentLinkedQueue<Thread>();

    public void lock() {
        boolean wasInterrupted = false;
        Thread current = Thread.currentThread();
        waiters.add(current);
        while (waiters.peek() != current ||
               !locked.compareAndSet(false, true)) {
            LockSupport.park(this);
            if (Thread.interrupted())
                wasInterrupted = true;
        }

        waiters.remove();
        if (wasInterrupted)
            current.interrupt();
    }

    public void unlock() {
        locked.set(false);
        LockSupport.unpark(waiters.peek());
    }
}
```

先进先出锁就是先申请锁的线程最先获得锁的资源，实现上采用了队列再加上 LockSupport. Park。

1.  将当前调用 lock 的线程加入队列
2.  如果等待队列的队首元素不是当前线程或者 locked 为 true，则说明有线程已经持有了锁，那么调用 park 阻塞其余的线程。
3.  如果队首元素是当前线程且 locked 为 false，则说明前面已经没有人持有锁，删除队首元素也就是当前的线程，然后当前线程继续正常执行。
4.  执行完后调用 unlock 方法将锁变量修改为 false, 并解除队首线程的阻塞状态。此时的队首元素继续之前的判断。


## AQS (`AbstractQuenedSynchronizer`)
在 ReentrantLock，Semaphore，CountDownLatch，ReentrantReadWriteLock 中都用到了继承自 AQS 的 Sync 内部类，正如 AQS 的 java doc 中一开始描述：

> Provides a framework for implementing blocking locks and related synchronizers (semaphores, events, etc) that rely on first-in-first-out (FIFO) wait queues.
> 
> 为实现依赖于先进先出（FIFO）等待队列的阻塞锁和相关同步器（信号量，事件等）提供框架。

AQS 根据模式的不同：独占（EXCLUSIVE）和共享（SHARED）模式。

-   独占：只有一个线程能执行。如 ReentrantLock。
-   共享：多个线程可同时执行。如 Semaphore，可以设置指定数量的线程共享资源。

对应的类根据不同的模式，来**实现**对应的方法。

### 结构概览

试想一下锁的应用场景，当线程试图请求资源的时候，先调用 lock，如果获得锁，则得以继续执行，而没有获得，则**排队**阻塞，直到锁被其他线程释放，听起来就像是一个列队的结构。而**实际上 AQS 底层就是一个先进先出的等待队列**：

![](https://images2018.cnblogs.com/blog/1256203/201805/1256203-20180507095207652-1493745445.png)

队列采用了链表的结构，node 作为基本结构，主要有以下几个成员变量：

```java
static final class Node {
    //用来表明当前节点的等待状态，主要有下面几个：
    // CANCELLED: 1, 表示当前的线程被取消
    // SIGNAL: -1, 表示后继节点需要运行，也就是unpark
    // CONDITION: -2, 表示线程在等待condition
    // PROPAGATE: -3, 表示后续的acquireShared能够得以执行，在共享模式中用到，后面会说
    // 0, 初始状态，在队列中等待
    volatile int waitStatus;
    // 指向前一个node
    volatile Node prev;
    // 指向后一个node
    volatile Node next;
    // 指向等待的那个线程
    volatile Thread thread;
    // 在condition中用到
    Node nextWaiter;
}
```

在 AQS 中，用 head，tail 来记录了队列的头和尾，方便快速操作队列：

```java
public abstract class AbstractQueuedSynchronizer extends AbstractOwnableSynchronizer implements java.io.Serializable {
    private transient volatile Node head;
    private transient volatile Node tail;
    // 同步状态
    private volatile int state;
}
```

**AQS 的基本框架就是：state 作为同步资源状态，当线程请求锁的时候，根据 state 数值判断能否获得锁。不能，则加入队列中等待。当持有锁的线程释放的时候，根据队列里的顺序来决定谁先获得锁。**

  

### 源码阅读

独占模式典型的实现就是 ReentrantLock，其具体流程如下：

![](https://images2018.cnblogs.com/blog/1256203/201805/1256203-20180507095222571-585433048.png)

独占模式下对应的 lock-unlock 就是 acquire-release。整个过程如上图所示。我们先来看一下 acquire 方法：

```java
public final void acquire(int arg) {
    if (!tryAcquire(arg) &&
        acquireQueued(addWaiter(Node.EXCLUSIVE), arg))
        selfInterrupt();
}
```

1.  调用 tryAcquire ()，该方法会在独占模式下尝试请求获取对象状态。具体的实现由实现类去决定。
2.  如果 tryAcquire () 失败，即返回 false，则调用 addWaiter 函数，将当前线程标记为独占模式，加入队列的尾部。
3.  调用 acquireQueued ()，让线程在队列中等待获取资源，一直获取到资源后才返回。如果在等阿迪过程中被中断过，则返回 true，否则返回 false
4.  如果线程被中断过，在获取锁之后，调用中断

  

#### 3.1 tryAcquire (int arg)

下面来具体看一下各个方法：

```java
protected boolean tryAcquire(int arg) {
    throw new UnsupportedOperationException();
}
```

前面说过了，AQS 提供的是框架，其具体的实现由实现类来完成，tryAcquire 就是其中之一，需要子类自己实现的方法，那既然要自己实现，为什么不加 abstract 关键字，因为前面提到过，只有独占模式的实现类才需要实现这个方法，像 Semaphore，CountDownLatch 等共享模式的类不需要用到这个方法。如果加了关键字，那么这些类还要实现，显得很鸡肋。

  

#### 3.2 addWaiter (Node mode)

```java
private Node addWaiter(Node mode) {
    // 将当前线程封装进node
    Node node = new Node(Thread.currentThread(), mode);
    
    Node pred = tail;
    // 插入队列尾部，并维持节点前后关系
    if (pred != null) {
        node.prev = pred;
        if (compareAndSetTail(pred, node)) {
            pred.next = node;
            return node;
        }
    }
    // 上一步如果失败，在enq中继续处理
    enq(node);
    return node;
}
```

逻辑相对简单，其中 compareAndSetTail 采用 Unsafe 类来实现。那么下面的 enq () 方法是具体做了什么呢？

```java
private Node enq(final Node node) {
    for (;;) {
        Node t = tail;
        // 队列初始化
        if (t == null) {
            if (compareAndSetHead(new Node()))
                tail = head;
        // 重复执行插入直到return
        } else {
            node.prev = t;
            if (compareAndSetTail(t, node)) {
                t.next = node;
                return t;
            }
        }
    }
}
```

Enq () 方法为了防止在 addWaiter 中，节点插入队列失败没有 return，或者队列没有初始化，在 for 循环中反复执行，确保插入成功，返回节点。

  

#### 3.3 acquireQueued (final Node Node, Int arg)

到目前为止，走到 acquireQueued () 调用了前两个方法，意味着获取资源失败，将节点加入了等待队列，那么下面要做的就是阻塞当前的线程，等待资源被是否后，再次唤醒线程来取得资源。

```java
final boolean acquireQueued(final Node node, int arg) {
    boolean failed = true;
    try {
        boolean interrupted = false;
        for (;;) {
            // 获取当前节点的前一个节点
            final Node p = node.predecessor();
            // 前一个节点是头结点，且获取到了资源
            if (p == head && tryAcquire(arg)) {
                setHead(node);
                p.next = null; // help GC
                failed = false;
                return interrupted;
            }
            // 不符合上面的条件，那么只能被park，等待被唤醒
            if (shouldParkAfterFailedAcquire(p, node) &&
                parkAndCheckInterrupt())
                interrupted = true;
        }
    } finally {
        if (failed)
            cancelAcquire(node);
    }
}
```

AcquireQueued 当中，用 for 循环来让线程等待，直至获得资源 return。而**return 的条件就是当前的节点是第二个节点，且头结点已经释放了资源。**

再来看看 shouldParkAfterFailedAcquire 和 parkAndCheckInterrupt 方法

先来说一下 parkAndCheckInterrupt：

```java
private final boolean parkAndCheckInterrupt() {
    LockSupport.park(this);
    return Thread.interrupted();
}
```

调用 LockSupport. Park，阻塞当前线程，当线程被重新唤醒后，返回是否被中断过。

再来重点看一下 shouldParkAfterFailedAcquire：

```java
private static boolean shouldParkAfterFailedAcquire(Node pred, Node node) {
    // 获取前一个节点的状态
    int ws = pred.waitStatus;
    // 如果前一个节点的状态是signal，前面提到表明会unpark下一个节点，则true
    if (ws == Node.SIGNAL)
        return true;
    // 如果ws > 0 即CANCELLED，则向前找，直到找到正常状态的节点。
    if (ws > 0) {
        do {
            node.prev = pred = pred.prev;
        } while (pred.waitStatus > 0);
        // 维护正常状态
        pred.next = node;
    // 将前一个节点设置为SIGNAL
    } else {
        compareAndSetWaitStatus(pred, ws, Node.SIGNAL);
    }
    return false;
}
```

ShouldParkAfterFailedAcquire 的主要作用就是将 node 放置在 SIGNAL 状态的前节点下，确保能被唤醒，在调用该方法后，**CANCELLED 状态的节点因为没有引用执行它将被 GC。**

那么问题来了，**什么时候节点会被设置为 CANCELLED 状态**？

答案就在 try-finally 的 cancelAcquire (node) 当中。当在 acquireQueued 取锁的过程中，抛出了异常，则会调用 cancelAcquire。将当前节点的状态设置为 CANCELLED。

  

#### 3.4 cancelAcquire (Node node)

我们先来看一下它的源码：

```java
private void cancelAcquire(Node node) {
    // node为空，啥都不干
    if (node == null)
        return;
    node.thread = null;

    // while查找，直到找到非CANCELLED的节点
    Node pred = node.prev;
    while (pred.waitStatus > 0)
        node.prev = pred = pred.prev;

    // 获取非CANCELLED的节点的下一个节点，predNext肯定是CANCELLED
    Node predNext = pred.next;

    // 设置当前节点为CANCELLED状态
    node.waitStatus = Node.CANCELLED;

    // 如果节点在队列尾部，直接移除自己就可以了
    if (node == tail && compareAndSetTail(node, pred)) {
        compareAndSetNext(pred, predNext, null);
    } else {
        int ws;
        // 重新维护剩下的链表关系
        if (pred != head &&
            ((ws = pred.waitStatus) == Node.SIGNAL ||
             (ws <= 0 && compareAndSetWaitStatus(pred, ws, Node.SIGNAL))) &&
            pred.thread != null) {
            Node next = node.next;
            if (next != null && next.waitStatus <= 0)
                compareAndSetNext(pred, predNext, next);
        } else {
            // 唤醒node的下一个节点
            unparkSuccessor(node);
        }
        // help GC
        node.next = node; 
    }
}
```

总结来说，cancelAcquire 就是用来维护链表正常状态的关系，直接看代码认识起来可能还比较模糊，放图：

![](https://images2018.cnblogs.com/blog/1256203/201805/1256203-20180507095252221-450091214.png)

几个注意点：

1.  如果 node 为第二个节点的时候，pred == head，唤醒下一个节点 next\_node，next\_node 线程会继续在 acquireQueued 的 for 循环中执行，调用 shouldParkAfterFailedAcquire 会重新维护状态，排除 node 节点
2.  调用 if 里的逻辑后，可以看到 next 的 prev 还指向 node，会导致 node 无法被 gc，这一点不用担心，当 next 调用 setHead 被设置为 head 的时候，next 的 prev 会被设置为 null，这样 node 就会被 gc

```java
private void setHead(Node node) {
    head = node;
    node.thread = null;
    node.prev = null;
}
```

以上部分就是 acquire 的所有部分，建议忘记的园友们可以回到上面重新看一下流程图，再接着稳固一遍。

  

#### 3.5 release (int arg)

下面开始 release 的源码解析，相对于 acquire 来说要简单一些：

```java
public final boolean release(int arg) {
    if (tryRelease(arg)) {
        Node h = head;
        if (h != null && h.waitStatus != 0)
            unparkSuccessor(h);
        return true;
    }
    return false;
}
```

与 acquire 一样，tryRelease 由实现类自己实现，如果为 true，则 unpark 队列头部的下一个节点。

```java
private void unparkSuccessor(Node node) {
    // 清楚小于0的状态
    int ws = node.waitStatus;
    if (ws < 0)
        compareAndSetWaitStatus(node, ws, 0);

    // 如果下一个节点是CANCELLED，则从尾部向头部找距离node最近的非CANCELLED节点
    Node s = node.next;
    if (s == null || s.waitStatus > 0) {
        s = null;
        for (Node t = tail; t != null && t != node; t = t.prev)
            if (t.waitStatus <= 0)
                s = t;
    }
    // unpark找到的节点
    if (s != null)
        LockSupport.unpark(s.thread);
}
```

至此 acuqire-release 的部分就此结束了，至于共享模式的代码大同小异，在后面分析信号量的时候会再提及~

  

### 总结

AQS 应该是整个 JUC 中各个类涉及最多的了，其重要性可想而知，在了解其实现原理后，有助于我们分析其他的代码。最后谢谢各位园友观看，如果有描述不对的地方欢迎指正，与大家共同进步！



