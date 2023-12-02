---
scope: learn
draft: true
tags: ["locksupport", "aqs", "synchronized"]
---
前段时间结束了jdk1.8集合框架的源码阅读，在过年的这段时间里，一直在准备JUC(java.util.concurrent)的源码阅读。平时接触的并发场景开发并不很多，但是有网络的地方，就存在并发，所以想找几本书阅读深入一下，看到网上推荐较多的两本书《Java并发编程实战》和《Java多线程编程核心技术》。看了两书的优缺点后，笔者选择了先看后者，据说代码例子较多，书到手后，看完后的印象就是对并发的关键字、几个常见类的api进行了介绍，内容挺早以前，讲的也是不是很深，对Java SE5新加的类介绍很少，只能说对于刚接触并发编程的人来说，还是值得一看的。
Java 并发编程的相关文章：
- [【JDK1.8】JUC——ReentrantLock](https://www.cnblogs.com/joemsu/p/9460156.html)
- [【JDK1.8】JUC——AbstractQueuedSynchronizer](https://www.cnblogs.com/joemsu/p/9001136.html)
- [【JDK1.8】JUC——LockSupport](https://www.cnblogs.com/joemsu/p/8902745.html)
- [【JDK1.8】JUC.Lock综述](https://www.cnblogs.com/joemsu/p/8543449.html)
- [Java并行(2): Monitor - tomsheep - 博客园](https://www.cnblogs.com/tomsheep/archive/2010/06/09/1754419.html)
- [Java并发编程：Synchronized底层优化（偏向锁、轻量级锁） - liuxiaopeng - 博客园](https://www.cnblogs.com/paddix/p/5405678.html)
- [关于操作系统中进程、线程、死锁、同步、进程间通信(IPC)的超详细整理 - 知乎](https://zhuanlan.zhihu.com/p/383522058)

# 前置知识

[线程八锁](线程八锁.md)

## 什么是监视器（monitor）？
- [Java并行(2): Monitor - tomsheep - 博客园](https://www.cnblogs.com/tomsheep/archive/2010/06/09/1754419.html)

大学有一门课程叫操作系统，监视器是操作系统实现同步的重要基础概念，同样它也用在 JAVA 的线程同步中，。监视器是一种同步模型，和 Java 语言没有关系，其他语言也可以使用监视器来进行同步代码块的访问。Java 语言是通过 synchronized 关键字来声明同步块的，具体是怎么同步的，是使用的监视器模型来同步的。

### Monitor Object 模式

Monitor 其实是一种同步工具，或者说是同步机制，它通常被描述成一个对象，主要特点是：

1.  **同步**。对象内的所有方法都**互斥**的执行。好比一个 Monitor 只有一个运行许可，任一个线程进入任何一个方法都需要获得这个许可，离开时把许可归还。
2.  **协作**。通常提供signal机制：允许正持有许可的线程暂时放弃许可，等待某个监视条件成真，条件成立后，当前线程可以通知正在等待这个条件的线程，让它可以重新获得运行许可。



在 Monitor Object 模式中，主要有四种类型参与者：

### 监视者对象 Monitor Object

负责公共的接口方法，这些公共的接口方法会在多线程的环境下被调用执行。

### 同步方法

这些方法是**监视者对象**所定义。为了防止竞争条件，无论是否有多个线程并发调用同步方法，还是监视者对象还用多个同步方法，在任一事件内只有**一个**同步方法能够执行。

### 监控锁 Monitor Lock

每一个监视者对象都会拥有一把监视锁。

### 监控条件 Monitor Condition

同步方法使用监视锁和监视条件来决定方法是否需要阻塞或重新执行。

### 执行序列

在 Monitor Object 模式中，参与者之间将发生如下协作过程：

1.  同步方法的调用和串行化。当某线程调用监视者对象的同步方法时，必须首先获得它的监视锁。只要监视者对象有其他同步方法正在执行，获取操作便不会成功，该线程将处于**阻塞（BLOCKED）**状态。当线程获得监控锁后，执行方法实现服务，一旦同步方法完成执行，监视锁**自动**释放。
2.  同步方法线程挂起。如果调用同步方法的线程必须被阻塞或是其他原因不能立刻进行，它能够在一个监视条件上等待，这将导致该客户线程暂时**释放监视锁**，并**挂起（WAITING / TIMED\_WAITING）**在监视条件上。
3.  监视条件通知。线程能够通知一个监视条件，目的是为了让一个前期使自己挂起在一个监视条件上的同步方法线程恢复运行。
4.  同步方法线程回复。一旦早先挂起在某监视条件上的同步方法线程获取通知，它将继续在最初的等待监视条件的点上执行，执行的条件是唤醒后抢占到监视锁。

下图描述了监视者对象的动态特性：

![](https://www.jianshu.com//upload-images.jianshu.io/upload_images/4417484-0f740594de7ae935.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/572/format/webp)

图1 监视者对象的动态特性
## Synchronized 方法和 Synchronized 语句块
https://docs.oracle.com/javase/tutorial/essential/concurrency/index.html

## Java 中的Monitor

实质上，Java 的 Object 类本身就是监视者对象，Java 对于 Monitor Object 模式做了内建的支持。

-   Object 类本身就是**监视者对象**
-   每个 Object 都带了一把看不见的锁，通常叫 **内部锁/Monitor 锁/Instrinsic Lock**, 这把锁就是 **监控锁**
-   synchronized 关键字修饰方法和代码块就是 **同步方法**
-   wait()/notify()/notifyAll() 方法构成**监控条件(Monitor Condition)**

下图描述了 Java Monitor 的工作机理：

  

![](https://www.jianshu.com//upload-images.jianshu.io/upload_images/4417484-39e8427c56f63429.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/500/format/webp)

图2 Java Monitor工作机理

1.  线程进入同步方法中：
2.  为了继续执行临界区代码，线程必须获取 Monitor 锁。如果获取锁成功，将成为该监视者对象的拥有者。任一时刻内，监视者对象只属于一个活动线程（The Owner）
3.  拥有监视者对象的线程可以调用 wait() 进入等待集合（Wait Set），同时释放监视锁，进入等待状态。
4.  其他线程调用 notify() / notifyAll() 接口唤醒等待集合中的线程，这些等待的线程需要**重新获取监视锁后**才能执行 wait() 之后的代码。
5.  同步方法执行完毕了，线程退出临界区，并释放监视锁。

## 关于 Wait / Notify / notifyAll

### 条件队列

条件队列（图2 中的 Wait Set）存储的是"处于等待状态的线程"，这些线程在等待某种特定的条件变成真。正如每个Java对象都可以作为一个锁，每个对象同样可以作为一个条件队列，这个对象的wait /notify / notifyAll就构成了内部条件队列的API。对象的**监控锁与条件队列是相互关联**的。要调用条件队列的任何一个方法，**必须先持有该对对象上的锁**，一个推论就是“wait / notify 方法只能出现在相应的同步块中”。如果不在同步方法或同步块中，运行时会报 `IllegalMonitorStateException`。

### 实践模式

```csharp
void xxxMethod() throws InterruptedException{  
    synchronized(lock){  
        while(!conditionPredition)  
            lock.wait();  
        doSomething();  
    }  
}
```

1.  `wait` 必须在 `synchronized` 方法或代码块中
2.  用 `while` 而不是 if 判断监视条件，因为当线程被唤醒的时候，监视条件可能根本没有被满足。如当前线程调用的是 `notifyAll`
3.  `lock` 可以是 `this`

notify 是从条件队列从随机选择一个线程来唤醒，而 notifyAll 是唤醒条件队列中的所有线程。

只有同时满足下列两个条件时，才使用 notify 而不是 notifyAll：

1.  所有的等待线程类型相同：**只有一个**监视条件与条件队列相关，并且每个线程从 wait 返回后将**执行相同的操作**。
2.  单进单出：条件变量上的每次通知，**最多**只能唤醒一个线程来执行。

# JUC
- [JUC 包总结](JUC%20包总结.md)
- 


# 线程池
## 线程池接口与 API
一、线程池：提供了一个线程队列，队列中保存着所有等待状态的线程。避免了创建与销毁额外开销，提高了响应的速度。

二、线程池的体系结构：
```
 	java.util.concurrent.Executor : 负责线程的使用与调度的根接口
 		|--**ExecutorService 子接口: 线程池的主要接口
 			|--ThreadPoolExecutor 线程池的实现类
 			|--ScheduledExecutorService 子接口：负责线程的调度
 				|--ScheduledThreadPoolExecutor ：继承 ThreadPoolExecutor， 实现 ScheduledExecutorService
```

 三、工具类 : Executors
 `ExecutorService newFixedThreadPool()` : 创建固定大小的线程池
 
 `ExecutorService newCachedThreadPool()` : 缓存线程池，线程池的数量不固定，可以根据需求自动的更改数量。
 
 `ExecutorService newSingleThreadExecutor()` : 创建单个线程池。线程池中只有一个线程

 `ScheduledExecutorService newScheduledThreadPool()` : 创建固定大小的线程，可以延迟或定时的执行任务。
 
## 合理使用线程池

- [Java-线程池动态修改大小 - 腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1906823)
- [Java线程池实现原理及其在美团业务中的实践 - 美团技术团队](https://tech.meituan.com/2020/04/02/java-pooling-pratice-in-meituan.html)
- [【原创】腾讯面试官：线程池要设置多大 - 腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1605149)
- 
# ThreadLocal 类型

- [理解Java中的ThreadLocal - 技术小黑屋](https://droidyue.com/blog/2016/03/13/learning-threadlocal-in-java/)
- [使用ThreadLocal - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1306581251653666)

# 1. 进程与线程

## 1.1 概念


进程

- 程序由指令和数据组成，但这些指令要运行，数据要读写，就必须将指令加载至 CPU, 数据加载至内存。在指令运行过程中还需要用到磁盘、网络等设备。进程就是用来加载指令、管理内存、管理 I0 的
- 当一个程序被运行，从磁盘加载这个程序的代码至内存, 这时就开启了一个进程。
- 进程就可以视为程序的一一个实例。大部分程序可以同时运行多个实例进程 (例如记事本、画图、浏览器等)，也有的程序只能启动一个实例进程 (例如网易云音乐、360 安全卫士等)
  

线程
- 一个进程之内可以分为-到多个线程。
- 一个线程就是一一个指令流，将指令流中的一条条指令以一定的顺序交给 CPU 执行
- Java 中，线程作为最小调度单位，进程作为资源分配的最小单位。在 windows 中进程是不活动的，只是作为线程的容器

二者对比
- 进程基本上相互独立的，而线程存在于进程内，是进程的一个子集
- 进程拥有共享的资源，如内存空间等，供其内部的线程共享
- 进程间通信较为复杂
  - 同一台计算机的进程通信称为 IPC (Inter-process communication)
  - 不同计算机之间的进程通信，需要通过网络，并遵守共同的协议，例如 HTTP
- 线程通信相对简单，因为它们共享进程内的内存，一个例子是多个线程可以访问同一个共享变量
- 线程更轻量，线程上下文切换成本-般上要比进程上下文切换低



## 1.2 并行与并发

- 单核 CPU 中，线程实际是串行执行的。
- 操作系统中的任务调度器，将 cpu 时间片分给不同的线程使用，实现并发
- 微观串行，宏观并发
- Concurrent

## 1.3 线程的应用：异步调用

**应用之异步调用 (案例 1)**
从方法调用的角度来讲，如果
- 需要等待结果返回，才能继续运行就是同步
- 不需要等待结果返回，就能继续运行就是异步

注意: 同步在多线程中还有另外- -层意思，是让多个线程步调-致
1. 设计
- 多线程可以让方法执行变为异步的 (即不要巴巴干等着) 比如说读取磁盘文件时，假设读取操作花费了 5 秒钟, 如果没有线程调度机制，这 5 秒调用者什么都做不了, 其代码都得暂停...
2. 结论
- 比如在项目中，视频文件需要转换格式等操作比较费时，这时开一个新线程处理视频转换，避免阻塞主线程
- Tomcat 的异步 servlet 也是类似的目的，让用户线程处理耗时较长的操作，避免阻塞 tomcat 的工作线程
- Ui 程序中，开线程进行其他操作, 避免阻塞 ui 线程

## 1.4 线程的应用：提升效率
**应用之提高效率 (案例 1)**
充分利用多核 cpu 的优势, 提高运行效率。想象下面的场景，执行 3 个计算，最后将计算结果汇总。
```计算1花费10ms
计算2花费11ms
计算3花费9ms
汇总需要1 ms
```
- 那么串行总共花费的时间是、 `10 + 11 + 9 + 1 =31ms'
- 但如果是四核 cpu, 各个核心分别使用线程 1 执行计算 1, 线程 2 执行计算 2, 线程 3 执行计算 3, 那么 3 个线程是并行的，花费时间只取决于最长的那个线程运行的时间，即 11ms 最后加上汇总时间只会花费 12ms

注意
- 需要在多核 cpu 才能提高效率，单核仍然时是轮流执行

1. 设计
- 依次启动三个线程进行计算，主线程拿到线程计算结果
2. 结论
  1. 单核 cpu 下，多线程不能实际提高程序运行效率，只是为了能够在不同的任务之间切换，不同线程轮流使用 cpu, 不至于一个线程总占用 cpu, 别的线程没法干活
  2. 多核 cpu 可以并行跑多个线程，但能否提高程序运行效率还是要分情况的

    - 有些任务,经过精心设计，将任务拆分，并行执行，当然可以提高程序的运行效率。但不是所有计算任务都能拆分(参考后文的[阿姆达尔定律] )
    - 也不是所有任务都需要拆分,任务的目的如果不同，谈拆分和效率没啥意义
3. IO 操作不占用 cpu, 只是我们一-般拷贝文件使用的是“阻塞 I0”，这时相当于线程虽然不用 cpu, 但需要一直等待 IO 结束，没能充分利用线程。所以才有后面的“非阻塞 I0”和“异步 IO”优化



##



# 2. Java 线程

## 2.1 创建和运行线程

### 2.1.1 Thread

```java
//创建线程对象
Thread t = new Thread(){
    public void run(){
        //todo
    }
};
//启动线程
t.start():
```

### 2.1.2 Runnable 配合 Thread

把线程和  todo  任务分来

- Thread 代表线程
- Runnable 代表可运行的任务

```java
//创建Runnable对象
Runnable runnable = new Runnable(){
    public void run(){
        //todo
    }
};
//创建线程对象
Thread t = new Thread(runnable);
//启动线程
t.start():
```

**Runnable 接口**

源码

```java
@FunctionalInterface
public interface Runnable {
    /**
     * When an object implementing interface <code>Runnable</code> is used
     * to create a thread, starting the thread causes the object's
     * <code>run</code> method to be called in that separately executing
     * thread.
     * <p>
     * The general contract of the method <code>run</code> is that it may
     * take any action whatsoever.
     *
     * @see     java.lang.Thread#run()
     */
    public abstract void run();
}
```

1. 只有一个抽象方法  run ()，没有返回值
2. JDK 会给只有一个方法的接口加上 `@FunctionalInterface` (函数式接口)，凡是有这种注解的接口可以被 lambda 表达式简化

Lambda 简化举例

1. `->` 为输入参数，
2. `{}` 可以省略，前提是只有一行代码体

```java
//创建Runnable对象
Runnable runnable () ->{
        //todo
};
//创建线程对象
Thread t = new Thread(runnable);
//启动线程
t.start():
```

## 2.2 Thread 和 Runnable 的关系

实际上，传入 Thread 的 Runnable 对象会作为对象的 `target` 示例参数**（前提是 Thread 自身的 Target 不为空）**，然后被 `thread.start()` 调用

使用 Runnable 的好处

1. 更容易与线程池 API 配合
2. 更灵活

## 2.3 FutureTask 配合 Thread

除了 1. 直接使用 Thread 2. Runnable ，还可以使用 FutureTask (继承了 Runnable)

```java
//通过FutureTask创建任务对象
//实际上里面的()并不是Runnable 的run()，而是Callable 的call()
FutureTask<Integer> task3 = new FutureTask<>( () -> {
    //todo
    return 100;
});

//参数1是任务对象；参数2是线程名字
new Thread(task3,"t3").start();

//...

//多路复用IO，当主线程需要读时调用get，此时主线程阻塞直到数据传回
Integer result = task3.get();
```

1. FutureTask 实际上接受 Callable 类型的参数，Callable 和 Runnable 区别只在于，Callable 有返回值
   ```java
   @FunctionalInterface
   public interface Callable<V> {
    /**
     * Computes a result, or throws an exception if unable to do so.
     *
     * @return computed result
     * @throws Exception if unable to compute a result
     */
    V call() throws Exception;
   }
   ```
2. FutureTask 是 Runnable 的实现类
   调用关系 Thread  ->  Runnable  ->  Callable

## 2.4 查看线程的方法

**windows**

- 任务管理器
- `tasklist | findstr java` 查看包含 java 的进程
- `taskkill` 杀死进程

**linux**

- `ps -fe` 查看所有进程
- `ps -fT -p  PID ` 查看某个 PID 进程的所有线程
- `kill` 杀死进程
- `top` 按大写 H 切换是否显示进程
- `top -H -p  PID ` 查看某个 PID 进程的所有线程信息

**Java**

- `jps` 查看所有 java 线程
- `jstack  PID ` 查看某个 java 进程的所有线程
- Jconsole 查看某个 java 进程种线程的运行状态



## 2.5 线程运行原理

### 2.5.1 栈与栈帧

JVM 中有虚拟机栈，其中栈就是给线程使用的，每个线程有一块栈中内存

- 每个栈由多个栈帧 (Frame) 组成，对应每次方法调用时所占用的内存
- 每个线程只能有一个活动栈帧，对应当前执行的方法

### 2.5.2 线程的上下文切换 (Thread Context Switch)

因为一些原因导致不再执行当前线程，转而执行另一个线程的代码

- 线程的 cpu 时间片用完
- 垃圾回收
- 有更高优先级的线程需要运行
- 线程自己调用了 `sleep` , `yield` , `wait` , `join` , `park` , `synchronized` , `lock` 等方法

当上下文切换发生时，需要由操作系统保存当前线程的状态，并恢复另一个线程的状态，Java 中对应的概念就是程序计数器，它的作用是记住下一条 jvm 指令的执行地址，线程私有

- 状态包括 PC、虚拟机中每个栈帧的信息，如局部变量、操作数栈、返回地址等
- 频繁切换影响性能

## 2.6 常用方法

### 2.6.1 Start 和 Run 的区别

1. `Thread.run()` 实际上是进入每个线程后自己调用的方法，直接调用会在<u>本线程执行，不会创建新线程</u>
2. `Thread.start()` 拥有创建新线程的能力，实际开发中需要使用 start，在新线程中自动调用 run
   Start 前线程状态是 `NEW` ，之后是 `RUNNABLE`

### 2.6.2 Sleep 与 Yield

**sleep**

1. 调用 `Thread.sleep( long millis )` 会让当前线程从 `Running` 进入 `Timed_Waiting` 状态
2. <u>其他线程</u>可以使用 `Thread.interrupt()` 方法打断正在睡眠的线程，这时 `sleep` 方法会抛出 `InterruptedExceptipon`
3. 睡眠结束后的线程未必会立刻得到执行，需要等待时间片
4. 建议用 `TimeUnit.SECONDS.sleep( long millis )` 代替 `Thread.sleep(long millis)` 来获得更好的可读性，中间可以指定任意单位，本质只是底层的代码调用和单位转换

**yield**

1. 调用 `Thread.yield()` 会让当前线程从 `Running` 进入 `Rurnnable` 状态, 然后调度执行其它同优先级的线程。如果这时没有同优先级的线程，那么不能保证让当前线程暂停的效果
2. 具体的实现依赖于操作系统的任务调度器，实际内容是让出自己的时间片

备注：

- 任务调度器不会把时间片给阻塞态/Timed_Waiting 的进程，而是会给就绪态/Runnable

### 2.6.3 setPriority 线程优先级

可以使用 `Thread.setPriority()` 优先级，最小 1，最大 10，越大优先级越高

- 线程优先级会提示 (hint) 调度器优先调度该线程，但它仅仅是一个提示, 调度器可以忽略它
- 如果 cpu 比较忙，那么优先级高的线程会获得更多的时间片，但 cpu 闲时，优先级几乎没作用

#### 2.6.3.1 案例-防止 CPU 占用 100%

**sleep 实现**

在没有利用 cpu 来计算时，不要让 while (true) 空转浪费 cpu, 这时可以使用 yield 或 sleep 来让出 cpu 的使用权给其他程序
```Java
while(true) {
    try {
        //每次while循环体都会sleep，如果没有sleep，while True会把时间片完全占满
		Thread. sleep(58);
	} catch (InterruptedException e) {
		e. printStackTrace();
}
```
- 可以用 wait 或条件变量达到类似的效果

- 不同的是，后两种都需要加锁，并且需要相应的唤醒操作，-般适用于要进行同步的场景

- Sleep 适用于无需锁同步的场景

  一个形象的比喻：踩着油门踩刹车

### 2.6.4 Join

`Thread.join()` ，底层实际上实现基于 wait ()

**为什么需要 join?**

举例：下面代码，打印 r 是什么？

```java
static int r = 0;
public static void main(String[] args) throws InterruptedException {
	test1();
}
private static void test1() throws InterruptedException {
	log.debug("开始");
	Thread t1 = new Thread(() -> {
		log.debug("开始");
		sleep(1);
		log.debug("结束");
		r=10;
	},"t1");
	t1.start();
	log . debug("结果为:{}", r);
	log . debug("结束");
}

```

分析：

- 因为主线程和 t1 并行执行，t1 需要 1 毫秒后才能赋值 r=10
- 主线程不等待直接打印，所以大概率 r=0

解决方法

1. Sleep 行不行？
   - 不行，可能会有其他线程 (高优先级) 导致 sleep 等完了也没执行
2. 用 `join` ，在 `t1.start()` 之后加 `t1.join()`
   - 这样直到 t1 结束后，主线程才会继续执行

#### 2.6.4.1 同步的概念

以调用方角度讲，如果

- 需要等待结果返回，才能继续运行就是同步
- 不需要等待结果返回，就能继续运行就是异步

#### 2.6.4.2 有时效的 Join

`Thread.join(long n)` 意味等待线程运行结束，最多等待 n 毫秒



### 2.6.5 Interrupt

1. 打断 sleep, wait join 的线程，即打断处于**阻塞 Wait**状态的线程
2. 用来打断运行的线程

**举例**

1. 打断 sleep 的线程，会清空打断状态，以 sleep 为例

- 打断后会有打断标记 `Thread.isInterrupted()` ，但是在被打断后，会重置这个标记为 false

```java
private static void test1() throws InterruptedException {
	Thread t1 = new Thread(()->{
		sleep(100);
	}, "t1");
	t1.start();
    
	sleep(1);
	t1. interrupt();
    //因为被打断了，所以打断标记重置了
	1og . debug("打断状态: {}", t1. isInterrupted());
}

```

 

2. 打断正常运行的线程

- 正常运行程序只会知道自己被打断了，但是其实不会停止线程，但是会将打断标记置 True

- 因此，可以将正常线程的循环条件设置为打断标记

```java
public static void main(String[] args) throws InterruptedException {
	Thread t1 = new Thread(() -> {
		while(true){
	I		boolean interrupted = Thread.currentThread().isInterrupted();
             if(interrupted){
                 Log. debug(" interrupt is true" );
                 //$!)

实现样例

```java

class TwoPhaseTermination {
	private Thread monitor;
	//启动监控线程
	public void start() {
		monitor = new Thread(() -> {
			while(true) {
				Thread current = Thread.currentThread();
				if(current.isInterrupted()) {
					log. debug(“料理后事");
					break;
            	 }
				try {
					Thread.sleep(1000); //情况1
					log.debug( "执行监控记录"); //情况2
				}catch (InterruptedException e) {
					e.printStackTrace();
					//重新设置打断标记
					current.interrupt();
				}
			}
		});
		monitor.start();
	}
            
	// 停止监控线程
	public void stop() {
		monitor.interrupt();
	}
}
```



# 4 Synchronized (黑马程序员)

https://www.bilibili.com/video/BV1aJ411V763?p=2&spm_id_from=pageDriver

## 4.0 并发编程的三个问题

1. 可见性问题
   - 一个线程修改了共享变量，另一个线程可能不会立即看到修改后的最新值
2. 原子性问题
   - 原子性：(Atomicity)，一次或多次操作中，要么所有操作都执行，要么所有操作都不执行
   - 并发操作可能不是原子的，一个线程在其他线程提交执行结果前就进行了新的操作
3. 有序性问题
   - 有序性：(Ordering) ，是指程序中代码的执行顺序, Java 在编译时和运行时会对代码进行优化，会导致程序最终的执行顺序不一定就是我们编写代码时的顺序。|

有序性问题的一个例子

```java
int num = 0;
boolean ready = false; 
//线程1执行的代码
@Actor
public void actor1(I_ Result r) {
	if (ready) {
		r.r1 = num+num;
	} else {
		r.r1 = 1;
    }
}
//线程2执行的代码
@Actor
public void actor2(I_ Result r) {
	num=2;
	ready=true;
}
```

分析：

1. 可能的结果 1：线程 1 先执行，ready=false，结果r.r1=1
2. 可能的结果 2：线程 2 先执行，num=2，ready=true，结果r.r1=2+2=4
3. 可能的结果 3：线程 2 先执行，num=2，此时切换到线程 1，ready=false，结果r.r1=1
4. 可能的结果 4：**重排序**，仍然是线程 2 先执行
   - Java 可能会对代码进行优化，认为 ready=true 在先，num=2 在后执行比较快
   - 线程 2 先执行，ready=true，此时切换到线程 1，结果r.r1=0+0=0

测试结果：

0 出现了很多次

## 4.1 Java 内存模型 (JMM)

### 4.1.1 计算机结构简介

冯诺依曼提出计算机五大部分

1. 输入设备
2. 输出设备
3. 存储器
4. 运算器
5. 控制器

![冯诺依曼结构](10-ComputeScience/Java/Java%20API/多线程/_attachments/多线程（JUC）/冯诺依曼结构.jpg)

Cache

Cache 的出现是为了解决 CPU 直接访问内存效率低下问题的，程序在运行的过程中，CPU 接收到指令后，它会最先向 CPU 中的一级缓存 (L1 Cache) 去寻找相关的数据，如果命中缓存，CPU 进行计算时就可以直接对 CPU Cache 中的数据进行读取和写人，当运算结束之后，再将 CPUCache 中的最新数据刷新到主内存当中，CPU 通过直接访问 Cache 的方式替代直接访问主存的方式极大地提高了 CPU 的吞吐能力。但是由于一级缓存 (L1 Cache) 容星较小, 所以不可能每次都命中。这时 CPU 会继续向下一级的二级缓存 (L2Cache) 寻找, 同样的道理，当所需要的数据在二级缓存中也没有的话，会继续转向 L3 Cache、内存 (主存) 和硬盘。

### 4.1.2 Java 内存模型 (JMM)

#### 4.1.2.1 概念

Java 内存模型，是 Java 虚拟机规范中所定义的一种内存模型, Java 内存模型是标准化的, 屏蔽掉了底层不同计算机的区别。
Java 内存模型是一套规范，描述了 Java 程序中各种变量 (线程共享变量) 的访问规则，以及在 JVM 中将变量存储到内存和从内存中读取变量这样的底层细节，具体如下。

- 主内存
  主内存是所有线程都共享的，都能访问的。所有的共享变量都存储于主内存。
- 工作内存
  每一个线程有自己的工作内存, 工作内存只存储该线程对共享变量的副本。线程对变量的所有的操作 (读，取) 都必须在工作内存中完成，而不能直接读写主内存中的变量，不同线程之间也不能直接访问对方工作内存中的变量。

![JMM模型](10-ComputeScience/Java/Java%20API/多线程/_attachments/多线程（JUC）/JMM模型.jpg)

#### 4.1.2.2 作用

Java 内存模型是一套在多线程读写共享数据时，对共享数据的可见性、有序性、和原子性的规则和保障。
主要使用两种关键词进行三个规则的保障

1. Synchronized
2. Volatile

#### 4.1.2.3 CPU 缓存，内存与 Java 内存模型的关系

通过对前面的 CPU 硬件内存架构、Java 内存模型以及 Java 多线程的实现原理的了解, 我们应该已经意识到，多线程的执行最终都会映射到硬件处理器上进行执行。
但 Java 内存模型和硬件内存架构并不完全一致。对于硬件内存来说只有寄存器、缓存内存、主内存的概念, 并没有工作内存和主内存之分，也就是说 Java 内存模型对内存的划分对硬件内存并没有任何影响，因为 JMM 只是一种抽象的概念是一组规则，不管是工作内存的数据还是主内存的数据，对于计算机硬件来说都会存储在计算机主内存中，当然也有可能存储到 CPU 缓存或者寄存器中，因此总体上来说, Java 内存模型和计算机硬件内存架构是一个相互交叉的关系，是-种抽象概念划分与真实物理硬件的交叉。

JMM 内存模型与 CPU 硬件内存架构的关系: 

![JMM和CPU硬件内存架构的关系](10-ComputeScience/Java/Java%20API/多线程/_attachments/多线程（JUC）/JMM和CPU硬件内存架构的关系.jpg)

小结
Java 内存模型是一套规范，描述了 Java 程序中各种变量 (线程共享变量) 的访问规则，以及在 JVM 中将变量存储到内存和从内存中读取变量这样的底层细节，Java 内存模型是对共享数据的可见性、有序性、和原子性的规则和保障。

#### 4.1.2.4 主内存和工作内存之间的交互

**对应如下流程图**

#### ![主内存与工作内存之间具体的交互协议](10-ComputeScience/Java/Java%20API/多线程/_attachments/多线程（JUC）/主内存与工作内存之间具体的交互协议.jpg)

注意：

1. 工作内存想要读取主内存中的变量，过程
   - Read 读共享变量 - Load 加载到工作内存中  -> Use 使用变量 x 的副本值  ->Assign 为共享变量赋值  -> Store 保存该次变更  ->  Write 写回到共享变量中
2. 如果对一个变量执行 lock 操作，将会清空工作内存中此变量的值
3. 对一个变量执行 unlock 操作之前，必须先把此变量同步到主内存中

**小结**
1ock -> read -> load -> use -➢assign -> store -> write -> unlock



## 4.2 Synchronized 保证三大特性

Synchronized 能够保证在同一时刻最多只有一个线程执行该段代码，以达到保证并发安全的效果。

用法

```java
synchronized ( 锁对象 ){
	//受保护资源
}
```

### 4.2.1 保证原子性

举例

原版代码，可能会导致结果小于 5000

```java
public class Test02Atomicity {
    // 1.定义一一个共享变量number
    private static int number = 0;
    // 1+.定义一个锁对象
    private static Object obj = new Object();

    public static void main(String[] args) throws InterruptedException {
        // 2.对number进行1000的++操作，不带synchronized()
        Runnable increment = () -> {
            for (int i = 0; i < 1000; i++) {
                number++;
            }
        };
        
         // 2+.对number进行1000的++操作，带synchronized()，保证其中++为原子操作
        Runnable incrementSyn = () -> {
            for (int i = 0; i < 1000; i++) {
                synchronized(obj){
                    number++;
                }
            }
        };
        
        List<Thread> list = new ArrayList<>();
        // 3.使用5个线程来进行
        for (int i = 0; i < 5; i++) {
            Thread t = new Thread(incrementSyn);
            t.start();
            list.add(t);
        }
    }
}
```

### 4.2.2 保证可见性

举例

原版代码，A 线程 while 读取 falg，B 现成的改动并不会让 A 停止循环

原因：

A 线程实际上读取的是工作内存中的变量副本，在从主内容 read load 后，在工作内存中已经有 true 的副本，反复读取它不会退出循环

```java
public class Test01Visibility {
    //1.创建一个共享变量
    private static boolean flag = true;
    //1+.解决方案1，使用volatile关键字
    private static volatile boolean flag = true;
    //1++.使用synchronized 创建锁对象
    private static Object obj = new Object();

    public static void main (String[] args) throws InterruptedException {
        //2. 创建A线程不断读取共享变量，实际上读取的是工作内存中的变量副本
        new Thread(() -> {
            while(flag) {
            }
        }).start();
        
         //2+. 解决方案2，使用synchronized获取锁对象
        new Thread(() -> {
            while(flag) {
                synchronized(obj){
                    
                }
            }
        }).start();
        
        Thread. sleep( 2000);

        //3.创建B线程修改共享变量
            new Thread(() -> {
                flag = false;
                System. out. println("线程修改了变量的值为false ");
            }).start();
    }
}
```

测试结果：确实停了

备注

1. `volatile` 会保证缓存一致性协议，更改后让所有工作内存中的副本失效，重新从主缓存中获取
2. `synchronized` 相当于主内存到工作内存中的  Lock 和 Unlock 操作，这个过程会让工作内存重新从主缓存中获取



### 4.2.3 保证有序性

#### 4.2.3.1 为什么会重排序？

编译器和 CPU 会重排序代码保证代码的执行效率

#### 4.2.3.2 重排序的前提：as-if-serial

As-if-serial 表示：不管如何重排序，必须保证单线程下程序的结果是正确的

不能重排序的情景（存在数据依赖的情况）：

1. 写后读
2. 写后写
3. 读后写

不存在数据依赖的情况就可以重排序

#### 4.2.3.3 保证有序性

举例

1. 可能的结果 1：线程 1 先执行，ready=false，结果r.r1=1
2. 可能的结果 2：线程 2 先执行，num=2，ready=true，结果r.r1=2+2=4
3. 可能的结果 3：线程 2 先执行，num=2，此时切换到线程 1，ready=false，结果r.r1=1
4. 可能的结果 4：**重排序**，仍然是线程 2 先执行
   - Java 可能会对代码进行优化，认为 ready=true 在先，num=2 在后执行比较快
   - 线程 2 先执行，ready=true，此时切换到线程 1，结果r.r1=0+0=0

```java
public class Test03Ordering {
    //1+.使用synchronized 创建锁对象
    private static Object obj = new Object();
    int num = 0;
    boolean ready = false;
    
    //1.线程1执行的代码
    public void actor1(I_Result r) {
        //1+. 用synchronized包起来
        synchronized(obj){
            if (ready) {
                r.r1 = num+num;
            } else {
                r.r1 = 1;
            }
        }
    }
    //2.线程2执行的代码
    public void actor2(I_Result r) {
        //1+. 用synchronized包起来
        synchronized(obj){
            num=2;
            ready=true;
        }
    }
}
```

测试：

结果一次 0 都没出现，说明解决了重排序的问题

原因：

- 无论先执行哪个线程，都会先获取锁对象，等待执行完毕之后才释放锁对象让其他线程使用共享资源，
- 此时仍然可能发生代码块中的重排序，但是不会影响最终结果的一致性

备注：

`volatile` 关键字，会强制禁止重排序

## 4.3 Synchronized 的自身特性

### 4.3.1 可重入性

一个线程可以多次使用 synchronized，重复获取一把锁

```java
public class Demo01 {
    public static void main(String[] args) {
        new MyThread().start();
        new MyThread().start();
    }
}
// 1.自定义一个线程类
class MyThread extends Thread {
    @Override
    public void run() {
        synchronized (MyThread.class) {
            System.out.println(getName() + "进入了同步代码块1");
            //$!)

### 4.4.1  monitorenter

原文在 jdk6 规范中

翻译过来:
每一个对象都会和一个监视器 monitor 关联。监视器被占用时会被锁住, 其他线程无法来获取该 monitor.
当 JVM 执行某个线程的某个方法内部的 monitorenter 时，它会尝试去获取当前对象对应的 monitor 的所有权。其过程如下:

1. 若 monior 的进入数为 0, 线程可以进入 monitor, 并将 monitor 的进入数置为 1。当前线程成为 monitor 的 owner (所有者)
2. 若线程已拥有 monitor 的所有权, 允许它重入 monitor, 则进入 monitor 的进入数加 1
3. 若其他线程已经占有 monitor 的所有权，那么当前尝试获取 monitor 的所有权的线程会被阻塞, 直到 monitor 的进入数变为 0，才能重新尝试获取 monitor 的所有权。

理解：
- 2 就是可重入性 
- 3 就是不可中断性 (被阻塞后不可中断)
- Monitor 是 JVM 线程执行到获取锁对象时，发现没有 monitor 临时创建的

### 4.4.2  monitorexit

翻译过来:
1. 能执行 monitorexit 指令的线程一定是拥有当前对象的 monitor 的所有权的线程。
2. 执行 monitoreXt 时会将 monitor 的进入数减 1. 当 monitor 的进入数减为 0 时，当前线程退出 monitor, 不再拥有 monitor 的所有权，此时其他被这个 monitor 阻塞的线程可以尝试去获取这个 monitor 的所有权

备注：
- JVM 保证，每个 monitorenter 一定会对应一个 monitorexit

### 4.4.3 异常释放

1. 面试题 synchroznied 出现异常会释放锁吗?
- 答：会释放锁，出现异常的时候会自动释放锁，即 monitorexit

### 4.4.4 synchronized 同步方法

用 synchroznied 关键字标记的方法

可以看到同步方法在反汇编后，会增加 ACC. SYNCHRONIZED 修饰。会隐式调用 monitorenter 和 monitorexit。在执行同步方法前会调用 monitorenter, 在执行完同步方法后会调用 monitorexit.

### 4.4.5 synchroznied 与 Lock 的区别

1. Synchronized 是关键字，而 Lock 是一个接口。
2. Synchronized 会自动释放锁，而 Lock 必须手动释放锁。
3. Synchronized 是不可中断的，Lock 可以中断也可以不中断。
4. 通过 Lock 可以知道线程有没有拿到锁，而 synchronized 不能。
5. Synchronized 能锁住方法和代码块, 而 Lock 只能锁住代码块。
6. Lock 可以使用读锁 (java. Util. Concurrent. Locks. ReentrantReadWriteLock) 提高多线程读效率。
7. Synchronized 是非公平锁，ReentrantLock 可以控制是否是公平锁。

## 4.5 JVM 中的 synchronized

### 4.5.1 monitor 监视器锁

可以看出无论是 synchronized 代码块还是 synchronized 方法，其线程安全的语义实现最终依赖-个叫 monitor 的东西，那么这个神秘的东西是什么呢? 下面让我们来详细介绍下。

在 HotSpot 虚拟机中，monitor 是由 ObjectMonitor 实现的。其源码是用 c++来实现的，位于 HotSpot 虚拟机源码 ObjectMonitor. Hpp 文件中 (src/share/vm/runtime/objectMonitor. Hpp)。
ObjectMonitor 主要数据结构如下:

```c++
objectMonitorO {
    _header			= NULL;
    _count			= 0;
	_waiters		= 0;
	_recursions		= 0; //线程的重入次数
	_object			= NULL; //存储该monitor的对象
	_owner			= NULL; //标识拥有该monitor的线程
	_waitSet		= NULL; //处于wait状态的线程， 会被加入到_WaitSet
	_waitSetLock 	= 0;
	_Responsible	= NULL;
	_succ			= NULL;
	_cxq			= NULL; //多线程竞争锁时的单向列表
	FreeNext		= NULL;
    _EntryList		= NULL; //处于等待锁b1ock状态的线程，会被加入到该列表
	_SpinFreq		= 0;
	_SpinClock		= 0;
	OwnerIsThread 	= 0;
}
```

![monitor和java对象](10-ComputeScience/Java/Java%20API/多线程/_attachments/多线程（JUC）/monitor和java对象.jpg)

1. _object 指向当前锁对象 obj，obj 的对象头中又会记录当前的锁信息
2. _owner 指向当前线程信息
3. _recursions 记录当前重入次数
4. _waitSet 记录拥有当前 mointor，但是又进入等待状态 Wait 的线程
5. _cxq 是一个<u>单向链表</u>  记录尝试获取锁，但是锁已经被其他线程持有了。此时该线程会进入阻塞态，加入该列表
6. _EntryList 是一个链表，当当前持有锁的线程释放线程后，会进入锁竞争状态。
   竞争得到锁的线程成为当前\_owner，竞争失败的线程进入该链表，依然进入阻塞态
7. 当当前线程执行完毕，可能是 EntryList 中的阻塞态线程竞争得到锁，也可能是_waitSet 中的等待态线程得到锁

### 4.5.2 Monitorenter 时的竞争进入


此处省略锁的自旋优化等操作, 统-放在后面 synchronzied 优化中说。
以上代码的具体流程概括如下:

1. 通过 CAS 尝试把 monitor 的 owner 字段设置为当前线程。
2. 如果设置之前的 owner 指向当前线程，说明当前线程再次进入 monitor, 即重入锁. 执行 `recursions ++.记录重入的次数。
3. 如果当前线程是第一次进入该 monitor, 设置 recursions 为 1，设置_owner 为当前线程, 该线程成功获得锁并返回。
4. 如果获取锁失败，则等待锁的释放。

### 4.5.3 Monitorenter 时的竞争失败的阻塞

以上代码的具体流程概括如下:

1. 当前线程被封装成 ObjectWaiter 对象 node, 状态设置成 ObjectWaiter:: TS_ CXQ。
2. 在 for 循环中，通过 CAS 把 node 节点 push 到 _cxq 列表中, 同一时刻可能有多个线程把自己的 node 节点 push 到_cxq 列表中。
3. Node 节点 push 到_cxq 列表之后，通过自旋尝试获取锁，如果还是没有获取到锁，则通过 park 将当前线程挂起，等待被唤醒。
4. 当该线程被唤醒时, 会从挂起的点继续执行，通过 objectMonitor :: TryLock 尝试获取锁。

### 4.5.4 Monitorexit 的释放

当某个持有锁的线程执行完同步代码块时, 会进行锁的释放，给其它线程机会执行同步代码，在 HotSpot 中, 通过退出 monitor 的方式实现锁的释放，并通知被阻塞的线程，具体实现位于 qbjectMonitor 的 exit 方法中。

1. 退出同步代码块时会让\_recursions 减 1, 当\_recursions 的值减为 0 时，说明线程释放了锁。
2. 根据不同的策略 (由 QMode 指定) , 从 cxq 或 EntryList 中获取头节点，通过 objectMonitor :: ExitEpilog 方法唤醒该节点封装的线程，唤醒操作最终由 unpark 完成，实现如下:

### 4.5.5 Monitor 是重量级锁

可以看到 ObjectMonitor 的函数调用中会涉及到 Atomic: cmpxchg_ptr, Atomic: inc_ptr 等内核函数, 执行同步代码块，没有竞争到锁的对象会 park () 被挂起，竞争到锁的线程会 unpark (唤醒。这个时候就会存在操作系统用户态和内核态的转换，这种切换会消耗大量的系统资源。所以 synchronized 是 Java 语言中是一个重量级 (Heavyweight) 的操作。

用户态和和内核态是什么东西呢? 要想了解用户态和内核态还需要先了解一下 Linux 系统的体系架构:

## 4.6 JDK6 对 Synchronized 的优化

### 4.6.1 CAS

**CAS 概述和作用**
CAS 的全称是: Compare And Swap (比较再交换)。是现代 CPU 广泛支持的一种对内存中的共享数据进行操作的一种特殊指令。
CAS 的作用: CAS 可以将比较和交换转换为原子操作，这个原子操作直接由 CPU 保证。CAS 可以保证共享变量赋值时的原子操作。
CAS 操作依赖 3 个值: 内存中的值Y.旧的预估值 X, 要修改的新值 B, 如果旧的预估值 X 等于内存中的值 V, 就将新的值 B 保存到内存中。

**举例：AtomicInteger 的自增操作**
```java
//new对象
AtomicInteger atomicInteger = new AtomicInteger();
//AtomicInteger的自增操作是原子的
atomicInteger.incremrntAndGet();



//AtomicInteger.java类中相关操作
//value存储数值
private volatile int value;
//方法实际调用了Unsafe类
public final int incremrntAndGet(){
	return unsafe.getAndAddInt(this, valueOffset, 1) +1;
}


//Unsafe.class类中相关操作
//var1传入的是对象，实际在获取其中value值
//var2传入的是内存的偏移值，用来获取内存中的最新值
public final int getAndAddInt(Object var1, long var2, int var4){
	//旧的预估值
	int var5;
    //反复取新的预估值
	do {
		var5 = this.getIntVolatile(var1,var2);
	}
    //CAS时要先对比，根据var1,var2找到内存最新值,var5为当前预估值
    //如果预估值与当前值一致，则将最新值var5+var4放入var5
    while(!this.compareAndSwapInt(var1,var2,var5,var5+var4))
    
	return unsafe.getAndAddInt(this, valueOffset, 1) +1;
}

```

执行 `this.compareAndSwapInt(var1,var2,var5,var5+var4)` 时

- 如果预估值和当前值一致，则会更新并返回 true
- 如果预估值和当前值不一致，则不会更新并返回 false
  - 当不一致时，反复 do while 知道执行成功，即自旋操作

### 4.6.2 乐观锁和悲观锁

**悲观锁**：
- 悲观锁从悲观的角度出发:
  - 总是假设最坏的情况，每次去拿数据的时候都认为别人会修改, 所以每次在拿数据的时候都会上锁, 这样别人想拿这个数据就会阻塞。
  - 因此 synchronized 我们也将其称之为悲观锁。JDK 中的 ReentrantLock 也是一种悲观锁。
  - 性能较差!

**乐观锁**
- 乐观锁从乐观的角度出发:
  - 总是假设最好的情况，每次去拿数据的时候都认为别人不会修改，就算改了也没关系，再重试即可。所以不会上锁, 但是在更新的时候会判断一下在此期间别人有没有去修改这个数据，如果没有人修改则更新, 如果有人修改则重试。
  - CAS 这种机制我们也可以将其称之为乐观锁。综合性能较好!

注意
- CAS 获取共享变量时，为了保证该变量的可见性, 需要使用 volatile 修饰。结合 CAS 和 voltile 可以实现无锁并发，适用于竞争不激烈、多核 CPU 的场景下。
  1. 因为没有使用 synchronized, 所以线程不会陷入阻塞, 这是效率提升的因素之一。
  2. 但如果竞争激烈，可以想到重试必然频繁发生，反而效率会受影响。

### 4.6.3 Synchronized 锁升级过程

高效并发是从 JDK 1.5 到 DK 1.6 的一个重要改进，HotSpot 虚拟机开发团队在这个版本上花费了大量的精力去实现各种锁优化技术, 包括
偏向锁 ( Biased Locking )、轻量级锁 ( Lightweight Locking ) 和

如适应性自旋 (Adaptive Spinning)、锁消除 ( Lock Elimination)、锁粗化 ( Lock Coarsening ) 等，这些技术都是为了在线程之间更高效地共享数据，以及解决竞争问题，从而提高程序的执行效率。

**升级过程：**

无锁-》偏向锁--》轻量级锁-》重量级锁

#### 4.6.3.1 Java 对象布局

JVM 中，对象包括对象头、实例数据、对齐填充

![对象的内存布局](对象的内存布局.png)

**对象头**包括：

1. 运行时元数据
   - 哈希值：方法的的引用地址 
   - GC 的分代年龄
   - 锁状态
   - 线程持有哪些锁
   - 偏向线程 ID
   - 偏向时间戳
2. 类型指针
   - 指向类元数据 InstanceKlass，确定该对象所属的类型
3. 如果是数组，还需要记录数组长度

- 当一个线程尝试访问 synchronized 修饰的代码块时，它首先要获得锁，那么这个锁到底存在哪里呢? 是存在锁对象的对象头中的。
- HotSpot 采用 `instanceOopDescarrpyoopDesc` 来描述对象头， `arrayOopDesc` 对象用来描述数组类型的对象头
- `instanceOopDesc` 的定义的在 Hotspot 源码的 `instanceOop.hpp` 文件中，另外, `arrayOopDesc` 的定义对应 `arrayOop.hpp` 。

在这里关注 `instanceOopDesc`

从 `instanceOopDesc` 代码中可以看到 `instanceOopDesc` 继承自 `OopDesc` , `OopDesc` 的定义载 Hotspot 源码中的 `oop.hpp` 文件中。

```c++
class oopDesc {
    friend class VMStructs;
private:
    //通常称作Mark Word
    volatile markOop _mark;
    //union表示二选一
    union _metadata{
        //没有开启指针压缩时 的类型指针
        Klass* _klass;
        //开启指针压缩时 的类型指针
        narrowKlass _compressed_klass;
	}_metadata;
    
	// Fast access to barrier set. Must be initialized.
	static BarrierSet* _bs;
    //省略其他代码
};

```

在普通实例对象中，oopDesc 的定义包含两个成员，分别是 `_mark` 和 `_metadata`

- `_mark` 表示对象标记、属于 markOop 类型，也就是接下来要讲解的 Mark Word, 它记录了对象和锁有关的信息
- `_metadata` 表示类元信息，类元信息存储的是对象指向它的类元数据 (Klass) 的首地址, 其中 `_klass` 表示普通指针、 `_compressed_klass` 表示压缩类指针。
- 对象头由两部分组成，一部分用于存储自身的运行时数据，称之为 Mark Word, 另外一部分是类型指针, 及对象指向它的类元数据的指针。

##### 4.6.3.1.1 MarkWord

在 64 位虚拟机下，Mark Word 是 64bit 太小的，其存储结构如下:

![MarkWord的内容](10-ComputeScience/Java/Java%20API/多线程/_attachments/多线程（JUC）/MarkWord的内容.jpg)

##### 4.6.3.1.2 Klass Pointer

这一部分用于存储对象的类型指针，该指针指向它的类元数据，JVM 通过这个撤针确定对象是哪个类的实例。该指针的位长度为 JVM 的一个字大小，即 32 位的 JVM 为 32 位，64 位的 JVM 为 64 位。
如果应用的对象过多，使用 64 位的指针将浪费大量内存, 统计而言，64 位的 JVM 将会比 32 位的 JVM 多耗费 50%的内存。为了节约内存可以使用选项 `-Xx:+Us eCompr essedoops` 开启指针压缩，其中，oop 即 ordinary object pointer 普通对象指针。开启该选项后，下列指针将压缩至 32 位:
  1. 每个 Class 的属性指针 (即静态变量)
  2. 每个对象的属性指针 (即对象变量)
  3. 普通对象数组的每个元素指针
当然，也不是所有的指针都会压缩，一些特殊类型的指针 JVM 不会优化, 比如指向 PermGen 的 Class 对象指针 (DK8 中指向元空间的 Class 对象指针)、本地变量、堆栈元素、入参、返回值和 NULL 指针等。

对象头= Mark Word +类型指针 (未开启指针压缩的情况下)
在 32 位系统中，Mark Word = 4 bytes, 类型指针= 4bytes, 对象头= 8 bytes = 64 bits;

#### 4.6.3.2 偏向锁

偏向锁是 JDK1.6 中的重要引进，因为 HotSpot 作者经过研究实践发现，在大多数情况下，锁不仅不存在多线程竞争，而且总是由同一线程多次获得，为了让线程获得锁的代价更低，引进了偏向锁。

偏向锁的“偏”，就是偏心的“偏"、偏袒的“偏"，它的意思是这个锁会偏向于第一个获得它的线程，会在对象头存储锁偏向的线程 ID，以后该线程进入和退出同步块时只需要检查是否为偏向锁、锁标志位以及 ThreadID 即可。

偏向锁在 Java 1.6 之后是默认启用的，但在应用程序启动几秒钟之后才激活，可以使用 `-   Xx:BiasedLockingStartupDelay=0` 参数关闭延迟，
如果确定应用程序中所有锁通常情况下处于竞争状态, 可以通过 `-xx:-UseBiasedLocking=false` 参数关闭偏向锁。


**偏向锁的原理**

当线程第一次访问同步块并获取锁时, 偏向锁处理流程如下:
1. 检测 Mark Word 是否为可偏向状态，即是否为偏向锁 1, 锁标识位为 01。
2. 若为可偏向状态，则测试线程 ID 是否为当前线程 ID, 如果是，执行同步代码块，否则执行步骤 (3) 。
3. 如果测试线程 ID 不为当前线程 ID, 则通过 CAS 操作将 Mark Word 的线程 ID 替换为当前线程 ID, 执行同步代码块。

持有偏向锁的线程以后每次进入这个锁相关的同步块时，虚拟机都可以不再进行任何同步操作，偏向锁的效率高。

**偏向锁的撤销**

一旦有第二个线程试图获取偏向锁，偏向锁撤销

1. 偏向锁的撤销动作必须等待全局安全点
2. 暂停拥有偏向锁的线程, 判断锁对象是否处于被锁定状态
3. 撤销偏向锁，恢复到无锁 (标志位为 01) 或轻量级锁 (标志位为 00) 的状态

**偏向锁好处**

偏向锁在只有一个线程执行同步块时进一步提高性能，适用于一个线程反复获得同一锁的情况。偏向锁可以提高带有同步但无竞争的程序性能。

它同样是一个带有效益权衡性质的优化，也就是说，它并不一-定总是对程序运行有利，如果程序中大多数的锁总是被多个不同的线程访问比如线程池，那偏向模式就是多余的。

#### 4.6.3.3 轻量级锁

**什么是轻量级锁**
轻量级锁是 JDK1.6 之中加入的新型锁机制，它名字中的“轻量级”是相对于使用 monitor 的传统锁而言的，因此传统的锁机制就称为“重量级”锁。首先需要强调一点的是，轻量级锁并不是用来代替重量级锁的。

引入轻量级锁的目的: 在多线程交替执行同步块的情况下，尽量避免重量级锁引起的性能消耗，但是如果多个线程在同一时刻进入临界区, 会导致轻量级锁膨胀升级成重量级锁, 所以轻星级锁的出现并非是要替代重量级锁。

**轻量级锁原理**

![轻量级锁](10-ComputeScience/Java/Java%20API/多线程/_attachments/多线程（JUC）/轻量级锁.jpg)

其中，栈帧保存锁对象 MarkWord、锁对象记录当前锁状态、锁对象记录栈帧中记录的地址，全都是 CAS 操作

当关闭偏向锁功能或者多个线程竞争偏向锁导致偏向锁升级为轻量级锁，则会尝试获取轻量级锁, 其步骤如下:
1. 判断当前对象是否处于无锁状态 (hashcode、 0、01)，
  - 如果是，则 VM 首先将在当前线程的栈帧中建立一个名为锁记录 (Lock Record) 的空间，用于存储锁对象目前的 Mark Word 的拷贝 (官方把这份拷贝加了一个 Displaced 前缀，即 Displaced Mark Word)，将对象的 Mark Word 复制到栈帧中的 Lock Record 中，将 Lock Reocrd 中的 owner 指向当前对象。
2. JM 利用 CAS 操作尝试将对象的 Mark Word 更新为指向 Lock Record 的指针，如果成功表示竞争到锁, 则将锁标志位变成 00, 执行同步操作。
3. 如果失败则判断当前对象的 Mark Word 是否指向当前线程的栈帧,
  - 如果是则表示当前线程已经持有当前对象的锁，则直接执行同步代码块;
  - 否则只能说明该锁对象已经被其他线程抢占了，这时轻量级锁需要膨胀为重量级锁，锁标志位变成 10, 后面等待的线程将会进入阻塞状态。

**轻量级锁的释放**

轻量级锁的释放也是通过 CAS 操作来进行的，主要步骤如下:
1. 取出在获取轻量级锁保存在 Displaced Mark Word 中的数据。
2. 用 CAS 操作将取出的数据替换当前对象的 Mark Word 中, 如果成功，则说明释放锁成功。
3. 如果 CAS 操作替换失败，说明有其他线程尝试获取该锁，则需要将轻量级锁需要膨胀升级为重量级锁。
4. 
对于轻量级锁，其性能提升的依据是“对于绝大部分的锁，在整个生命周期内都是不会存在竞争的"，如果打破这个依据则除了互斥的开销外，还有额外的 CAS 操作，因此在有多线程竞争的情况下，轻量级锁比重量级锁更慢。

**轻量级锁好处**
在多线程交替执行同步块的情况下，可以避免重星级锁引起的性能消耗。

**小结**
- 轻量级锁的原理是什么?
  - 将对象的 Mark Word 复制到栈帧中的 Lock Recod 中。Mark Word 更新为指向 Lock Record 的指针。
- 轻量级锁好处是什么?
  - 在多线程交替执行同步块的情况下，可以避免重量级锁引起的性能消耗。



#### 4.6.3.4 自旋锁

**自旋锁原理**

```java
synchronized (Demo01.class) {
    System.out.println(" aa");
}
```

前面我们讨论 monitor 实现锁的时候，知道 monitor 会阻塞和唤醒线程, 线程的阻塞和唤醒需要 CPU 从用户态转为核心态, 频繁的阻塞和唤醒对 CPU 来说是一件负担很重的工作, 这些操作给系统的并发性能带来了很大的压力。
同时，虚拟机的开发团队也注意到在许多应用上, 共享数据的锁定状态只会持续很短的一段时间，为了这段时间阻塞和唤醒线程并不值得。如果物理机器有一个以上的处理器，能让两个或以上的线程同时并行执行，我们就可以让后面请求锁的那个线程"稍等一下”，但不放弃处理器的执行时间, 看看持有锁的线程是否很快就会释放锁。为了让线程等待，我们只需让线程执行一个<u>忙循环 (自旋)</u> , 这项技术就是所谓的自旋锁。

自旋锁在 JDK 1.4.2 中就已经引入，只不过默认是关闭的，可以使用·-XX:+UseSpinning·参数来开启, 在 JDK 6 中就已经改为默认开启了。
自旋等待不能代替阻塞，且先不说对处理器数量的要求，自旋等待本身虽然避免了线程切换的开销，但它是要占用处理器时间的, 因此，如果锁被占用的时间很短，自旋等待的效果就会非常好，反之, 如果锁被占用的时间很长。那么自旋的线程只会白白消耗处理器资源，而不会做任何有用的工作，反而会带来性能上的浪费。因此，自旋等待的时间必须要有一定的限度，如果自旋超过了限定的次数仍然没有成功获得锁，就应当使用传统的方式去挂起线程了。自旋次数的默认值是 10 次，用户可以使用参数·-XX:PreBlockSpin·来更改。

**适应性自旋锁**
在 JDK 6 中引入了自适应的自旋锁。自适应意味着自旋的时间不再固定了, 而是由前一次在同一个锁上的自旋时间及锁的拥有者的状态来决定。
如果在同一个锁对象上，自旋等待刚刚成功获得过锁, 并且持有锁的线程正在运行中，那么虚拟机就会认为这次自旋也很有可能再次成功，进而它将允许自旋等待持续相对更长的时间，比如 100 次循环。另外，如果对于某个锁，自旋很少成功获得过, 那在以后要获取这个锁时将可能省略掉自旋过程, 以避免浪费处理器资源。有了自适应自旋，随着程序运行和性能监控信息的不断完善，虚拟机对程序锁的状况预测就会越来越准确，虚拟机就会变得越来越"聪明”了。

### 4.6.4 锁消除

锁消除是指虚拟机即时编译器 (JIT) 在运行时，对一些代码上要求同步, 但是被检测到不可能存在共享数据竞争的锁进行消除。

锁消除的主要判定依据来源于逃逸分析的数据支持，如果判断在一段代码中，堆上的所有数据都不会逃逸出去从而被其他线程访问到，那就可以把它们当做栈上数据对待，认为它们是线程私有的, 同步加锁自然就无须进行。

变量是否逃逸，对于虚拟机来说需要使用数据流分析来确定，但是程序员自己应该是很清楚的，怎么会在明知道不存在数据争用的情况下要求同步呢?
实际上有许多同步措施并不是程序员自己加入的，同步的代码在 Java 程序中的普遍程度也许超过了大部分读者的想象。

举例

下面这段非常简单的代码仅仅是输出 3 个字符串相加的结果，无论是源码字面上还是程序语义上都没有同步。

```java
public class Demo01 {
    public static void main(String[] args) {
        contactstring("aa", "bb", "cc");
    }
    public static String contactString(String s1, String s2, String s3) {
        return new StringBuffer().append(s1).append(s2).append(s3).toString();
    }
}
```

- 实际上 `new StringBuffer()` 的 `append()` 方法是 `synchronized` 的，此时隐含着加锁操作。
- 但是，实际上这段代码中，new 出来的 StringBuffer () 对象并没有逃逸出代码段！所以实际上锁可以被消除，也确实被消除了

### 4.6.5 锁粗化

原则上, 我们在编写代码的时候，总是推荐将同步块的作用范围限制得尽量小，只在共享数据的实际作用域中才进行同步，这样是为了使得需要同步的操作数量尽可能变小，如果存在锁竞争，那等待锁的线程也能尽快拿到锁。
大部分情况下，上面的原则都是正确的，但是如果一系列的连续操作都对同一个对象反复加锁和解锁，甚至加锁操作是出现在循环体中的，那即使没有线程竞争，频繁地进行互斥同步操作也会导致不必要的性能损耗。

举例

```java
public class Demo01 {
    public static void main(String[] args) {
        StringBuffer sb = new StringBuffer();
        for(int i=1;i<100;i++){
            sb.append("aa");
        }
        System.out.println(sb.toString());
    }
}
```

- 实际上 `new StringBuffer()` 的 `append()` 方法是 `synchronized` 的，此时隐含着加锁操作。
- 但是，在 for 中反复加锁解锁，其实会极大程度影响性能，实际上可以将锁加到 for 外面，即锁粗化
- 实际上 JIT 就是这么干的，这样只需要加一次锁即可

### 4.6.6 代码中我们怎么优化 Synchronized

1. 减少 synchronized 的范围

   - 同步代码块中代码尽量段

2. 降低 synchronized 的粒度

   2.1. 把一个锁拆分成为为多个锁
   - 举例：HashTable 的增删改查全都加了锁，同时锁对象就是 HAshTable 对象，这样就导致同时只能有一个线程在操作，哪怕操作互不影响
   - 解决：ConcurrentHashMap
     - 局部锁定，有多个 segment 分段锁 (JDK7)，只锁定当前分段，当对当前元素锁定时，其他元素不锁定
     - Get 不加锁

   2.2. 尽量不使用类 Class 加锁，可能会锁到完全不相关的业务
   2.3. 队列中使用锁时，入队和出队用不同的锁

3. 读写分离，读取时不加锁，写入和删除时加锁 




# 5 ReentrantLock (马士兵)

https://www.bilibili.com/video/BV1QL4y1u72t

- `ReentrantLock` 是排他锁 (独占锁)
- 可以是公平锁也可以是非公平锁
- 是可重入锁

内部使用了 AQS 实现

## 5.1 AQS

本质是 `AbstractQueuedSynchronizer` 类，

在这个类中，通过维护 state 和双向队列 (CLH 队列) 实现并发控制

AQS 中，存在一个内部类 `Node` ，由于学习的是 ReentrantLock 是独占锁，只留独占锁相关内容

`Node` 就是其中 CLH 队列的一个节点

```java
static final class Node {
    //排他锁标识        
    static final Node EXCLUSIVE = null;

    //失效标识，拥有这个标识说明 当前 节点已经失效
    static final int CANCELLED =  1;
   	//唤醒标识，拥有这个标识说明 后继 节点需要被唤醒
    static final int SIGNAL    = -1;

    //Node对象存储标识的地方
    volatile int waitStatus;

    //双向队列的前驱节点
    volatile Node prev;
    //双向队列的后继节点
    volatile Node next;
    
    //当前Node绑定的线程
    volatile Thread thread;
    
    //$!)

## 5.2 ReentrantLock 中的加锁过程

首先， `ReentrantLock` 的锁是通过其中一个 `Sync sync` 对象实现的，这个变量继承了 `ReentrantLock`

加锁过程

1. Sync. Lock ()  进入
2. 如果 compareAndSetState (0, 1) 成功，说明获取到了锁
   1. SetExclusiveOwnerThread (Thread. CurrentThread ()) 设置当前线程占用锁
3. 如果 compareAndSetState (0, 1) 失败，说明没获取到锁，需要继续尝试获取锁
   1. Acquire (1) 进入
      1. TryAcquire ()
         1. NonfairTryAcquire () 进入
      2. 如果 tryAcquire () 成功，说明我得到了锁
      3. 如果 tryAcquire () 失败，说明我没得到锁
         1. AcquireQueued (addWaiter (Node. EXCLUSIVE), arg)) 将当前线程加入 CLS 等待队列尾部

### 5.2.1 sync 变量的加锁过程

`ReentrantLock` 通过 sync 加锁，可以从 lock () 方法进入

```java
public void lock(){
    //sync分为非公平锁和公平锁
    sync.lock();
}
```

而从 sync 中的 Lock () 构造方法实际上可以发现，有非公平锁 `UnfairSync` 和公平锁 `FairSync` 构造方法，ReentrantLock 是非公平锁，因此只看非公平锁相关部分

注：

- ReentrantLock 是非公平锁
- ReentrantLock 是互斥锁
- ReentrantLock 是可重入锁

### 5.2.1.1 Lock () Sync 类方法

```java
static final class NonfairSync extends Sync {
    private static final long serialVersionUID = 7316153563782823691L;
   
    final void lock() {
        
        //state是ReentrantLock中标识锁状态的变量，0标识未占有，大于1标识已占有 
        //通过CAS将state从0修改到1，如果成功返回true
        //如果新线程要获取当前锁，状态一定是从0到1，如果不是0，说明有线程正在占用
        if (compareAndSetState(0, 1))
            //用来设置当前线程
            setExclusiveOwnerThread(Thread.currentThread());
        else
            //实现加锁的核心功能
            acquire(1);
    }
    
   
    protected final boolean tryAcquire(int acquires) {
        return nonfairTryAcquire(acquires);
    }
}
    
```

### 5.2.1.2 setExclusiveOwnerThread AOS 方法

`setExclusiveOwnerThread(Thread.currentThread());`

属于 AOS 类中下， `public abstract class AbstractOwnableSynchronizer implements java.io.Serializable ` ，这个类是 AQS 的父类

```java
public abstract class AbstractOwnableSynchronizer implements java.io.Serializable  { 
    protected final void setExclusiveOwnerThread(Thread thread) {
        exclusiveOwnerThread = thread;
    }
}
```

### 5.2.1.3 Acquire AQS 类方法

`acquire(1);` AQS `AbstractQueuedSynchronizer` 的方法

```java
public abstract class AbstractQueuedSynchronizer
    extends AbstractOwnableSynchronizer
    implements java.io.Serializable {
    
    public final void acquire(int arg) {
        //tryAcquire就是再次尝试获取锁资源
        if (!tryAcquire(arg) &&
            //如果获取失败了，需要将当前线程封装成一个node，追加到AQS队列中
            acquireQueued(addWaiter(Node.EXCLUSIVE), arg))
            //获取失败，加入node后，当前线程中断
            selfInterrupt();
    }
    
    //AQS是抽象类，需要每个子类锁自己实现这个方法
    protected boolean tryAcquire(int arg) {
        throw new UnsupportedOperationException();
    }
      
    //AQS将新线程加入队列
    private Node addWaiter(Node mode) {
        Node node = new Node(Thread.currentThread(), mode);
        // Try the fast path of enq; backup to full enq on failure
        Node pred = tail;
        if (pred != null) {
            node.prev = pred;
            if (compareAndSetTail(pred, node)) {
                pred.next = node;
                return node;
            }
        }
        enq(node);
        return node;
    }
    

    private Node enq(final Node node) {
        for (;;) {
            //获取当前的尾部
            Node t = tail;
            //队列为空，尝试CAS初始化一个空的头结点
            if (t == null) { // Must initialize
                if (compareAndSetHead(new Node()))
                    tail = head;
            } else {
                //队列不为空，尝试CAS将新节点加入尾部
                node.prev = t;
                if (compareAndSetTail(t, node)) {
                    t.next = node;
                    return t;
                }
            }
        }
    }

    final boolean acquireQueued(final Node node, int arg) {
        boolean failed = true;
        try {
            boolean interrupted = false;
            for (;;) {
                final Node p = node.predecessor();
                if (p == head && tryAcquire(arg)) {
                    setHead(node);
                    p.next = null; // help GC
                    failed = false;
                    return interrupted;
                }
                if (shouldParkAfterFailedAcquire(p, node) &&
                    parkAndCheckInterrupt())
                    interrupted = true;
            }
        } finally {
            if (failed)
                cancelAcquire(node);
        }
    }
    
  
    private static boolean shouldParkAfterFailedAcquire(Node pred, Node node) {
        int ws = pred.waitStatus;
        if (ws == Node.SIGNAL)
            /*
             * This node has already set status asking a release
             * to signal it, so it can safely park.
             */
            return true;
        if (ws > 0) {
            /*
             * Predecessor was cancelled. Skip over predecessors and
             * indicate retry.
             */
            do {
                node.prev = pred = pred.prev;
            } while (pred.waitStatus > 0);
            pred.next = node;
        } else {
            /*
             * waitStatus must be 0 or PROPAGATE.  Indicate that we
             * need a signal, but don't park yet.  Caller will need to
             * retry to make sure it cannot acquire before parking.
             */
            compareAndSetWaitStatus(pred, ws, Node.SIGNAL);
        }
        return false;
    }
    
    
    private void cancelAcquire(Node node) {
        // Ignore if node doesn't exist
        if (node == null)
            return;

        node.thread = null;

        // Skip cancelled predecessors
        Node pred = node.prev;
        while (pred.waitStatus > 0)
            node.prev = pred = pred.prev;

        // predNext is the apparent node to unsplice. CASes below will
        // fail if not, in which case, we lost race vs another cancel
        // or signal, so no further action is necessary.
        Node predNext = pred.next;

        // Can use unconditional write instead of CAS here.
        // After this atomic step, other Nodes can skip past us.
        // Before, we are free of interference from other threads.
        node.waitStatus = Node.CANCELLED;

        // If we are the tail, remove ourselves.
        if (node == tail && compareAndSetTail(node, pred)) {
            compareAndSetNext(pred, predNext, null);
        } else {
            // If successor needs signal, try to set pred's next-link
            // so it will get one. Otherwise wake it up to propagate.
            int ws;
            if (pred != head &&
                ((ws = pred.waitStatus) == Node.SIGNAL ||
                 (ws <= 0 && compareAndSetWaitStatus(pred, ws, Node.SIGNAL))) &&
                pred.thread != null) {
                Node next = node.next;
                if (next != null && next.waitStatus <= 0)
                    compareAndSetNext(pred, predNext, next);
            } else {
                unparkSuccessor(node);
            }

            node.next = node; // help GC
        }
    }
}
```

而对`ReentrantLock`，有非公平锁实现方式，在`ReentrantLock`的内部类`Sync 中`

注：

1. `ReentrantLock`是`Lock`的实现类，实现了`Lock`和`Serializable`

2. `Sync`是`ReentrantLock`的静态内部抽象类

3. `Sync` 是 AQS 的子类， `abstract static class Sync extends AbstractQueuedSynchronizer`

4. `NonfairSync` 同样是 `ReentrantLock` 静态内部类，但是是静态内部 final 类

5. `NonfairSync` 是 `Sync` 的子类

   ```java
   static final class NonfairSync extends Sync {
       private static final long serialVersionUID = 7316153563782823691L;
       
       final void lock() {
           if (compareAndSetState(0, 1))
               setExclusiveOwnerThread(Thread.currentThread());
           else
               acquire(1);
       }
       
       protected final boolean tryAcquire(int acquires) {
           return nonfairTryAcquire(acquires);
       }
   }
   ```

6. 所以最终 acquire 来到了 `NonfairSync` 中的 `tryAcquire` ，这个方法来自 `ReentrantLock` 中的方法 `nonfairTryAcquire`

### 5.2.1.4 tryAcquire Sync 类方法

`ReentrantLock` 内部 `Sync` 的 `tryAcquire` 方法，实际上是 `ReentrantLock` 中的方法 `nonfairTryAcquire`

```java
final boolean nonfairTryAcquire(int acquires) {
    //获取当前线程
    final Thread current = Thread.currentThread();
    //获取AQS的值
    int c = getState();
    //state为0，代表当前没有线程占用该锁资源，本线程开始尝试竞争
    if (c == 0) {
        //CAS修改state，如果成功，设置当前线程占有
        if (compareAndSetState(0, acquires)) {
            setExclusiveOwnerThread(current);
            return true;
        }
    }
    //如果不是0，说明有线程在占用锁，考察当前线程是不是占有资源的
    //当前线程如果就是占用锁的线程，说明是在重入
    else if (current == getExclusiveOwnerThread()) {
        //将state +1
        int nextc = c + acquires;
        //当nextc超过了int上限，超过了最大锁数量
        if (nextc < 0) // overflow
            throw new Error("Maximum lock count exceeded");
        //当前状态修改为state+1
        setState(nextc);
        //锁重入成功
        return true;
    }
    //锁被人占用了，重入还失败，说明获取锁失败了
    return false;
}
```

### 5.2.1.5 addWaiter () 和 Enq () AQS 类方法

//如果获取失败了，需要将当前线程封装成一个 node，追加到 AQS 队列中，以独占锁形式

` acquireQueued(addWaiter(Node.EXCLUSIVE), arg))`

```java
//说明前面获取锁资源失败，需要加入AQS队列等待
private Node addWaiter(Node mode) {

    //AQS内部类，等待队列的节点
    //mode为Node.EXCLUSIVE，即独占锁
    Node node = new Node(Thread.currentThread(), mode);
    // Try the fast path of enq; backup to full enq on failure
    //当前队列的尾部
    Node pred = tail;
    //队列尾部为空，就是队列为空；队列不为空，说明有线程在排队
    if (pred != null) {
        //新节点的前驱为队列的尾部
        node.prev = pred;
        
        //CAS将尾部节点换成新节点
        if (compareAndSetTail(pred, node)) {
            pred.next = node;
            return node;
        }
    }
    enq(node);
    return node;
}


//走到这里说明，之前队列为空  或者  CAS失败
//自旋，直到我成功将新节点加入尾部
private Node enq(final Node node) {
    for (;;) {
        //获取当前的尾部
        Node t = tail;
        //队列为空，尝试CAS初始化一个空的头结点
        if (t == null) { // Must initialize
            if (compareAndSetHead(new Node()))
                tail = head;
        } else {
            //队列不为空，尝试CAS将新节点加入尾部
            node.prev = t;
            if (compareAndSetTail(t, node)) {
                t.next = node;
                return t;
            }
        }
    }
}
```



### 5.2.1.6 acquireQueued () AQS 类方法

执行完成` addWaiter ()`后，会将当前节点 node 加入 AQS 队列尾端，此时返回 node，继续执行 `acquireQueued ()`

```java
//此时新节点node已经加入AQS等待队列尾部
final boolean acquireQueued(final Node node, int arg) {
    //获取锁资源的标识
    boolean failed = true;
    try {
        //设置终端成功的标识
        boolean interrupted = false;
        for (;;) {
            //拿到新节点node的前驱,没有节点则抛出异常
            final Node p = node.predecessor();
            //如果前驱p就是head，说明我在争夺锁的过程失败了，但是在等待队列中争夺到了队列第一名（大家都在CAS争夺队列尾部）
            //于是再次尝试获取锁资源，arg从开始的lock()中的acquire(1)一直传入
            if (p == head && tryAcquire(arg)) {
                //拿到了锁资源，我就是头，前驱置空，返回不中断
                setHead(node);
                p.next = null; // help GC
                failed = false;
                return interrupted;
            }
            
            //如果前面还有其他线程，或者我再次获取锁失败了
            //shouldParkAfterFailedAcquire(p, node) 保证前驱节点状态为-1
            //然后阻塞我自己，等待前面执行完唤醒
            if (shouldParkAfterFailedAcquire(p, node) &&
                //阻塞当前线程，这里是唯一可能抛出异常的地方
                parkAndCheckInterrupt())
                interrupted = true;
        }
    } finally {
        //当走return时，failed一定是false，不执行
        //只有发生异常时，才会取消Acquire
        if (failed)
            cancelAcquire(node);
    }
}
```



### 5.2.1.7 shouldParkAfterFailedAcquire (p, node) AQS 类方法

将前一个线程状态设置为 1，即保证前一个结点为有效节点

如果不这样，有可能在我阻塞后，前面出错而导致我始终不能被唤醒

```java
//来到这个节点，说明有前驱  或者 新节点争夺锁失败了
private static boolean shouldParkAfterFailedAcquire(Node pred, Node node) {
    //获取前驱状态，1为失效，-1正常(需要唤醒下一个)，-2等待，-3共享模式
    int ws = pred.waitStatus;
    //如果Node.SIGNAL，前一个结点正常结束了，一切正常，继续执行
    if (ws == Node.SIGNAL)
            /*
             * This node has already set status asking a release
             * to signal it, so it can safely park.
             */
        return true;
    
    //如果前一个结点出了问题，抛弃前驱，我主动指向前驱的前驱
    //直到找到之前正常结束的节点
    if (ws > 0) {
            /*
             * Predecessor was cancelled. Skip over predecessors and
             * indicate retry.
             */
        do {
            node.prev = pred = pred.prev;
        } while (pred.waitStatus > 0);
        pred.next = node;
    } else {
        //其他情况，直接设置前驱节点状态为-1
            /*
             * waitStatus must be 0 or PROPAGATE.  Indicate that we
             * need a signal, but don't park yet.  Caller will need to
             * retry to make sure it cannot acquire before parking.
             */
        compareAndSetWaitStatus(pred, ws, Node.SIGNAL);
    }
    return false;
}
```



### 5.2.1.8 cancelAcquire () AQS 类方法

当设置完成前一个节点状态为-1 后，可以将当前线程设置为阻塞状态，此时可能会发生异常

此时会调用 `cancelAcquire(node) ` ，取消当前节点的获取过程

```java
private void cancelAcquire(Node node) {
    //当前节点为null，直接退出，健壮性判断
    if (node == null)
        return;
    
    //当前节点的线程置空
    node.thread = null;
    
    //将所有失效前驱(state > 0)都跳过
    Node pred = node.prev;
    while (pred.waitStatus > 0)
        node.prev = pred = pred.prev;
    
    //声明当前第一个非失效节点 的 后继节点，这个后继节点表示第一个有用的节点
    Node predNext = pred.next;
    
    //当前节点置为失效节点，
    node.waitStatus = Node.CANCELLED;

    //如果当前节点是尾节点，将尾节点设置为 当前第一个非失效节点 的 后继节点
    if (node == tail && compareAndSetTail(node, pred)) {
        compareAndSetNext(pred, predNext, null);
    } else {
        //如果当前节点不是尾节点，是中间节点的操作
        int ws;
        //如果上一个节点不是头结点
        if (pred != head &&
            //获取上一个节点状态，要求是-1正常(需要唤醒下一个)
            ((ws = pred.waitStatus) == Node.SIGNAL ||
             //或者非正常但是我曾成功设置成了-1正常
             (ws <= 0 && compareAndSetWaitStatus(pred, ws, Node.SIGNAL))) &&
            pred.thread != null) {
            //将当前节点的后继替换成为第一个非失效节 点 的后继节点
            Node next = node.next;
            if (next != null && next.waitStatus <= 0)
                compareAndSetNext(pred, predNext, next);
        } else {
            unparkSuccessor(node);
        }
        node.next = node; // help GC
    }
}
```

