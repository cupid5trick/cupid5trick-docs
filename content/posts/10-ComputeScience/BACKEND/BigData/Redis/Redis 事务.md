---
scope: learn
draft: true
---
[Transactions | Redis](https://redis.io/docs/manual/transactions/)
[(170条消息) Spring Data Redis事务的正确使用姿势_H阿布的博客-CSDN博客_springdataredis 事务](https://blog.csdn.net/hxm_Code/article/details/105119273)

[RedisTemplate 常用API+事务+陷阱+序列化+pipeline+LUA - sw008 - 博客园](https://www.cnblogs.com/sw008/p/11054322.html)
[RedisTemplate先在事务中使用，然后在非事务中使用，导致读操作不能立即读出数据 - Lasipia的个人空间 - OSCHINA - 中文开源技术交流社区](https://my.oschina.net/lasipia/blog/967685)
[由 RedisTemplate 事务 enableTransactionSupport 引发的血案 - 知乎](https://zhuanlan.zhihu.com/p/336828695)
## Redis 事务 API
Redis的事务的命令主要有multi、exec、discard和watch，在RedisTemplate中也是对应的有这几种方法
```Java
  public interface RedisOperations<K, V> {
      ....
    void watch(K key);
	void watch(Collection<K> keys);
	void unwatch();
	void multi();
	void discard();
	List<Object> exec();
      ....
  }
```

然而，它们是不能单独直接被调用的，Spring Data官网有句话说：

> Redis provides support for transactions through the multi, exec, and discard commands. These operations are available on RedisTemplate. However, RedisTemplate is not guaranteed to execute all operations in the transaction with the same connection.

大概意思是直接单独调用的话，RedisTemplate是不会保证这些操作在一个连接内完成：

```Java
//错误示例
public void testRedisTx0() {
	template.multi();
	template.opsForValue().set("hxm", "9999");
	System.out.println(template.opsForValue().get("hxm"));
	List<Object> result = template.exec();//此处抛出异常
	System.out.println(result);
}
//此处会导致一个异常
org.springframework.dao.InvalidDataAccessApiUsageException: No ongoing transaction. Did you forget to call multi?
```

## 通过 RedisTemplate.execute 方法实现事务
[Spring Data Redis - 通过 RedisTemplate 的 execute 方法实现事务](https://docs.spring.io/spring-data/redis/docs/2.1.5.RELEASE/reference/html/#tx)

`RedisTemplate`提供了一种正确的使用方式，那就是`execute(SessionCallback session)`方法：

```java
<T> T execute(SessionCallback<T> session);
```

`SessionCallback`包含了一个回调函数`execute(RedisOperations operations)`，在这个函数里实现以上的操作，就可以保证事务的正常使用。

```java
public void testRedisTx1() {
	List<Object> r = template.execute(new SessionCallback<List<Object>>() {

	@Override
	public List<Object> execute(RedisOperations operations) throws DataAccessException {
		operations.multi();
		operations.opsForValue().set("hxm", "9999");
		                  //此处打印null，因为事务还没真正执行
		System.out.println(operations.opsForValue().get("hxm"));
		return operations.exec();
		}
	});
	
	System.out.println(r);
}
```

我们可以看看这个execute 方法的内部实现机理，可以看到该方法中先把当前建立的连接绑定在当前的线程中，确保之后的`redis`操作可以在一个连接内进行，而`redis`操作过后，会把当前连接在线程中解绑，并且释放这个连接。

```java
public <T> T execute(SessionCallback<T> session) {
	RedisConnectionFactory factory = getRequiredConnectionFactory();
	//绑定连接在当前线程，可实现下面execute方法内的redis操作保持在一个连接内完成
	RedisConnectionUtils.bindConnection(factory, enableTransactionSupport);
	try {
		return session.execute(this);
	} finally {
		RedisConnectionUtils.unbindConnection(factory);//把连接从当前线程中解绑、释放连接
	}
}
```

## 通过 `@Transactional` 注解
[Spring Data Redis - 通过 @Transactional 注解实现事务](https://docs.spring.io/spring-data/redis/docs/2.1.5.RELEASE/reference/html/#tx.spring)

 另一种实现事务的是 `@Transactional` 注解，这种方法是把事务交由给spring事务管理器进行自动管理。使用这种方法之前，跟jdbc事务一样，要先注入事务管理器，如果工程中已经有配置了事务管理器，就可以复用这个事务管理器，不用另外进行配置。
Spring 默认关闭了事务支持。如果要开启事务，每个 redisTemplate 都要通过`setEnableTransactionSupport()` 方法，强制把 `redisConnection` 绑定到当前触发了 `MULTI` 命令的线程上。所有 Redis 写操作都被事务管理，但是其他读操作都将在一个没有绑定任何线程的 `redisConnection` 上执行。由于事务管理的写操作都还未生效，在事务管理的上下文中对事务数据的 Redis 只读操作通常会返回 null。
 另外，需要注意的是，**跟第一种事务操作方法不一样的地方就是RedisTemplate的setEnableTransactionSupport(boolean enableTransactionSupport)方法要set为true**，此处贴出官方的配置框架：

```java
@Configuration
// 1. 设置@EnableTransactionManagement 注解
@EnableTransactionManagement                                 
public class RedisTxContextConfiguration {

  @Bean
  public StringRedisTemplate redisTemplate() {
    StringRedisTemplate template = new StringRedisTemplate(redisConnectionFactory());
    // explicitly enable transaction support
    // 2. 对 redisTemplate 设置开启事务支持
    template.setEnableTransactionSupport(true);//此处必须设置为true，不然没法实现事务管理            
    return template;
  }

  @Bean
  public RedisConnectionFactory redisConnectionFactory() {
    // jedis || Lettuce
  }

  @Bean
  public PlatformTransactionManager transactionManager() throws SQLException {
  // 3. 把一个 PlatformTransactionManager 事务管理器定义为 Bean
  return new DataSourceTransactionManager(dataSource());   
}

  @Bean
  public DataSource dataSource() throws SQLException {
    // ...
  }
}
```

这种方法的使用方法比较简单，就在要使用事务的方法注解@Transactional，这跟jdbc事务使用是一样的，这样就不用手工的执行multi、exec方法了，这些事务控制方法会由spring事务管理器自动完成。实例如下：

```java
@Transactional
public void testRedisTx2() {

	template.opsForValue().set("hxm", "9999");
	System.out.println(template.opsForValue().get("hxm"));//此处打印为null

}
```

然而，这种便利的使用方法有局限性，**就是不支持只读操作**，如果执行 get 之类的操作，将会返回 null，所以使用的时候要多加注意！

# Redis 异常情况
[Redis客户端常见异常分析 - 腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1491173)
### Redis 读出空值
[python - Redis list getting emptied without any reason? - Stack Overflow](https://stackoverflow.com/questions/59691760/redis-list-getting-emptied-without-any-reason)