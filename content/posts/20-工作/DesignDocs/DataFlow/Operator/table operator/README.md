---
scope: work
draft: true
---
# 后端处理SQL拼接的实现





Table operator的过滤和分组聚合涉及到调用SQL表达式的问题，由前端进行简单的SQL函数拼接、替换存在编码复杂、不易维护、不易扩展的问题。目前有几个场景不能很好地工作。希望把后端SQL处理部分的代码重构为每一种数据类型对应一个字段类、过滤函数类和聚合函数类，同一控制SQL表达式转换、聚合操作列改名和数据类型适配。



# 针对的问题

## SQL表达式转换

因为dataflow定义的某些操作可能找不到一个SQL函数恰好满足其语义，需要用一组SQL函数的复合表达式来实现这个操作。目前的实现方式是后端通过web API传递一个过滤/聚合操作到SQL表达式模板的映射给前端，前端根据每种操作编写特定的代码把列名、表名、用户输入等填入SQL模板形成可以工作的SQL表达式，后续会把这个表达式作为请求的一个字段发送给后端请求表数据，后端把所有字段拼接成一个完整的SELECT语句查询结果返回给前端。目前这种实现，每有一种操作前后端都需要编写一定量代码来支持这种操作，工作量大、不移维护和扩展。

## 列改名

聚合操作输出的列名依赖具体的SQL语句和ClickHouse内部实现，例如对一列数据进行Distinct Count聚合操作，前端生成一段SQL表达式`count(distinct airuuid.city)`后端执行后返回的列名是`uniqExact(airuuid.city)`，这样输出的列名不能反映操作的语义。

## Dataflow数据类型到CH数据类型的适配



ClickHouse 没有专门的 Boolean 类型，使用 UInt8 代替，用 0 表示 false ，用 1 表示 true 。

> Boolean Values [¶](https://clickhouse.com/docs/en/sql-reference/data-types/boolean/#boolean-values)
>
> There is no separate type for boolean values. Use UInt8 type, restricted to the values 0 or 1.

下面的 SQL 语句可以创建 Boolean 类型的列，但是无法插入 true，false 的值，这里 Boolean 被转换成 Int8。

![image-20211108001223557](README.assets/image-20211108001223557.png)





# 设计方案



## SQL 语句



## 字段类型





## 过滤函数：SQL 表达式转换



## 聚合函数：列改名



![image-20211114144011305](README.assets/image-20211114144011305.png)

