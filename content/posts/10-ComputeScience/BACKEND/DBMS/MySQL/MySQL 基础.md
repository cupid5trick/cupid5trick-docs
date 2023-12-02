---
title: MySQL 基础
author: cupid5trick
created: 2022-11-03 22:29
tags: 
categories: 
access: private
draft: true
lang:
- zh-cn
- en-us
abstract:
keywords:
scope: learn
draft: true
---

Mysql——SELECT 使用篇

# SQL 概述

## 1.1 SQL 分类

### 1.1.1 DDL（数据定义语言）

包含：`CREATE`、`ALTER`、`DROP`、`RENAME`、`TRUNCATE`

主要指的是创建修改表整体属性的过程。用于定义不同的数据库、表、视图、索引等数据库对象，还可以用来创建、删除、修改数据库和数据表的结构。

### 1.1.2 DML（数据操作语言）

`INSERT`、`DELETE`、`UPDATE`、`SELECT`

主要指的是对数据进行操作，使用频率是最高的。用于添加、删除、更新和查询数据库记录，并检查数据完整性。**其中 `SELECT` 是重中之重。**

### 1.1.3 DCL（数据控制语言）

`COMMIT`、`ROLLBACK`、`SAVEPOINT`、`GRANT`、`REVOLE`

主要是控制数据和操作数据的权限。用于定义数据库、表、字段、用户的访问权限和安全级别。



# SQL 语言的规则与规范

## 2.1 基本规则

- SQL 可以写在一行或者多行，为了提高可读性，各字句分行书写，必要时使用缩进。
- 每条命令以 `;`、`\g`、`\G` 三种方式结束
- 关键字不能被缩写也不能分行
- 关于标点符号：
  - 必须保证所有的 `()`、单引号、双引号是成对结束的。
  - 必须使用英文状态下的半角输入方式
  - 字符串型和日期时间类型的数据使用单引号 `''` 表示（**MySQL 不严谨，使用双引号 `""` 也可以，但是 Oracle 就不行**）
  - 列的别名，尽量使用双引号 `""`，而且不建议省略 as

## 2.2 SQL 大小写规范（建议遵守）

- **MySQL 在 Windows 环境下是大小写不敏感的**
- **MySQL 在 Linux 环境下是大小写敏感的**
  - 数据库名、表名、表的别名变量名是严格区分大小写的
  - 关键字、函数名、列名（或字段名）、列的别名（字段的别名）是忽略大小写的
- 推荐采用统一的书写规范
  - 数据库名、表名、表别名、字段名、字段别名等都小写
  - SQL 关键字、函数名、绑定变量等都大写

## 2.3 注释

可以使用以下三种注释结构：

```sql
# 单行注释       （MySQL特有的方式）
-- 单行注释      （--后面必须有一个空格）
/*
	多行注释
*/
```

## 2.4 数据导入方式

导入现有的数据表、表的数据有以下两种方式：

1. 命令行使用：`source` + 文件的全路径名

   ```txt
   source d:\atguigudb.sql;
   ```

2. 基于图形化界面的工具导入数据



# 基本的 SELECT 语句

## 3.1 SELECT... FROM...

语法：

```sql
SELECT		标识选择哪些列，不同的列字段名之间用,隔开，*表示全部列
FROM		标识从哪个表中选择
```

## 3.2 列的别名

- 重命名一个列
- 便于计算
- 紧跟列名，**也可以在列名和别名之间加入关键字 AS，别名使用双引号**，以便在别名中包含空格或特殊的字符并区分大小写。
- **AS 可以省略**（相当于直接空格就可以，但是建议使用 AS，避免产生歧义，同时建议别名用""引起来，防止别名中如果有空格产生问题）
- 建议别名简短，见名知意
- 举例：

```sql
SELECT last_name AS "name", last_age age
From employees;
```

## 3.3 去除重复行

默认情况下，查询会返回所有的行，其中会包含重复的行。

使用 `DISTINCT` 关键字可以进行去重操作

举例：

```sql
SELECT DISTINCT department_id
FROM employees;
```

如果 `DISTINCT` 关键字后面跟多个列名，相当于**联合去重**：即多个字段内容全部相同才会被认为是重复。

同时，如果 `DISTINCT` 关键字在某个字段中间，会发生错误。

## 3.4 空值参与运算

空值：null

所有的运算符或列值遇见 null 值，运算结果都为 null

**注意：在 MySQL 里面，空值不等于空字符串，一个空字符串的长度是 0，而一个空值的长度是空。而且，在 MySQL 里面，空值是占用空间的！！**

**如果参与运算的列值可能会出现 null，那么我们一般会引入 `IFNULL` 关键字将 null 值进行转换再进入运算。**

## 3.5 着重号

如果字段、表名和系统保留字或者关键字冲突，使用时需要使用着重号来引用起来，表示不是系统的保留字和关键字。

举例：

```sql
SELECT * FROM `ORDER`;     #从ORDER表中查找数据，但是ORDER是系统保留的排序关键字，所以我们需要用着重号来引起来
```

## 3.6 查询常数

可以在 SELECT 查询结果中增加一列固定的列，这一列的取值是我们自己定义的，而不是从数据表中动态取出的。

通常用于想整合不同的数据源，用常数列作为这个表的标记，就需要查询常数。

比如，我们想对 `employees` 数据表中的员工姓名进行查询，同时增加一列字段 `corporation`，这个字段固定值为"尚硅谷"，可以这么写：

```sql
SELECT '尚硅谷' as corporation, last_name
FROM employees;
```



# 显示表结构

使用 `DESCRIBE` 或者 `DESC` 关键字，可以显示表中字段的详细信息（是否允许为 null，主键信息，默认值等）

```sql
DESCRIBE employees;
DESC departments;
```



# 过滤数据

语法：

```sql
SELECT 字段1,字段2
FROM 表名
WHERE 过滤条件
```

**这里过滤条件的区分大小写和 windows 或者 linux 无关，是一定要区分大小写的！但是 MySQL 不够严谨，它是不区分过滤条件里面的大小写的！！**

```sql
SELECT *
FROM employees
WHERE last_name = 'King';  #这里的King和king在MySQL里面是不区分的，因为MySQL不够严谨，如果在Oracle里面是区分的
```

**`WHERE` 语句的意义指的是，返回过滤条件中结果为 1 的内容。**即每一行进入过滤条件，如果结果为 1，那么会被返回。



# 运算符

## 6.1 算术运算符

包括+、-、*、/、%等操作

### 6.1.1 加减运算符

注意：`SELECT 100 + '1'` 输出的结果是 101。

在 SQL 中，+没有连接的作用，就表示加法运算。此时，会将字符串转换为数值。（隐式转换）

注意：`SELECT 100 + 'a'` 输出的结果是 100。**此时将'a'看作 0 来处理加减。**

注意：`SELECT 100 + NULL` 输出的结果是 null，空值参与运算结果为空。

通过加减运算结果得到以下结论：

- 一个整数类型数值和整数加减，结果是整数
- 一个整数和浮点数进行加减，结果是浮点数
- 加减法的优先级相同
- 在 Java 中+可能表示字符串拼接，但是 SQL 中不存在这种情况，会将非数值类型转换为数值类型，如果转换不成功，那么按照数值 0 进行计算（上面的'a'情况）MySQL 中字符串的拼接使用字符串函数 `CONCAT()` 实现

### 6.1.2 乘除运算符

通过乘除运算结果得到以下结论：

- 一个数乘以 1 或者除以 1 还是原数
- 一个数乘以浮点数 1 或者除以浮点数 1 后变成浮点数，数值与原数相同
- 一个数除以整数后，变成浮点数
- 一个数除以另一个数，除不尽时，保留小数点后 4 位
- 乘除法优先级相同
- 在 MySQL 中，如果除数为 0，那么结果为 NULL

### 6.1.3 取模运算符

注意：取模的结果的符号（正负号）与被模数的符号一致。

## 6.2 比较运算符

比较运算符队表达式左边操作数和右边操作数进行比较，比较结果为真返回 1，结果为假返回-1，其他情况返回 NULL

符号运算符：

![比较运算符_1](比较运算符_1.PNG)

非符号类型的运算符：

![比较运算符_2](比较运算符_2.PNG)

### 6.2.1 符号比较运算符

#### 6.2.1.1 等于运算符（`=`）

该比较运算符存在隐式转换，如果转换数值不成功，那么就看作为 0，`1 = '1'` 输出结果为 1，但是隐式转换只会存在与不同类型之间，如果两个字符串类型比较不会发生隐式转换。如果两边有一个值为 NULL，那么比较结果为 NULL。（**所以 WHERE 条件中如果使用 `=` 判断是否为 NULL，将不会得到任何结果，因为 NULL 参与运算后得到的结果为 NULL，永远不可能为 1。而 WHERE 字句的意义是返回过滤条件为 1 的内容。所以就不会有查询结果返回**）

```sql
SELECT *
FROM employees
WHERE commission_pct = NULL;  #即使这个字段里面有NULL值，也不会返回，因为NULL参与运算结果为NULL，永远不可能为1，WHERE字句永远不可能返回结果。
```

#### 6.2.1.2 安全等于运算符（`<=>`）

安全等于运算符和等于运算符大部分情况下完全一样，**唯一的区别是安全等于运算符可以用来对 NULL 进行判断。**在两个操作符均为 NULL 时，返回值为 1；当一个操作数为 NULL 时，返回值为 0。

```sql
SELECT *
FROM employees
WHERE commission_pct <=> NULL;  #可以返回commission_pct字段中值为NULL的数据
```

#### 6.2.1.3 不等于运算符（`!=`）

符号左右两边有 NULL 的话，结果一定为 NULL。

### 6.2.2 非符号比较运算符

#### 6.2.2.1 is null \ is not null \ isnull

`IS NULL`、`IS NOT NULL` 和 `<=>` 判断 NULL 的效果一样

`ISNULL()` 是一个函数，用来判断是否是 NULL 值，和 `IS NULL`、`<=>` 判断 NULL 相同，用法如下：

```sql
SELECT *
FROM employees
WHERE ISNULL(commission_pct);  #可以返回commission_pct字段中值为NULL的数据
```

#### 6.2.2.2 LEAST \ GREATEST

求指定范围内的最小值和最大值，如果是字符串，按照字典序依次查找比较。（不是比较字符串长度）

#### 6.2.2.3 BETWEEN... AND

求出范围内的所有值，`BETWEEN 条件下界 AND 条件上界`（查询条件 1 和条件 2 范围内的数据，包含边界）

举例：

```sql
SELECT *
FROM employees
WHERE salary BETWEEN 6000 AND 8000;
#等价于:
WHERE salary >= 6000 AND salary <= 8000;
```

`BETWEEN...AND` 字句的两个条件是不能互换的，**即条件上界和条件下界是不能互换的**

#### 6.2.2.4 IN \ NOT IN

`IN(set) \ NOT IN(set)` 字句是用来查找在\不在 set 集合内的**离散值**，而 `BETWEEN...AND` 字句是查找连续值。

举例：

```sql
#查询部门为10，20，30部门的员工信息
SELECT *
FROM employees
WHERE department_id IN (10,20,30);
#等价于:
WHERE department_id = 10 OR department_id = 20 OR department_id = 30;
```

#### 6.2.2.5 LIKE 

`LIKE` 字句是用来实现模糊查询。

```sql
#查询last_name中包含字符'a'的员工信息
SELECT *
FROM employees
WHERE last_name LIKE '%a%';
# %:代表不确定个数的字符，以上表示只要名字中有a就可以被查到
WHERE last_name LIKE 'a%';
# 以上表示名字中以a开头的
```

```sql
#查询last_name中包含字符'a'且包含'e'的员工信息
#写法1:
SELECT *
FROM employees
WHERE last_name LIKE '%a%' AND last_name LIKE '%e%';
#写法2:
SELECT *
FROM employees
WHERE last_name LIKE '%a%e%' OR last_name LIKE '%e%a%';
```

```sql
#查询第二个字符是'a'的员工信息
SELECT *
FROM employees
WHERE last_name LIKE '_a%';
# _:代表一个不确定的字符
#查询第三个字符是'a'的员工信息
SELECT *
FROM employees
WHERE last_name LIKE '__a%';
```

```sql
#查询第二个字符是'_'且第三个字符是'a'的员工信息
#需要使用转义字符:\
SELECT *
FROM employees
WHERE last_name LIKE '_\_a%';
# _前面用转义字符(\)进行修饰，那么就表示字符'_'，而不是代表一个不确定的字符。

#或者使用ESCAPE关键字描述转义字符
SELECT *
FROM employees
WHERE last_name LIKE '_$_a%' ESCAPE '$';
# 以上表示指定$为转义字符
```

#### 6.2.2.6 REGEXP \ RLIKE（正则表达式）

`REGEXP` 运算符用来匹配字符串，语法格式为：`expr REGEXP 匹配条件`。如果 expr 满足匹配条件，返回 1；如果不满足，返回 0。若 expr 或者匹配条件任意一个为 NULL，则结果为 NULL

![正则表达式_1](正则表达式_1.PNG)

## 6.3 逻辑运算符

![逻辑运算符](逻辑运算符.PNG)

注意：OR 可以和 AND 一起使用，但是使用时注意二者的优先级，由于 AND 的优先级高于 OR，因此先对 AND 两边的操作数进行操作，再与 OR 中的操作数结合。

## 6.4 位运算符

![位运算符](位运算符.PNG)

注意：在一定范围内满足时，每向左移动一位，相当于乘以 2；每向右移动一位，相当于除以 2。

## 6.5 运算符的优先级

![运算符优先级](运算符优先级.PNG)

 

# 排序与分页

## 7.1 排序数据

### 7.1.1 排序基础

如果没有使用排序操作，默认情况下查询返回的数据是按照添加数据的顺序显示的。

使用 `ORDER BY` 对查询到的数据进行排序操作。**默认情况下是升序排序。**

升序：`ASC`、降序：`DESC`

```sql
#按照salary从高到低的顺序显示员工信息
SELECT *
FROM employees
ORDER BY salary DESC;
```

```sql
#我们可以使用列的别名，进行排序（按照salary * 12的结果进行排序，这一列的别名为annual_sal）
SELECT employee_id,salary,salary * 12 annual_sal
FROM employees
ORDER BY annual_sal;
```

可以使用不在 SELECT 列表中的列进行排序。

**列的别名只能在 `ORDER BY` 中使用，不能在 `WHERE` 中使用。**

### 7.1.2 二级排序

```sql
#按照department_id降序，按照salary升序
SELECT *
FROM employees
ORDER BY department_id DESC,salary ASC;
```

可以使用不在 SELECT 列表中的列进行排序。

在二级排序（多列排序）的时候，首先排序的第一列必须有相同的列值，才会对第二列进行排序。如果第一列数据中**所有值都是唯一的**，将不再对第二列进行排序。

## 7.2 分页

查询返回的记录很多，查看起来不方便，怎么可以实现分页查询呢？

假设表里面有 4 条数据，我们只想显示第二条和第三条数据怎么办呢？

使用 `LIMIT` 关键字实现分页操作：

```sql
#需求1：每页显示20条记录，此时显示第1页
SELECT *
FROM empoyees
LIMIT 0,20;
#需求2：每页显示20条记录，此时显示第2页
SELECT *
FROM empoyees
LIMIT 20,20;
#需求3：每页显示20条记录，此时显示第3页
SELECT *
FROM empoyees
LIMIT 40,20;
#需求：每页显示pageSize条记录，此时显示pageNo页
#公式：LIMIT (pageNo - 1) * pageSize,pageSize;
```

`LIMIT` 的规范格式：`LIMIT 位置偏移量 条目数`

如果位置偏移量等于 0，那么可以省略位置偏移量，即 `LIMIT 条目数`

`WHERE... ODERE BY...LIMIT...` 的声明顺序：

```sql
SELECT *
FROM empoyees
WHERE salary > 6000
ORDER BY salary DESC
LIMIT 10;
```

其中 `ORDER BY...` 和 `LIMIT` 是放在 SELECT 语句最后的，并且他们的顺序也是确定的，`ORDER BY` 在 `LIMIT` 之前。

注意：MySQL8.0 新特性：`LIMIT...OFFSET...`

```SQL
#表里面有107条数据，想要显示第32、33条数据
SELECT *
FROM empoyees
LIMIT 2 OFFSET 31;
```

在 MySQL8.0 中，`LIMIT...OFFSET...` 字句偏移量在后面，长度在前面，和原来的 `LIMIT` 相反。

拓展：![LIMIT拓展](LIMIT拓展.PNG)



# 多表查询

## 8.1 笛卡尔积

多表查询可以避免多次简单的 SELECT 查询，降低了 IO 和网络次数。

多表查询如何实现？

以下的方式为**错误示范**，出现了笛卡尔积的错误。

```sql
#错误的实现方式：每个员工与每个部门匹配一遍
SELECT employee_id,department_name
FROM empoylees,departments;
```

笛卡尔乘积是一个数学运算，X 和 Y 的笛卡尔积就是 X 和 Y 的所有可能组合，组合的个数就是两个集合元素个数的乘积数。

错误的原因：**缺少了多表连接的条件。**

笛卡尔积的错误会在下面条件下产生：

- 省略多个表的连接条件
- 连接条件无效
- 所有表中的所有行相互连接

避免笛卡尔积，可以在 `WHERE` 字句中加入有效的连接条件

多表查询的正确方式：需要有连接条件

```sql
SELECT employee_id,department_name
FROM empoylees,departments;
# 两个表的连接条件
WHERE empoylees.`department_id` = departments.`department_id`;
```

```sql
# 如果查询语句中出现了多个表中都存在的字段，则必须指明此字段所在的表（下面的department_id）
SELECT employee_id,department_name,empoylees.department_id
FROM empoylees,departments;
WHERE empoylees.`department_id` = departments.`department_id`;
```

注意：从 SQL 优化的角度，建议**多表查询时，每个字段都指明其所在的表**。

如果多表查询时，产生的 SQL 语句过长，可以给表起别名，在 SELECT 和 WHERE 中使用表的别名。**同时，给表起了别名之后，在 `SELECT` 和 `WHERE` 中必须使用别名，而不能使用表的原名！**

```sql
# 给表起一个别名，使用别名在SELECT和WHERE字句中，减少长度
SELECT emp.employee_id,dept.department_name,emp.department_id
FROM empoylees emp,departments dept;
WHERE emp.department_id = dept.department_id;

# 如下的操作都是错误的，因为SELECT和WHERE字句中使用了表的原名
SELECT empoylees.employee_id,dept.department_name,emp.department_id
FROM empoylees emp,departments dept;
WHERE emp.department_id = departments.department_id;
```

**注意：`WHERE` 字句可以使用表的别名，但是不能使用字段的别名。**

![image-20220224170427843](image-20220224170427843.png)

**结论：如果有 n 个表实现多表查询，则需要至少 n-1 个连接条件。**

## 8.2 多表查询的分类

### 8.2.1 等值连接 vs 非等值连接

根据连接条件区分，条件为等于就是等值连接，条件为不等于就是非等值连接。

非等值连接的例子：

```sql
# 查询每个员工的工资及其工资等级，等级是按照范围内的工资划分的
SELECT e.last_name,e.salary,j.grade_level
FROM empoylees e,job_grades j;
WHERE e.salary BETWEEN j.lowest_sal AND j.highest_sal;
```

### 8.2.2 自链接 vs 非自链接

自链接就是自己表和自己表进行连接

自链接的例子：

```sql
#查询员工id，员工姓名，及其管理者的id和姓名
SELECT emp.employee_id,emp.lastname,mgr.employee_id,mgr.lastname   
#管理者也是一个员工，也在员工信息表中
FROM empoylees emp,empoylees mgr
WHERE emp.manager_id = mgr.employee_id;
```

### 8.2.3 内连接 vs 外连接

内连接：合并具有同一列的两个以上表的行，结果集中**不包含一个表与另一个表不匹配的行**。

外连接：合并具有同一列的两个以上表的行，结果集中除了包含一个表与另一个表匹配的行以外，**还查询到了左表或者右表中不匹配的行**。

外连接的分类：左外连接和右外连接和满外连接，左外连接就是只查左表中不匹配的行，右外连接就是只查右表中不匹配的行，满外连接就是左表和右表不匹配的行都会查出来。

如果是左外连接，连接条件左表称为**主表**，右表称为**从表**。右外连接反之。

```sql
# 目标：查询所有的员工的last_name,department_name信息（所有，这个词一定指的是外连接，因为可能存在不匹配数据）

# SQL92语法实现内连接：见上
# SQL92语法实现外连接：使用 +  ------- MySQL不支持SQL92语法的外连接（经典白学属于是）
SELECT e.last_name,d.department_name
# 员工表写在左边，相当于需要使用左外连接
FROM employees e, departments d
WHERE e.department_id = d.department_id(+);   # MySQL会报错，寄，Orcale支持


# SQL99语法中使用JOIN...ON的方式实现多表查询，这种方式也能解决外连接的问题，MySQL也是这么支持的

# SQL99语法实现内连接：(将连接条件写在ON语句中，而不是写在WHERE语句中)
SELECT e.last_name,d.department_name
FROM employees e JOIN departments d
ON e.department_id = d.department_id;
#三张表内连接使用JOIN...ON..语句
SELECT e.last_name,d.department_name,l.city
FROM employees e JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = l.location_id;

# SQL99语法实现外连接：(左外连接——LEFT OUTER JOIN，OUTER可以省略掉)
SELECT e.last_name,d.department_name
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id = d.department_id;
# SQL99语法实现外连接：(右外连接——RIGHT OUTER JOIN，OUTER可以省略掉)
SELECT e.last_name,d.department_name
FROM employees e RIGHT OUTER JOIN departments d
ON e.department_id = d.department_id;
# SQL99语法实现外连接：(满外连接——FULL OUTER JOIN，OUTER可以省略掉)  ---- MySQL不支持，寄
SELECT e.last_name,d.department_name
FROM employees e FULL OUTER JOIN departments d  # MySQL不支持，Oracle支持。无语了属于是
ON e.department_id = d.department_id;  

```

![image-20220224173424273](image-20220224173424273.png)

## 8.3 UNION 的使用

利用`UNION`关键字，可以给出多条 SELECT 语句，并将他们的结果组合成单个结果集。合并时，两个表对应的列数和数据类型必须相同，并且相互对应。各个 SELECT 语句之间使用`UNION`或者`UNION ALL`关键字分隔。

`UNOIN` : 执行去重操作

`UNION ALL` : 不执行去重操作

![image-20220224190824307](image-20220224190824307.png)

![image-20220224190857499](image-20220224190857499.png)

## 8.4 使用 SQL99 实现 7 种 JOIN

![image-20220224191409320](image-20220224191409320.png)

```sql
# 中图：内连接
SELECT e.last_name,d.department_name
FROM employees e JOIN departments d
ON e.department_id = d.department_id;

# 左上图：左外连接
SELECT e.last_name,d.department_name
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id = d.department_id;

# 右上图：右外连接
SELECT e.last_name,d.department_name
FROM employees e RIGHT OUTER JOIN departments d
ON e.department_id = d.department_id;

# 左中图：相当于左上图的内容里面，去掉中间的部分，而中间的部分就是d.department_id不是NULL的
# 因为左连接左边肯定不是空的，可能出现左边不空右边不空 或者左边不空右边空的情况，去掉右边不空的情况即可（左右都不空就是内连接，属于中图）
SELECT e.last_name,d.department_name
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id = d.department_id
WHERE d.department_id IS NULL;

# 右中图：右上图的内容里面，去掉中间的部分，同上，中间的部分就是e.department_id不是NULL的
# 因为右连接右边肯定不是空的，可能出现右边不空左边不空 或者 右边不空左边空的情况，去掉左边不空的情况即可（左右都不空就是内连接，属于中图）
SELECT e.last_name,d.department_name
FROM employees e RIGHT OUTER JOIN departments d
ON e.department_id = d.department_id
WHERE e.department_id IS NULL;

# 左下图：满外连接
# 方式1:左上图 UNION ALL 右中图
SELECT e.last_name,d.department_name
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id = d.department_id
UNION ALL
SELECT e.last_name,d.department_name
FROM employees e RIGHT OUTER JOIN departments d
ON e.department_id = d.department_id
WHERE e.department_id IS NULL;
# 方式2:右上图 UNION ALL 左中图
SELECT e.last_name,d.department_name
FROM employees e RIGHT OUTER JOIN departments d
ON e.department_id = d.department_id
UNION ALL
SELECT e.last_name,d.department_name
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id = d.department_id
WHERE d.department_id IS NULL;

# 右下图：左中图 UNION ALL 右中图
SELECT e.last_name,d.department_name
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id = d.department_id
WHERE d.department_id IS NULL
UNION ALL
SELECT e.last_name,d.department_name
FROM employees e RIGHT OUTER JOIN departments d
ON e.department_id = d.department_id
WHERE e.department_id IS NULL;
```

## 8.5 SQL99 语法的新特性

### 8.5.1 自然连接

`NATURAL JOIN`用来表示自然连接。自然连接可以理解为 SQL92 中的等值连接。它会帮你自动查询两张连接表中**所有相同的字段**，然后进行等值连接。（如果只想部分字段，两张表有两个相同的字段，但是我只想按照一个字段去进行连接，这个就不能够实现，不够灵活）

```sql
#SQL92中：将两个表的全部相同字段匹配进行等值连接
SELECT emp.employee_id,dept.department_name,emp.department_id
FROM empoylees emp JOIN departments dept
ON emp.department_id = dept.department_id
AND emp.manager_id = dept.manager_id;

#SQL99中：使用自然连接来代替SQL92中所有字段的等值连接
SELECT emp.employee_id,dept.department_name,emp.department_id
FROM empoylees emp NATURAL JOIN departments dept;
```

### 8.5.2 USING 的使用 

当使用两张表的字段相同时，可以使用 `USING` 代替 `ON`，只需要在 `USING` 的括号内填入同名的字段（不能使用在自链接中，因为自链接中的字段不一样）

```SQL
SELECT emp.employee_id,dept.department_name,emp.department_id
FROM empoylees emp JOIN departments dept
ON emp.department_id = dept.department_id;

# 等价于
SELECT emp.employee_id,dept.department_name,emp.department_id
FROM empoylees emp JOIN departments dept
USING (department_id);
```

## 8.6 小结

表连接的约束条件有三种方式：

- `WHERE` : 适用于所有关联查询
- `ON` : 只能和 `JOIN` 一起使用，只能写关联条件。
- `USING` : 只能和 `JOIN` 一起使用，而且要求两个关键字在关联表中名称一致，而且只能表示关联字段相等

**推荐使用 `ON` 来表示表连接的约束条件。**

注意：**我们需要控制连接表的数量**。多表连接时很耗费性能的一件事情，多个表连接相当于 for 循环嵌套一样消耗资源。

![image-20220224194218280](image-20220224194218280.png)



# 单行函数

单行函数的定义：

- 操作数据对象
- 接受参数返回一个结果
- **只对一行进行变换**
- **每行返回一个结果**
- 可以嵌套
- 参数可以是一列或者一个值

## 9.1 数值函数

### 9.1.1 基本函数

![image-20220225100815238](image-20220225100815238.png)

其中 `RAND()` 操作是伪随机数，`RAND(x)` 函数中，当填入的 x 值相同时，产生的随机数相同。

`ROUND(x,y)` 函数中 y 可以为负数，**相当于往前看一位**。`ROUND(123.456,-1)` 的结果是 120（将个位进行四舍五入，然后变成 0，结果为 120）

同理，`TRUNCATE(x,y)` 中 y 也可以为负数，**相当于往前看一位，`TRUNCATE(123.456,-1)`**结果是 120（将个位数字 3 直接进行截断，变成 0 即可）

### 9.1.2 角度与弧度函数

![image-20220225101850436](image-20220225101850436.png)

### 9.1.3 三角函数

![image-20220225101911032](image-20220225101911032.png)

![image-20220225102651818](image-20220225102651818.png)

### 9.1.4 指数和对数

![image-20220225102752940](image-20220225102752940.png)

### 9.1.5 进制间的转换

![image-20220225102907449](image-20220225102907449.png)

## 9.2 字符串函数

![image-20220225103237510](image-20220225103237510.png)

**注意：SQL 中字符串的索引是从 1 开始的！**`LAPD` 可以实现右对齐的效果（填充空格），同理 `RPAD` 可以实现左对齐。

![image-20220225104541751](image-20220225104541751.png)

![image-20220225105228133](image-20220225105228133.png)

## 9.3 日期与时间类型

### 9.3.1 获取日期、时间

![image-20220225110510061](image-20220225110510061.png)

### 9.3.2 日期与时间戳转换

![image-20220225110744670](image-20220225110744670.png)

### 9.3.3 获取月份、星期、星期数、天数等函数

![image-20220225111033691](image-20220225111033691.png)

### 9.3.4 日期的操作函数

![image-20220225111454556](image-20220225111454556.png)

![image-20220225111601252](image-20220225111601252.png)

### 9.3.5 时间和秒钟转换函数

![image-20220225111716542](image-20220225111716542.png)

### 9.3.6 计算日期和时间的函数

![image-20220225111949135](image-20220225111949135.png)

其中`expr`是一个数值，比如指定日期加上 1 年、减少 2 个月等，这个数值就是由`expr`指定的。

其中表示月份和日期这种两个参数的，需要用特殊的`expr`，中间使用下划线连接，并且外部整体需要用单引号，如下所示：

![image-20220225112336582](image-20220225112336582.png)

![image-20220225120523544](image-20220225120523544.png)

### 9.3.7 日期的格式化与解析

格式化：日期——>字符串

解析：字符串——>日期

此时我们谈的是日期的显式格式化和解析，**其中格式化的逆过程，字符串 str 和 fmt 的规则必须完全一致，才会被转化为一个合理的日期，否则会返回 null**

![image-20220225121313683](image-20220225121313683.png)

![image-20220225121728750](image-20220225121728750.png)

![image-20220225121844273](image-20220225121844273.png)

**其中 `GET_FORMAT` 方法可以用来便捷的获取 fmt（即获取某一种时间的格式）**，下图展示了 `GET_FORMAT` 可以获得的时间格式：

![image-20220225122522708](image-20220225122522708.png)

## 9.4 流程控制函数

![image-20220225192440119](image-20220225192440119.png)

```sql
# CASE...WHEN...举例：按照员工薪资分类重命名为details，并查询姓名和部门编号
SELECT last_name,salary,CASE WHEN salary >= 15000 TEHN '超高薪'
						   WHEN salary >= 10000 TEHN '高薪'
						   WHEN salary >= 8000 TEHN '中薪'
						   ELSE '低薪' END AS "details",department_id
FROM employees;
```

```sql
/*
查询部门号为10，20，30的员工信息
如果为10 打印工资1.1倍，为20 打印工资的1.2倍 为30 打印沟通子的1.3倍 其他部门打印1.4倍
*/
SELECT employee_id,last_name,department_id,salary,CASE department_id 
WHEN 10 THEN salary *1.1
WHEN 20 THEN salary *1.2
WHEN 30 THEN salary *1.3
ELSE salary *1.4
END "deatils"
FROM employees;

```

## 9.5 加密与解密函数

![image-20220225194946495](image-20220225194946495.png)

注意：其中 MySQL8.0 中只能使用`MD5、SHA`两个函数（其余被弃用），在 MySQL5.7 中都可以使用。

## 9.6 MySQL 信息函数

![image-20220225195658063](image-20220225195658063.png)

## 9.7 其他函数

![image-20220225200726031](image-20220225200726031.png)

其中 `FORMAT` 函数如果 n 小于等于 0，则只保留整数部分。`INET_ATON` 的转换规则是：第一个数字乘以 256 的 3 次方+第二个数字乘以 256 的 2 次方+第三个数字乘以 256+第四个数字（ipv4 一共由四个数字组成，这里的顺序从左到右即可）

#  10. 聚合函数

聚合函数**作用于一组数据**，并对一组数据**返回一个值**。

**注意！！在 MySQL 中，聚合函数是不能嵌套使用的！！**（单行函数可以，并且在 Oracle 中聚合函数可以嵌套）

## 10.1 5 大常用聚合函数

常见聚合函数类型：

- `AVG()`
- `SUM()`
- `MAX()`
- `MIN()`
- `COUNT()`

### 10.1.1 `AVG` / `SUM`

```sql
# 查询工资的平均数
SELECT AVG(salary)
FROM employees;
# 查询一共要发多少工资
SELECT SUM(salary)
FROM employees;
```

在 MySQL 中，以上两个函数内如果填写字符串类型，输出结果为 0（相当于把字符串隐式转换成 0，是没有意义的操作，Oracle 会直接报错）

**`AVG` / `SUM` 是只适用于数值类型的字段（或变量），并且 `SUM()` 会自动过滤 NULL 值**

### 10.1.2 `MAX` / `MIN`

```sql
# 查询工资的最大值
SELECT MAX(salary)
FROM employees;
# 查询工资的最小值
SELECT MIN(salary)
FROM employees;
# 查询人名的最大值
SELECT MAX(last_name)
FROM employees;
# 查询人名的最小值
SELECT MIN(last_name)
FROM employees;
```

`MAX` / `MIN` 是适用于数值类型，字符串类型，日期时间类型的字段（因为他们自身之间都可以比较大小，所以可以获得最大值和最小值）

### 10.1.3 `COUNT`

计算指定字段在查询结构中出现的个数（**不包含 NULL 值**）

```SQL
# 查询表中的某一列的个数
SELECT COUNT(employee_id),COUNT(salary)
FROM employees;
# COUNT()中间的参数是常数时，结果等于表中记录的个数，所以可以用来简单计算表中有多少条记录
SELECT COUNT(1)
FROM employees;
```

计算表中有多少条记录的方式：

1. `COUNT(*)`
2. `COUNT(1)`
3. `COUNT(具体字段)` ：这个方法**不一定对！**

**注意：`COUNT()` 计算指定字段出现的个数时，是不计算 NULL 值的！！！**

**永远成立**的公式：`AVG = SUM / COUNT`，在这三个函数中，**这个公式永远成立。**

```SQL
# 查询公司的平均奖金率
SELECT AVG(commission_pct)
FROM employees;
# 以上做法是错误的，因为如果存在空值，AVG() = SUM() / COUNT(),而COUNT()函数会过滤空值，很明显是错误的，所以不能直接使用AVG()函数进行公司平均奖金的计算！！！
# 正确方式：
SELECT SUM(commission_pct) / COUNT(IFNULL(commission_pct,0))
FROM employees;
# 正确方式2：如果为空，相当于加上0，来表示这个人就没有这个值，那么COUNT()也不会过滤掉
SELECT AVG(IFNULL(commission_pct,0))
FROM employees;
```

那么当统计表中的记录数，使用上面三种的 `COUNT` 方式（假设字段不为空时），哪个效率更高呢？

具体结果和存储引擎相关，在下篇的调优与优化中，我们会详细的讨论这个问题！

如果使用的时 MyISAM 存储引擎，则三者的效率相同，都是 O (1)

如果使用 InnoDB 存储引擎，则三者效率是不一样的，`COUNT(*) = COUNT(1) > COUNT(字段)`

## 10.2 `GROUP BY`

可以使用 `GRUOP BY` 字句将表中的数据分组成若干组

```sql
# 查询各个部门的平均工资，最高工资（即按照部门进行分组来求值）
SELECT AVG(salary),MAX(salary)
FROM employees
GROUP BY department_id;
```

使用多个列进行分组实例如下：

```sql
# 查询各个department_id,job_id的平均工资
SELECT AVG(salary)
FROM employees
GROUP BY department_id,job_id;
# 或
SELECT AVG(salary)
FROM employees
GROUP BY job_id,department_id;
```

 **`GROUP BY` 的分组具有交换律，即分组条件的前后顺序没有关系。**

**注意：`SELECT中出现的非组合函数字段` 一定要出现在 `GROUP BY` 中！！反之不一定出现**

```sql
# 错误的！！！(即使不报错，也是不正确的操作，这个job_id没有出现在GROUP BY中)
SELECT department_id,job_id,AVG(salary)
FROM employees
GROUP BY department_id;
```

结论：

- `GROUP BY` 声明在 `FROM` 后面、`WHERE` 后面、`ORDER BY` 前面、`LIMIT` 前面。
- MySQL 中的 `GROUP BY` 使用 `WITH ROLLUP` (除了预定的分组之外，最后会将全部数据作为一个整体来计算一次)

```sql
SELECT department_id,AVG(salary)
FROM employees
GROUP BY department_id WHIT ROLLUP;
```

注意：当使用 `WITH ROLLUP` 时，不能同时使用 `ORDER BY` 字句排序结果，他们是互斥的。

## 10.3 `HAVING`

`HAVING` 是用来过滤数据的（经常和 `GROUP BY` 一起使用）

```sql
# 查询各个部门中最高工资比10000高的部门信息
# 错误的写法：
SELECT department_id,MAX(salary)
FROM employees
WHERE MAX(salary) > 10000 
GROUP BY department_id;

# 正确的写法：
SELECT department_id,MAX(salary)
FROM employees
GROUP BY department_id
HAVING MAX(salary) > 10000;
```

```SQL
# 查询部门id为10，20，30，40这四个部门的最高工资比10000高的部门信息
# 方式1：推荐，执行效率高于方式2（具体原因在SQL底层执行原理中讲到）
SELECT department_id,MAX(salary)
FROM employees
WHERE department_id IN (10,20,30,40)
GROUP BY department_id
HAVING MAX(salary) > 10000;
# 方式2：
SELECT department_id,MAX(salary)
FROM employees
GROUP BY department_id
HAVING MAX(salary) > 10000 AND department_id IN (10,20,30,40);
```

结论：

- 如果**过滤条件中使用了聚合函数**，则必须要使用 `HAVING` 来替换 `WHERE` 来声明这个过滤条件，否则会报错
- 同时 `HAVING` 必须声明在 `GRUOP BY` 的后面
- 开发中，我们使用 `HAVING` 的前提是 SQL 中使用了 `GROUP BY`
- 当过滤条件中没有聚合函数时，则此过滤条件声明在 `WHERE` 中或 `HAVING` 都可以，建议声明在 `WHERE` 中

`WHERE` 和 `HAVING` 的对比:

1. 适用范围上来说，`HAVING` 的适用范围更广
2. 如果过滤条件中没有聚合函数，`WHERE` 的执行效率高于 `HAVING`

![image-20220226094210355](image-20220226094210355.png)

## 10.4 `SELECT` 的执行过程（执行原理）

### 10.4.1 `SELECT` 语句的完整结构

```sql
# SQL92语法
SELECT ...,....,...(存在聚合函数)
FROM ...,...,...
WHERE 多表连接条件 AND 不包含聚合函数的过滤条件
GROUP BY ....,....
HAVING 聚合函数的过滤条件
ORDER BY ....,....(ASC/DESC)
LIMIT ...,...

# SQL99语法
SELECT ...,....,...(存在聚合函数)
FROM ... (LEFT / RIGHT) JOIN ... ON 多表的连接条件
(LEFT / RIGHT) JOIN ... ON
WHERE 多表连接条件 AND 不包含聚合函数的过滤条件
GROUP BY ....,....
HAVING 聚合函数的过滤条件
ORDER BY ....,....(ASC/DESC)
LIMIT ...,...
```

### 10.4.2 SQL 语句的执行顺序

全部语句的执行过程如下：

`FROM ...,...,... -> ON -> (LEFT/RIGHT) JOIN -> WHERE -> GROUP BY -> HAVING -> SELECT -> DISTINCT -> ORDER BY -> LIMIT`

SELECT 语句执行这些步骤的过程中，每个步骤都会产生一个虚拟表，然后将这些虚拟表传给下一步作为新的输入。

#  11 子查询

子查询指的是一个查询语句嵌套在另一个查询语句的内部。

## 11.1 需求分析与问题解决

问题：谁的工资比 Abel 高？

```sql
# 谁的工资比Abel高？
# 方法1：使用两步SQL进行组合
SELECT last_name,salary
FROM employees
WHERE last_name = 'Abel';

SELECT last_name,salary
FROM employees
WHERE salary > 11000;

# 方式2：自链接
SELECT e2.last_name,e2.salary
FROM employees e1,employees e2
WHERE e2.salary > e1.salary
AND e1.last_name = 'Abel';

#方式3：子查询
SELECT last_name,salary
FROM employees
WHERE salary > (
    SELECT salary
	FROM employees
	WHERE last_name = 'Abel'
);
```

子查询可以分为外查询和内查询。外查询也叫做主查询，内查询也叫做子查询。

注意事项：

- 子查询在主查询之前一次执行完成
- 子查询的结果被主查询使用
- 子查询要包含在括号内：
  - 将子查询放在比较条件的右侧
  - 单行操作符对应单行子查询，多行操作对应多行子查询

子查询的分类：（两种分类方法）

1. 从内查询返回的结果的条目数：返回一条就是单行子查询，返回多条就是多行子查询
2. 内查询是否被执行多次：子查询只执行一次就是不相关子查询，执行多次则是相关子查询

## 11.2 单行子查询

单行子查询指的是子查询内容返回结果只有一行。

![image-20220226163338284](image-20220226163338284.png) 

```SQL
# 查询工资大于149号员工工资的员工信息
SELECT employee_id,last_name,salary
FROM employees
WHERE salary > (
    SELECT salary
	FROM employees
	WHERE employee_id = 149;
);

# 返回job_id与141号员工相同，salary比143号员工多的员工姓名,job_id和工资
SELECT last_name,job_id,salary
FROM employees
WHERE job_id = (
    SELECT job_id
    FROM employees
    WHERE job_id = 141
)
AND salary > (
    SELECT salary
    FROM employees
    WHERE job_id = 143
);

# 返回公司工资最少的员工的last_name,job_id和salary
SELECT last_name,job_id,salary
FROM employees
WHERE salary = (
    SELECT MIN(salary)
    FROM employees
)

# 查询与141号员工的manager_id和departmant_id相同的其他员工的employee_id,manager_id,departmant_id
# 方式1：
SELECT employee_id,manager_id,departmant_id
FROM employees
WHERE manager_id = (
    SELECT manager_id
    FROM employees
    WHERE employee_id = 141
)
AND departmant_id = (
    SELECT departmant_id
    FROM employees
    WHERE employee_id = 141
)
AND employee_id != 141;
# 方式2：成对查询
SELECT employee_id,manager_id,departmant_id
FROM employees
WHERE (manager_id,departmant_id) = (
    SELECT manager_id,departmant_id
    FROM employees
    WHERE employee_id = 141
)
AND employee_id != 141;


```

子查询的编写技巧：

1. 从里往外写：如果子查询相对比较复杂，建议从里往外写。
2. 从外往里写：如果子查询相对比较简单，建议从外往里写。如果是相关子查询，通常都是从外往里写。

`HAVING`中的子查询：首先执行子查询，然后向主查询中的`HAVING`返回结果

```SQL
# 查询最低工资大于50号部门最低工资的部门id和其最低工资
SELECT department_id,MIN(salary)
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING MIN(salary) > (
    SELECT MIN(salary)
    FROM employees
    WHERE department_id = 50
);
```

`CASE`中的子查询：

```SQL
# 查询员工的employee_id,lastname和location
其中，若员工的department_id与location_id为1800的department_id相同，
则location为Canada,其余为USA
SELECT employee_id,lastname,CASE department_id WHEN (
    											SELECT department_id
    											FROM departments
    											WHERE location_id = 1800
											) THEN 'Canada'
                            					ELSE 'USA' END "location"
FROM employees;
```

子查询的空值问题：如果子查询结果为空，不会报错，但是结果集没有任何结果。

非法使用子查询：**多行子查询不能使用单行比较符**，会产生报错。

## 11.3 多行子查询

多行子查询指的是子查询内容返回结果有多行。

![image-20220226173415390](image-20220226173415390.png)

```sql
# IN
# 查询各个部门的最低工资，同时寻找等于最低工资的这些人
SELECT employee_id,last_name
FROM employees
WHERE salary IN (
    SELECT MIN(salary)
    FROM employees
    GROUP BY deparyment_id
);

# ANY
# 返回其他job_id中比job_id为'IT_PROG'部门任一工资低的员工的员工号，姓名job_id以及salary
SELECT employee_id,last_name,job_id,salary
FROM employees
WHERE job_id != 'IT_PROG'
AND salary < ANY (
    SELECT salary
    FROM employees
    WHERE job_id = 'IT_PROG'
);

#ALL
# 返回其他job_id中比job_id为'IT_PROG'部门所有工资低的员工的员工号，姓名job_id以及salary
SELECT employee_id,last_name,job_id,salary
FROM employees
WHERE job_id != 'IT_PROG'
AND salary < ALL (
    SELECT salary
    FROM employees
    WHERE job_id = 'IT_PROG'
);

#查询平均工资最低的部门id
SELECT department_id
FROM departments
GROUP BY department_id
HAVING AVG(salary) <= ALL(
    SELECT AVG(salary)
    FROM departments
    GROUP BY department_id
);
#老师方法：
SELECT department_id
FROM departments
GROUP BY department_id
HAVING AVG(salary)  = (
    SELECT MIN(avg_sal)
	FROM(
        SELECT AVG(salary) avg_sal
        FROM employees
        GROUP BY department_id
	) t_dept_avg_sal
);

```

同时注意，**内查询中是否有 Null 值会影响整体的判断**，应该思考清楚 NULL 值对于自身查询的影响。

![image-20220226175914979](image-20220226175914979.png)

上面示例子查询结果会有一个 NULL 值，而`NOT IN`和 NULL 比较会产生问题，导致没有查询结果产生。

## 11.4 相关子查询

### 11.4.1 子查询执行流程

当内部子查询需要执行多次的情况下，就叫做相关子查询。

如果子查询的执行依赖于外部查询，通常情况下都是因为子查询的表用到了外部的表，并进行了条件关联，因此每执行一次外部查询，子查询都要重新计算一次，这样的子查询就称之为关联子查询。

相关子查询按照一行接一行的顺序执行，主查询的每一行都执行一次子查询。

![image-20220226213057093](image-20220226213057093.png)

```sql
# 查询员工中工资大于本部门平均工资的员工的last_name,salary以及department_id
# 方式1：子查询
SELECT last_name,salary,department_id
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e1.department_id
);
# 方式2：多表查询
SELECT e.last_name,e.salary,e.department_id
FROM employees e JOIN (
        SELECT department_id,AVG(salary) avg_sal   --重命名字段名
        FROM employees
        GROUP BY department_id
    ) mine   --重命名表名
ON e.department_id = mine.department_id
WHERE e.department_id = mine.department_id
AND e.salary > mine.avg_sal

# 查询员工的id,salary,按照department_name升序排序
SELECT employee_id,salary
FROM employee e
ORDER BY (
    SELECT department_name
    FROM department d
    WHERE e.department_id = d.department_id
) ASC;
```

**结论：子查询的位置可以在除了`GROUP BY 、LIMIT`之外的所有语句中使用！！**

```sql
# 查询调岗次数两次以上的员工，输出这些员工的employee_id,last_name及其job_id
SELECT employee_id,last_name,job_id
FROM employees e
WHERE 2 <= (
    SELECT COUNT(*)
    FROM job_history j
    WHERE e.employee_id = j.employee_id
);
```

### 11.4.2 `EXISTS 、NOT EXISTS`关键字：

关联子查询通常也会和`EXISTS 、NOT EXISTS`操作符一起来使用，用来检查子查询中是否存在满足条件的行。

如果子查询中不存在满足条件的行：

- 条件返回 FALSE
- 继续在子查询中寻找

如果在子查询中存在满足条件的行：

- 不在子查询中继续寻找
- 条件返回 TRUE

`NOT EXISTS` 关键字表示，如果不存在某种条件，则返回 TRUE，否则返回 FALSE

```SQL
# 查询公司管理者的employee_id,last_name,job_id,department_id信息
# 方式1：自链接
SELECT DISTINCT mgr.employee_id,mgr.last_name,mgr.job_id,mgr.department_id
FROM employees emp JOIN employees mgr
ON emp.manager_id = mgr.employee_id
# 方式2：子查询
SELECT employee_id,last_name,job_id,department_id
FROM employees
WHERE employee_id IN (
    SELECT DISTINCT manager_id
    FROM employees
);
# 方式3：使用EXISTS
SELECT employee_id,last_name,job_id,department_id
FROM employees e1
WHERE EXISTS (
    SELECT *
    FROM employees e2
    WHERE e1.employee_id = e2.manager_id
)
```

上面的 `EXISTS` 关键字相当于，每一次将 e1 表的记录送进来，在 e2 表中进行匹配，如果没有匹配，继续往下找 e2 表的下一条字段。如果匹配上了，直接返回，然后 e1 表将下一条记录送入 e2 表中，继续执行上面的过程即可。

```sql
# 查询departments表中，不存在于empoloyees表中的部门的
department_id和department_name
# 方式1：
SELECT d.department_id,d.department_name
FROM departments d LEFT JOIN empoloyees e
ON d.department_id = e.department_id
WHERE e.department_id IS NULL;
# 方式2：
SELECT department_id,department_name
FROM departments d
WHERE NOT EXISTS(
    SELECT *
    FROM empoloyees e
    WHERE d.department_id = e.department_id
)
```

上面的 `NOT EXISTS` 关键字相当于，d 表传入匹配 e 里面的内容，如果匹配上，那直接丢弃，传入 d 表下一条记录开始从 e 表从头匹配；如果没有匹配上，依次匹配 e 表结果，直到匹配到 e 表结束都没有匹配成功时，返回记录，证明不存在。

### 11.4.3 相关更新

![image-20220227105904661](image-20220227105904661.png)

### 11.4.4 相关删除

![image-20220227105925801](image-20220227105925801.png)

### 11.4.5 思考问题：表连接 OR 子查询？

![image-20220227110215689](image-20220227110215689.png)

### 11.4.6 子查询的课后练习（难点）

```sql
# 查询和 任意姓Zlotkey的员工  相同部门的员工姓名和工资
SELECT last_name,salary
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    WHERE last_name = 'Zlotkey'
);
```

```SQL
# 查询工资比公司平均工资高的员工的员工号，姓名和工资
SELECT employee_id,last_name,salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);
```

```sql
# 选择工资大于所有   job_id = 'SA_MAN'的员工的工资   的员工的last_name,job_id,salary
SELECT last_name,job_id,salary
FROM employees
WHERE salary > (
    SELECT MAX(salary)
    FROM employees
    WHERE job_id = 'SA_MAN'
);

# 老师方法：
SELECT last_name,job_id,salary
FROM employees
WHERE salary > ALL (
    SELECT salary
    FROM employees
    WHERE job_id = 'SA_MAN'
);
```

```SQL
# 查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名
SELECT employee_id,last_name
FROM employees
WHERE department_id IN (
    SELECT DISTINCT department_id
    FROM employees
    WHERE last_name LIKE '%u%'
);
```

```sql
# 查询在部门的location_id = 1700的部门工作的员工和员工号
SELECT employee_id,last_name
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE location_id = 1700
);
```

```sql
# 查询管理者是King的员工姓名和工资
SELECT last_name,salary
FROM employees
WHERE manager_id IN (
    SELECT employee_id
    FROM employees
    WHERE last_name = 'King'
);
```

```sql
# 查询工资最低的员工信息：last_name,salary
SELECT last_name,salary
FROM employees
WHERE salary = (
    SELECT MIN(salary)
    FROM employees
);
```

```sql
# 查询平均工资最低的部门信息
SELECT *
FROM departments
WHERE department_id = (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING AVG(salary) <= ALL(
    	SELECT AVG(salary)
    	FROM employees
   	 	GROUP BY department_id
	)
);

# 特殊方式：
SELECT *
FROM departments
WHERE department_id = (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING AVG(salary) = (
        SELECT AVG(salary) avg_sal
        FROM employees
        GROUP BY department_id
        ORDER BY avg_sal ASC
        LIMIT 1
	)
);

# 特殊方式plus:
SELECT d.*
FROM departments d JOIN (
        SELECT department_id,AVG(salary) avg_sal
        FROM employees
        GROUP BY department_id
        ORDER BY avg_sal ASC
        LIMIT 1
) t_dept_avg_sal
ON d.department_id = t_dept_avg_sal.department_id;

```

```sql
# 查询平均工资最低的部门信息和该部门的平均工资（相关子查询）
SELECT d.*,(
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = d.department_id
) avg_sal
FROM departments d
WHERE department_id = (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING AVG(salary) <= ALL(
    	SELECT AVG(salary)
    	FROM employees
   	 	GROUP BY department_id
	)
);
```

```sql
# 查询平均工资最高的job信息 （类似上上题）
# 方式1：
SELECT *
FROM jobs
WHERE job_id = (
    SELECT job_id
    FROM employees
    GROUP BY job_id
    HAVING AVG(salary) >= ALL(
        SELECT ABG(salary)
        FROM employees
        GROUP BY job_id
    )
);

# 其余方式类似上上题
```

```sql
# 查询平均工资高于公司平均工资的部门有哪些
SELECT department_id
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM employees
);
```

```sql
# 查询公司中所有manager的详细信息
# 方式1：自链接
SELECT DISTINCT mgr.employee_id,mgr.last_name,mgr.job_id,mgr.department_id
FROM employees emp JOIN employees mgr
ON emp.manager_id = mgr.employee_id
# 方式2：子查询
SELECT employee_id,last_name,job_id,department_id
FROM employees
WHERE employee_id IN (
    SELECT DISTINCT manager_id
    FROM employees
);
# 方式3：使用EXISTS
SELECT employee_id,last_name,job_id,department_id
FROM employees e1
WHERE EXISTS (
    SELECT *
    FROM employees e2
    WHERE e1.employee_id = e2.manager_id
)

```

```sql
# 查询 各个部门中 最高工资最低的 那个部门的 最低工资是多少
SELECT MIN(salary)
FROM emoloyees
WHERE department_id = (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING MAX(salary) <= ALL (
        SELECT MAX(salary)
        FROM emoloyees
        GROUP BY department_id
    )
);

# 其余方式同上上上题
```

```sql
# 查询平均工资最高部门的manager的详细信息：last_name,department_id,email,salary
SELECT last_name,department_id,email,salary
FROM employees
WHERE employee_id IN (
    SELECT DISTINCT manager_id
    FROM employees
    WHERE department_id = (
        SELECT department_id
        FROM employees
        GROUP BY department_id
        HAVING AVG(salary) >= ALL(
            SELECT AVG(salary)
            FROM employees
            GROUP BY department_id
        )
    )
);

# 其余方式同上题
```

```sql
# 查询部门的部门号，其中不包括job_id是"ST_CLERK"的部门号
# 方式1：
SELECT department_id
FROM departments 
WHERE department_id NOT IN (
    SELECT DISTINCT department_id
    FROM employees 
    WHERE job_id = "ST_CLERK"
);

# 方式2：
SELECT department_id
FROM departments d 
WHERE NOT EXISTS (
    SELECT *
    FROM employees e
    WHERE d.department_id = e.department_id
    AND e.job_id = 'ST_CLERK'
);
```

```sql
# 选择所有没有管理者的员工的last_name
SELECT last_name
FROM employees emp
WHERE NOT EXISTS (
    SELECT *
    FROM employees mgr
    WHERE emp.manager_id = mgr.employee_id
);
```

```sql
# 查询员工号、姓名、雇佣时间、工资，其中员工的管理者为"De Haan"
方式1：
SELECT employee_id,last_name,hire_date,salary
FROM employees
WHERE manager_id IN (
    SELECT employee_id
    FROM employees
    WHERE last_name = 'De Haan'
);
方式2：
SELECT employee_id,last_name,hire_date,salary
FROM employees emp
WHERE EXISTS (
    SELECT employee_id
    FROM employees mgr
    WHERE mgr.last_name = 'De Haan'
    AND emp.manager_id = mgr.employee_id
);
```

```sql
# 查询   各部门中   工资比本部门平均工资    高    的员工的员工号、姓名和工资（相关子查询中原题）
SELECT employee_id,last_name,salary
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e1.department_id = e2.department_id
);
```

```sql
# 查询每个部门下的部门人数大于5的部门名称
SELECT department_name
FROM departments d
WHERE 5 < (
    SELECT COUNT(*)
    FROM employees
    WHERE d.department_id = e.department_id
);
```

```sql
# 查询每个国家下的部门个数大于2的国家编号（此题是否有误？）
# 当一个国家有多个location_id,每一个是1,加起来超过2，那么这里将不会统计到（他只是统计了每个location_id中大于2的，应该是country_id全部对应的location_id加起来大于2的）
SELECT country_id
FROM locations l
WHERE 2 < (
    SELECT COUNT(*)
    FROM departments d
    WHERE l.location_id = d.location_id
);
```

