---
title: SpringBoot 整合业务功能
author: cupid5trick
created: 2022-07-18 11:51
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

- [Spring开发](https://www.liaoxuefeng.com/wiki/1252599548343744/1266263217140032)
- [(155条消息) 创建 SpringBoot 项目的 3 种方式_村雨遥的博客-CSDN博客_创建springboot项目](https://cunyu1943.blog.csdn.net/article/details/119618308?spm=a2c6h.12873639.article-detail.7.68cbaa30OttH1I)
- [(155条消息) SpringBoot (多个yml文件配置、SpringBoot自动配置流程、配置视图的前后缀、资源文件默认路径、application中配置属性如何查找、SpringBoot配置属性)-tiz198183的博客-CSDN博客](https://blog.csdn.net/litao2/article/details/112612433)

# 一、整合 Junit

## 1.1 Spring整合Junit
```java
//加载spring整合junit专用的类运行器
@RunWith(SpringJUnit4ClassRunner.class)
//指定对应的配置信息
@ContextConfiguration(classes = SpringConfig.class)
public class AccountServiceTestCase {
    //注入你要测试的对象
    @Autowired
    private AccountService accountService;
    @Test
    public void testGetById(){
        //执行要测试的对象对应的方法
        System.out.println(accountService.findById(2));
    }
}
```
核心代码是前两个注解，第一个注解 @RunWith 是设置Spring专用于测试的类运行器。
第二个注解 @ContextConfiguration 是用来设置Spring核心配置文件或配置类。

## 1.2 SpringBoot整合Junit
使用SpringBoot整合JUnit需要保障导入test对应的starter。(初始化项目时默认导入的）
```java
@SpringBootTest
class Springboot04JunitApplicationTests {
    //注入你要测试的对象
    @Autowired
    private BookDao bookDao;
    @Test
    void contextLoads() {
        //执行要测试的对象对应的方法
        bookDao.save();
        System.out.println("two...");
    }
}
```
@SpringBootTest替换了前面两个注解,配置都是默认值。

加载的配置类或者配置文件就是前面启动程序使用的引导类。手动指定配置类：
```java
@SpringBootTest(classes = Springboot04JunitApplication.class)

```

```java
@SpringBootTest
@ContextConfiguration(classes = Springboot04JunitApplication.class)
```

# ORM 解决方案
[访问数据库 - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1282383540125729)
常用的 ORM 解决方案或框架有 普通DAO、JPA、Hibernate、Mybatis、MybatisPlus：
[使用DAO](https://www.liaoxuefeng.com/wiki/1252599548343744/1282383605137441)
[集成Hibernate](https://www.liaoxuefeng.com/wiki/1252599548343744/1266263275862720)
[集成JPA](https://www.liaoxuefeng.com/wiki/1252599548343744/1282383789686817)
[集成MyBatis](https://www.liaoxuefeng.com/wiki/1252599548343744/1331313418174498)
也可以自己设计 ORM 框架：
[设计ORM](https://www.liaoxuefeng.com/wiki/1252599548343744/1282383340896289)
可以在 DAO 层增加事务功能：
[使用声明式事务 - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1282383642886177)
## Mybatis

### 2.1 Spring整合Mybatis
* 导入坐标，MyBatis坐标不能少，Spring整合MyBatis还有自己专用的坐标，此外Spring进行数据库操作的jdbc坐标是必须的，剩下还有mysql驱动坐标，本例中使用了Druid数据源，这个倒是可以不要
```xml
<dependencies>
    <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>druid</artifactId>
        <version>1.1.16</version>
    </dependency>
    <dependency>
        <groupId>org.mybatis</groupId>
        <artifactId>mybatis</artifactId>
        <version>3.5.6</version>
    </dependency>
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>5.1.47</version>
    </dependency>
    <!--1.导入mybatis与spring整合的jar包-->
    <dependency>
        <groupId>org.mybatis</groupId>
        <artifactId>mybatis-spring</artifactId>
        <version>1.3.0</version>
    </dependency>
    <!--导入spring操作数据库必选的包-->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-jdbc</artifactId>
        <version>5.2.10.RELEASE</version>
    </dependency>
</dependencies>
```

* Spring核心配置
```java
@Configuration
@ComponentScan("com.itheima")
@PropertySource("jdbc.properties")
public class SpringConfig {
}

```

* MyBatis要交给Spring接管的配置类bean
```java
//定义mybatis专用的配置类
@Configuration
public class MyBatisConfig {
//    定义创建SqlSessionFactory对应的bean
    @Bean
    public SqlSessionFactoryBean sqlSessionFactory(DataSource dataSource){
        //SqlSessionFactoryBean是由mybatis-spring包提供的，专用于整合用的对象
        SqlSessionFactoryBean sfb = new SqlSessionFactoryBean();
        //设置数据源替代原始配置中的environments的配置
        sfb.setDataSource(dataSource);
        //设置类型别名替代原始配置中的typeAliases的配置
        sfb.setTypeAliasesPackage("com.itheima.domain");
        return sfb;
    }
//    定义加载所有的映射配置
    @Bean
    public MapperScannerConfigurer mapperScannerConfigurer(){
        MapperScannerConfigurer msc = new MapperScannerConfigurer();
        msc.setBasePackage("com.itheima.dao");
        return msc;
    }

}
```

* 数据源对应的bean
```java
@Configuration
public class JdbcConfig {
    @Value("${jdbc.driver}")
    private String driver;
    @Value("${jdbc.url}")
    private String url;
    @Value("${jdbc.username}")
    private String userName;
    @Value("${jdbc.password}")
    private String password;

    @Bean("dataSource")
    public DataSource dataSource(){
        DruidDataSource ds = new DruidDataSource();
        ds.setDriverClassName(driver);
        ds.setUrl(url);
        ds.setUsername(userName);
        ds.setPassword(password);
        return ds;
    }
}

```

* 数据库连接信息
```java
jdbc.driver=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/spring_db?useSSL=false
jdbc.username=root
jdbc.password=root
```

### 2.2 SpringBoot整合Mybatis
* 1. 创建模块时勾选要使用的技术，MyBatis，由于要操作数据库，还要勾选对应数据库
![](https://raw.githubusercontent.com/minangong/mng_images/main/images2/20220306002249.png)

或者手工导入对应技术的starter，和对应数据库的坐标
```xml
<dependencies>
    <!--1.导入对应的starter-->
    <dependency>
        <groupId>org.mybatis.spring.boot</groupId>
        <artifactId>mybatis-spring-boot-starter</artifactId>
        <version>2.2.0</version>
    </dependency>

    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <scope>runtime</scope>
    </dependency>
</dependencies>
```

* 2.配置数据源相关信息，没有这个信息你连接哪个数据库都不知道

```yml
#2.配置相关信息  
spring:  
 datasource:  
 driver-class-name: com.mysql.cj.jdbc.Driver  
 url: jdbc:mysql://localhost:3306/ssm_db  
 username: root  
 password: root
```

**实体类**
```java
public class Book {  
 private Integer id;  
 private String type;  
 private String name;  
 private String description;  
}
```


**映射接口（Dao）**
```java
@Mapper  
public interface BookDao {  
 @Select("select * from tbl_book where id = #{id}")  
 public Book getById(Integer id);  
}
```

**测试类**
```java
@SpringBootTest  
class Springboot05MybatisApplicationTests {  
 @Autowired  
 private BookDao bookDao;  
 @Test  
 void contextLoads() {  
 System.out.println(bookDao.getById(1));  
 }  
}
```


1.  MySQL 8.X驱动强制要求设置时区
    -   修改url，添加serverTimezone设定
```
    url: jdbc:mysql://localhost:3306/ssm_db?serverTimezone=UTC 
	# (全球标准时间)
    url: jdbc:mysql://localhost:3306/ssm_db?serverTimezone=Asia/Shanghai

```
   *   修改MySQL数据库配置
2.  驱动类过时，提醒更换为com.mysql.cj.jdbc.Driver


## Mybatis Plus
1. 导入对应的starter
```xml
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-boot-starter</artifactId>
    <version>3.4.3</version>
</dependency>
```
2. 配置数据源相关信息
```yaml
#2.配置相关信息
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/ssm_db
    username: root
    password: root
```

**映射接口（Dao）**
```java
@Mapper  
public interface BookDao extends BaseMapper<Book> {  
}
```

ps: 数据库的表名定义规则是tbl_模块名称，为了能和实体类相对应，需要做一个配置.设置所有表名的通用前缀名.
```yaml
mybatis-plus:
  global-config:
    db-config:
      table-prefix: tbl_		#设置所有表的通用前缀名称为tbl_
```

## Hibernate
[Hibernate. Everything data.](https://hibernate.org/)
[Hibernate ORM 6.1.1.Final User Guide](https://docs.jboss.org/hibernate/orm/6.1/userguide/html_single/Hibernate_User_Guide.html#hql-examples-domain-model)
[集成Hibernate](https://www.liaoxuefeng.com/wiki/1252599548343744/1266263275862720)
# 四、整合Druid
## 4.1 切换数据源
1. 导入坐标
```xml
<dependencies>
    <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>druid</artifactId>
        <version>1.1.16</version>
    </dependency>
</dependencies>
```
2. 修改type配置
```yaml
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/ssm_db?serverTimezone=UTC
    username: root
    password: root
    type: com.alibaba.druid.pool.DruidDataSource

```
## 4.2 SpringBoot整合Druid
1. 导入starter
```xml
<dependencies>
    <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>druid-spring-boot-starter</artifactId>
        <version>1.2.6</version>
    </dependency>
</dependencies>
```

2. 修改配置
```yaml
spring:
  datasource:
    druid:
      driver-class-name: com.mysql.cj.jdbc.Driver
      url: jdbc:mysql://localhost:3306/ssm_db?serverTimezone=UTC
      username: root
      password: root
```



# 五、SSMP案例
[米南宫/BookManager (gitee.com)](https://gitee.com/minan-palace/BookManager)
## 5.1 实体类
```java
import lombok.Data;  
  
@Data  
public class Book {  
    private Integer id;  
    private String type;  
    private String name;  
    private String description;  
}

```

## 5.2 数据层
1. 首先导入依赖
```xml
    <dependency>
        <groupId>com.baomidou</groupId>
        <artifactId>mybatis-plus-boot-starter</artifactId>
        <version>3.4.3</version>
    </dependency>
    <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>druid-spring-boot-starter</artifactId>
        <version>1.2.5</version>
    </dependency>
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <scope>runtime</scope>
    </dependency>
```

2. 数据源连接的数据源配置
```yaml
spring:  
  datasource:  
    druid:  
      driver-class-name: com.mysql.cj.jdbc.Driver  
      url: jdbc:mysql://localhost:3306/mybatisdb?serverTimezone=UTC  
      username: root  
      password: 

```

3. 使用MP的标准通用接口BaseMapper加速开发
```java
@Mapper  
public interface BookDao extends BaseMapper<Book> {  
  
}
```

4. MP技术默认的主键生成策略为雪花算法，生成的主键ID长度较大，和目前的数据库设定规则不相符，需要配置一下使MP使用数据库的主键生成策略
```yaml
mybatis-plus:  
  global-config:  
    db-config:  
      table-prefix: tbl_  
      id-type: auto

```

5. 查看MP运行日志
```yaml
mybatis-plus:
  global-config:
    db-config:
      table-prefix: tbl_
      id-type: auto
  configuration:
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
```


6. 测试Dao
not registered 、not be managered  是没有事务管理（@transactional注解）的原因
```txt
Creating a new SqlSession
SqlSession [org.apache.ibatis.session.defaults.DefaultSqlSession@35f639fa] was not registered for synchronization because synchronization is not active
JDBC Connection [com.mysql.cj.jdbc.ConnectionImpl@3f725306] will not be managed by Spring
==>  Preparing: INSERT INTO tbl_book ( type, name, description ) VALUES ( ?, ?, ? )
==> Parameters: 测试type(String), 测试name(String), 测试description(String)
<==    Updates: 1
Closing non transactional SqlSession [org.apache.ibatis.session.defaults.DefaultSqlSession@35f639fa]
```



## 5.3 数据层--分页功能
MP将分页操作做成了一个开关，用分页功能要把开关开启。这个开关是通过MP的拦截器的形式存在的。
```java
@Configuration
public class MPConfig {
    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor(){
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        interceptor.addInnerInterceptor(new PaginationInnerInterceptor());
        return interceptor;
    }
}

```
上述代码第一行是创建MP的拦截器栈，这个时候拦截器栈中没有具体的拦截器，第二行是初始化了分页拦截器，并添加到拦截器栈中。如果后期开发其他功能，需要添加全新的拦截器，按照第二行的格式继续add进去新的拦截器就可以了。

```java
@Test
void testGetPage(){
    IPage page = new Page(2,5);
    bookDao.selectPage(page, null);
    System.out.println(page.getCurrent());		//当前页码值
    System.out.println(page.getSize());			//每页显示数
    System.out.println(page.getTotal());		//数据总量
    System.out.println(page.getPages());		//总页数
    System.out.println(page.getRecords());		//详细数据
}

```


## 5.4 数据层--条件查询
```java
@Test  
public void selectSBooks(){  
    QueryWrapper<Book> queryWrapper = new QueryWrapper<>();  
    queryWrapper.like("name","Spring");  
    List<Book> books = bookDao.selectList(queryWrapper);  
    System.out.println(books);  
}
```
字段是用字符串格式，写错，编译器没有办法发现，只能将问题抛到运行器通过异常堆栈告诉开发者，不太友好。所以MP功能升级，由QueryWrapper对象升级为LambdaQueryWrapper对象,全面支持Lambda表达式。
```java
@Test  
public void selectSBooks2(){  
    LambdaQueryWrapper<Book> bookLambdaQueryWrapper = new LambdaQueryWrapper<>();  
    bookLambdaQueryWrapper.like(Book::getName,"Spring");  
    List<Book> books = bookDao.selectList(bookLambdaQueryWrapper);  
    System.out.println(books);  
}
```
为了防止将null数据作为条件使用，MP还提供了动态拼装SQL的快捷书写方式
```
bookLambdaQueryWrapper.like(name != null,Book::getName,name);  
```


## 5.5 业务层
在开发的时候是可以根据完成的工作不同划分成不同职能的开发团队的。比如制作数据层的人，可以不知道业务是什么样子，拿到的需求文档要求可能是这样的
```tex
接口：传入用户名与密码字段，查询出对应结果，结果是单条数据  
接口：传入ID字段，查询出对应结果，结果是单条数据  
接口：传入离职字段，查询出对应结果，结果是多条数据
```
但是进行业务功能开发的，拿到的需求文档要求差别就很大
```tex
接口：传入用户名与密码字段，对用户名字段做长度校验，4-15位，对密码字段做长度校验，8到24位，对喵喵喵字段做特殊字符校验，不允许存在空格，查询结果为对象。如果为null，返回BusinessException，封装消息码INFO_LOGON_USERNAME_PASSWORD_ERROR
```
ISO标准化文档


业务层接口：
```java
public interface BookService {
    Boolean save(Book book);
    Boolean update(Book book);
    Boolean delete(Integer id);
    Book getById(Integer id);
    List<Book> getAll();
    IPage<Book> getPage(int currentPage,int pageSize);
}
```
业务层实现类：
```java
public class BookServiceImpl implements BookService {  
    @Autowired  
 public BookDao bookDao;  
    @Override  
 public Boolean save(Book book) {  
        return bookDao.insert(book) > 0;  
    }  
  
    @Override  
 public Boolean update(Book book) {  
        return bookDao.updateById(book) > 0;  
    }  
  
    @Override  
 public Boolean delete(Integer id) {  
        return bookDao.deleteById(id) > 0;  
    }  
  
    @Override  
 public Book getById(Integer id) {  
        return bookDao.selectById(id);  
    }  
  
    @Override  
 public List<Book> getAll() {  
        return bookDao.selectList(null);  
    }  
  
    @Override  
 public IPage<Book> getPage(int currentPage, int pageSize) {  
        IPage<Book> page = new Page<>(currentPage,pageSize);  
        bookDao.selectPage(page,null);  
        return page;  
    }  
  
    @Override  
 public IPage<Book> getPage(int currentPage, int pageSize, Book book) {  
        IPage<Book> page = new Page<>(currentPage,pageSize);  
        LambdaQueryWrapper<Book> bookLambdaQueryWrapper = new LambdaQueryWrapper<>();  
        bookLambdaQueryWrapper.eq(!book.getName().isEmpty(),Book::getName,book.getName());  
        bookLambdaQueryWrapper.eq(!book.getType().isEmpty(),Book::getType,book.getType());  
        bookLambdaQueryWrapper.eq(!book.getDescription().isEmpty(),Book::getDescription,book.getDescription());  
        bookDao.selectPage(page,bookLambdaQueryWrapper);  
        return page;  
    }  
}

```

## 5.6 表现层
### 5.6.1 表现层消息一致性处理
不同的操作可能返回 true/false、数据、或者错误消息等等，前端难处理。必须将所有操作的操作结果数据格式统一起来，需要设计表现层返回结果的模型类，用于后端与前端进行数据格式统一，也称为**前后端数据协议**
```java
public class R {  
    private Boolean flag;  
    private Object data;  
    private String msg;
}
```

### 5.6.2 表现层接口
表现层的开发使用基于Restful的表现层接口开发
```java
@RestController  
@RequestMapping("/books")  
public class BookController {  
    @Autowired  
 public BookService bookService;  
  
    @GetMapping  
 public R getAll(){  
        List<Book> bookList = bookService.getAll();  
        return new R(true,bookList);  
    }  
    @PostMapping  
 public R insertBook(@RequestBody Book book) throws IOException{  
        if (book.getName().equals("123") ) throw new IOException();  
        Boolean flag = bookService.save(book);  
        return new R(flag,flag ? "添加成功" : "添加失败");  
    }  
    @PutMapping  
 public R update(@RequestBody Book book) throws IOException {  
        if (book.getName().equals("123") ) throw new IOException();  
        boolean flag = bookService.update(book);  
        return new R(flag, flag ? "修改成功" : "修改失败");  
    }  
    @DeleteMapping("{id}")  
    public R delete(@PathVariable Integer id){  
        return new R(bookService.delete(id));  
    }  
  
    @GetMapping("{id}")  
    public R getById(@PathVariable Integer id){  
        return new R(true, bookService.getById(id));  
    }  
    @GetMapping("{currentPage}/{pageSize}")  
    public R getPage(@PathVariable Integer currentPage, @PathVariable Integer pageSize,Book book){  
        IPage<Book> page = bookService.getPage(currentPage, pageSize,book);  
        //如果当前页码值大于了总页码值，那么重新执行查询操作，使用最大页码值作为当前页码值  
 if(currentPage > page.getPages()){  
            page = bookService.getPage(currentPage, pageSize,book);  
        }  
        return new R(true,page);  
    }  
  
}

```

### 5.6.3 异常处理
```java
@RestControllerAdvice
public class ProjectExceptionAdvice {
    @ExceptionHandler(Exception.class)
    public R doOtherException(Exception ex){
        //记录日志
        //发送消息给运维
        //发送邮件给开发人员,ex对象发送给开发人员
        ex.printStackTrace();
        return new R(false,null,"系统错误，请稍后再试！");
    }
}
```


## 5.6.4 返回页面
### 1. 直接 controller
默认/static下
```java
@Controller  
@RequestMapping("/book")  
public class pageController {  
    @RequestMapping  
 public String book(){  
        return "pages/books.html";  
    }  
}
```
### 2. MVC 设置
```yaml
spring:  
  mvc:  
    view:  
      prefix: pages/  
      suffix: .html
```

controller:
```java
@Controller  
@RequestMapping("/book")  
public class pageController {  
    @RequestMapping  
 public String book(){  
        return "books";  
    }  
}
```
### 3. thymeleaf
导入依赖
```xml
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-thymeleaf</artifactId>
        </dependency>
```
默认模板目录在/templates
```yaml
spring:  
  thymeleaf:  
    cache: false  # 开发时关闭缓存
	# 默认前后缀
    suffix: .html  
    prefix: classpath:/templates/   # classpath:/static/pages/
	
```
controller
```java
@Controller  
@RequestMapping("/book")  
public class pageController {  
    @RequestMapping  
 public String book(){  
        return "books";  
    }  
}
```

## 5.7 运行
运行启动类后，访问local:8080/pages/books.html
![](https://raw.githubusercontent.com/minangong/mng_images/main/images2/20220309011347.png)

# 集成各种业务功能
[Spring Boot Reference Documentation](https://docs.spring.io/spring-boot/docs/current/reference/html/)
- [IO](https://docs.spring.io/spring-boot/docs/current/reference/html/index.htmlio.html#io) Caching, Quartz Scheduler, REST clients, Sending email, Spring Web Services, and more.
- [Messaging](https://docs.spring.io/spring-boot/docs/current/reference/html/index.htmlmessaging.html#messaging) JMS, AMQP, Apache Kafka, RSocket, WebSocket, and Spring Integration.
- [Web](https://docs.spring.io/spring-boot/docs/current/reference/html/index.htmlweb.html#web) Servlet Web, Reactive Web, GraphQL, Embedded Container Support, Graceful Shutdown, and more.
- [Core Features](https://docs.spring.io/spring-boot/docs/current/reference/html/index.htmlfeatures.html#features) Profiles, Logging, Security, Caching, Spring Integration, Testing, and more.
数据库
-   [1\. SQL Databases](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql)
    -   [1.1. Configure a DataSource](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.datasource)
        -   [1.1.1. Embedded Database Support](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.datasource.embedded)
        -   [1.1.2. Connection to a Production Database](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.datasource.production)
        -   [1.1.3. DataSource Configuration](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.datasource.configuration)
        -   [1.1.4. Supported Connection Pools](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.datasource.connection-pool)
        -   [1.1.5. Connection to a JNDI DataSource](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.datasource.jndi)
    -   [1.2. Using JdbcTemplate](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.jdbc-template)
    -   [1.3. JPA and Spring Data JPA](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.jpa-and-spring-data)
        -   [1.3.1. Entity Classes](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.jpa-and-spring-data.entity-classes)
        -   [1.3.2. Spring Data JPA Repositories](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.jpa-and-spring-data.repositories)
        -   [1.3.3. Spring Data Envers Repositories](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.jpa-and-spring-data.envers-repositories)
        -   [1.3.4. Creating and Dropping JPA Databases](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.jpa-and-spring-data.creating-and-dropping)
        -   [1.3.5. Open EntityManager in View](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.jpa-and-spring-data.open-entity-manager-in-view)
    -   [1.4. Spring Data JDBC](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.jdbc)
    -   [1.5. Using H2’s Web Console](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.h2-web-console)
        -   [1.5.1. Changing the H2 Console’s Path](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.h2-web-console.custom-path)
        -   [1.5.2. Accessing the H2 Console in a Secured Application](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.h2-web-console.spring-security)
    -   [1.6. Using jOOQ](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.jooq)
        -   [1.6.1. Code Generation](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.jooq.codegen)
        -   [1.6.2. Using DSLContext](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.jooq.dslcontext)
        -   [1.6.3. jOOQ SQL Dialect](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.jooq.sqldialect)
        -   [1.6.4. Customizing jOOQ](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.jooq.customizing)
    -   [1.7. Using R2DBC](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.r2dbc)
        -   [1.7.1. Embedded Database Support](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.r2dbc.embedded)
        -   [1.7.2. Using DatabaseClient](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.r2dbc.using-database-client)
        -   [1.7.3. Spring Data R2DBC Repositories](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.sql.r2dbc.repositories)
-   [2\. Working with NoSQL Technologies](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql)
    -   [2.1. Redis](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.redis)
        -   [2.1.1. Connecting to Redis](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.redis.connecting)
    -   [2.2. MongoDB](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.mongodb)
        -   [2.2.1. Connecting to a MongoDB Database](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.mongodb.connecting)
        -   [2.2.2. MongoTemplate](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.mongodb.template)
        -   [2.2.3. Spring Data MongoDB Repositories](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.mongodb.repositories)
        -   [2.2.4. Embedded Mongo](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.mongodb.embedded)
    -   [2.3. Neo4j](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.neo4j)
        -   [2.3.1. Connecting to a Neo4j Database](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.neo4j.connecting)
        -   [2.3.2. Spring Data Neo4j Repositories](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.neo4j.repositories)
    -   [2.4. Solr](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.solr)
        -   [2.4.1. Connecting to Solr](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.solr.connecting)
    -   [2.5. Elasticsearch](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.elasticsearch)
        -   [2.5.1. Connecting to Elasticsearch using REST clients](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.elasticsearch.connecting-using-rest)
            -   [Connecting to Elasticsearch using RestClient](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.elasticsearch.connecting-using-rest.restclient)
            -   [Connecting to Elasticsearch using ReactiveElasticsearchClient](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.elasticsearch.connecting-using-rest.webclient)
        -   [2.5.2. Connecting to Elasticsearch by Using Spring Data](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.elasticsearch.connecting-using-spring-data)
        -   [2.5.3. Spring Data Elasticsearch Repositories](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.elasticsearch.repositories)
    -   [2.6. Cassandra](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.cassandra)
        -   [2.6.1. Connecting to Cassandra](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.cassandra.connecting)
        -   [2.6.2. Spring Data Cassandra Repositories](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.cassandra.repositories)
    -   [2.7. Couchbase](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.couchbase)
        -   [2.7.1. Connecting to Couchbase](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.couchbase.connecting)
        -   [2.7.2. Spring Data Couchbase Repositories](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.couchbase.repositories)
    -   [2.8. LDAP](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.ldap)
        -   [2.8.1. Connecting to an LDAP Server](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.ldap.connecting)
        -   [2.8.2. Spring Data LDAP Repositories](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.ldap.repositories)
        -   [2.8.3. Embedded In-memory LDAP Server](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.ldap.embedded)
    -   [2.9. InfluxDB](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.influxdb)
        -   [2.9.1. Connecting to InfluxDB](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql#data.nosql.influxdb.connecting)
日志
[4\. Logging](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.logging#features.logging)
-   [4.1. Log Format](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.logging#features.logging.log-format)
-   [4.2. Console Output](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.logging#features.logging.console-output)
    -   [4.2.1. Color-coded Output](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.logging#features.logging.console-output.color-coded)
-   [4.3. File Output](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.logging#features.logging.file-output)
-   [4.4. File Rotation](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.logging#features.logging.file-rotation)
-   [4.5. Log Levels](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.logging#features.logging.log-levels)
-   [4.6. Log Groups](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.logging#features.logging.log-groups)
-   [4.7. Using a Log Shutdown Hook](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.logging#features.logging.shutdown-hook)
-   [4.8. Custom Log Configuration](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.logging#features.logging.custom-log-configuration)
-   [4.9. Logback Extensions](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.logging#features.logging.logback-extensions)
JSON 解析
[6\. JSON](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.logging#features.json)
-   [6.1. Jackson](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.logging#features.json.jackson)
    -   [6.1.1. Custom Serializers and Deserializers](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.logging#features.json.jackson.custom-serializers-and-deserializers)
    -   [6.1.2. Mixins](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.logging#features.json.jackson.mixins)
-   [6.2. Gson](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.logging#features.json.gson)
-   [6.3. JSON-B](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.logging#features.json.json-b)
Web
-   [1\. Servlet Web Applications](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet)
    -   [1.1. The “Spring Web MVC Framework”](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.spring-mvc)
        -   [1.1.1. Spring MVC Auto-configuration](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.spring-mvc.auto-configuration)
        -   [1.1.2. HttpMessageConverters](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.spring-mvc.message-converters)
        -   [1.1.3. MessageCodesResolver](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.spring-mvc.message-codes)
        -   [1.1.4. Static Content](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.spring-mvc.static-content)
        -   [1.1.5. Welcome Page](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.spring-mvc.welcome-page)
        -   [1.1.6. Custom Favicon](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.spring-mvc.favicon)
        -   [1.1.7. Path Matching and Content Negotiation](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.spring-mvc.content-negotiation)
        -   [1.1.8. ConfigurableWebBindingInitializer](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.spring-mvc.binding-initializer)
        -   [1.1.9. Template Engines](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.spring-mvc.template-engines)
        -   [1.1.10. Error Handling](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.spring-mvc.error-handling)
            -   [Custom Error Pages](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.spring-mvc.error-handling.error-pages)
            -   [Mapping Error Pages outside of Spring MVC](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.spring-mvc.error-handling.error-pages-without-spring-mvc)
            -   [Error handling in a war deployment](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.spring-mvc.error-handling.in-a-war-deployment)
        -   [1.1.11. CORS Support](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.spring-mvc.cors)
    -   [1.2. JAX-RS and Jersey](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.jersey)
    -   [1.3. Embedded Servlet Container Support](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.embedded-container)
        -   [1.3.1. Servlets, Filters, and listeners](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.embedded-container.servlets-filters-listeners)
            -   [Registering Servlets, Filters, and Listeners as Spring Beans](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.embedded-container.servlets-filters-listeners.beans)
        -   [1.3.2. Servlet Context Initialization](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.embedded-container.context-initializer)
            -   [Scanning for Servlets, Filters, and listeners](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.embedded-container.context-initializer.scanning)
        -   [1.3.3. The ServletWebServerApplicationContext](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.embedded-container.application-context)
        -   [1.3.4. Customizing Embedded Servlet Containers](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.embedded-container.customizing)
            -   [SameSite Cookies](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.embedded-container.customizing.samesite)
            -   [Programmatic Customization](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.embedded-container.customizing.programmatic)
            -   [Customizing ConfigurableServletWebServerFactory Directly](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.embedded-container.customizing.direct)
        -   [1.3.5. JSP Limitations](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.servlet.embedded-container.jsp-limitations)
-   [2\. Reactive Web Applications](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.reactive)
    -   [2.1. The “Spring WebFlux Framework”](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.reactive.webflux)
        -   [2.1.1. Spring WebFlux Auto-configuration](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.reactive.webflux.auto-configuration)
        -   [2.1.2. HTTP Codecs with HttpMessageReaders and HttpMessageWriters](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.reactive.webflux.httpcodecs)
        -   [2.1.3. Static Content](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.reactive.webflux.static-content)
        -   [2.1.4. Welcome Page](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.reactive.webflux.welcome-page)
        -   [2.1.5. Template Engines](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.reactive.webflux.template-engines)
        -   [2.1.6. Error Handling](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.reactive.webflux.error-handling)
            -   [Custom Error Pages](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.reactive.webflux.error-handling.error-pages)
        -   [2.1.7. Web Filters](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.reactive.webflux.web-filters)
    -   [2.2. Embedded Reactive Server Support](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.reactive.reactive-server)
    -   [2.3. Reactive Server Resources Configuration](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.reactive.reactive-server-resources-configuration)
-   [3\. Graceful Shutdown](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.graceful-shutdown)
-   [4\. Spring Security](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.security)
    -   [4.1. MVC Security](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.security.spring-mvc)
    -   [4.2. WebFlux Security](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.security.spring-webflux)
    -   [4.3. OAuth2](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.security.oauth2)
        -   [4.3.1. Client](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.security.oauth2.client)
            -   [OAuth2 client registration for common providers](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.security.oauth2.client.common-providers)
        -   [4.3.2. Resource Server](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.security.oauth2.server)
        -   [4.3.3. Authorization Server](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.security.oauth2.authorization-server)
    -   [4.4. SAML 2.0](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.security.saml2)
        -   [4.4.1. Relying Party](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.security.saml2.relying-party)
-   [5\. Spring Session](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.spring-session)
-   [6\. Spring for GraphQL](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.graphql)
    -   [6.1. GraphQL Schema](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.graphql.schema)
    -   [6.2. GraphQL RuntimeWiring](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.graphql.runtimewiring)
    -   [6.3. Querydsl and QueryByExample Repositories support](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.graphql.data-query)
    -   [6.4. Transports](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.graphql.transports)
        -   [6.4.1. HTTP and WebSocket](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.graphql.transports.http-websocket)
        -   [6.4.2. RSocket](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.graphql.transports.rsocket)
    -   [6.5. Exceptions Handling](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.graphql.exception-handling)
    -   [6.6. GraphiQL and Schema printer](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.graphql.graphiql)
-   [7\. Spring HATEOAS](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.security#web.spring-hateoas)
Spring 系列：
技术方面：
- [使用Spring MVC](https://www.liaoxuefeng.com/wiki/1252599548343744/1282383921807393)

- [使用REST](https://www.liaoxuefeng.com/wiki/1252599548343744/1282384941023266)

- [集成Filter](https://www.liaoxuefeng.com/wiki/1252599548343744/1282384114745378)

- [使用Interceptor](https://www.liaoxuefeng.com/wiki/1252599548343744/1347180610715681)

- [处理CORS](https://www.liaoxuefeng.com/wiki/1252599548343744/1282384360112162)

- [国际化](https://www.liaoxuefeng.com/wiki/1252599548343744/1282384236380194)

- [异步处理](https://www.liaoxuefeng.com/wiki/1252599548343744/1282384506912802)
- [使用WebSocket](https://www.liaoxuefeng.com/wiki/1252599548343744/1282384966189089)
- 功能方面：
- [集成JavaMail](https://www.liaoxuefeng.com/wiki/1252599548343744/1282385704386594)
- [集成JMS](https://www.liaoxuefeng.com/wiki/1252599548343744/1304266721460258)
- [使用Scheduler](https://www.liaoxuefeng.com/wiki/1252599548343744/1282385878450210)
- [集成JMX](https://www.liaoxuefeng.com/wiki/1252599548343744/1282385687609378)

SpringBoot 系列：
[集成Open API](https://www.liaoxuefeng.com/wiki/1252599548343744/1283318525984802)
[访问Redis](https://www.liaoxuefeng.com/wiki/1252599548343744/1282386499207201)
[集成Artemis](https://www.liaoxuefeng.com/wiki/1252599548343744/1282388602650658)
[集成RabbitMQ](https://www.liaoxuefeng.com/wiki/1252599548343744/1282385960239138)
[集成Kafka](https://www.liaoxuefeng.com/wiki/1252599548343744/1282388443267106)

Spring Cloud
- [Spring Cloud开发](https://www.liaoxuefeng.com/wiki/1252599548343744/1266263401691296)
- [项目架构设计](https://www.liaoxuefeng.com/wiki/1252599548343744/1492032577077281)
- [搭建项目框架](https://www.liaoxuefeng.com/wiki/1252599548343744/1490560363790369)
- [设计交易引擎](https://www.liaoxuefeng.com/wiki/1252599548343744/1491662232616993)
	- [设计资产系统](https://www.liaoxuefeng.com/wiki/1252599548343744/1491808051789856)
	- [设计订单系统](https://www.liaoxuefeng.com/wiki/1252599548343744/1491808154550304)
	- [设计撮合引擎](https://www.liaoxuefeng.com/wiki/1252599548343744/1491662270365728)
	- [设计清算系统](https://www.liaoxuefeng.com/wiki/1252599548343744/1491808179716128)
	- [完成交易引擎](https://www.liaoxuefeng.com/wiki/1252599548343744/1492754649579557)
- [设计定序系统](https://www.liaoxuefeng.com/wiki/1252599548343744/1491662199062560)
- [设计API系统](https://www.liaoxuefeng.com/wiki/1252599548343744/1493043121225765)
- [设计行情系统](https://www.liaoxuefeng.com/wiki/1252599548343744/1491662255685664)
- [设计推送系统](https://www.liaoxuefeng.com/wiki/1252599548343744/1491662276657184)
- [编写UI](https://www.liaoxuefeng.com/wiki/1252599548343744/1491662245199904)
- [项目总结](https://www.liaoxuefeng.com/wiki/1252599548343744/1493054808653860)

# Swagger/OpenAPI 接口文档
- [Spring Boot 基础教程：使用 Swagger3 生成 API 接口文档-阿里云开发者社区](https://developer.aliyun.com/article/859622)
- [(212条消息) 全新Swagger3.0教程，OAS3快速配置指南，实现API接口文档自动化！_无敌路路帅气的博客-CSDN博客](https://blog.csdn.net/m0_59562547/article/details/118933734): <https://blog.csdn.net/m0_59562547/article/details/118933734>
- [Spring Boot - 自动生成接口文档 - 简书](https://www.jianshu.com/p/4f797a56cc78)
- [OpenAPI Specification - Version 3.0.3 | Swagger](https://swagger.io/specification/)
- [OpenAPI 3 Library for spring-boot](https://springdoc.org/)

# JWT 用户认证与鉴权
[HTTP authentication - HTTP | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication)
**NEW:** get the [JWT Handbook for free](https://auth0.com/resources/ebooks/jwt-handbook) and learn JWTs in depth!

- 耶鲁大学企业级产品，单点登录解决方案 apereo cas: [github.com/apereo/cas](https://github.com/apereo/cas)
- apache shiro: 鉴权 授权 加密和会话管理 [shiro.apache.com](https://shiro.apache.com)
## What is JSON Web Token?

JSON Web Token (JWT) is an open standard ([RFC 7519](https://tools.ietf.org/html/rfc7519)) that defines a compact and self-contained way for securely transmitting information between parties as a JSON object. This information can be verified and trusted because it is digitally signed. JWTs can be signed using a secret (with the **HMAC** algorithm) or a public/private key pair using **RSA** or **ECDSA**.

Although JWTs can be encrypted to also provide secrecy between parties, we will focus on *signed* tokens. Signed tokens can verify the *integrity* of the claims contained within it, while encrypted tokens *hide* those claims from other parties. When tokens are signed using public/private key pairs, the signature also certifies that only the party holding the private key is the one that signed it.

## When should you use JSON Web Tokens?

Here are some scenarios where JSON Web Tokens are useful:

-   **Authorization**: This is the most common scenario for using JWT. Once the user is logged in, each subsequent request will include the JWT, allowing the user to access routes, services, and resources that are permitted with that token. Single Sign On is a feature that widely uses JWT nowadays, because of its small overhead and its ability to be easily used across different domains.
    
-   **Information Exchange**: JSON Web Tokens are a good way of securely transmitting information between parties. Because JWTs can be signed—for example, using public/private key pairs—you can be sure the senders are who they say they are. Additionally, as the signature is calculated using the header and the payload, you can also verify that the content hasn't been tampered with.
    

## What is the JSON Web Token structure?

In its compact form, JSON Web Tokens consist of three parts separated by dots (`.`), which are:

-   Header
-   Payload
-   Signature

Therefore, a JWT typically looks like the following.

`xxxxx.yyyyy.zzzzz`

Let's break down the different parts.

### Header

The header *typically* consists of two parts: the type of the token, which is JWT, and the signing algorithm being used, such as HMAC SHA256 or RSA.

For example:

```
{
  "alg": "HS256",
  "typ": "JWT"
}
```

Then, this JSON is **Base64Url** encoded to form the first part of the JWT.

### Payload

The second part of the token is the payload, which contains the claims. Claims are statements about an entity (typically, the user) and additional data. There are three types of claims: *registered*, *public*, and *private* claims.

-   [**Registered claims**](https://tools.ietf.org/html/rfc7519#section-4.1): These are a set of predefined claims which are not mandatory but recommended, to provide a set of useful, interoperable claims. Some of them are: **iss** (issuer), **exp** (expiration time), **sub** (subject), **aud** (audience), and [others](https://tools.ietf.org/html/rfc7519#section-4.1).
    
    > Notice that the claim names are only three characters long as JWT is meant to be compact.
    
-   [**Public claims**](https://tools.ietf.org/html/rfc7519#section-4.2): These can be defined at will by those using JWTs. But to avoid collisions they should be defined in the [IANA JSON Web Token Registry](https://www.iana.org/assignments/jwt/jwt.xhtml) or be defined as a URI that contains a collision resistant namespace.
    
-   [**Private claims**](https://tools.ietf.org/html/rfc7519#section-4.3): These are the custom claims created to share information between parties that agree on using them and are neither *registered* or *public* claims.
    

An example payload could be:

```
{
  "sub": "1234567890",
  "name": "John Doe",
  "admin": true
}
```

The payload is then **Base64Url** encoded to form the second part of the JSON Web Token.

> Do note that for signed tokens this information, though protected against tampering, is readable by anyone. Do not put secret information in the payload or header elements of a JWT unless it is encrypted.

### Signature

To create the signature part you have to take the encoded header, the encoded payload, a secret, the algorithm specified in the header, and sign that.

For example if you want to use the HMAC SHA256 algorithm, the signature will be created in the following way:

```
HMACSHA256(
  base64UrlEncode(header) + "." +
  base64UrlEncode(payload),
  secret)
```

The signature is used to verify the message wasn't changed along the way, and, in the case of tokens signed with a private key, it can also verify that the sender of the JWT is who it says it is.

### Putting all together

The output is three Base64-URL strings separated by dots that can be easily passed in HTML and HTTP environments, while being more compact when compared to XML-based standards such as SAML.

The following shows a JWT that has the previous header and payload encoded, and it is signed with a secret. ![Encoded JWT](https://cdn.auth0.com/content/jwt/encoded-jwt3.png)

If you want to play with JWT and put these concepts into practice, you can use [jwt.io Debugger](https://jwt.io/#debugger-io) to decode, verify, and generate JWTs.

![JWT.io Debugger](https://cdn.auth0.com/blog/legacy-app-auth/legacy-app-auth-5.png)

## How do JSON Web Tokens work?

In authentication, when the user successfully logs in using their credentials, a JSON Web Token will be returned. Since tokens are credentials, great care must be taken to prevent security issues. In general, you should not keep tokens longer than required.

You also [should not store sensitive session data in browser storage due to lack of security](https://cheatsheetseries.owasp.org/cheatsheets/HTML5_Security_Cheat_Sheet.html#local-storage).

Whenever the user wants to access a protected route or resource, the user agent should send the JWT, typically in the **Authorization** header using the **Bearer** schema. The content of the header should look like the following:

```
Authorization: Bearer <token>
```

This can be, in certain cases, a stateless authorization mechanism. The server's protected routes will check for a valid JWT in the `Authorization` header, and if it's present, the user will be allowed to access protected resources. If the JWT contains the necessary data, the need to query the database for certain operations may be reduced, though this may not always be the case.

Note that if you send JWT tokens through HTTP headers, you should try to prevent them from getting too big. Some servers don't accept more than 8 KB in headers. If you are trying to embed too much information in a JWT token, like by including all the user's permissions, you may need an alternative solution, like [Auth0 Fine-Grained Authorization](https://fga.dev/).

If the token is sent in the `Authorization` header, Cross-Origin Resource Sharing (CORS) won't be an issue as it doesn't use cookies.

The following diagram shows how a JWT is obtained and used to access APIs or resources:

![How does a JSON Web Token work](https://cdn2.auth0.com/docs/media/articles/api-auth/client-credentials-grant.png)

1.  The application or client requests authorization to the authorization server. This is performed through one of the different authorization flows. For example, a typical [OpenID Connect](http://openid.net/connect/) compliant web application will go through the `/oauth/authorize` endpoint using the [authorization code flow](http://openid.net/specs/openid-connect-core-1_0.html#CodeFlowAuth).
2.  When the authorization is granted, the authorization server returns an access token to the application.
3.  The application uses the access token to access a protected resource (like an API).

Do note that with signed tokens, all the information contained within the token is exposed to users or other parties, even though they are unable to change it. This means you should not put secret information within the token.

## Why should we use JSON Web Tokens?

Let's talk about the benefits of **JSON Web Tokens (JWT)** when compared to **Simple Web Tokens (SWT)** and **Security Assertion Markup Language Tokens (SAML)**.

As JSON is less verbose than XML, when it is encoded its size is also smaller, making JWT more compact than SAML. This makes JWT a good choice to be passed in HTML and HTTP environments.

Security-wise, SWT can only be symmetrically signed by a shared secret using the HMAC algorithm. However, JWT and SAML tokens can use a public/private key pair in the form of a X.509 certificate for signing. Signing XML with XML Digital Signature without introducing obscure security holes is very difficult when compared to the simplicity of signing JSON.

JSON parsers are common in most programming languages because they map directly to objects. Conversely, XML doesn't have a natural document-to-object mapping. This makes it easier to work with JWT than SAML assertions.

Regarding usage, JWT is used at Internet scale. This highlights the ease of client-side processing of the JSON Web token on multiple platforms, especially mobile.

![Comparing the length of an encoded JWT and an encoded SAML](https://cdn.auth0.com/content/jwt/comparing-jwt-vs-saml2.png) *Comparison of the length of an encoded JWT and an encoded SAML*

If you want to read more about JSON Web Tokens and even start using them to perform authentication in your own applications, browse to the [JSON Web Token landing page](http://auth0.com/learn/json-web-tokens) at Auth0.

## 其他认证方式
[HTTP authentication - HTTP | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication)
### Basic
[Basic access authentication - Wikipedia](https://en.wikipedia.org/wiki/Basic_access_authentication)
### Digest
[Digest access authentication - Wikipedia](https://en.wikipedia.org/wiki/Digest_access_authentication)

**Basic**

See [RFC 7617](https://datatracker.ietf.org/doc/html/rfc7617), base64-encoded credentials. More information below.

**Bearer**

See [RFC 6750](https://datatracker.ietf.org/doc/html/rfc6750), bearer tokens to access OAuth 2.0-protected resources

**Digest**

See [RFC 7616](https://datatracker.ietf.org/doc/html/rfc7616). Firefox 93 and later support the SHA-256 algorithm. Previous versions only support MD5 hashing (not recommended).

**HOBA**

See [RFC 7486](https://datatracker.ietf.org/doc/html/rfc7486), Section 3, **H**TTP **O**rigin-**B**ound **A**uthentication, digital-signature-based

**Mutual**

See [RFC 8120](https://datatracker.ietf.org/doc/html/rfc8120)

**Negotiate** / **NTLM**

See [RFC4599](https://www.ietf.org/rfc/rfc4559.txt)

**VAPID**

See [RFC 8292](https://datatracker.ietf.org/doc/html/rfc8292)

**SCRAM**

See [RFC 7804](https://datatracker.ietf.org/doc/html/rfc7804)

**AWS4-HMAC-SHA256**

See [AWS docs](https://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-auth-using-authorization-header.html). This scheme is used for AWS3 server authentication.

Schemes can differ in security strength and in their availability in client or server software.

The "Basic" authentication scheme offers very poor security, but is widely supported and easy to set up. It is introduced in more detail below.

## Spring Security 应用
在 springboot 使用 swagger 添加权限接口：
[如何在Swagger2或Swagger3中增加Json Web Token_码农小胖哥的技术博客_51CTO博客](https://blog.51cto.com/u_14558366/5177419): <https://blog.51cto.com/u_14558366/5177419>

- [Spring Security 解析(一) —— 授权过程 - 掘金](https://juejin.cn/post/6844903919773040653)
- [Spring Security 解析(二) —— 认证过程 - 掘金](https://juejin.cn/post/6844903922167971853)
- [Spring Security 解析(三) —— 个性化认证 以及 RememberMe 实现 - 掘金](https://juejin.cn/post/6844903926710419469)
- [Spring Security 解析(四) ——短信登录开发 - 掘金](https://juejin.cn/post/6844903933215784968)
- [Spring Security 解析(五) —— Spring Security Oauth2 开发 - 掘金](https://juejin.cn/post/6844903942543900679)
- [Spring Security 解析(六) —— 基于JWT的单点登陆(SSO)开发及原理解析 - 掘金](https://juejin.cn/post/6844903942820888590)

## JWT 软件测试

[WSTG - Latest | OWASP Foundation](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/06-Session_Management_Testing/10-Testing_JSON_Web_Tokens)

# WebSocket
[WebSocket协议：5分钟从入门到精通 - 程序猿小卡 - 博客园](https://www.cnblogs.com/chyingp/p/websocket-deep-in.html)
[JSR 356, Java API for WebSocket](https://www.oracle.com/technical-resources/articles/java/jsr356.html)
[javax.websocket (Java(TM) EE 8 Specification APIs)](https://javaee.github.io/javaee-spec/javadocs/javax/websocket/package-summary.html)
[javax.websocket.server (Java(TM) EE 8 Specification APIs)](https://javaee.github.io/javaee-spec/javadocs/javax/websocket/server/package-summary.html)

[【WebSocket】断连问题排查](https://blog.csdn.net/shsugar/article/details/121487090)

[WebSocket 经常断开原因，解决办法：心跳机制防止自动断开连接。](https://blog.csdn.net/cai4561/article/details/106809244)

WebSocket 用户认证
使用 Spring Interceptor 的方式：
[java - Websocket Authentication and Authorization in Spring - Stack Overflow](https://stackoverflow.com/questions/45405332/websocket-authentication-and-authorization-in-spring)
使用 Servlet Filter 的方式：
[security - How to secure a WebSocket endpoint in Java EE? - Stack Overflow](https://stackoverflow.com/questions/42644779/how-to-secure-a-websocket-endpoint-in-java-ee)
在 Spring 项目中使用令牌对访问 WebSocket API 的用户做认证（STOMP）
[WebSocket Token-Based Authentication — Nuvalence](https://nuvalence.io/blog/websocket-token-based-authentication)


[(196条消息) 【SpringBoot框架篇】18.使用Netty加websocket实现在线聊天功能_皓亮君的博客-CSDN博客_springboot客服聊天功能](https://blog.csdn.net/ming19951224/article/details/108555917): <https://blog.csdn.net/ming19951224/article/details/108555917>

[(196条消息) SpringBoot之——内置web容器切换(Jetty、Netty、Tomcat、Undertow）默认:Tomcat_孟浩浩的博客-CSDN博客_spring boot undertow started on port(s)](https://blog.csdn.net/JAVA_MHH/article/details/115417612): <https://blog.csdn.net/JAVA_MHH/article/details/115417612>

[(197条消息) tomcat websocket 并发问题解决（一）_houbin0912的博客-CSDN博客_websocket高并发卡顿](https://blog.csdn.net/houbin0912/article/details/111044764): <https://blog.csdn.net/houbin0912/article/details/111044764>

[(197条消息) tomcat websocket 并发问题解决（二）_houbin0912的博客-CSDN博客_tomcat websocket阻塞](https://blog.csdn.net/houbin0912/article/details/111044955): <https://blog.csdn.net/houbin0912/article/details/111044955>

[(197条消息) tomcat websocket 并发问题解决（三）_houbin0912的博客-CSDN博客](https://blog.csdn.net/houbin0912/article/details/111045128): <https://blog.csdn.net/houbin0912/article/details/111045128>

[(197条消息) tomcat websocket 并发问题解决（四）_houbin0912的博客-CSDN博客_tomcat websocket阻塞](https://blog.csdn.net/houbin0912/article/details/111045245): <https://blog.csdn.net/houbin0912/article/details/111045245>

[(197条消息) websocket error code 错误码说明 （CloseEvent事件说明）_houbin0912的博客-CSDN博客](https://blog.csdn.net/houbin0912/article/details/110879747): <https://blog.csdn.net/houbin0912/article/details/110879747>

[(197条消息) log4j.properties 详解与配置步骤_houbin0912的博客-CSDN博客](https://blog.csdn.net/houbin0912/article/details/52791144): <https://blog.csdn.net/houbin0912/article/details/52791144>

# Redis
[PubSub Messaging with Spring Data Redis | Baeldung](https://www.baeldung.com/spring-data-redis-pub-sub)
[Overview (Spring Data Redis 2.7.2 API)](https://docs.spring.io/spring-data/redis/docs/current/api/)
[RedisTemplate (Spring Data Redis 2.7.2 API)](https://docs.spring.io/spring-data/redis/docs/current/api/)
  -  [10\. Redis support](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis)
        -  [10.1. Getting Started](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:setup)
        -  [10.2. Redis Requirements](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:requirements)
        -  [10.3. Redis Support High-level View](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:architecture)
        -  [10.4. Connecting to Redis](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:connectors)
            -  [10.4.1. RedisConnection and RedisConnectionFactory](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:connectors:connection)
            -  [10.4.2. Configuring the Lettuce Connector](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:connectors:lettuce)
            -  [10.4.3. Configuring the Jedis Connector](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:connectors:jedis)
            -  [10.4.4. Write to Master, Read from Replica](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:write-to-master-read-from-replica)
        -  [10.5. Redis Sentinel Support](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:sentinel)
        -  [10.6. Working with Objects through RedisTemplate](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:template)
        -  [10.7. String-focused Convenience Classes](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:string)
        -  [10.8. Serializers](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:serializer)
        -  [10.9. Hash mapping](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.hashmappers.root)
            -  [10.9.1. Hash Mappers](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#)
            -  [10.9.2. Jackson2HashMapper](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.hashmappers.jackson2)
        -  [10.10. Redis Messaging (Pub/Sub)](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#pubsub)
            -  [10.10.1. Publishing (Sending Messages)](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:pubsub:publish)
            -  [10.10.2. Subscribing (Receiving Messages)](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:pubsub:subscribe)
                -  [Message Listener Containers](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:pubsub:subscribe:containers)
                -  [The MessageListenerAdapter](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:pubsub:subscribe:adapter)
        -  [10.11. Redis Streams](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.streams)
            -  [10.11.1. Appending](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.streams.send)
            -  [10.11.2. Consuming](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.streams.receive)
                -  [Synchronous reception](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.streams.receive.synchronous)
                -  [Asynchronous reception through Message Listener Containers](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.streams.receive.containers)
                -  [Acknowledge strategies](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.streams.acknowledge)
                -  [ReadOffset strategies](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.streams.receive.readoffset)
                -  [Serialization](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.streams.receive.serialization)
                -  [Object Mapping](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.streams.hashing)
        -  [10.12. Redis Transactions](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#tx)
            -  [10.12.1. @Transactional Support](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#tx.spring)
        -  [10.13. Pipelining](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#pipeline)
        -  [10.14. Redis Scripting](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#scripting)
            -  [10.14.1. Redis Cache](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:support:cache-abstraction)
        -  [10.15. Support Classes](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:support)
    -  [11\. Reactive Redis support](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:reactive)
        -  [11.1. Redis Requirements](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:reactive:requirements)
        -  [11.2. Connecting to Redis by Using a Reactive Driver](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:reactive:connectors)
            -  [11.2.1. Redis Operation Modes](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:reactive:connectors:operation-modes)
            -  [11.2.2. ReactiveRedisConnection and ReactiveRedisConnectionFactory](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:reactive:connectors:connection)
            -  [11.2.3. Configuring a Lettuce Connector](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:reactive:connectors:lettuce)
        -  [11.3. Working with Objects through ReactiveRedisTemplate](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:reactive:template)
        -  [11.4. String-focused Convenience Classes](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:reactive:string)
        -  [11.5. Redis Messaging/PubSub](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:reactive:pubsub)
            -  [11.5.1. Sending/Publishing messages](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:reactive:pubsub:publish)
            -  [11.5.2. Receiving/Subscribing for messages](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:reactive:pubsub:subscribe)
                -  [Message Listener Containers](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:reactive:pubsub:subscribe:containers)
                -  [Subscribing via template API](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:reactive:pubsub:subscribe:template)
        -  [11.6. Reactive Scripting](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis:reactive:scripting)
    -  [12\. Redis Cluster](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#cluster)
        -  [12.1. Enabling Redis Cluster](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#)
        -  [12.2. Working With Redis Cluster Connection](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#cluster.working.with.cluster)
        -  [12.3. Working with RedisTemplate and ClusterOperations](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#cluster.redistemplate)
    -  [13\. Redis Repositories](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories)
        -  [13.1. Usage](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.usage)
        -  [13.2. Object Mapping Fundamentals](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#mapping.fundamentals)
            -  [13.2.1. Object creation](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#mapping.object-creation)
            -  [13.2.2. Property population](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#mapping.property-population)
            -  [13.2.3. General recommendations](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#mapping.general-recommendations)
                -  [Overriding Properties](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#mapping.general-recommendations.override.properties)
            -  [13.2.4. Kotlin support](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#mapping.kotlin)
                -  [Kotlin object creation](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#)
                -  [Property population of Kotlin data classes](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#)
                -  [Kotlin Overriding Properties](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#mapping.kotlin.override.properties)
        -  [13.3. Object-to-Hash Mapping](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.mapping)
            -  [13.3.1. Customizing Type Mapping](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#)
                -  [Configuring Custom Type Mapping](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#)
        -  [13.4. Keyspaces](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.keyspaces)
        -  [13.5. Secondary Indexes](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.indexes)
            -  [13.5.1. Simple Property Index](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.indexes.simple)
            -  [13.5.2. Geospatial Index](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.indexes.geospatial)
        -  [13.6. Query by Example](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#query-by-example)
            -  [13.6.1. Introduction](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#query-by-example.introduction)
            -  [13.6.2. Usage](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#query-by-example.usage)
            -  [13.6.3. Example Matchers](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#query-by-example.matchers)
            -  [13.6.4. Running an Example](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#query-by-example.running)
        -  [13.7. Time To Live](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.expirations)
        -  [13.8. Persisting References](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.references)
        -  [13.9. Persisting Partial Updates](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.partial-updates)
        -  [13.10. Queries and Query Methods](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.queries)
            -  [13.10.1. Sorting Query Method results](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.queries.sort)
        -  [13.11. Redis Repositories Running on a Cluster](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.cluster)
        -  [13.12. CDI Integration](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.cdi-integration)
        -  [13.13. Redis Repositories Anatomy](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.anatomy)
            -  [13.13.1. Insert new](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.anatomy.insert)
            -  [13.13.2. Replace existing](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.anatomy.replace)
            -  [13.13.3. Save Geo Data](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.anatomy.geo)
            -  [13.13.4. Find using simple index](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.anatomy.index)
            -  [13.13.5. Find using Geo Index](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#redis.repositories.anatomy.geo-index)
-   [Appendixes](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#appendixes)

## 发布订阅
[10.10. Redis Messaging (Pub/Sub)](https://docs.spring.io/spring-data/redis/docs/current/reference/html/#redis:reactive#pubsub)
发布消息可以通过RedisConnection 低级 API 或者 RedisTemplate 的 convertAndSend 来完成：
```java
// send message through connection RedisConnection con = ...
byte[] msg = ...
byte[] channel = ...
con.publish(msg, channel); // send message through RedisTemplate
RedisTemplate template = ...
template.convertAndSend("hello!", "world");
```
要注意 Redis中订阅消息是一个阻塞操作。在一个连接上订阅消息之后，连接所在的线程就开始阻塞接收消息。所以一个连接执行了订阅方法之后，只允许进行 `subscribe`、`unsubscribe`、`pSubscribe`、`pUnsubscribe` 这四种操作，如果执行其他操作就会抛出异常。
如果想要取消订阅，只需要在同一个连接上执行 `unsubscribe` 或者 `pUnsubscribe` 即可，只要连接不再订阅任何信道的消息，对应的阻塞线程就会退出。
MessageListenerContainer
要保证订阅消息后能接受到并处理消息，就必须实现 `MessageListener` 回调函数，它是一个接口。`MessageListenerContainer` 专门负责从 Redis 连接中接收消息，并驱动 `MessageListener` 完成接收到特定消息之后的操作。开发者不必对每个监听器单独维护它的连接状态。
`MessageListener`可以另外实现`SubscriptionListener`在订阅/取消订阅确认时接收通知。在同步调用时收听订阅通知可能很有用。

此外，为了最小化应用程序占用空间，`RedisMessageListenerContainer`让多个侦听器共享一个连接和一个线程，即使它们不共享订阅。因此，无论应用程序跟踪多少侦听器或通道，运行时成本在其整个生命周期内都保持不变。此外，容器允许更改运行时配置，以便您可以在应用程序运行时添加或删除侦听器，而无需重新启动。此外，容器使用惰性订阅方法，`RedisConnection`仅在需要时使用。如果所有侦听器都取消订阅，则会自动执行清理，并释放线程。

为了帮助处理消息的异步特性，容器需要一个`java.util.concurrent.Executor`（或 Spring 的`TaskExecutor`）来分派消息。根据负载、侦听器的数量或运行时环境，您应该更改或调整执行器以更好地满足您的需求。特别是在托管环境（例如应用服务器）中，强烈建议选择适当`TaskExecutor`的以利用其运行时。
MessageListenerAdapter
`MessageListenerAdapter` 方便注册消息监听器的一个类，它是 `MessageListener` 接口的实现类之一。通过 `MessageListenerAdapter` 可以把普通的 POJO 对象注册为消息监听器，具体使用方式可以参考 Spring Redis Data 的 JavaDoc：
[MessageListenerAdapter (Spring Data Redis 2.7.2 API)](https://docs.spring.io/spring-data/redis/docs/current/api/)
MessageListenerAdapter 的设计在尽可能的模仿 JMS中的 MessageListenerAdapter。Adapter 通过反射把处理订阅消息的工作委托给 “delegate” 对象，允许委托对象根据不同的消息内容类型执行不同的处理逻辑，而与固定的 Redis API 完全独立。“delegate” 对象可以是 MessageListener 的实现类，也可以是一个普通的 POJO 对象。
注意在设置完 MessageListenerAdapter 的参数以后，一定要调用 `afterPropertiesSet()` 方法。
在把接收到的消息传递给目标监听方法时，默认会使用 RedisSerializer 从封装好的 Message 对象中把消息内容反序列化成相应的消息类型，使用的序列化器默认是 JdkSerializationRedisSerializer，如果不想要自动消息反序列化可以把序列化器设为 null，当然也可以给 MessageListenerAdapter 设置自己需要的序列化器。

下面是 `MessageListener` 的实现类：
![](image-20220806220350153.png)


# AMQP
-   [1\. Preface](https://docs.spring.io/spring-amqp/docs/current/reference/html//#preface)
-   [2\. What’s New](https://docs.spring.io/spring-amqp/docs/current/reference/html//#whats-new)
    -  [2.1. Changes in 2.4 Since 2.3](https://docs.spring.io/spring-amqp/docs/current/reference/html//#changes-in-2-4-since-2-3)
        -  [2.1.1. @RabbitListener Changes](https://docs.spring.io/spring-amqp/docs/current/reference/html//#rabbitlistener-changes)
        -  [2.1.2. RabbitAdmin Changes](https://docs.spring.io/spring-amqp/docs/current/reference/html//#rabbitadmin-changes)
        -  [2.1.3. Remoting Support](https://docs.spring.io/spring-amqp/docs/current/reference/html//#remoting-support)
        -  [2.1.4. Message Converter Changes](https://docs.spring.io/spring-amqp/docs/current/reference/html//#message-converter-changes)
-   [3\. Introduction](https://docs.spring.io/spring-amqp/docs/current/reference/html//#introduction)
    -  [3.1. Quick Tour for the impatient](https://docs.spring.io/spring-amqp/docs/current/reference/html//#quick-tour)
        -  [3.1.1. Introduction](https://docs.spring.io/spring-amqp/docs/current/reference/html//#introduction-2)
            -  [Compatibility](https://docs.spring.io/spring-amqp/docs/current/reference/html//#compatibility)
            -  [Very, Very Quick](https://docs.spring.io/spring-amqp/docs/current/reference/html//#very-very-quick)
            -  [With XML Configuration](https://docs.spring.io/spring-amqp/docs/current/reference/html//#with-xml-configuration)
            -  [With Java Configuration](https://docs.spring.io/spring-amqp/docs/current/reference/html//#with-java-configuration)
            -  [With Spring Boot Auto Configuration and an Async POJO Listener](https://docs.spring.io/spring-amqp/docs/current/reference/html//#with-spring-boot-auto-configuration-and-an-async-pojo-listener)
-   [4\. Reference](https://docs.spring.io/spring-amqp/docs/current/reference/html//#reference)
    -  [4.1. Using Spring AMQP](https://docs.spring.io/spring-amqp/docs/current/reference/html//#amqp)
        -  [4.1.1. AMQP Abstractions](https://docs.spring.io/spring-amqp/docs/current/reference/html//#amqp-abstractions)
            -  [Message](https://docs.spring.io/spring-amqp/docs/current/reference/html//#message)
            -  [Exchange](https://docs.spring.io/spring-amqp/docs/current/reference/html//#exchange)
            -  [Queue](https://docs.spring.io/spring-amqp/docs/current/reference/html//#queue)
            -  [Binding](https://docs.spring.io/spring-amqp/docs/current/reference/html//#binding)
        -  [4.1.2. Connection and Resource Management](https://docs.spring.io/spring-amqp/docs/current/reference/html//#connections)
            -  [Choosing a Connection Factory](https://docs.spring.io/spring-amqp/docs/current/reference/html//#choosing-factory)
            -  [AddressResolver](https://docs.spring.io/spring-amqp/docs/current/reference/html//#addressresolver)
            -  [Naming Connections](https://docs.spring.io/spring-amqp/docs/current/reference/html//#naming-connections)
            -  [Blocked Connections and Resource Constraints](https://docs.spring.io/spring-amqp/docs/current/reference/html//#blocked-connections-and-resource-constraints)
            -  [Configuring the Underlying Client Connection Factory](https://docs.spring.io/spring-amqp/docs/current/reference/html//#connection-factory)
            -  [RabbitConnectionFactoryBean and Configuring SSL](https://docs.spring.io/spring-amqp/docs/current/reference/html//#rabbitconnectionfactorybean-configuring-ssl)
            -  [Connecting to a Cluster](https://docs.spring.io/spring-amqp/docs/current/reference/html//#cluster)
            -  [Routing Connection Factory](https://docs.spring.io/spring-amqp/docs/current/reference/html//#routing-connection-factory)
            -  [Queue Affinity and the LocalizedQueueConnectionFactory](https://docs.spring.io/spring-amqp/docs/current/reference/html//#queue-affinity)
            -  [Publisher Confirms and Returns](https://docs.spring.io/spring-amqp/docs/current/reference/html//#cf-pub-conf-ret)
            -  [Connection and Channel Listeners](https://docs.spring.io/spring-amqp/docs/current/reference/html//#connection-channel-listeners)
            -  [Logging Channel Close Events](https://docs.spring.io/spring-amqp/docs/current/reference/html//#channel-close-logging)
            -  [Runtime Cache Properties](https://docs.spring.io/spring-amqp/docs/current/reference/html//#runtime-cache-properties)
            -  [RabbitMQ Automatic Connection/Topology recovery](https://docs.spring.io/spring-amqp/docs/current/reference/html//#auto-recovery)
        -  [4.1.3. Adding Custom Client Connection Properties](https://docs.spring.io/spring-amqp/docs/current/reference/html//#custom-client-props)
        -  [4.1.4. AmqpTemplate](https://docs.spring.io/spring-amqp/docs/current/reference/html//#amqp-template)
            -  [Adding Retry Capabilities](https://docs.spring.io/spring-amqp/docs/current/reference/html//#template-retry)
            -  [Publishing is Asynchronous — How to Detect Successes and Failures](https://docs.spring.io/spring-amqp/docs/current/reference/html//#publishing-is-async)
            -  [Correlated Publisher Confirms and Returns](https://docs.spring.io/spring-amqp/docs/current/reference/html//#template-confirms)
            -  [Scoped Operations](https://docs.spring.io/spring-amqp/docs/current/reference/html//#scoped-operations)
            -  [Strict Message Ordering in a Multi-Threaded Environment](https://docs.spring.io/spring-amqp/docs/current/reference/html//#multi-strict)
            -  [Messaging Integration](https://docs.spring.io/spring-amqp/docs/current/reference/html//#template-messaging)
            -  [Validated User Id](https://docs.spring.io/spring-amqp/docs/current/reference/html//#template-user-id)
            -  [Using a Separate Connection](https://docs.spring.io/spring-amqp/docs/current/reference/html//#separate-connection)
        -  [4.1.5. Sending Messages](https://docs.spring.io/spring-amqp/docs/current/reference/html//#sending-messages)
            -  [Message Builder API](https://docs.spring.io/spring-amqp/docs/current/reference/html//#message-builder)
            -  [Publisher Returns](https://docs.spring.io/spring-amqp/docs/current/reference/html//#publisher-returns)
            -  [Batching](https://docs.spring.io/spring-amqp/docs/current/reference/html//#template-batching)
        -  [4.1.6. Receiving Messages](https://docs.spring.io/spring-amqp/docs/current/reference/html//#receiving-messages)
            -  [Polling Consumer](https://docs.spring.io/spring-amqp/docs/current/reference/html//#polling-consumer)
            -  [Asynchronous Consumer](https://docs.spring.io/spring-amqp/docs/current/reference/html//#async-consumer)
            -  [Batched Messages](https://docs.spring.io/spring-amqp/docs/current/reference/html//#de-batching)
            -  [Consumer Events](https://docs.spring.io/spring-amqp/docs/current/reference/html//#consumer-events)
            -  [Consumer Tags](https://docs.spring.io/spring-amqp/docs/current/reference/html//#consumerTags)
            -  [Annotation-driven Listener Endpoints](https://docs.spring.io/spring-amqp/docs/current/reference/html//#async-annotation-driven)
            -  [@RabbitListener with Batching](https://docs.spring.io/spring-amqp/docs/current/reference/html//#receiving-batch)
            -  [Using Container Factories](https://docs.spring.io/spring-amqp/docs/current/reference/html//#using-container-factories)
            -  [Asynchronous @RabbitListener Return Types](https://docs.spring.io/spring-amqp/docs/current/reference/html//#async-returns)
            -  [Threading and Asynchronous Consumers](https://docs.spring.io/spring-amqp/docs/current/reference/html//#threading)
            -  [Choosing a Container](https://docs.spring.io/spring-amqp/docs/current/reference/html//#choose-container)
            -  [Detecting Idle Asynchronous Consumers](https://docs.spring.io/spring-amqp/docs/current/reference/html//#idle-containers)
            -  [Monitoring Listener Performance](https://docs.spring.io/spring-amqp/docs/current/reference/html//#micrometer)
        -  [4.1.7. Containers and Broker-Named queues](https://docs.spring.io/spring-amqp/docs/current/reference/html//#containers-and-broker-named-queues)
        -  [4.1.8. Message Converters](https://docs.spring.io/spring-amqp/docs/current/reference/html//#message-converters)
            -  [SimpleMessageConverter](https://docs.spring.io/spring-amqp/docs/current/reference/html//#simple-message-converter)
            -  [SerializerMessageConverter](https://docs.spring.io/spring-amqp/docs/current/reference/html//#serializer-message-converter)
            -  [Jackson2JsonMessageConverter](https://docs.spring.io/spring-amqp/docs/current/reference/html//#json-message-converter)
            -  [MarshallingMessageConverter](https://docs.spring.io/spring-amqp/docs/current/reference/html//#marshallingmessageconverter)
            -  [Jackson2XmlMessageConverter](https://docs.spring.io/spring-amqp/docs/current/reference/html//#jackson2xml)
            -  [ContentTypeDelegatingMessageConverter](https://docs.spring.io/spring-amqp/docs/current/reference/html//#contenttypedelegatingmessageconverter)
            -  [Java Deserialization](https://docs.spring.io/spring-amqp/docs/current/reference/html//#java-deserialization)
            -  [Message Properties Converters](https://docs.spring.io/spring-amqp/docs/current/reference/html//#message-properties-converters)
        -  [4.1.9. Modifying Messages - Compression and More](https://docs.spring.io/spring-amqp/docs/current/reference/html//#post-processing)
        -  [4.1.10. Request/Reply Messaging](https://docs.spring.io/spring-amqp/docs/current/reference/html//#request-reply)
            -  [Reply Timeout](https://docs.spring.io/spring-amqp/docs/current/reference/html//#reply-timeout)
            -  [RabbitMQ Direct reply-to](https://docs.spring.io/spring-amqp/docs/current/reference/html//#direct-reply-to)
            -  [Message Correlation With A Reply Queue](https://docs.spring.io/spring-amqp/docs/current/reference/html//#message-correlation-with-a-reply-queue)
            -  [Reply Listener Container](https://docs.spring.io/spring-amqp/docs/current/reference/html//#reply-listener)
            -  [Async Rabbit Template](https://docs.spring.io/spring-amqp/docs/current/reference/html//#async-template)
            -  [Spring Remoting with AMQP](https://docs.spring.io/spring-amqp/docs/current/reference/html//#remoting)
        -  [4.1.11. Configuring the Broker](https://docs.spring.io/spring-amqp/docs/current/reference/html//#broker-configuration)
            -  [Headers Exchange](https://docs.spring.io/spring-amqp/docs/current/reference/html//#headers-exchange)
            -  [Builder API for Queues and Exchanges](https://docs.spring.io/spring-amqp/docs/current/reference/html//#builder-api)
            -  [Declaring Collections of Exchanges, Queues, and Bindings](https://docs.spring.io/spring-amqp/docs/current/reference/html//#collection-declaration)
            -  [Conditional Declaration](https://docs.spring.io/spring-amqp/docs/current/reference/html//#conditional-declaration)
            -  [A Note On the id and name Attributes](https://docs.spring.io/spring-amqp/docs/current/reference/html//#note-id-name)
            -  [AnonymousQueue](https://docs.spring.io/spring-amqp/docs/current/reference/html//#anonymous-queue)
            -  [Recovering Auto-Delete Declarations](https://docs.spring.io/spring-amqp/docs/current/reference/html//#declarable-recovery)
        -  [4.1.12. Broker Event Listener](https://docs.spring.io/spring-amqp/docs/current/reference/html//#broker-events)
        -  [4.1.13. Delayed Message Exchange](https://docs.spring.io/spring-amqp/docs/current/reference/html//#delayed-message-exchange)
        -  [4.1.14. RabbitMQ REST API](https://docs.spring.io/spring-amqp/docs/current/reference/html//#management-rest-api)
        -  [4.1.15. Exception Handling](https://docs.spring.io/spring-amqp/docs/current/reference/html//#exception-handling)
        -  [4.1.16. Transactions](https://docs.spring.io/spring-amqp/docs/current/reference/html//#transactions)
            -  [Conditional Rollback](https://docs.spring.io/spring-amqp/docs/current/reference/html//#conditional-rollback)
            -  [A note on Rollback of Received Messages](https://docs.spring.io/spring-amqp/docs/current/reference/html//#transaction-rollback)
            -  [Using RabbitTransactionManager](https://docs.spring.io/spring-amqp/docs/current/reference/html//#using-rabbittransactionmanager)
            -  [Transaction Synchronization](https://docs.spring.io/spring-amqp/docs/current/reference/html//#tx-sync)
        -  [4.1.17. Message Listener Container Configuration](https://docs.spring.io/spring-amqp/docs/current/reference/html//#containerAttributes)
        -  [4.1.18. Listener Concurrency](https://docs.spring.io/spring-amqp/docs/current/reference/html//#listener-concurrency)
            -  [SimpleMessageListenerContainer](https://docs.spring.io/spring-amqp/docs/current/reference/html//#simplemessagelistenercontainer)
            -  [Using DirectMessageListenerContainer](https://docs.spring.io/spring-amqp/docs/current/reference/html//#using-directmessagelistenercontainer)
        -  [4.1.19. Exclusive Consumer](https://docs.spring.io/spring-amqp/docs/current/reference/html//#exclusive-consumer)
        -  [4.1.20. Listener Container Queues](https://docs.spring.io/spring-amqp/docs/current/reference/html//#listener-queues)
        -  [4.1.21. Resilience: Recovering from Errors and Broker Failures](https://docs.spring.io/spring-amqp/docs/current/reference/html//#resilience-recovering-from-errors-and-broker-failures)
            -  [Automatic Declaration of Exchanges, Queues, and Bindings](https://docs.spring.io/spring-amqp/docs/current/reference/html//#automatic-declaration)
            -  [Failures in Synchronous Operations and Options for Retry](https://docs.spring.io/spring-amqp/docs/current/reference/html//#retry)
            -  [Retry with Batch Listeners](https://docs.spring.io/spring-amqp/docs/current/reference/html//#batch-retry)
            -  [Message Listeners and the Asynchronous Case](https://docs.spring.io/spring-amqp/docs/current/reference/html//#async-listeners)
            -  [Exception Classification for Spring Retry](https://docs.spring.io/spring-amqp/docs/current/reference/html//#exception-classification-for-spring-retry)
        -  [4.1.22. Multiple Broker (or Cluster) Support](https://docs.spring.io/spring-amqp/docs/current/reference/html//#multi-rabbit)
        -  [4.1.23. Debugging](https://docs.spring.io/spring-amqp/docs/current/reference/html//#debugging)
    -  [4.2. Using the RabbitMQ Stream Plugin](https://docs.spring.io/spring-amqp/docs/current/reference/html//#stream-support)
        -  [4.2.1. Sending Messages](https://docs.spring.io/spring-amqp/docs/current/reference/html//#sending-messages-2)
        -  [4.2.2. Receiving Messages](https://docs.spring.io/spring-amqp/docs/current/reference/html//#receiving-messages-2)
        -  [4.2.3. Examples](https://docs.spring.io/spring-amqp/docs/current/reference/html//#examples)
    -  [4.3. Logging Subsystem AMQP Appenders](https://docs.spring.io/spring-amqp/docs/current/reference/html//#logging)
        -  [4.3.1. Common properties](https://docs.spring.io/spring-amqp/docs/current/reference/html//#common-properties)
        -  [4.3.2. Log4j 2 Appender](https://docs.spring.io/spring-amqp/docs/current/reference/html//#log4j-2-appender)
        -  [4.3.3. Logback Appender](https://docs.spring.io/spring-amqp/docs/current/reference/html//#logback-appender)
        -  [4.3.4. Customizing the Messages](https://docs.spring.io/spring-amqp/docs/current/reference/html//#customizing-the-messages)
        -  [4.3.5. Customizing the Client Properties](https://docs.spring.io/spring-amqp/docs/current/reference/html//#customizing-the-client-properties)
            -  [Simple String Properties](https://docs.spring.io/spring-amqp/docs/current/reference/html//#simple-string-properties)
            -  [Advanced Technique for Logback](https://docs.spring.io/spring-amqp/docs/current/reference/html//#advanced-technique-for-logback)
        -  [4.3.6. Providing a Custom Queue Implementation](https://docs.spring.io/spring-amqp/docs/current/reference/html//#providing-a-custom-queue-implementation)
    -  [4.4. Sample Applications](https://docs.spring.io/spring-amqp/docs/current/reference/html//#sample-apps)
        -  [4.4.1. The “Hello World” Sample](https://docs.spring.io/spring-amqp/docs/current/reference/html//#hello-world-sample)
            -  [Synchronous Example](https://docs.spring.io/spring-amqp/docs/current/reference/html//#hello-world-sync)
            -  [Asynchronous Example](https://docs.spring.io/spring-amqp/docs/current/reference/html//#hello-world-async)
        -  [4.4.2. Stock Trading](https://docs.spring.io/spring-amqp/docs/current/reference/html//#stock-trading)
        -  [4.4.3. Receiving JSON from Non-Spring Applications](https://docs.spring.io/spring-amqp/docs/current/reference/html//#spring-rabbit-json)
    -  [4.5. Testing Support](https://docs.spring.io/spring-amqp/docs/current/reference/html//#testing)
        -  [4.5.1. @SpringRabbitTest](https://docs.spring.io/spring-amqp/docs/current/reference/html//#spring-rabbit-test)
        -  [4.5.2. Mockito `Answer<?>` Implementations](https://docs.spring.io/spring-amqp/docs/current/reference/html//#mockito-answer)
        -  [4.5.3. @RabbitListenerTest and RabbitListenerTestHarness](https://docs.spring.io/spring-amqp/docs/current/reference/html//#test-harness)
        -  [4.5.4. Using TestRabbitTemplate](https://docs.spring.io/spring-amqp/docs/current/reference/html//#test-template)
        -  [4.5.5. JUnit4 @Rules](https://docs.spring.io/spring-amqp/docs/current/reference/html//#junit-rules)
            -  [Using BrokerRunning](https://docs.spring.io/spring-amqp/docs/current/reference/html//#using-brokerrunning)
            -  [Using LongRunningIntegrationTest](https://docs.spring.io/spring-amqp/docs/current/reference/html//#using-longrunningintegrationtest)
        -  [4.5.6. JUnit5 Conditions](https://docs.spring.io/spring-amqp/docs/current/reference/html//#junit5-conditions)
            -  [Using the @RabbitAvailable Annotation](https://docs.spring.io/spring-amqp/docs/current/reference/html//#using-the-rabbitavailable-annotation)
            -  [Using the @LongRunning Annotation](https://docs.spring.io/spring-amqp/docs/current/reference/html//#using-the-longrunning-annotation)
-   [5\. Spring Integration - Reference](https://docs.spring.io/spring-amqp/docs/current/reference/html//#spring-integration-reference)
    -  [5.1. Spring Integration AMQP Support](https://docs.spring.io/spring-amqp/docs/current/reference/html//#spring-integration-amqp)
        -  [5.1.1. Introduction](https://docs.spring.io/spring-amqp/docs/current/reference/html//#spring-integration-amqp-introduction)
        -  [5.1.2. Inbound Channel Adapter](https://docs.spring.io/spring-amqp/docs/current/reference/html//#inbound-channel-adapter)
        -  [5.1.3. Outbound Channel Adapter](https://docs.spring.io/spring-amqp/docs/current/reference/html//#outbound-channel-adapter)
        -  [5.1.4. Inbound Gateway](https://docs.spring.io/spring-amqp/docs/current/reference/html//#inbound-gateway)
        -  [5.1.5. Outbound Gateway](https://docs.spring.io/spring-amqp/docs/current/reference/html//#outbound-gateway)
-   [6\. Other Resources](https://docs.spring.io/spring-amqp/docs/current/reference/html//#resources)
    -  [6.1. Further Reading](https://docs.spring.io/spring-amqp/docs/current/reference/html//#further-reading)
-   [Appendix A: Change History](https://docs.spring.io/spring-amqp/docs/current/reference/html//#change-history)
## MQTT

-   Paho 项目网站：[https://www.eclipse.org/paho](https://www.eclipse.org/paho)
-   MQTT 协议概述：[https://www.jianshu.com/p/73d9c6668dfc](https://www.jianshu.com/p/73d9c6668dfc)
-   Paho Java：[https://eclipse.org/paho/clients/java/](https://eclipse.org/paho/clients/java)
-   GitHub：[https://github.com/eclipse/paho.mqtt.java](https://github.com/eclipse/paho.mqtt.java)
-   Spring 支持：[https://www.jianshu.com/p/6b60858b7d44](https://www.jianshu.com/p/6b60858b7d44)
-   Mosquitto 搭建：[https://www.jianshu.com/p/9e3cb7042a2e](https://www.jianshu.com/p/9e3cb7042a2e)
[How to integrate a mqtt broker into spring boot project - Stack Overflow](https://stackoverflow.com/questions/70502957/how-to-integrate-a-mqtt-broker-into-spring-boot-project)
```xml
<dependency>
	<groupId>org.springframework.integration</groupId>
	<artifactId>spring-integration-stream</artifactId>
</dependency>
<dependency>
	<groupId>org.springframework.integration</groupId>
	<artifactId>spring-integration-mqtt</artifactId>
</dependency>
```

```bash
D:\install\x86_64\Java\maven\apache-maven-3.6.3\bin\mvn archetype:generate -DarchetypeGroupId=pl.codeleak -DarchetypeArtifactId=spring-mvc-quickstart -DarchetypeVersion=5.0.1 -DgroupId=org.cupid5trick -DartifactId=web-backend -Dversion=1.0-SNAPSHOT -DarchetypeRepository=http://kolorobot.github.io/spring-mvc-quickstart-archetype
```

# IP 地址定位

[准确率 99.9% 的离线IP地址定位库](https://mp.weixin.qq.com/s/3O7tFWPG3NLsX0LiUP3ETg): <https://mp.weixin.qq.com/s/3O7tFWPG3NLsX0LiUP3ETg>

https://github.com/zoujingli/ip2region

# 模板引擎
- [使用 thymeleaf 作为 springboot 模板引擎](#3.%20thymeleaf)

- [FreeMarker教程网](http://www.freemarker.net/#4): <http://www.freemarker.net/#4>
