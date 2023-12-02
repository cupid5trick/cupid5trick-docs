---
scope: learn
draft: true
---


[简介 | MyBatis-Plus](https://baomidou.com/pages/24112f/)
[使用配置 | MyBatis-Plus](https://baomidou.com/pages/56bac0/#%E4%BD%BF%E7%94%A8%E6%96%B9%E5%BC%8F)
[代码生成器（新） | MyBatis-Plus](https://baomidou.com/pages/779a6e/#%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8)
# 主要功能
[主要功能](https://mp.baomidou.com/guide/#特性)

- **通用单表CRUD 操作**：内置通用 Mapper 提供了常用数据库增删改查操作，通用 Service 提供了常用业务批量操作分页查询等。
- **内置分页插件**：基于 `MyBatis` 物理分页，开发者无需关心具体操作，配置好插件之后，写分页等同于普通 List 查询
- **主键自动生成**：支持多达 4 种主键策略（内含分布式唯一 ID 生成器 - Sequence）
- **字段填充**：通过自定义 `MetaObjectHandler` 实现类似时间字段自动填充的功能。

# 通用 CRUD
## 基本使用
**`BaseMapper` 使用方法** 
[`BaseMapper` 使用方法](https://mp.baomidou.com/guide/quick-start.html#编码)

定义接口继承`BaseMapper`，单表增删改查即可用，只要自己设计连表查询即可。

```java
@Repository
public interface UserMapper extends BaseMapper<User> {
	
}
```

**`Iservice` 使用方法**

实体服务类使用方式：

```java
@Service
public class UserService extends  ServiceImpl<UserMapper, User> implements IService<User> {
	// 通用的单表业务操作已经可用，定义自己的业务逻辑
}
```

一个实体服务类对应一个服务接口的方式：

`UserService`接口：

```java
public interface UserService extends Iservice<User> {
	// UserService接口继承了IService接口定义的的通用操作
}
```

定义实体服务类实现`UserService`接口：

```java
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IService<User> {
    // IService的通用业务操作可用，定义自己的业务逻辑
}
```

## 联表查询
[MybatisPlus多表连接查询 - 腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1937160?from=15425)
[Mybatis-Plus中复杂连表的查询 - 掘金](https://juejin.cn/post/6940553213514874893)
[(154条消息) mybatisplus复杂查询介绍和基本使用（三）-十里长街的博客-CSDN博客-likeright](https://blog.csdn.net/weixin_46258873/article/details/114292468)
复杂连表sql的mybatis-plus实现

mybatis-plus自带的方法是很难实现复杂sql查询的，这里如果我们还想用上面提到的几个特性，就要使用mybatis-plus提供的自定义sql功能： 大致理念是在service层集成好QueryWrapper对象，之后传递到mapper接口或者mapper.xml文件中。 首先看一下`mapper`接口和`mapper.xml`文件，两种方式都是可以的  
纯mapper接口：

```sql
String SELECT_SQL = " select user.id                         as userId,
               IFNULL(so.name, '-')                        as platform,
               user.username                               as username,
               user.enable                                 as enable,
               IFNULL(GROUP_CONCAT(DISTINCT sg.name), '-') as groupNames,
               IFNULL(GROUP_CONCAT(DISTINCT sp.name), '-') as policyNames,
               user.email  as email,
               user.phone  as phone
        from sys_user user
                 left join sys_organization so on so.id = user.organization_id
                 left join sys_user_group sug on user.id = sug.user_id
                 left join sys_group sg on sug.group_id = sg.id
                 left join sys_policy_belong spb on spb.belong_id = user.id and spb.belong_type = 'user'
                 left join sys_policy sp on sp.id = spb.policy_id
            ${ew.customSqlSegment}
        group by user.id";

@Select(SELECT_SQL)
IPage<UserListDto> selectUserPageList(Page<SysUser> page, @Param(Constants.WRAPPER) QueryWrapper<SysUser> wrapper);

@Select(SELECT_SQL)
List<UserListDto> selectUserList(@Param(Constants.WRAPPER) QueryWrapper<SysUser> wrapper);
     
```
mapper.xml模式：

```java
IPage<UserListDto> selectUserPageList(Page<SysUser> page,
                     @Param(Constants.WRAPPER) QueryWrapper<SysUser> wrapper);
```

```xml
<select id="selectUserPageList" resultType="com.wochanye.dtube.rbac.bean.user.UserListDto"> select user.id as userId, IFNULL(so.name, '-') as platform, user.username as username, user.enable as enable, IFNULL(GROUP_CONCAT(DISTINCT sg.name), '-') as groupNames, IFNULL(GROUP_CONCAT(DISTINCT sp.name), '-') as policyNames, user.email as email, user.phone as phone from sys_user user left join sys_organization so on so.id = user.organization_id left join sys_user_group sug on user.id = sug.user_id left join sys_group sg on sug.group_id = sg.id left join sys_policy_belong spb on spb.belong_id = user.id and spb.belong_type = 'user' left join sys_policy sp on sp.id = spb.policy_id ${ew.customSqlSegment} group by user.id </select>
```
这里需要注意的是两点：  
1.每个表都需要设置别名  
2.where语区不写，用`${ew.customSqlSegment}`代替  
这里可以看出来，分页功能也是不需要自己单独写的，将Page类传递过来就可以。  
之后在service层组装QueryWrapper，这时候就没法用Lambda模式了，只能使用原生的模式：

```perl
QueryWrapper<SysUser> queryWrapper = new QueryWrapper<SysUser>();
// 这里的user、so、sg对应sql中的表别名
queryWrapper.eq("user.deleted", false)
            .in("user.organization_id", isOrganizationManager)
            .eq("user.create_user", userId)
            .eq("so.name", organizationName)
            .eq("sg.name",groupName);
Page<SysUser> iPage = new Page<>(pageParam.getPage(), pageParam.getPageSize());
IPage<UserListDto> userListDtoPage = sysUserExtMapper.selectUserPageList(iPage, queryWrapper);
```
## 复杂查询
环境搭建参考mybatisplus第一，第二篇文章  
### wapper介绍
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210302192628510.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NjI1ODg3Mw==,size_16,color_FFFFFF,t_70)  
[Wrapper](https://so.csdn.net/so/search?q=Wrapper&spm=1001.2101.3001.7020) ： 条件构造抽象类，最顶端父类  
AbstractWrapper ： 用于查询条件封装，生成 sql 的 where 条件  
QueryWrapper ： Entity 对象封装操作类，不是用[lambda](https://so.csdn.net/so/search?q=lambda&spm=1001.2101.3001.7020)语法  
UpdateWrapper ： Update 条件封装，用于Entity对象更新操作  
AbstractLambdaWrapper ： Lambda 语法使用 Wrapper统一处理解析 lambda 获取 column。  
LambdaQueryWrapper ：看名称也能明白就是用于Lambda语法使用的查询Wrapper  
LambdaUpdateWrapper ： Lambda 更新封装Wrapper

AbstractWrapper  
注意：以下条件构造器的方法入参中的 column 均表示数据库字段  
### 1、ge(>=)、gt(>)、le(<=)、lt(<)、isNull、isNotNull

```
@Test
public void testDelete() {
    QueryWrapper<User> queryWrapper = new QueryWrapper<>();
    queryWrapper.isNull("name")
    //queryWrapper.ge("age", 12)
    //queryWrapper.isNotNull("email");
    int result = userMapper.delete(queryWrapper);
    System.out.println("delete return count = " + result);
}
```

SQL：UPDATE user SET deleted=1 WHERE deleted=0 AND name IS NULL AND age >= ? AND email IS NOT NULL  
### 2、eq(=)、ne(!=或者是<>)
注意：seletOne返回的是一条实体记录，当出现多条时会报错

```
@Test
public void testSelectOne() {

    QueryWrapper<User> queryWrapper = new QueryWrapper<>();
    queryWrapper.eq("name", "Tom");
    User user = userMapper.selectOne(queryWrapper);
    System.out.println(user);
}
```

SELECT id,name,age,email,create\_time,update\_time,deleted,version FROM user WHERE deleted=0 AND name = ?  
### 3、between（之间）、notBetween（不再之间）
包含大小边界

```
@Test
public void testSelectCount() {

    QueryWrapper<User> queryWrapper = new QueryWrapper<>();
    queryWrapper.between("age", 20, 30);
    Integer count = userMapper.selectCount(queryWrapper);
    System.out.println(count);
}
```

SELECT COUNT(1) FROM user WHERE deleted=0 AND age BETWEEN ? AND ?  
### 4、allEq

```

@Test@
public void testSelectList() {
    QueryWrapper<User> queryWrapper = new QueryWrapper<>();
    Map<String, Object> map = new HashMap<>();
    map.put("id", 2);
    map.put("name", "Jack");
    map.put("age", 20);
    queryWrapper.allEq(map);
    List<User> users = userMapper.selectList(queryWrapper);
    users.forEach(System.out::println);
}
```

SELECT id,name,age,email,create\_time,update\_time,deleted,version  
FROM user WHERE deleted=0 AND name = ? AND id = ? AND age = ?  
### 5、like、notLike、likeLeft、likeRight
selectMaps返回Map集合列表

```
@Test
public void testSelectMaps() {
    QueryWrapper<User> queryWrapper = new QueryWrapper<>();
    queryWrapper
        .notLike("name", "e")
        .likeRight("email", "t");
    List<Map<String, Object>> maps = userMapper.selectMaps(queryWrapper);//返回值是Map列表

    maps.forEach(System.out::println);
}
```

SELECT id,name,age,email,create\_time,update\_time,deleted,version  
FROM user WHERE deleted=0 AND name NOT LIKE ? AND email LIKE ?  
### 6、in、notIn、inSql、notinSql、exists、notExists
in、notIn：  
notIn(“age”,{1,2,3})—>age not in (1,2,3)  
notIn(“age”, 1, 2, 3)—>age not in (1,2,3)  
inSql、notinSql：可以实现子查询  
例: inSql(“age”, “1,2,3,4,5,6”)—>age in (1,2,3,4,5,6)  
例: inSql(“id”, “select id from table where id < 3”)—>id in (select id from table where id < 3)

```

@Test@
public void testSelectObjs() {

    QueryWrapper<User> queryWrapper = new QueryWrapper<>();
    //queryWrapper.in("id", 1, 2, 3);
    queryWrapper.inSql("id", "select id from user where id < 3");

    List<Object> objects = userMapper.selectObjs(queryWrapper);//返回值是Object列表
    objects.forEach(System.out::println);
}
```

SELECT id,name,age,email,create\_time,update\_time,deleted,version  
FROM user WHERE deleted=0 AND id IN (select id from user where id < 3)  
### 7、or、and
注意：这里使用的是 UpdateWrapper  
不调用or则默认为使用 and 连

```
@Test
public void testUpdate1() {

    //修改值
    User user = new User();
    user.setAge(99);
    user.setName("Andy");
    //修改条件
    UpdateWrapper<User> userUpdateWrapper = new UpdateWrapper<>();
    userUpdateWrapper
        .like("name", "h")
        .or()
        .between("age", 20, 30);
    int result = userMapper.update(user, userUpdateWrapper);
    System.out.println(result);
}
```

UPDATE user SET name=?, age=?, update\_time=? WHERE deleted=0 AND name LIKE ? OR age BETWEEN ? AND ?  
### 8、嵌套or、嵌套and
这里使用了lambda表达式，or中的表达式最后翻译成sql时会被加上圆括号

```
@Test
public void testUpdate2() {
    //修改值
    User user = new User();
    user.setAge(99);
    user.setName("Andy");
    //修改条件
    UpdateWrapper<User> userUpdateWrapper = new UpdateWrapper<>();
    userUpdateWrapper
        .like("name", "h")
        .or(i -> i.eq("name", "李白").ne("age", 20));
    int result = userMapper.update(user, userUpdateWrapper);
    System.out.println(result);
}
```

UPDATE user SET name=?, age=?, update\_time=?  
WHERE deleted=0 AND name LIKE ?  
OR ( name = ? AND age <> ? )  
### 9、orderBy、orderByDesc、orderByAsc

```
@Test
public void testSelectListOrderBy() {

    QueryWrapper<User> queryWrapper = new QueryWrapper<>();
    queryWrapper.orderByDesc("id");
    List<User> users = userMapper.selectList(queryWrapper);
    users.forEach(System.out::println);
}
```

SELECT id,name,age,email,create\_time,update\_time,deleted,version  
FROM user WHERE deleted=0 ORDER BY id DESC  
### 10、last
直接拼接到 sql 的最后  
注意：只能调用一次,多次调用以最后一次为准 有sql注入的风险,请谨慎使用

```

@Test
public void testSelectListLast() {
    QueryWrapper<User> queryWrapper = new QueryWrapper<>();
    queryWrapper.last("limit 1");

    List<User> users = userMapper.selectList(queryWrapper);
    users.forEach(System.out::println);
}
```

SELECT id,name,age,email,create\_time,update\_time,deleted,version  
FROM user WHERE deleted=0 limit 1  
### 11、指定要查询的列

```

@Test
public void testSelectListColumn() {
    QueryWrapper<User> queryWrapper = new QueryWrapper<>();
    queryWrapper.select("id", "name", "age");
    List<User> users = userMapper.selectList(queryWrapper);
    users.forEach(System.out::println);
}
```

SELECT id,name,age FROM user WHERE deleted=0  
### 12、set、setSql
最终的sql会合并 user.setAge()，以及 userUpdateWrapper.set() 和 setSql() 中 的字段

```
@Test
public void testUpdateSet() {
    //修改值
    User user = new User();
    user.setAge(99);
    //修改条件
    UpdateWrapper<User> userUpdateWrapper = new UpdateWrapper<>();
    userUpdateWrapper
        .like("name", "h")
        .set("name", "老李头")//除了可以查询还可以使用set设置修改的字段
        .setSql(" email = '123@qq.com'");//可以有子查询
    int result = userMapper.update(user, userUpdateWrapper);
}
```

UPDATE user SET age=?, update\_time=?, name=?, email = ‘123@qq.com’ WHERE deleted=0 AND name LIKE ?
这样就可以实现mybatis-plus下的多表连表查询了。
# 模型定义
#### 使用枚举
[通用枚举 | MyBatis-Plus](https://baomidou.com/pages/8390a4/#%E6%AD%A5%E9%AA%A41-%E5%A3%B0%E6%98%8E%E9%80%9A%E7%94%A8%E6%9E%9A%E4%B8%BE%E5%B1%9E%E6%80%A7)

# 自动生成主键

在定义models实体类时通过`@TableId`注解的`type`参数可以设置主键生成策略。

当使用`IdType.AUTO`时，需要在数据库设置该字段为自增主键，因为`Mybatis-plus`此时对主键生成不做任何处理、完全交给数据库。

## IdType
[IdType](https://github.com/baomidou/mybatis-plus/blob/3.0/mybatis-plus-annotation/src/main/java/com/baomidou/mybatisplus/annotation/IdType.java)

|      值       |                             描述                             |
| :-----------: | :----------------------------------------------------------: |
|    `AUTO`     |           `Mybatis`不做处理，利用数据库自增ID特性            |
|    `NONE`     | 无状态,该类型为未设置主键类型(注解里等于跟随全局,全局里约等于 INPUT) |
|    `INPUT`    |                    insert前自行set主键值                     |
|  `ASSIGN_ID`  | 分配ID(主键类型为Number(Long和Integer)或String)(since 3.3.0),使用接口`IdentifierGenerator`的方法`nextId`(默认实现类为`DefaultIdentifierGenerator`雪花算法) |
| `ASSIGN_UUID` | 分配UUID,主键类型为String(since 3.3.0),使用接口`IdentifierGenerator`的方法`nextUUID`(默认default方法) |

## `Mybatis-plus`用于字段定义的其他注解
[`Mybatis-plus`用于字段定义的其他注解](https://mp.baomidou.com/guide/annotation.html#%E6%B3%A8%E8%A7%A3)

## 字段填充
[字段填充](https://mp.baomidou.com/guide/auto-fill-metainfo.html#自动填充功能)
[自动填充功能 | MyBatis-Plus](https://baomidou.com/pages/4c6bcf/)
在定义models实体类字段时，通过`@TableField`注解的`fill`参数设置字段填充方式：

```java
@TableField(value="db_table", fill=FieldFill.xxx)
```


[FieldFill](https://github.com/baomidou/mybatis-plus/blob/3.0/mybatis-plus-annotation/src/main/java/com/baomidou/mybatisplus/annotation/FieldFill.java)

|      值       |         描述         |
| :-----------: | :------------------: |
|    DEFAULT    |      默认不处理      |
|    INSERT     |    插入时填充字段    |
|    UPDATE     |    更新时填充字段    |
| INSERT_UPDATE | 插入和更新时填充字段 |

 设置填充方式之后实现元对象处理接口 `MetaObjectHandler`，在实现类中覆写`insertFill`、`updateFill`方法定义自己的填充行为。

```java
@Slf4j
@Component
public class MyMetaObjectHandler implements MetaObjectHandler {

    @Override
    public void insertFill(MetaObject metaObject) {
        log.info("start insert fill ....");
        // this.strictInsertFill(metaObject, "createTime", LocalDateTime.class, LocalDateTime.now()); // 起始版本 3.3.0(推荐使用)
        // this.strictInsertFill(metaObject, "createTime", () -> LocalDateTime.now(), LocalDateTime.class); // 起始版本 3.3.3(推荐)
        // mybatis-plus: 3.3.2版本测试了上面两个方法不生效，fillStrategy可以成功填充
        this.fillStrategy(metaObject, "createTime", LocalDateTime.now()); // 也可以使用(3.3.0 该方法有bug)
        // 或者直接调用元对象字段赋值方法setFieldValByName
        this.setFieldValByName("createTime", LocalDateTime.now(), metaObject);
    }

    @Override
    public void updateFill(MetaObject metaObject) {
        ...
    }
}
```

因为字段填充的原理就是给对象某个字段赋值，因此直接调用`setFieldValByName`即可。
注意事项：

-   填充原理是直接给`entity`的属性设置值!!!
-   注解则是指定该属性在对应情况下必有值,如果无值则入库会是`null`
-   `MetaObjectHandler`提供的默认方法的策略均为:如果属性有值则不覆盖,如果填充值为`null`则不填充
-   字段必须声明`TableField`注解,属性`fill`选择对应策略,该声明告知`Mybatis-Plus`需要预留注入`SQL`字段
-   填充处理器`MyMetaObjectHandler`在 Spring Boot 中需要声明`@Component`或`@Bean`注入
-   要想根据注解`FieldFill.xxx`和`字段名`以及`字段类型`来区分必须使用父类的`strictInsertFill`或者`strictUpdateFill`方法
-   不需要根据任何来区分可以使用父类的`fillStrategy`方法
-   update(T t,Wrapper updateWrapper)时t不能为空,否则自动填充失效
## 执行 SQL 分析打印
[### 执行 SQL 分析打印](https://mp.baomidou.com/guide/p6spy.html#执行-sql-分析打印)
# 使用配置
[使用配置 | MyBatis-Plus](https://baomidou.com/pages/56bac0/#%E4%BD%BF%E7%94%A8%E6%96%B9%E5%BC%8F)
# 拓展功能
### 拓展
#### 逻辑删除
[逻辑删除](https://baomidou.com/pages/6b03c5/)
#### 通用枚举
[通用枚举](https://baomidou.com/pages/8390a4/)
#### 字段类型处理器
[字段类型处理器](https://baomidou.com/pages/fd41d8/)
#### 自动填充功能
[自动填充功能](https://baomidou.com/pages/4c6bcf/)
#### SQL注入器
[SQL注入器](https://baomidou.com/pages/42ea4a/)
#### 执行SQL分析打印
[执行SQL分析打印](https://baomidou.com/pages/833fab/)
#### 数据安全保护
[数据安全保护](https://baomidou.com/pages/e0a5ce/)
#### 多数据源
[多数据源](https://baomidou.com/pages/a61e1b/)
#### MybatisX快速开发插件
[MybatisX快速开发插件](https://baomidou.com/pages/ba5b24/)
#### 企业高级特性
[企业高级特性](https://baomidou.com/pages/1864e1/)

### 插件

#### 插件主体
[插件主体](https://baomidou.com/pages/2976a3/)
#### 分页插件
[分页插件](https://baomidou.com/pages/97710a/)
#### 乐观锁插件
[乐观锁插件](https://baomidou.com/pages/0d93c0/)
#### 多租户插件
[多租户插件](https://baomidou.com/pages/aef2f2/)
#### 防全表更新与删除插件
[防全表更新与删除插件](https://baomidou.com/pages/614bb2/)
#### 动态表名插件
[动态表名插件](https://baomidou.com/pages/2a45ff/)
# Mybatis
[Mybatis](https://mybatis.org/mybatis-3/)

![mybatis](mybatis.png)

Mybatis的主要功能是利用xml或注解来编写数据库查询代码。把用于业务处理的Java对象和数据库数据做了映射。

xml形式的Mapper文件和类似`@Select`、`@Insert`、`@Update`、`@Delete`等注解发挥了同样的作用。

## MyBatis 注解用法
[Mybatis 注解用法](Mybatis%20注解用法.md)
[MyBatis 联表查询](MyBatis%20联表查询.md)

基本使用
分页 API
需要依赖 jsqlparser：
[(154条消息) java.lang.NoSuchMethodError: net.sf.jsqlparser.statement.select.PlainSelect.getGroupBy()Lnet/sf/jsql_筱家小雅的博客-CSDN博客](https://blog.csdn.net/qq_41018670/article/details/120862670)
# Mybatis-Plus 代码生成

[baomidou/mybatis-plus: An powerful enhanced toolkit of MyBatis for simplify development](https://github.com/baomidou/mybatis-plus)

[使用swagger2，数据库comment包含双引号，@ApiModelProperty会报错 · Issue #36 · baomidou/generator](https://github.com/baomidou/generator/issues/36)
[fix: 修复swagger注释的转义双引号. · baomidou/generator@f17fae6](https://github.com/baomidou/generator/commit/f17fae6650444f69fd02098282d5a757af89d367)
#### 生成器配置项
[代码生成器配置新 | MyBatis-Plus](https://baomidou.com/pages/981406/#service-%E7%AD%96%E7%95%A5%E9%85%8D%E7%BD%AE)
数据源配置
全局配置
包配置
模板配置
注入配置
策略配置
模板引擎
#### 普通的面向对象使用方式
```Java
package com.bdilab.dataflow.authority.common.config.mp;
  
import com.baomidou.mybatisplus.annotation.DbType;  
import com.baomidou.mybatisplus.annotation.IdType;  
import com.baomidou.mybatisplus.core.exceptions.MybatisPlusException;  
import com.baomidou.mybatisplus.core.toolkit.StringPool;  
import com.baomidou.mybatisplus.generator.AutoGenerator;  
import com.baomidou.mybatisplus.generator.InjectionConfig;  
import com.baomidou.mybatisplus.generator.config.*;  
import com.baomidou.mybatisplus.generator.config.po.TableInfo;  
import com.baomidou.mybatisplus.generator.config.rules.DateType;  
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;  
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;  
  
import java.util.ArrayList;  
import java.util.List;  
import java.util.Scanner;  
  
/*  
  代码生成器  
  
  @author liran  @since 2021-07-09 */
  public class MysqlGenerator {  
    /**  
     * 读取控制台内容  
     */  
    public static String scanner(String tip){  
        Scanner scanner = new Scanner(System.in);  
        System.out.println("请输入" + tip + ": ");  
        if(scanner.hasNext()){  
            String ipt = scanner.next();  
            if(ipt != null && !"".equals(ipt)){  
                return ipt;  
            }        
		} 
		throw new MybatisPlusException("请输入正确的"+tip+"!");  
    }  
    public static void main(String[] args){  
        //代码生成器  
        AutoGenerator mpg = new AutoGenerator();  
  
        //全局配置  
        GlobalConfig gc = new GlobalConfig();  
        String projectPath = System.getProperty("user.dir");  
        gc.setOutputDir(projectPath+"/src/main/java");  
        gc.setAuthor("liran");  
        gc.setOpen(false);//生成后是否打开资源管理器  
        gc.setFileOverride(false);//重新生成时文件是否覆盖  
        gc.setServiceName("%sService");//去掉Service接口的首字母  
        gc.setIdType(IdType.ASSIGN_UUID);//主键策略  
        gc.setDateType(DateType.ONLY_DATE);//定义生成的实体类中日期类型  
        gc.setSwagger2(false);//开启Swagger2模式  
        mpg.setGlobalConfig(gc);  
  
        //数据源配置  
        DataSourceConfig dsc = new DataSourceConfig();  
        dsc.setUrl("jdbc:mysql://localhost:3306/dataflow?serverTimezone=UTC&useSSL=false");  
        dsc.setDriverName("com.mysql.jdbc.Driver");  
        dsc.setUsername("root");  
        dsc.setPassword("123456");  
        dsc.setDbType(DbType.MYSQL);  
        mpg.setDataSource(dsc);  
  
        //包配置  
        PackageConfig pc = new PackageConfig();  
        String moduleName = scanner("模块名");  
        pc.setParent("cn.edu.xidian.bdilab.dataflow");  
        pc.setController("controller."+moduleName);  
        pc.setEntity("model."+moduleName);  
        pc.setService("service."+moduleName);  
        pc.setServiceImpl("service."+moduleName+".impl");  
        pc.setMapper("mapper."+moduleName);  
        pc.setXml("please-delete-me");  
        mpg.setPackageInfo(pc);  
  
        // 自定义配置  
        InjectionConfig cfg = new InjectionConfig() {  
            @Override  
            public void initMap() {  
                // to do nothing  
            }  
        };        // 如果模板引擎是 freemarker        String templatePath = "/templates/mapper.xml.ftl";  
        // 自定义输出配置  
        List<FileOutConfig> focList = new ArrayList<>();  
        // 自定义配置会被优先输出  
        focList.add(new FileOutConfig(templatePath) {  
            @Override  
            public String outputFile(TableInfo tableInfo) {  
                // 自定义输出文件名 ， 如果你 Entity 设置了前后缀、此处注意 xml 的名称会跟着发生变化！！  
                return projectPath + "/src/main/resources/mapper/" + moduleName  
                        + "/" + tableInfo.getEntityName() + "Mapper" + StringPool.DOT_XML;  
            }        });        cfg.setFileOutConfigList(focList);  
        mpg.setCfg(cfg);  
  
        //策略配置  
        StrategyConfig strategy = new StrategyConfig();  
        strategy.setNaming(NamingStrategy.underline_to_camel);  
        strategy.setColumnNaming(NamingStrategy.underline_to_camel);  
        strategy.setEntityLombokModel(false);  
        strategy.setInclude(scanner("表名，多个英文逗号分割").split(","));  
        strategy.setControllerMappingHyphenStyle(true);  
        //strategy.setTablePrefix(moduleName+"_");  
  
        mpg.setStrategy(strategy);  
        mpg.setTemplateEngine(new FreemarkerTemplateEngine());  
        mpg.execute();  
    }}
```

#### 构建器使用方式
这些配置类的 Builder 类看起来是只有 3.5.2 版本才有的，3.4 好像没有。使用时要注意版本。
```Java
  
import com.baomidou.mybatisplus.annotation.FieldFill;  
import com.baomidou.mybatisplus.annotation.IdType;  
import com.baomidou.mybatisplus.core.mapper.BaseMapper;  
import com.baomidou.mybatisplus.generator.AutoGenerator;  
import com.baomidou.mybatisplus.generator.FastAutoGenerator;  
import com.baomidou.mybatisplus.generator.config.*;  
import com.baomidou.mybatisplus.generator.config.rules.DateType;  
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;  
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;  
import com.baomidou.mybatisplus.generator.fill.Column;  
import com.baomidou.mybatisplus.generator.fill.Property;  
import org.apache.ibatis.annotations.Mapper;  
import org.junit.jupiter.api.Test;  
  
import java.util.Collections;  
  
  
public class MybatisGenerateTest {  
  
  
  protected static DataSourceConfig.Builder dataSourceConfig() {  
    final String MYSQL_URL = "jdbc:mysql://192.168.153.129:3306/dataflow";  
    final String MYSQL_USERNAME = "root";  
    final String MYSQL_PASSWORD = "bdilab@1308";  
  
    return new DataSourceConfig.Builder(MYSQL_URL, MYSQL_USERNAME, MYSQL_PASSWORD);  
  }  
  /**  
   * 策略配置  
   */  
  protected static StrategyConfig.Builder strategyConfig() {  
    StrategyConfig.Builder strategyBuilder =  new StrategyConfig.Builder()  
        .addInclude("dashboard_v2", "diagram")  
        .enableCapitalMode()  
        .enableSkipView()  
        .disableSqlFilter();  
  
    // Entity 配置  
    strategyBuilder.entityBuilder()  
        // .superClass(BaseEntity.class)  
        .disableSerialVersionUID()  
        .enableChainModel()  
        .enableLombok()  
        .enableRemoveIsPrefix()  
        .enableTableFieldAnnotation()  
        .enableActiveRecord()  
        .versionColumnName("version")  
        .versionPropertyName("version")  
        .logicDeleteColumnName("deleted")  
        .logicDeletePropertyName("deleteFlag")  
        .naming(NamingStrategy.underline_to_camel)  
        .columnNaming(NamingStrategy.underline_to_camel)  
        .addSuperEntityColumns("id", "created_by", "created_time", "updated_by", "updated_time")  
        .addIgnoreColumns("age")  
        .addTableFills(new Column("create_time", FieldFill.INSERT))  
        .addTableFills(new Property("updateTime", FieldFill.INSERT_UPDATE))  
        .idType(IdType.AUTO)  
        .formatFileName("%s")  
        .build();  
  
    // Mapper 配置  
    strategyBuilder.mapperBuilder()  
        .superClass(BaseMapper.class)  
        // 设置 Mapper 注解  
        // .enableMapperAnnotation()  
        .mapperAnnotation(Mapper.class)  
        .enableBaseResultMap()  
        .enableBaseColumnList()  
        // 设置缓存实现类  
        // .cache(MyMapperCache.class)  
        .formatMapperFileName("%sMapper")  
        .formatXmlFileName("%sXml")  
        .build();  
  
    // Service 配置  
    strategyBuilder.serviceBuilder()  
        // 设置 service 接口的父类和实现类的父类  
        // .superServiceClass(BaseService.class)  
        // .superServiceImplClass(BaseServiceImpl.class)        .formatServiceFileName("%sService")  
        .formatServiceImplFileName("%sServiceImp")  
        .build();  
  
    // Controller  
    strategyBuilder.controllerBuilder()  
        // 设置 controller 的父类  
        // .superClass(BaseController.class)  
        .enableHyphenStyle()  
        .enableRestStyle()  
        .formatFileName("%sController")  
        .build();  
  
    return strategyBuilder;  
  }  
  /**  
   * 全局配置  
   */  
  protected static GlobalConfig.Builder globalConfig() {  
    return new GlobalConfig.Builder()  
        .outputDir("D:\\bdilab\\projects\\DataFlow\\code\\Dataflow_Develop\\dashboard\\src\\main\\java")  
        .author("cupid5trick")  
        // 生成 kotlin 类  
        // .enableKotlin()  
        .enableSwagger()  
        .dateType(DateType.TIME_PACK)  
        .commentDate("yyyy-MM-dd");  
  }  
  /**  
   * 包配置  
   */  
  protected static PackageConfig.Builder packageConfig() {  
    return new PackageConfig.Builder()  
        .parent("com.bdilab")  
        .moduleName("dashboard")  
        .entity("model")  
        .service("service")  
        .serviceImpl("service.impl")  
        .mapper("mapper")  
        .xml("mapper.xml")  
        .controller("controller");  
  }  
  /**  
   * 模板配置  
   */  
  protected static TemplateConfig.Builder templateConfig() {  
    return new TemplateConfig.Builder();  
  }  
  /**  
   * 注入配置  
   */  
  protected static InjectionConfig.Builder injectionConfig() {  
    // 测试自定义输出文件之前注入操作，该操作再执行生成代码前 debug 查看  
    return new InjectionConfig.Builder().beforeOutputFile((tableInfo, objectMap) -> {  
      System.out.println("tableInfo: " + tableInfo.getEntityName() + " objectMap:");  
//      System.out.println(objectMap);  
    });  
  }  
  // [代码生成器配置新 | MyBatis-Plus](https://baomidou.com/pages/981406/#service-%E7%AD%96%E7%95%A5%E9%85%8D%E7%BD%AE)  @Test  
  public void generateTest() {  
    AutoGenerator generator = new AutoGenerator(dataSourceConfig().build());  
    generator.global(globalConfig().build())  
        .packageInfo(packageConfig().build())  
        .injection(injectionConfig().build())  
        .strategy(strategyConfig().build())  
        .template(templateConfig().build())  
        .execute(new FreemarkerTemplateEngine());  
  
  }}
```

# 原理与架构
[Mybatis通用mapper和动态ResultMap的设计和实现 - 掘金](https://juejin.cn/post/6850418108243869709)