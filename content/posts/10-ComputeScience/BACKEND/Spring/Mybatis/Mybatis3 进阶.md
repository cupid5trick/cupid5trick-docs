---
scope: learn
draft: true
---

[MyBatis 3 文档](https://mybatis.org/mybatis-3/zh/configuration.html)

# 一、简介
[Mybatis源码主流程分析 - 掘金](https://juejin.cn/post/7143188589164609543)
## 1.mybatis

* MyBatis 是支持定制化 SQL、存储过程以及高级 映射的优秀的持久层框架。 
* MyBatis 避免了几乎所有的 JDBC 代码和手动设 置参数以及获取结果集。
*  MyBatis可以使用简单的XML或注解用于配置和原 始映射，将接口和Java的POJO（Plain Old Java  Objects，普通的Java对象）映射成数据库中的记 录.

## 2.为什么要使用mybatis

* MyBatis是一个**半自动化**的持久化层框架。 

  ![image-20211011001224929](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211011001224929.png)

* JDBC 

  ![image-20211011000630449](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211011000630449.png)

  – SQL夹在Java代码块里，**耦合度高**导致硬编码内伤 

  – 维护不易且实际开发需求中**sql是有变化**，频繁修改的情况多见 

* Hibernate和JPA 

  ![image-20211011001246014](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211011001246014.png)

  – **长难复杂SQL**，对于Hibernate而言处理也不容易 

  – 内部**自动生产**的SQL，不容易做特殊优化。 

  – 基于全映射的**全自动**框架，大量字段的POJO进行**部分映射**时比较**困难**。 导致数据库性能下降。 

* 对开发人员而言，**核心sql**还是需要自己优化,自己**定制**
* **sql和java编码分开**，功能边界清晰，一个专注业务、 一个专注数据。

[Mybatis 注解用法](Mybatis%20注解用法.md)

# 二. mybatis 使用流程

## 1.从 XML 文件中构建 SqlSessionFactory 的实例

​        每个基于 MyBatis 的应用都是以一个 SqlSessionFactory 的实例为核心的。SqlSessionFactory 的实例可以通过 SqlSessionFactoryBuilder 获得。而 SqlSessionFactoryBuilder 则可以从 XML 配置文件或一个预先配置的 Configuration 实例来构建出 SqlSessionFactory 实例。

```java
String resource = "org/mybatis/example/mybatis-config.xml";
InputStream inputStream = Resources.getResourceAsStream(resource);
SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
```



## 2. 从 SqlSessionFactory 中获取 SqlSession

​      SqlSession 提供了在数据库执行 SQL 命令所需的所有方法。你可以通过 SqlSession 实例来直接执行已映射的 SQL 语句。一个 SqlSession对象代表和数据库的一次会话。

​      SqlSession非线程安全，所以不能写在共享的成员变量中，应该每次用时在方法里创建对象。

```java
SqlSession sqlSession = sqlSessionFactory.openSession();

/*
  执行SQL语句 方法1
  只需要编写mapper.xml
  第一个参数 SQL statement 唯一标识符
  但缺少参数类型判断
*/
Employee employee = (Employee) sqlSession.selectOne("com.mng.mybatistest.mapper.EmployeeMapper.getEmployeeById", 1L);
System.out.println(employee);
sqlSession.close();
 /*
   执行SQL语句方法二   接口式编程
   mapper：为接口自动创建的动态代理对象。将接口和xml原本就绑定了
   保证类型安全
*/
EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
Employee employee = mapper.getEmployeeById(1L);
System.out.println(employee);
sqlSession.close();

```

## 代码附录

### Employee实体类

```java
@Data
public class Employee {
    private Long id;
    String lastname;
    String gender;
    String email;
}
```

### mapper接口（DAO层）

```java
@Mapper
public interface EmployeeMapper {
    public Employee getEmployeeById(Long Id);
}
```

### mybatis-config.xml  mybatis全局配置文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
 PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
 "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <!--default：默认情况下用的数据源-->
	<environments default="development">
        <!--数据源配置，id是标识符-->
		<environment id="development">
            <!--使用JDBC事务管理器-->
			<transactionManager type="JDBC" />
            <!-- 数据库连接池 -->
			<dataSource type="POOLED">
				<property name="driver" value="com.mysql.jdbc.Driver" />
				<property name="url" value="jdbc:mysql://localhost:3306/mybatis" />
				<property name="username" value="root" />
				<property name="password" value="123456" />
			</dataSource>
		</environment>
	</environments>
	<!-- 将我们写好的sql映射文件（EmployeeMapper.xml）一定要注册到全局配置文件（mybatis-config.xml）中 -->
	<mappers>
		<mapper resource="EmployeeMapper.xml" />
	</mappers>
</configuration>
```

### SQL映射文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.mng.mybatistest.mapper.EmployeeMapper">
    <resultMap id="ResultMap" type="com.mng.mybatistest.model.Employee">
        <id column="id" jdbcType="BIGINT" property="id"/>
        <result column="last_name" jdbcType="VARCHAR" property="lastname"/>
        <result column="gender" jdbcType="VARCHAR" property="gender"/>
        <result column="email" jdbcType="VARCHAR" property="email"/>
    </resultMap>

    <select id="getEmployeeById" parameterType="Long" resultMap="ResultMap">
        select *
        from tbl_employee
        where id = #{id}
    </select>
</mapper>
```





# 三、程序规范和并发问题

## SqlSessionFactoryBuilder

​        一旦创建了SqlSessionFactory,就不需要了。最佳作用域：方法作用域

## SqlSessionFactory

​        SqlSessionFactory 一旦被创建就应该在应用的运行期间一直存在，最佳作用域是应用作用域。最简单的就是使用单例模式或者静态单例模式。

## SqlSession

​       不是线程安全的，因此是不能被共享的，所以它的最佳的作用域是请求或方法作用域。不能作为类的对象

​       为了确保每次都能执行关闭操作，你应该把这个关闭操作放到 finally 块中。 下面的示例就是一个确保 SqlSession 关闭的标准模式：

```java
try (SqlSession session = sqlSessionFactory.openSession()) {
  // 你的应用逻辑代码
}finally{
    session.close();
}
```

## 映射器实例（mapper）

最大的作用域应该和SqlSession相同，方法作用域才是映射器实例的最合适的作用域。不需要显式关闭。

```
try (SqlSession session = sqlSessionFactory.openSession()) {
  BlogMapper mapper = session.getMapper(BlogMapper.class);
  // 你的应用逻辑代码
}finally{
    session.close();
}
```

# 四、全局配置对象 Configuration
## Configuration 加载过程
[Mybatis源码解析(二) —— 加载 Configuration - 掘金](https://juejin.cn/post/6844903990384132110)

## 1. 属性（properties）

属性可以在外部进行配置，并可以进行动态替换。

```
<properties resource="org/mybatis/example/config.properties">
  <property name="username" value="dev_user"/>
  <property name="password" value="F2Fa3!33TYyg"/>
</properties>
```

设置好的属性可以在整个配置文件中用来替换需要动态配置的属性值

```
<dataSource type="POOLED">
  <property name="driver" value="${driver}"/>
  <property name="url" value="${url}"/>
  <property name="username" value="${username}"/>
  <property name="password" value="${password}"/>
</dataSource>
```

也可以 SqlSessionFactoryBuilder.build() 方法中传入属性值



所以读取顺序：

* 1.properties元素体内指定属性

* 2.然后读取properties中**resource、url**中的配置，并覆盖同名字段（resource引入类路径下的资源，url引入网络路径或磁盘路径下的资源）

* 3.然后传入的属性值，覆盖同名字段

所以mybatis-config.xml的配置可以在.properties文件（或者yaml文件）中配置，spring把这个xml的工作做了。

![image-20211016213747670](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211016213747670.png)

## 2.设置（Settings）

MyBatis 中极为重要的调整设置，它们会改变 MyBatis 的运行时行为。

具体设置项查看文档。

```xml
<Settings>
    <Setting  name="mapUnderscoreToCamelCase" value="true"/>
</Settings>
```



## 3.类型别名（typeAliases）

```xml
<typeAliases>
  <!--为Java类型设置缩写别名-->
  <typeAlias alias="Author" type="domain.blog.Author"/>
  <typeAlias alias="Blog" type="domain.blog.Blog"/>
  <!--指定一个包名，MyBatis 会在包名下面搜索需要的 Java Bean-->
  <package name = "domain.blog">
</typeAliases>
```

```
@Alias("author")
//注解起别名
```

## 4.类型处理器（typeHandlers）

MyBatis 在设置预处理语句（PreparedStatement）中的参数或从结果集中取出一个值时， 用类型处理器将获取到的值以合适的方式转换成 Java 类型。



## 5.环境配置（environments） （多数据库 多数据源 但是mapper方法没有区分）

**可以配置多个环境，但每个 SqlSessionFactory 实例只能选择一种环境，即对应一个数据库。**

```java
SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(reader, environment);
SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(reader, environment, properties);
SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(reader);
SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(reader, properties);
```

**事务管理器**有两种：JDBC|MANAGED

* JDBC – 这个配置直接使用了 JDBC 的提交和回滚设施，它依赖从数据源获得的连接来管理事务作用域。

* MANAGED – 这个配置几乎没做什么。它从不提交或回滚一个连接，而是让容器来管理事务的整个生命周期（比如 JEE 应用服务器的上下文）。 默认情况下它会关闭连接。然而一些容器并不希望连接被关闭，因此需要将 closeConnection 属性设置为 false 来阻止默认的关闭行为。例如:

  ```
  <transactionManager type="MANAGED">
    <property name="closeConnection" value="false"/>
  </transactionManager>
  ```

**Spring + MyBatis，则没有必要配置事务管理器，因为 Spring 模块会使用自带的管理器来覆盖前面的配置**。

**dataSource type:**UNPOOLED|POOLED|JNDI

* UNPOOLED– 这个数据源的实现会每次请求时打开和关闭连接。
* POOLED– 这种数据源的实现利用“池”的概念将 JDBC 连接对象组织起来，避免了创建新的连接实例时所必需的初始化和认证时间。 这种处理方式很流行，能使并发 Web 应用快速响应请求。
* 

栗子：

首先,mybatis-config.xml中配置了两个数据源, 两个数据源数据不同（development lastname是asdddd  haha lastname 是mng）

![image-20211017000035744](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211017000035744.png)



根据mybatis全局配置文件 和  emvironment id 生成SqlSessionFactory

![image-20211017003533099](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211017003533099.png)



获得SqlSession、根据接口获得mapper后查表 结果：

![image-20211017010620558](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211017010620558.png)

**多数据库 单数据源  成功**





## 6.数据库厂商标识（databaseIdProvider）

\<environment\>中可以配置多个数据源，但是mapper接口在调用方法时，对于不同数据源应该调用不同的SQL语句。根据环境的驱动，采用不同的SQL语句，所以SQL语句要加上数据库厂商的标识

![image-20211017013138499](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211017013138499.png)

```xml
    <!--给数据源起别名-->
    <databaseIdProvider type="DB_VENDOR">
        <property name="MySQL" value="mysql"/>
        <property name="Oracle" value="oracle"/>
        <property name="SQL Server" value="sqlserver"/>
    </databaseIdProvider>
```

然后在mapper映射文件里给sql语句加上数据库厂商标识(感觉像多态)，会用到什么数据源，就定义个相应的sql语句，再打上数据库厂商标识。

```
    <select id="getEmployeeById" parameterType="Long" resultMap="ResultMap"
    databaseId="mysql">
        select *
        from tbl_employee
        where id = #{id}
    </select>
```

![image-20211017013613938](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211017013613938.png)



过程，根据环境驱动获得数据库厂商标识，例如mysql,然后加载所有带mysql标识、不带标识的sql语句，如果sql语句id同名，那么加载更精确的，例如一个mysql，一个不带，则加载mysql的。



## 7.映射器（mappers）

将写好的sql映射文件注册到全局配置文件

```xml
<mappers>
  <!-- 使用相对于类路径的资源引用 引用类路径下的sql映射文件-->
  <mapper resource="org/mybatis/builder/AuthorMapper.xml"/>
  <mapper resource="mapper/EmployeeMapper.xml"/>
  
  <!-- 使用完全限定资源定位符（URL） 引用网络路径或者磁盘路径下的sql映射文件-->
  <mapper url="file:///var/mappers/AuthorMapper.xml"/>
  <mapper url="file:///var/mappers/BlogMapper.xml"/>
    
  <!-- 使用映射器接口实现类的完全限定类名   
       mapper.xml和接口必须在同一目录里，且同名 不然无法绑定-->
  <mapper class="org.mybatis.builder.AuthorMapper"/>
  <mapper class="org.mybatis.builder.BlogMapper"/>
  
  <!-- 将包内的映射器接口实现全部注册为映射器 -->
  <package name="org.mybatis.builder"/>
   
</mappers>
```

用class注册时有两种：有映射文件，方便维护，不用改源代码

​                                        没有映射文件，基于注解，开发容易。  

![image-20211017015426310](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211017015426310.png)



例：

全局配置文件注册 注解的接口：

![image-20211017020555875](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211017020555875.png)



接口定义：

![image-20211017020631004](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211017020631004.png)

调用运行及结果：

![image-20211017020701214](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211017020701214.png)

![image-20211017020720613](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211017020720613.png)





映射文件和接口放在同一目录下，不好看--->方法：

代码最后都会合并到bin (idea 是target）文件目录下，所以可以接口放在src/包名下，映射文件放在conf/相同包名下。

![image-20211017020336230](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211017020336230.png)

# Mybatis 映射文件

1. mybatis返回sql语句影响的行数，可以在接口处定义返回的类型int,long,boolean(影响行数>0,true).

2. SqlSession需要手动或自动提交sql语句，不然在close时提交

   ```
   //autoCommit 设为 true
   SqlSession sqlSession = sqlSessionFactory.openSession(true);
   
   ```

## select

```
id="selectPerson"
parameterType="int" //可选
resultType=""//返回值类型，全类名或者别名，如果返回的是集合，定义集合中元素的类型。不能和resultMap同时使用。
resultMap=""  //外部resultMap的命名引用。不能和resultType同时使用。
databaseId
```

 **返回List：**

resultType还是写list集合里的类

```xml
//接口类
public List<String> getNameContainsN(String n);

//映射文件   注意字符串拼接的写法！！
    <select id="getNameContainsN" resultType="String">
        select last_name from tbl_employee where last_name like "%"#{n}"%"
    </select>
```



**返回map**：

```xml
//接口类    
    public Map<String,Object> getMapById(Long Id);
    public Map<String,Object> getMapByName(String name);

//映射文件
<!--    public Map<String,Object> getMapById(Long Id);-->
    <select id="getMapById" resultType="map">
        select * from tbl_employee where id = #{id}
    </select>
<!--    public Map<String,Object> getMapByName(String name);-->
    <select id="getMapByName" resultType="map">
        select  * from tbl_employee  where last_name=#{name}
    </select>
```

结果：

![image-20211020233758811](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211020233758811.png)

mybatis会把结果封装成 **列名=列值** 的形式

![image-20211020233441852](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211020233441852.png)

**但结果大于1个时，报错**

```xml
//接口类
@MapKey("id")    //如果没有mapkey，会报com.mng.Employee cannot be cast to java.util.Map错误
public Map<Long, Employee> getByIdReturnMap(Long Id);

    
//映射文件
<!--    Map<Long,Employee> getByIdReturnMap(Long Id);-->
    <select id="getByIdReturnMap" resultType="com.mng.Employee">
        select * from tbl_employee where id = #{id}
    </select>
    
    
```









## insert、update、delete

```java
id="insertAuthor"
parameterType="domain.blog.Author" //可选
 
databaseId
//只有insert、update有这两个属性
keyProperty="id"
useGeneratedKeys="true"


```

1. parameterType可选  MyBatis 可以通过类型处理器（TypeHandler）推断出具体传入语句的参数，默认值为未设置（unset）。
2.  useGeneratedKeys：使用自增主键获取获取主键策略
3.  keyProperty：指定对应的主键属性，即mybatis获取到主键值后（getGeneratedKeys的返回值或者insert的selectKey子元素），将这个值封装给Javabean哪个属性。

**主键生成方式：**

* 数据库支持自动生成主键：设置useGeneratedKeys、keyProperty

* 不支持自动生成主键（如Oracle）：可以使用selectKey从序列中得到下一个主键的值，设置id，然后插入语句调用

  ![image-20211018110442291](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211018110442291.png)

  After版本：（仅作了解，在插入多条记录时，可能出现问题）

  ![image-20211018111038400](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211018111038400.png)



## sql

这个元素可以用来定义可重用的 SQL 代码片段，以便在其它语句中使用。 参数可以静态地（在加载的时候）确定下来，并且可以在不同的 include 元素中定义不同的参数值。

```xml
<sql id="userColumns"> ${alias}.id,${alias}.username,${alias}.password </sql>
```

这个 SQL 片段可以在其它语句中使用，例如：

```xml
<select id="selectUsers" resultType="map">
  select
    <include refid="userColumns"><property name="alias" value="t1"/></include>,
    <include refid="userColumns"><property name="alias" value="t2"/></include>
  from some_table t1
    cross join some_table t2
</select>
```

也可以在 include 元素的 refid 属性或内部语句中使用属性值，例如：

```xml
<sql id="sometable">
  ${prefix}Table
</sql>

<sql id="someinclude">
  from
    <include refid="${include_target}"/>
</sql>

<select id="select" resultType="map">
  select
    field1, field2, field3
  <include refid="someinclude">
    <property name="prefix" value="Some"/>
    <property name="include_target" value="sometable"/>
  </include>
</select>
```



## 参数处理

**单个参数：**Mybatis不做任何处理

​                   #{参数名}，取出参数值，//命名不同都可以

**多个参数：**mybatis会做特殊处理

​                   多个参数会被封装成1个map

​                           key: param1........paramN,或者参数的索引

​                    #{param1}就是从map里获得指定key的值

![image-20211018205830725](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211018205830725.png)

![image-20211018162127520](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211018162127520.png)



**命名参数：**

为参数使用@Param起一个名字，MyBatis就会将这些参数封装进map中，key就是我们自己指定的名字



**POJO**：

当这些参数属于我们业务POJO时，我们直接传递POJO

#{属性名}，取出传入的POJO的属性值





**map:** 

反正最后封装成map

#{key},取出map中对应的值

而且mapper.xml不用写参数类型。

如果多个参数不是业务模型中的数据，但是经常要使用，推荐编写一个**TO（transfer object），数据传输对象**



**PS：**

![image-20211018165342351](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211018165342351.png)



### 源码分析

```
public Employee getEmp(@Param("id")Integer id,String lastName);
	取值：id==>#{id/param1}   lastName==>#{param2}

public Employee getEmp(Integer id,@Param("e")Employee emp);
	取值：id==>#{param1}    lastName===>#{param2.lastName/e.lastName}

##特别注意：如果是Collection（List、Set）类型或者是数组，
		 也会特殊处理。也是把传入的list或者数组封装在map中。
			key：Collection（collection）,如果是List还可以使用这个key(list)
				数组(array)
public Employee getEmpById(List<Integer> ids);
	取值：取出第一个id的值：   #{list[0]}
	
========================结合源码，mybatis怎么处理参数==========================
总结：参数多时会封装map，为了不混乱，我们可以使用@Param来指定封装时使用的key；
#{key}就可以取出map中的值；

(@Param("id")Integer id,@Param("lastName")String lastName);
ParamNameResolver解析参数封装map的；
//1、names：{0=id, 1=lastName}；构造器的时候就确定好了

	确定流程：
	1.获取每个标了param注解的参数的@Param的值：id，lastName；  赋值给name;
	2.每次解析一个参数给map中保存信息：（key：参数索引，value：name的值）
		name的值：
			标注了param注解：注解的值
			没有标注：
				1.全局配置：useActualParamName（jdk1.8）：name=参数名
				2.name=map.size()；相当于当前元素的索引
	{0=id, 1=lastName,2=2}
				

args【1，"Tom",'hello'】:

public Object getNamedParams(Object[] args) {
    final int paramCount = names.size();
    //1、参数为null直接返回
    if (args == null || paramCount == 0) {
      return null;
     
    //2、如果只有一个元素，并且没有Param注解；args[0]：单个参数直接返回
    } else if (!hasParamAnnotation && paramCount == 1) {
      return args[names.firstKey()];
      
    //3、多个元素或者有Param标注
    } else {
      final Map<String, Object> param = new ParamMap<Object>();
      int i = 0;
      
      //4、遍历names集合；{0=id, 1=lastName,2=2}
      for (Map.Entry<Integer, String> entry : names.entrySet()) {
      
      	//names集合的value作为key;  names集合的key又作为取值的参考args[0]:args【1，"Tom"】:
      	//eg:{id=args[0]:1,lastName=args[1]:Tom,2=args[2]}
        param.put(entry.getValue(), args[entry.getKey()]);
        
        
        // add generic param names (param1, param2, ...)param
        //额外的将每一个参数也保存到map中，使用新的key：param1...paramN
        //效果：有Param注解可以#{指定的key}，或者#{param1}
        final String genericParamName = GENERIC_NAME_PREFIX + String.valueOf(i + 1);
        // ensure not to overwrite parameter named with @Param
        if (!names.containsValue(genericParamName)) {
          param.put(genericParamName, args[entry.getKey()]);
        }
        i++;
      }
      return param;
    }
  }
}
```



### 参数值的获取

#{key}获取map或者POJO中的值，\${key}也可以

区别：
	#{}:是以预编译的形式，将参数设置到sql语句中；PreparedStatement；防止sql注入
	${}:取出的值直接拼装在sql语句中；会有安全问题；

```
String sql = "select * from user_table where username=
' "+userName+" ' and password=' "+password+" '";

当输入了上面的用户名和密码，上面的SQL语句变成：
SELECT * FROM user_table WHERE username=
'’or 1 = 1 -- and password='’

条件后面username=”or 1=1 用户名等于 ” 或1=1 那么这个条件一定会成功；

然后后面加两个-，这意味着注释，它将后面的语句注释，让他们不起作用，这样语句永远都能正确执行，用户轻易骗过系统，获取合法身份。

这还是比较温柔的，如果是执行
SELECT * FROM user_table WHERE
username='' ;DROP DATABASE (DB Name) --' and password=''
其后果可想而知…
```

​	大多情况下，我们去参数的值都应该去使用#{}；

![image-20211019095644336](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211019095644336.png)



  \${}用处：原生sql在不支持占位符的地方可以用${}取值

​                  比如分表

![image-20211019101019760](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211019101019760.png)



#{}:更丰富的用法：
	规定参数的一些规则：
	javaType、 jdbcType、 mode（存储过程）、 numericScale、
	resultMap、 typeHandler、 jdbcTypeName、 expression（未来准备支持的功能）；

	jdbcType通常需要在某种特定的条件下被设置：
		在我们数据为null的时候，有些数据库可能不能识别mybatis对null的默认处理。比如Oracle（报错）；
		
		JdbcType OTHER：无效的类型；因为mybatis对所有的null都映射的是原生Jdbc的OTHER类型，oracle不能正确处理;
		
		由于全局配置中：jdbcTypeForNull=OTHER；oracle不支持；两种办法
		1、#{email,jdbcType=NULL};
		2、jdbcTypeForNull=NULL
			<setting name="jdbcTypeForNull" value="NULL"/>

![image-20211019102401610](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211019102401610.png)



## resultMap

自定义封装规则

![image-20211021134006987](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211021134006987.png)

![image-20211021133856271](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211021133856271.png)

![image-20211021202353145](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211021202353145.png)

没有resultMap，也能查到数据，但是lastName会是null，因为没有匹配。



### 关联对象的封装

![image-20211021215021922](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211021215021922.png)

![image-20211021214800105](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211021214800105.png)

### association（关联对象）

或者使用association定义单个对象封装规则

![image-20211021220653985](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211021220653985.png)

```java
//javabean
@Data
public class Employee {
    private Long id;
    private String lastName;
    private String gender;
    private String email;
    private Department department;

}
@Data
public class Department {
    Long id;
    String name;
}
```

```xml
//mapper映射文件
<resultMap id="ResultMap" type="com.mng.Employee">
        <id column="id" property="id"/>
        <result column="last_name" property="lastName"/>
        <result column="gender" property="gender"/>
        <result column="email" property="email"/>
        <association property="department" javaType="com.mng.Department">
            <id column="d_id" property="id"/>
            <result column="d_name" property="name" />
        </association>
    </resultMap>

<!--    public Employee getEmpById(Long id);-->
    <select id="getEmpById" resultMap="ResultMap">
        select * from tbl_employee where id = #{id}
    </select>

<!--       public Employee getEDById(Long id); -->
    <select id="getEDById" resultMap="ResultMap">
        select t1.*,t2.id d_id,t2.name d_name
        from tbl_employee t1 join  department t2
        on t1.dept_id = t2.id
        where t1.id = #{id}
    </select>
```

结果：

方法getEmpById结果：没有匹配的类名所以department为null

![image-20211021234215049](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211021234215049.png)

方法getEDById结果，有匹配类名

![image-20211021235242277](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211021235242277.png)

**分步查询**

![image-20211021224531032](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211021224531032.png)

```xml
//mapper映射文件
    <resultMap id="ResultMap2" type="com.mng.Employee">
        <id column="id" property="id"/>
        <result column="last_name" property="lastName"/>
        <result column="gender" property="gender"/>
        <result column="email" property="email"/>
        <association property="department" select="com.mng.DepartmentMapper.getDepById"
        column="dept_id">
        </association>

    </resultMap>
    <!--    public Employee getEmpById(Long id);-->
    <select id="getEmpById" resultMap="ResultMap2">
        select * from tbl_employee where id = #{id}
    </select>


```

结果：对上面的getEmpById的resultMap改成了新的，查询到了结果

![image-20211021235438504](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211021235438504.png)



### 延迟加载

查询某个对象时，对于其关联对象，在使用时再去查询。

```
//全局配置
lazyLoadingEnabled 开启！！   ( 延迟加载的全局开关。当开启时，所有关联对象都会延迟加载。 特定关联关系中可通过设置 fetchType 属性来覆盖该项的开关状态。)

aggressiveLazyLoading 关闭！！ (开启时，任一方法的调用都会加载该对象的所有延迟加载属性。 否则，每个延迟加载属性会按需加载 3.4.1后默认关闭)

```





### 关联集合

```xml
<mapper namespace="com.mng.DepartmentMapper">
<!--       public List<Department> getDep();-->
    <resultMap id="ListTest" type="com.mng.Department">
        <id column="id" property="id"/>
        <result column="name" property="name"/>
        <collection property="employeeList" ofType="com.mng.Employee" columnPrefix="e_">
            <id column="id" property="id"/>
            <result column="last_name" property="lastName"/>
            <result column="gender" property="gender"/>
            <result column="email" property="email"/>
        </collection>
    </resultMap>
    <select id="getDep" resultMap="ListTest">
        select t1.*,
        t2.id e_id,t2.last_name e_last_name,t2.gender e_gender,t2.email e_email
        from department t1 join tbl_employee t2 on  t1.id = t2.dept_id
    </select>
</mapper>
```

![image-20211026222824283](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211026222824283.png)



**分步查询**

```xml
    //department映射文件
    <resultMap id="ListTest2" type="com.mng.Department">
        <id column="id" property="id"/>
        <result column="name" property="name"/>
        <collection property="employeeList"
                    select="com.mng.EmployeeMapMapper.getELByDeptId"
                    column="id">
        </collection>

    </resultMap>
    
    <select id="getDep2" resultMap="ListTest2">
        select * from department
    </select>
```

```xml
//employeement映射文件
    <resultMap id="ResultMap2" type="com.mng.Employee">
        <id column="id" property="id"/>
        <result column="last_name" property="lastName"/>
        <result column="gender" property="gender"/>
        <result column="email" property="email"/>
        <association property="department" select="com.mng.DepartmentMapper.getDepById"
        column="dept_id">
        </association>

    </resultMap>
    
<!--       public List<Employee> getELByDeptId(Long deptId); -->
    <select id="getELByDeptId" resultMap="ResultMap2">
        select * from tbl_employee where dept_id = #{deptId}
    </select>
```

![image-20211026230902551](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211026230902551.png)

# TypeHandler 
#### Mybatis TypeHandler

|    Mybatis     |                 Java                 |        MySQL         |
|:--------------:|:------------------------------------:|:--------------------:|
|  big\_decimal  |         java.math.BigDecimal         |       NUMERIC        |
|     binary     |               byte\[\]               |  VARBINARY OR BLOB   |
|      blob      |            java.sql.Blob             |         BLOB         |
|    boolean     |     boolean OR java.lang.Boolean     |         BIT          |
|      byte      |        byte OR java.lang.Byte        |       TINYINT        |
|    calendar    |          java.util.Calendar          |      TIMESTAMP       |
| calendar\_date |          java.util.Calendar          |         DTAE         |
|   character    |           java.lang.String           |       CHAR(1)        |
|     class      |           java.lang.Class            |       VARCHAR        |
|      clob      |            java.sql.Clob             |         CLOB         |
|    currency    |          java.util.Currency          |       VARCHAR        |
|      date      |   java.util.Date OR java.sql.Date    |         DATE         |
|     double     |      double OR java.lang.Double      |        DOUBLE        |
|     float      |       float OR java.lang.Float       |        FLOAT         |
|    integer     |       int OR java.lang.Integer       |       INTEGER        |
|     locale     |           java.util.Locale           |       VARCHAR        |
|      long      |        long OR java.lang.Long        |        BIGINT        |
|  serializable  |         java.io.Seriailzable         |  VARBINARY OR BLOB   |
|     short      |       short OR java.lang.Short       |       SMALLINT       |
|     string     |           java.lang.String           |       VARCHAR        |
|      text      |           java.lang.String           |         CLOB         |
|      time      |   java.util.Date OR java.sql.Time    |         TIME         |
|   timestamp    | java.util.Date OR java.sql.TimeStamp |      TIMESTAMP       |
|    timezone    |          java.util.TimeZone          |       VARCHAR        |
|  true\_false   |     boolean OR java.lang.Boolean     | CHAR(1) (‘Y’ OR ‘N’) |
|    yes\_no     |     boolean OR java.lang.Boolean     | CHAR(1) (‘Y’ OR ‘N’) |




#### 自定义 typeHandler
[(171条消息) MyBatis各种数据类型映射对应及mybatis plus中 List、Map等类型映射为json_Deschampszzzz的博客-CSDN博客_mybatisplus字段类型映射](https://blog.csdn.net/Deschampszzzz/article/details/125362425?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-125362425-blog-110136015.t0_edu_mix&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-125362425-blog-110136015.t0_edu_mix&utm_relevant_index=2)
[(171条消息) mybatis plus将对象list转换为string存储&mybatisplus存储list字符串_病毒plus的博客-CSDN博客_mybatis 对象转字符串](https://blog.csdn.net/sinat_38073073/article/details/110136015)

#### autoResultMap
[MyBatis Plus - xml中如何使用autoResultMap构造的ResultMap - 腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1784804)

# 动态 SQL

用于拼接sql

## 1. if 标签

```Java
//接口,多个参数（还是自定义类），所以命名了参数
public interface EmployeeDSQLMapper {
     public List<Employee> getEmpByNameAndDept(@Param("name") String name,@Param("department") Department department);
}
```

```xml
//映射文件
    <resultMap id="ResultMap" type="com.mng.Employee">
        <id column="id" property="id"/>
        <result column="last_name" property="lastName"/>
        <result column="gender" property="gender"/>
        <result column="email" property="email"/>
        <association property="department" javaType="com.mng.Department">
            <id column="d_id" property="id"/>
            <result column="d_name" property="name" />
        </association>
    </resultMap>
<!--  public List<Employee> getEmpByNameAndDept(String name,Department department); -->
    <select id="getEmpByNameAndDept" resultMap="ResultMap">
         select t1.*,t2.id  d_id,t2.name d_name from
         tbl_employee t1 join department t2
         on t1.dept_id = t2.id
         where t1.last_name = #{name}
         <if test="department!=null and department.name !=null">
             and t2.name = #{department.name}
         </if>
    </select>
```

测试：

1. deparatment.name为null

   ![image-20211026233650086](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211026233650086.png)

2. departname.name = “dep1”

   ![image-20211026234131512](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211026234131512.png)

## 2. choose 标签

```Java
//接口,多个参数（还是自定义类），所以命名了参数
public List<Employee> getEmp(@Param("id")Long id,@Param("name")String name,@Param("department") Department department);
```

```xml
  //映射文件
  <select id="getEmp" resultMap="ResultMap">
        select t1.*,t2.id  d_id,t2.name d_name from
        tbl_employee t1 join department t2
        on t1.dept_id = t2.id
        where 1=1
        <choose>
            <when test="id != null">
                and t1.id = #{id}
            </when>
            <when test="name != null">
                and t1.name = #{name}
            </when>
            <when test="department!=null and department.name !=null">
                and t2.name = #{department.name}
            </when>
        </choose>
    </select>
```

测试：

1. id为1，但是name，departname不是相应的数据

![image-20211026235429387](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211026235429387.png)2. id为null, name为null

![image-20211026235709361](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211026235709361.png)



## 3. trim 标签

可以看到为了格式的正确，我在choose里用了 where 1=1 的语句，trim就是为了解决这样的问题。

**where:**

相当于

```xml
<trim prefix="WHERE" prefixOverrides="AND |OR ">
  ...
</trim>
```

![image-20211027000736310](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211027000736310.png)

![image-20211027000751728](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211027000751728.png)



**set:**

相当于：

```xml
<trim prefix="SET" suffixOverrides=",">
  ...
</trim>
```

```xml
//借用文档例子
<update id="updateAuthorIfNecessary">
  update Author
    <set>
      <if test="username != null">username=#{username},</if>
      <if test="password != null">password=#{password},</if>
      <if test="email != null">email=#{email},</if>
      <if test="bio != null">bio=#{bio}</if>
    </set>
  where id=#{id}
</update>
```

## 4.foreach
[MyBatis系列(八)：MyBatis动态Sql之foreach标签的用法 - 掘金](https://juejin.cn/post/6844903886575108110)
![image-20211027001308141](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211027001308141.png)

```Java
//接口,命名参数
public  List<Employee> getEmpByDeptList(@Param("dapartmentList") List<Department> departmentList);
```

```xml
  //映射文件
      <select id="getEmpByDeptList" resultMap="ResultMap">
        select t1.*,t2.id  d_id,t2.name d_name from
        tbl_employee t1 join department t2
        on t1.dept_id = t2.id
        where t2.name in
        <foreach collection="dapartmentList" item="item" open="(" close=")" separator=",">
            #{item.name}
        </foreach>
    </select>
```

结果：

![image-20211027002338080](https://raw.githubusercontent.com/minangong/mng_images/main/images/image-20211027002338080.png)



## 5.script

要在带注解的映射器接口类中使用动态 SQL，可以使用 *script* 元素。比如:

```Java
    @Update({"<script>",
      "update Author",
      "  <set>",
      "    <if test='username != null'>username=#{username},</if>",
      "    <if test='password != null'>password=#{password},</if>",
      "    <if test='email != null'>email=#{email},</if>",
      "    <if test='bio != null'>bio=#{bio}</if>",
      "  </set>",
      "where id=#{id}",
      "</script>"})
    void updateAuthorValues(Author author);
```

## 6.bind

`bind` 元素允许你在 OGNL 表达式以外创建一个变量，并将其绑定到当前的上下文。比如：

```xml
<select id="selectBlogsLike" resultType="Blog">
  <bind name="pattern" value="'%' + _parameter.getTitle() + '%'" />
  SELECT * FROM BLOG
  WHERE title LIKE #{pattern}
</select>
```

   

## 7.多数据库支持

如果配置了 databaseIdProvider，你就可以在动态代码中使用名为 “_databaseId” 的变量来为不同的数据库构建特定的语句。比如下面的例子：

```xml
<insert id="insert">
  <selectKey keyProperty="id" resultType="int" order="BEFORE">
    <if test="_databaseId == 'oracle'">
      select seq_users.nextval from dual
    </if>
    <if test="_databaseId == 'db2'">
      select nextval for seq_users from sysibm.sysdummy1"
    </if>
  </selectKey>
  insert into users values (#{id}, #{name})
</insert>
```

# 源码、架构
[Mybatis源码解析（一） -- 动态代理,拦截器及架构分析 - 掘金](https://juejin.cn/post/6911235079163838472)
[Mybatis源码解析(二) —— 加载 Configuration - 掘金](https://juejin.cn/post/6844903990384132110)
[Mybatis源码解析(三) —— Mapper代理类的生成 - 掘金](https://juejin.cn/post/6844903997933879309)
[Mybatis源码解析(四) —— SqlSession是如何实现数据库操作的？ - 掘金](https://juejin.cn/post/6844904002421800967)
