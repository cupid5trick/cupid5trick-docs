---
scope: work
draft: true
---


# 

操作说明



# 1. 定义与公式

互信息的定义为逐点互信息 （pmi）的期望。逐点互信息是一个二元随机变量：
$$
pmi = \log (\frac{p(X=x, Y=y)}{p(X=x)p(Y=y)})
$$
因此，$\text{MI}=E[pmi]$。由于熵的定义是$\text{H}=E[-\log_2(p(X=x))]$，互信息 $\text{MI}$ 和熵 $\text{H}$ 有下面的关系：


$$
\begin{aligned}\operatorname {I} (X;Y)&{}\equiv \mathrm {H} (X)-\mathrm {H} (X\mid Y)\\&{}\equiv \mathrm {H} (Y)-\mathrm {H} (Y\mid X)\\&{}\equiv \mathrm {H} (X)+\mathrm {H} (Y)-\mathrm {H} (X,Y)\\&{}\equiv \mathrm {H} (X,Y)-\mathrm {H} (X\mid Y)-\mathrm {H} (Y\mid X)\end{aligned}
$$


对于离散型随机变量：
$$
\text{MI}(U, V) = \sum_{i=1}^{|U|}\sum_{j=1}^{|V|}P(i, j)\log\left(\frac{P(i,j)}{P(i)P'(j)}\right)
$$
对于连续型随机变量是相应的一个二重积分。

## 1.1 归一化的变种公式

### eq1: [uncertainty coefficient](https://en.wikipedia.org/wiki/Uncertainty_coefficient)

$$
{\displaystyle C_{XY}={\frac {\operatorname {I} (X;Y)}{\mathrm {H} (Y)}}~~~~{\mbox{and}}~~~~C_{YX}={\frac {\operatorname {I} (X;Y)}{\mathrm {H} (X)}}.}
$$

这个变种公式的计算结果是不对称的。

根据 eiblick MI 操作符界面把互信息计算结果显示为 *uncertaincy_coefficient*，而且计算结果不具有对称性，基本可以确定 einblick 所用的互信息计算公式是 $C_{XY}$。

从目前的查阅过的资料还没有掌握这个公式的实际意义。

### eq2: sklearn [normalized_mutual_info_score](https://scikit-learn.org/stable/modules/clustering.html#id12)

$$
{\displaystyle U(X,Y)=2R=2{\frac {\operatorname {I} (X;Y)}{\mathrm {H} (X)+\mathrm {H} (Y)}}}
$$

# 2. ClickHouse 实现

目前的实现方式：

使用 ClickHouse 的 `entropy` 函数实现离散属性的互信息。计划 Mutual Information 操作符只实现离散型的计算公式（Eq1），限制用户只能选择离散型的属性计算互信息。Einblick 把多种公式包装在一起的模式，用户无法得知自己选用的是什么指标、相应的有什么实际意义。（见 2.2.1 Einblick 对不同数据类型的互信息计算结果不同）。



- [x] 对离散型数据，计算公式采用 Eq1 - uncertaincy coefficient，即：

$$
\text{MI}(X, Y)=\frac{\text{H}(X)+\text{H}(Y)-\text{H}(X,Y)}{\text{H}(X)}
$$



- [x] 离散型属性互信息计算结果与 Einblick 一致
- [ ] 连续型属性结果 偏差很大（可能是 `entropy` 只能正确计算出离散型属性的信息熵）





## 2.1 CH 查询结果和 einblick 计算结果对比（离散型）

ClickHouse 提供了计算信息熵的函数 `entropy(x)`，可以用来实现 uncertaincy coefficient，SQL 语句如下：

```sql
select (entropy(target) + entropy(feature) - entropy(tuple(target, feature))) / entropy(feature) from t;
```

把 einblick 的 car_sales_transactions.csv 和 promotion_leases_transactions.csv 两个数据集导入 ClickHouse，对比 einblick 和 ClickHouse 的查询结果。因为 ClickHouse 对数据类型的限制，建表时 Einblick 中的 布尔字段（true, false）用 String 类型代替。





**计算结果对比（以下是对比结果，SQL 语句在下一个表格提供）**：

|      | target       | feature      | CH 列类型          | ClickHouse                                   | Einblick  |
| ---- | ------------ | ------------ | ------------------ | -------------------------------------------- | --------- |
| 1    | `Type`       | `Model`      | `String, String`   | 1                                            | 1         |
| 2    | `Model`      | `Type`       |                    | 0.6246330731458857                           | 0.624     |
| 3    | `Used`       | `CarMileage` | `String, Float32`  | 0.9999999999999283                           | 0.993     |
| 4    | `CarMileage` | `Used`       | -                  | 0.11305682229262375                          | 0.152     |
| 5    | `Price`      | `CarMileage` | `Float32, Float32` | **0.5163150827726563** (0.176380101046852)   | **0.107** |
| 6    | `CarMileage` | `Price`      |                    | **0.9423031274790961** (0.27913394092219185) | **0.191** |
| 7    | `Used`       | `Price`      | `String, Float32`  | **0.9968880354572393**                       | **0.76**  |
| 8    | `Price`      | `Used`       |                    | 0.06175431910982507                          | 0.065     |
|      |              |              |                    |                                              |           |

加粗的三行（5, 6, 7）两者计算结果偏差很大，它们的共同特征是参与计算的属性包含浮点类型的数据列。可能的原因是 ClickHouse 的 `entropy` 函数对连续型的数据列（包含浮点类型的列）采取了离散式的计算方法，导致结果严重偏大。

对 6 的情况，对列进行均值 - 标准差的归一化以后，利用 ClickHouse 的`round` 函数把连续列离散化，然后套用`entropy` 函数计算互信息。对比发现可以显著缩小偏差，但和 Einblick计算结果的差距还是很大（括号里是离散化的计算结果）。（使用的 SQL 语句序号分别是9、10）

对连续值的列还要寻找其他计算方式。

**SQL 查询语句**：

|      | SQL 语句                                                     |
| ---- | ------------------------------------------------------------ |
| 1    | `select (entropy(Model) + entropy(Type) - entropy(tuple(Model, Type))) / (entropy(Type)) from operator_mi.car_sales` |
| 2    | `select (entropy(Model) + entropy(Type) - entropy(tuple(Model, Type))) / (entropy(Model)) from operator_mi.car_sales` |
| 3    | `select (entropy(Used) + entropy(CarMileage) - entropy(tuple(Used, CarMileage))) / (entropy(Used)) from operator_mi.car_sales` |
| 4    | `select (entropy(Used) + entropy(CarMileage) - entropy(tuple(Used, CarMileage))) / (entropy(CarMileage)) from operator_mi.car_sales` |
| 5    | `select (entropy(Price) + entropy(CarMileage) - entropy(tuple(Price, CarMileage))) / (entropy(Price)) from operator_mi.car_sales` |
| 6    | `select (entropy(Price) + entropy(CarMileage) - entropy(tuple(Price, CarMileage))) / (entropy(CarMileage)) from operator_mi.car_sales` |
| 7    | `select (entropy(Price) + entropy(Used) - entropy(tuple(Price, Used))) / (entropy(Used)) from operator_mi.car_sales` |
| 8    | `select (entropy(Price) + entropy(Used) - entropy(tuple(Price, Used))) / (entropy(Price)) from operator_mi.car_sales` |
| 9    | `select (entropy(x) + entropy(y) - entropy(tuple(x, y))) / (entropy(x))<br/>from (<br/>with <br/>(select avg(Price) v1, stddevPop(Price) v2, avg(CarMileage) v3, stddevPop(CarMileage) v4 from operator_mi.car_sales)<br/> as t<br/>select round((Price - t.1) / t.2, 2) x, round((CarMileage - t.3) / t.4, 2) y from operator_mi.car_sales)` |
| 10   | `select (entropy(x) + entropy(y) - entropy(tuple(x, y))) / (entropy(x))<br/>from (<br/>with <br/>(select avg(CarMileage) v1, stddevPop(CarMileage) v2, avg(Price) v3, stddevPop(Price) v4 from operator_mi.car_sales)<br/> as t<br/>select round((CarMileage - t.1) / t.2, 2) x, round((Price - t.3) / t.4, 2) y from operator_mi.car_sales);` |



## 2.2 包含连续型数据的计算结果



目前无法得知 Einblick 对连续型数据的计算公式。从 sklearn.feature_selection ( [^sklearn.feature_selection.mutual_info_classif], [^sklearn.feature_selection.mutual_info_regression]) 了解到有近似公式，sklearn 的实现用到了[^A. Kraskov, H. Stogbauer and P. Grassberger, “Estimating mutual information”. Phys. Rev. E 69, 2004.] 和 [^B. C. Ross “Mutual Information between Discrete and Continuous Data Sets”. PLoS ONE 9(2), 2014.] 两篇论文的近似公式，但是和 Einblick 计算结果不一致。

Einblick 互信息操作符对连续型数据和离散型的不同，相同分布的数据如果数据类型不同也会产生不同的计算结果。



### 2.2.1 Einblick MI 操作符不同数据类型输出不同

复刻一个维基百科介绍逐点互信息时用到的分布：

**联合分布**：

| *x*  | *y*  | *p*(*x*, *y*) |
| :--: | :--: | :-----------: |
|  0   |  0   |      0.1      |
|  0   |  1   |      0.7      |
|  1   |  0   |     0.15      |
|  1   |  1   |     0.05      |

**边界分布**：

|      | *p*(*x*) | *p*(*y*) |
| :--: | :------: | :------: |
|  0   |   0.8    |   0.25   |
|  1   |   0.2    |   0.75   |

在此基础上构建同样分布的四个数据集，各有 20 条数据，它们除了数据类型不同和值不同没有其他区别，都满足上述分布。



| 数据集         | x 类型     | y 类型     |
| -------------- | ---------- | ---------- |
| `pmi-int`      | `Int`      | `Int`      |
| `pmi-string`   | `String`   | `String`   |
| `pmi-boolean`  | `Boolean`  | `Boolean`  |
| `pmi-datetime` | `Datetime` | `Datetime` |



因为四个数据集都服从同样的分布，按照 uncertaincy coefficient 计算公式应该产生同样的计算结果。但是 Einblick 对不同类型的数据得出的结果不同。除了图中展示的以外，只要两列数据属于不同的数据类型（例如 `x(String), y(Int)`），也会产生第5、6……种结果。

![image-20211215230533690](mi-implementation.assets/image-20211215230533690.png)

目前用 ClickHouse 实现的互信息操作符计算结果只能和 Einblick 对 String 类型数据（也就是所有离散型属性）的计算结果完全匹配。







# 参考资料

[^维基百科：Uncertaincy Coefficient]: https://en.wikipedia.org/wiki/Uncertainty_coefficient
[^维基百科：互信息归一化的各种变种公式]: https://en.wikipedia.org/wiki/Mutual_information#Normalized_variants
[^sklearn 中使用的几种互信息公式]: https://scikit-learn.org/stable/modules/clustering.html#id12
[^维基百科：互信息]: https://en.wikipedia.org/wiki/Mutual_information
[^维基百科：逐点互信息定义]: https://en.wikipedia.org/wiki/Pointwise_mutual_information#Definition
[^sklearn.feature_selection.mutual_info_classif]: https://scikit-learn.org/stable/modules/generated/sklearn.feature_selection.mutual_info_classif.html#sklearn.feature_selection.mutual_info_classif
[^sklearn.feature_selection.mutual_info_regression]: https://scikit-learn.org/stable/modules/generated/sklearn.feature_selection.mutual_info_regression.html#sklearn.feature_selection.mutual_info_regression
[^A. Kraskov, H. Stogbauer and P. Grassberger, “Estimating mutual information”. Phys. Rev. E 69, 2004.]: https://journals.aps.org/pre/pdf/10.1103/PhysRevE.69.066138
[^B. C. Ross “Mutual Information between Discrete and Continuous Data Sets”. PLoS ONE 9(2), 2014.]: https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0087357



1. [维基百科：Uncertaincy Coefficient](https://en.wikipedia.org/wiki/Uncertainty_coefficient)
2. [维基百科：互信息归一化的各种变种公式](https://en.wikipedia.org/wiki/Mutual_information#Normalized_variants)
3. [sklearn 中使用的几种互信息公式](https://scikit-learn.org/stable/modules/clustering.html#id12)
4. [维基百科：互信息](https://en.wikipedia.org/wiki/Mutual_information)
5. [维基百科：逐点互信息定义](https://en.wikipedia.org/wiki/Pointwise_mutual_information#Definition)
6. [sklearn.feature_selection.mutual_info_classif](https://scikit-learn.org/stable/modules/generated/sklearn.feature_selection.mutual_info_classif.html#sklearn.feature_selection.mutual_info_classif)
7. [sklearn.feature_selection.mutual_info_regression](https://scikit-learn.org/stable/modules/generated/sklearn.feature_selection.mutual_info_regression.html#sklearn.feature_selection.mutual_info_regression)
8. [A. Kraskov, H. Stogbauer and P. Grassberger, “Estimating mutual information”. Phys. Rev. E 69, 2004.](https://journals.aps.org/pre/pdf/10.1103/PhysRevE.69.066138)
9. [B. C. Ross “Mutual Information between Discrete and Continuous Data Sets”. PLoS ONE 9(2), 2014.](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0087357)



# Mutual Information 响应数据

```json

{
    "SubscribeResponse": {
        "jobId": "45",
        "jobStatus": {
            "status": "JOB_FINISHED"
        },
        "outputs": {
            "mutual_information": {
                "table": {
                    "columns": [
                        "attribute",
                        "uncertainty_coefficient"
                    ],
                    "values": [
                        {
                            "dim": [
                                2
                            ],
                            "type": "STRING",
                            "stringValue": [
                                "EducationLevel",
                                "Married"
                            ]
                        },
                        {
                            "dim": [
                                2
                            ],
                            "type": "FLOAT",
                            "floatValue": [
                                1,
                                0.000542340243257029
                            ]
                        }
                    ],
                    "numRows": 2
                }
            }
        },
        "samples": [
            {
                "version": 1,
                "numRows": "10000",
                "dataRatio": 1,
                "samplingProgress": 1,
                "dataSourceLoadingTime": {
                    "seconds": "1639040372"
                },
                "sampleCreatedTime": {
                    "seconds": "1639040372"
                },
                "quality": 1
            }
        ],
        "progress": 1,
        "latency": 0.059996123,
        "overallProgress": 1,
        "resourceSummary": {}
    },
    "_id": "61c1e6211b0588e7938290c3",
    "MiddlewareLatency": 0.001347886085510254,
    "SerializationLatency": 0.0001594562530517578
}
```







# Clickhouse SQL

```sql
create table if not exists operator_mi.pointwise_mutual_information (x UInt64, y UInt64)
ENGINE = MergeTree()
PARTITION BY x
PRIMARY KEY x;

insert into operator_mi.pointwise_mutual_information (x, y) values (0, 0), (0, 1), (0, 1), (0, 1), (0, 1), (0, 1), (0, 1), (0, 1), (0, 0), (0, 1), (0, 1), (0, 1), (0, 1), (0, 1), (0, 1), (0, 1), (1, 0), (1, 0), (1, 0), (1, 1); 

// 0.21417094500762918
with t as (
    select t1.x as x, t1.y as y, t1.joint as joint, t2.mx as mx, t3.my as my, (select count() from operator_mi.pointwise_mutual_information) as n
    from 
    (
        select x, y, count(*) as joint from operator_mi.pointwise_mutual_information group by x, y) t1 inner join (select x, count(*) as mx from operator_mi.pointwise_mutual_information group by x) t2 on t1.x = t2.x inner join (select y, count(*) as my from operator_mi.pointwise_mutual_information group by y) t3 on t1.y = t3.y
)
select sum(joint/n*log2(joint/n/(mx/n*my/n))) from t;

-- 0.214170945007629
select entropy(x) + entropy(y) - entropy(tuple(x, y)) mi from operator_mi.pointwise_mutual_information;

-- uncertainty coefficient
select (select (entropy(x) + entropy(y) - entropy(tuple(x, y))) / entropy(x) from operator_mi.pointwise_mutual_information) Mxy,
(select (entropy(x) + entropy(y) - entropy(tuple(x, y))) / entropy(y) from operator_mi.pointwise_mutual_information) Myx;

select entropy(Model) ,entropy(Type) , entropy(tuple(Model, Type)), entropy(tuple(Model, Type)),entropy(Model) + entropy(Type) - entropy(tuple(Model, Type)) mi from operator_mi.car_sales;

/// car_sales
create table if not exists operator_mi.car_sales (Model String, Type String, ExteriorColor String, InteriorColor String, CarYear UInt16, Price Float32, CarMileage Float32, Used String, Lease String, SalesDate Date, DealerId UInt32)
engine = MergeTree()
ORDER BY SalesDate;

/// promotion
create table if not exists operator_mi.promotion (
    Age Float32,
    Married String,
    EducationalLevel String,
    Employed String,
    CreditScore UInt16,
    LeaseLength UInt16,
    LeasePrice Float32,
    RemainingLength Float32,
    PurchasePrice UInt32,
    Incentive UInt16,
    Accepted String,
    DealerId UInt16,
    AppliedOnline String,
    AppliedAtDealership String
)
engine = MergeTree()
ORDER BY DealerId;

-- Syntex Error
select map(
'x', toArray(select count() from operator_mi.pointwise_mutual_information group by x order by x),
'y', toArray(select count() from operator_mi.pointwise_mutual_information group by y order by y),
'joint', toArray(select count() from operator_mi.pointwise_mutual_information group by x, y order by x, y)
) from operator_mi.pointwise_mutual_information;


select 2 * (entropy(x) + entropy(y) - entropy(tuple(x, y))) / (entropy(x) + entropy(y)) mi, entropy(x) hx, entropy(y) hy, entropy(tuple(x, y)) hxy from (
select arrayJoin([1]) as x, arrayJoin([0]) as n, number as y from numbers(20)
)


-- 极慢
with t as (
select (CarMileage - (select  avg(CarMileage) from operator_mi.car_sales)) / (select  stddevPop(CarMileage) from operator_mi.car_sales) x,
 (Price - (select  avg(Price) from operator_mi.car_sales)) / (select  stddevPop(Price) from operator_mi.car_sales) y
from operator_mi.car_sales
)
select * from t;

with t as (
select avg(CarMileage), stddevPop(CarMileage), avg(Price), stddevPop(Price) from operator_mi.car_sales
)
select * from t;
```





# Python Snips

```python
x1, y1 = [0]*16 + [1]*4, [0]*2 + [1]*14 + [0]*3 + [1]
x2, y2 = [1]*20, [0]*20
x3, y3 = [0]*20, range(1, 21)


import math
from sklearn import metrics as mr
from functools import reduce

def mi(x, y):
	return mr.mutual_info_score(x, y) / math.log(2)
	
def nmi(x, y):
	return mr.normalized_mutual_info_score(x, y)
	
def ami(x, y):
	return mr.adjusted_mutual_info_score(x, y)

def p(values):
	values = list(values)
	def f(x, y):
		if isinstance(x, tuple):
			x = dict([x])
		if y[0] in x:
			x[y[0]] += y[1]
		else:
			x[y[0]] = y[1]
		return x
	prob = dict(reduce(f, map(lambda v: (v, 1), values))).values()
	n = len(values)
	return [pv/n for pv in prob]

def entropy(x):
	x = list(x)
	return sum([-math.log(p, 2)*p for p in p(x)])

def mi1(x, y):
	p1 = p(x)
	p2 = p(y)
	p12 = p(zip(x, y))
	pmi = [math.log(p12[i*len(p2)+j]/p1[i]/p2[j], 2) * p12[i*len(p2)+j] for j in range(len(p2)) for i in range(len(p1))]
	return sum(pmi)
	
def nmi1(x, y):
	p1 = p(x)
	p2 = p(y)
	p12 = p(zip(x, y))
	pmi = [math.log(p12[i*len(p2)+j]/p1[i]/p2[j], 2) / -math.log(p12[i*len(p2)+j], 2) * p12[i*len(p2)+j] for j in range(len(p2)) for i in range(len(p1))]
	return sum(pmi)
	
def nmi2(x, y):
	p1 = p(x)
	p2 = p(y)
	p12 = p(zip(x, y))
	pmi = [2 * math.log(p12[i*len(p2)+j]/(p1[i]*p2[j]), 2) / -(math.log(p1[i], 2) + math.log(p2[j], 2)) * p12[i*len(p2)+j] for j in range(len(p2)) for i in range(len(p1))]
	return sum(pmi)
	
def nmi3(x, y):
	return mi(x, y) / entropy(zip(x, y))
	
def nmi4(x, y):
	return 2 * mi(x, y) / (entropy(x) + entropy(y))

[
    [mi(x1,y1), mi(x2, y2), mi(x3, y3)],
    [mi1(x1,y1), mi1(x2, y2), mi1(x3, y3)]
]
#[[0.21417094500762898, 0.0, 0.0], [0.214170945007629, 0.0, 0.0]]

def clickhouse_mi(col1, col2, tbl="operator_mi.pointwise_mutual_information"):
	h1 = f'entropy({col1})'
	h2 = f'entropy({col2})'
	h12 = f'entropy(tuple({col1}, {col2}))'
	return f'select {h1} + {h2} - {h12} from {tbl}'


def round_nmi(x, y, tbl = 'operator_mi.car_sales'):
	sql = f"""
select (entropy(x) + entropy(y) - entropy(tuple(x, y))) / (entropy(x))
from (
with 
(select avg({x}) v1, stddevPop({x}) v2, avg({y}) v3, stddevPop({y}) v4 from operator_mi.car_sales)
 as t
select round(({x} - t.1) / t.2, 2) x, round(({y} - t.3) / t.4, 2) y from {tbl});
"""
	print(sql)
    
def nmi_raw(col1, col2, tbl = 'promotion'):
    tbl = "operator_mi." + tbl
    
    sql = f"""
    with t as (
    select t1.x as x, t1.y as y, t1.joint as joint, t2.mx as mx, t3.my as my, (select count() from {tbl}) as n
    from 
    (
        select {tbl}.{col1} AS x, {tbl}.{col2} AS y, count(*) as joint from {tbl} group by x, y) t1 inner join (select {tbl}.{col1} AS x, count(*) as mx from {tbl} group by x) t2 on t1.x = t2.x inner join (select {tbl}.{col2} AS y, count(*) as my from {tbl} group by y) t3 on t1.y = t3.y
)
select sum(joint/n*log2(joint/n/(mx/n*my/n))) from t;
    """
    return sql

```





# Einblick 数据集（测试 MI 操作符对不同类型的计算结果）



下面以 JSON 描述每个数据集，`type` 表示列的类型，`size` 表示数据集的样本数，`freq` 表示每一对观测值出现的频率，`Pxy` 表示相应的概率。

```json
// 数据集 pmi-int:
{
    'type': int,
    'size': 20,
    'dist': [
        {'x': 0, 'y': 0, 'freq': 2, 'Pxy': 0.1},
        {'x': 0, 'y': 1, 'freq': 14, 'Pxy': 0.7},
        {'x': 1, 'y': 0, 'freq': 3, 'Pxy': 0.15},
        {'x': 1, 'y': 1, 'freq': 1, 'Pxy': 0.05}
    ]
}

// 数据集 pmi-string:
{
    'type': int,
    'size': 20,
    'dist': [
        {'x': '0', 'y': '0', 'freq': 2, 'Pxy': 0.1},
        {'x': '0', 'y': '1', 'freq': 14, 'Pxy': 0.7},
        {'x': '1', 'y': '0', 'freq': 3, 'Pxy': 0.15},
        {'x': '1', 'y': '1', 'freq': 1, 'Pxy': 0.05}
    ]
}

// 数据集 pmi-boolean:
{
    'type': int,
    'size': 20,
    'dist': [
        {'x': false, 'y': false, 'freq': 2, 'Pxy': 0.1},
        {'x': false, 'y': true, 'freq': 14, 'Pxy': 0.7},
        {'x': true, 'y': false, 'freq': 3, 'Pxy': 0.15},
        {'x': true, 'y': true, 'freq': 1, 'Pxy': 0.05}
    ]
}

// 数据集 pmi-datetime:
{
    'type': int,
    'size': 20,
    'dist': [
        {'x': "2020-01-01 00:00:00", 'y': "2020-01-01 00:00:00", 'freq': 2, 'Pxy': 0.1},
        {'x': "2020-01-01 00:00:00", 'y': "2021-01-01 00:00:00", 'freq': 14, 'Pxy': 0.7},
        {'x': "2021-01-01 00:00:00", 'y': "2020-01-01 00:00:00", 'freq': 3, 'Pxy': 0.15},
        {'x': "2021-01-01 00:00:00", 'y': "2021-01-01 00:00:00", 'freq': 1, 'Pxy': 0.05}
    ]
}

// 数据集 pmi-float:
{
    'type': int,
    'size': 20,
    'dist': [
        {'x': 0.0, 'y': 0.0, 'freq': 2, 'Pxy': 0.1},
        {'x': 0.0, 'y': 1.0, 'freq': 14, 'Pxy': 0.7},
        {'x': 1.0, 'y': 0.0, 'freq': 3, 'Pxy': 0.15},
        {'x': 1.0, 'y': 1.0, 'freq': 1, 'Pxy': 0.05}
    ]
}
```

