---
scope: work
draft: true
---
# Dataflow的DAG生成方法研究

# Dataflow的DAG结构

## 一些问题概述

- **后端记录了所有的DAG非结构信息（Redis），包括节点间的关系和节点参数内容。**
- **本文使用“DAG”代表一个工作面板中的所有图。实际上，这些图为多个有向无环图（DAG）。**
- 对于DAG中节点的位置信息则另行存储。
- 后端DAG图存储内容，是整个平台DAG数据的唯一标准，是页面保存和协同功能的数据一致性的保证。
- 目前DAG图存储在Reids，对于持久化问题淘汰和加载策略已做规划，后续会完善，不影响AirFlow使用。

## DAG基本结构介绍

![](_attachments/工作流%20DAG/Pasted%20image%2020220711201406.png)



## 存储格式

### 存储方式

每个工作区的DAG图存储在一个Redis数据结构中的Hash中，Key目前为止工作区Id，Value为每个节点。Value数据存储使用JSON格式。

### 数据结构

节点的Java数据结构，即Redis Hash中Value的数据结构，主要分为两部分：

- 节点结构信息：固定格式，用来标识节点的前驱节点、后继节点、边类型等。
- 节点内容描述信息：根据操作符进行自定义（但必须包含 `"dataSource"`字段）

对应图如下（未包含所有字段）：

![](_attachments/工作流%20DAG/Pasted%20image%2020220711201431.png)



具体介绍如下，其中`DagNode.class`为主类


| DagNode.class   |                                                |                       |
| --------------- | ---------------------------------------------- | --------------------- |
| 变量名          | 字段描述                                       | 类型                  |
| nodeId          | 节点唯一ID                                     | String                |
| inputDataSlots  | 输入槽，可多个                                 | InputDataSlot[]       |
| outputDataSlots | 输出槽，可多个                                 | List< OutputDataSlot> |
| nodeType        | 节点类型，如Table、Filter、Chart               | String                |
| nodeDescription | 节点描述信息（目前直接为Object，尚未定义父类） | Object                |

| InputDataSlot.class |                                              |                     |
| ------------------- | -------------------------------------------- | ------------------- |
| dataSource          | 数据源                                       | String              |
| preNodeId           | 前节点为非filter类型的操作符ID               | String              |
| filterId            | 前节点为filter类型的操作符ID                 | List< String>       |
| edgeType            | 边类型（三种，默认为实线 0，虚线 1，刷子 2） | Map<String, String> |

*注：过滤filter类型操作符目前有两种：Filter 和 Chart。*

*注：非过滤f类型操作符输出边只有类型0，过滤filter类型操作符输出边包含以上所有三种类型。*

| OutputDataSlot.class |                          |         |
| -------------------- | ------------------------ | ------- |
| nextNodeId           | 后节点ID                 | String  |
| nextSlotIndex        | 连接到后节点的槽slot的ID | Integer |



## 前端发往后端数据格式

主要分为两类：

- 节点增改：此类数据信息包含操作符信息
- 边增删改 和 节点删除：此类数据信息不包含操作符信息

格式模板如下：

```
{
  "job": "start_job",
  "xxxDescription": {
    dataSource: [""],
    ...
  },
  "operatorType": "xxx",
  "dagType": "example",
  "operatorId": "example",
  "workspaceId": "example"
}
```

> 说明：
>
> - `job`：String类型，标记工作开始；
> - `xxxDescription`：本操作符操作的描述，根据具体操作进行自定义，但必须包含**dataSource键值（其中增加节点此值根据是否有数据源，选择是否填入表名，长度为数据源个数；更新节点默认为空，长度为数据源个数；）**。在第二部分“单个操作符格式”中会给出每个操作符的格式。
> - `operatorType`：String类型，操作符类型名，注意要**与"xxxDescription"中的"xxx"保持一致**。如table、join、tronspose等；
> - `dagType`：String类型，对Dag图做的操作类型，如addNode、updateNode、removeNode、addEdge、removeEdge等。
> - `operatorId`：String类型，本操作符的id，是工作区中操作符组件的**唯一id**，用于标识；
> - `workspaceId`：String类型，工作区id，一个工作区对应一个id。
>
> 
>
> 注意：xxxDescription的dataSource为空时要写成`dataSource: [""]`！！！！！！！！

### 节点增改

如上

### 节点删除

```
{
  "job": "start_job",
  "dagDescription": {
    "jobType": "filter"
  },
  "operatorType": "dag",
  "dagType": "removeNode",
  "operatorId": "example",
  "workspaceId": "example"
}
```



### 边增删改

```
{
  "job": "start_job",
  "dagDescription": {
    "jobType": "addEdge",
    "preNodeId": "example",
    "nextNodeId": "example",
    "slotIndex": "0"
  },
  "operatorType": "dag",
  "dagType": "example",
  "workspaceId": "example"
}
```



## DAG生成和解析过程

### 生成描述

用户的一步步操作可看成一个个原子操作，当用户拖入节点、删除节点、更新节点、添加边、删除边、修改边，都会反馈给后端并更新Redis（应该于AirFlow无影响）。

后端记录了所有的DAG信息（Redis），包括节点间的关系和节点参数内容。对于DAG中节点的位置信息另行存储。



### 解析描述

主要根据3.2节的内容，从Redis中读取Hash结构的数据结构。该读取数据将包含3.2节的数据变量，通过链表相关算法（如迭代）对DAG进行遍历。

示例：Redis存储DAG图为：A -> B -> C，ABC都为非过滤类型。Redis数据格式大致如下：

```
Redis：

Key：工作区ID --> Value 
					|
					|----> Key: A   Value: {过滤型前节点ID：null，非过滤型前节点ID：null，后节点ID："B"，等信息}
					|
					|----> Key: B   Value: {过滤型前节点ID：null，非过滤型前节点ID："A"，后节点ID："C"，等信息}
					|
					|----> Key: C   Value: {过滤型前节点ID：null，非过滤型前节点ID："B"，后节点ID：null，等信息}
```

- 如果想得到DAG图，直接 redis.get(工作区ID)，返回List<DagNode类型>;
- 如果想得到A节点，直接 redis.get(工作区ID, A);
- 如果想得到A节点后继节点，直接 redis.get(工作区ID，A).getNextNode();
- 得到后继节点同理。
- **注意：不推荐直接操作Redis数据库，推荐使用RealDag.class（后续可能改类名）中封装好的方法**





### 执行过程

![](_attachments/工作流%20DAG/Pasted%20image%2020220711201535.png)

以上图为示例，解析过程分为如下几个步骤：

1. 用户修改A节点参数信息
2. 接收并解析参数
3. 修改reids存储的DAG图结构
4. 删除、持久化或复制某些临时表，进行ClickHouse的表维护（垃圾回收）
5. 调用任务调度类（某些操作不需要执行）
6. 开始正式运行，如下
   1. 遍历A节点后继节点得到需要执行的节点集合A
   2. 对集合A进行拓扑排序，得到执行顺序集合B（目前单线程运行，之后可能修改为多线程）
   3. 按照集合B逐个图中节点，生成临时表，并通过WebSocket返回节点结果。
   4. （注：过滤类型节点运行细节不同，此类型节点不需要执行，仅更改或组合过滤信息）

# 2. Airflow的DAG结构

## 2.0 cfg配置信息

在airflow目录下的`airflow.cfg`中，可配置默认的属性和信息

其中，

- `dags_folder`：用来配置aiflow pipeline的存放地点，必须是绝对路径，其中的DAG文件必须以py结尾
- `DAG_DISCOVERY_SAFE_MODE`：可以配置让airflow发现所有python文件

- 注意：

- 在 DAG_FOLDER 中搜索 DAG 时，Airflow 仅将包含字符串气流和 dag（不区分大小写）的 Python 文件视为优化。

  要改为考虑所有 Python 文件，请禁用 DAG_DISCOVERY_SAFE_MODE 配置标志。

  您还可以在 DAG_FOLDER 或其任何子文件夹中提供一个 .airflowignore 文件，该文件描述加载程序要忽略的文件。 它涵盖了它所在的目录以及它下面的所有子文件夹，并且应该是每行一个正则表达式，# 表示注释。

进入这个文件夹，DAG通过.py格式存放

一个python样例

```python
from datetime import datetime, timedelta
from textwrap import dedent

# airflow中的DAG包，提供实例化DAG能力
from airflow import DAG

# Operators; we need this to operate!
from airflow.operators.bash import BashOperator 

# 上下文方式创建
with DAG(
    # 隐式输入id
    'tutorial',
    # 传递给每个operator的默认参数，可以在每个operator单独操作
    # You can override them on a per-task basis during operator initialization
    default_args={
        'depends_on_past': False,
        'email': ['airflow@example.com'],
        'email_on_failure': False,
        'email_on_retry': False,
        'retries': 1,
        'retry_delay': timedelta(minutes=5),
        # 'queue': 'bash_queue',
        # 'pool': 'backfill',
        # 'priority_weight': 10,
        # 'end_date': datetime(2016, 1, 1),
        # 'wait_for_downstream': False,
        # 'sla': timedelta(hours=2),
        # 'execution_timeout': timedelta(seconds=300),
        # 'on_failure_callback': some_function,
        # 'on_success_callback': some_other_function,
        # 'on_retry_callback': another_function,
        # 'sla_miss_callback': yet_another_function,
        # 'trigger_rule': 'all_success'
    },
    description='A simple tutorial DAG',
    schedule_interval=timedelta(days=1),
    start_date=datetime(2021, 1, 1),
    catchup=False,
    tags=['example'],
) as dag:

    # t1, t2 and t3 are examples of tasks created by instantiating operators
    t1 = BashOperator(
        task_id='print_date',
        bash_command='date',
    )

    t2 = BashOperator(
        task_id='sleep',
        depends_on_past=False,
        bash_command='sleep 5',
        retries=3,
    )
    t1.doc_md = dedent(
        """\
    #### Task Documentation
    You can document your task using the attributes `doc_md` (markdown),
    `doc` (plain text), `doc_rst`, `doc_json`, `doc_yaml` which gets
    rendered in the UI's Task Instance Details page.
    ![img](http://montcs.bloomu.edu/~bobmon/Semesters/2012-01/491/import%20soul.png)

    """
    )

    dag.doc_md = __doc__  # providing that you have a docstring at the beginning of the DAG
    dag.doc_md = """
    This is a documentation placed anywhere
    """  # otherwise, type it like this
    templated_command = dedent(
        """
    {% for i in range(5) %}
        echo "{{ ds }}"
        echo "{{ macros.ds_add(ds, 7)}}"
    {% endfor %}
    """
    )

    t3 = BashOperator(
        task_id='templated',
        depends_on_past=False,
        bash_command=templated_command,
    )

    t1 >> [t2, t3]
```

## 2.1 声明DAG的三种方式

### 2.1.1 DAG是什么

DAG(Directed Acyclic Graph) ，是Airflow的核心概念，主要任务是将Tasks收集起来，根据他们的依赖和关系，组织所有Tasks的运行。

例如，一个基本的DAG

![basicDAG](../images/basic-dag.png)

这个DAG其中包括了四个Task:a,b,c,d
并且指示他们的运行应该是有依赖的，b依赖a，c依赖a，d依赖b和c
在Airflow中，DAG还应该指示这四个任务的执行周期，如每周一上午10点跑一遍

- 注意：
  1. DAG并不关心每个Task中具体执行了什么，而只关注什么时候执行这些Task、Task之间执行顺序、执行超时应该如何重启，等等
  2. 如果不定义DAG其中Tasks的运行，DAG将不会有任何作用
  3. Tasks通常由 [Operators](https://airflow.apache.org/docs/apache-airflow/stable/concepts/operators.html), [Sensors](https://airflow.apache.org/docs/apache-airflow/stable/concepts/sensors.html) or [TaskFlow](https://airflow.apache.org/docs/apache-airflow/stable/concepts/taskflow.html) 构成

### 2.1.2 声明DAG的三种方式

#### 2.1.2.1 context manager

**什么是context manager？**

- `context manager`：python特性，是在Py2.5之后加入的功能。上下文管理器就是实现了上下文管理协议的对象。主要用于保存和恢复各种全局状态，关闭文件等，上下文管理器本身就是一种装饰器。
- https://www.jianshu.com/p/7bae11eaf84d

**使用context manager声明**

效果是先接入一个DAG()构造，传给dag参数，然后开始执行`:`后面的操作，如`op = DummyOperator(task_id="task")`

```python
with DAG(
    "my_dag_name", start_date=pendulum.datetime(2021, 1, 1, tz="UTC"),
    schedule_interval="@daily", catchup=False
) as dag:
    op = DummyOperator(task_id="task")
```

#### 2.1.2.2 DAG标准构造器 DAG()

此处顺序执行，先执行DAG()构造，传给my_dag参数，然后开始执行op

```python
my_dag = DAG("my_dag_name", start_date=pendulum.datetime(2021, 1, 1, tz="UTC"),
             schedule_interval="@daily", catchup=False)
op = DummyOperator(task_id="task", dag=my_dag)
```

#### 2.1.2.3 @dag装饰器

类似于java注解，将可以将一个方法添加注释，转换成为DAG生成器，并附带其中执行的op

```python
@dag(start_date=pendulum.datetime(2021, 1, 1, tz="UTC"),
     schedule_interval="@daily", catchup=False)
def generate_dag():
    op = DummyOperator(task_id="task")

dag = generate_dag()
```

一个更完整的例子

```python
@dag(
    schedule_interval=None,
    start_date=pendulum.datetime(2021, 1, 1, tz="UTC"),
    catchup=False,
    tags=['example'],
)
def example_dag_decorator(email: str = 'example@example.com'):
    """
    DAG to send server IP to email.

    :param email: Email to send IP to. Defaults to example@example.com.
    :type email: str
    """
    get_ip = GetRequestOperator(task_id='get_ip', url="http://httpbin.org/get")

    @task(multiple_outputs=True)
    def prepare_email(raw_json: Dict[str, Any]) -> Dict[str, str]:
        external_ip = raw_json['origin']
        return {
            'subject': f'Server connected from {external_ip}',
            'body': f'Seems like today your server executing Airflow is connected from IP {external_ip}<br>',
        }

    email_info = prepare_email(get_ip.output)

    EmailOperator(
        task_id='send_email', to=email, subject=email_info['subject'], html_content=email_info['body']
    )


dag = example_dag_decorator()
```



### 2.1.3  从python文件中加载DAG

Airflow 从 Python 源文件加载 DAG，并在其配置的 DAG_FOLDER 中查找这些文件。 它将获取每个文件，执行它，然后从该文件加载任何 DAG 对象。

这意味着您可以为每个 Python 文件定义多个 DAG，甚至可以使用导入将一个非常复杂的 DAG 分布在多个 Python 文件中。

但请注意，当 Airflow 从 Python 文件加载 DAG 时，它只会拉取顶层的任何 DAG 实例对象。 例如，以这个 DAG 文件为例：

```python
dag_1 = DAG('this_dag_will_be_discovered')

def my_function():
    dag_2 = DAG('but_this_dag_will_not')

my_function()
```

虽然在访问文件时会调用两个 DAG 构造函数，但只有 dag_1 位于顶层（在 globals() 中），因此只有它被添加到 Airflow。 dag_2 未加载。



### 2.1.4 运行DAG

DAG 将以以下两种方式之一运行：

1. 当它们被手动或通过 API 触发时
2. 在定义的时间表上，该时间表被定义为 DAG 的一部分

DAG 不需要时间表，但定义一个时间表是很常见的。 您可以通过`schedule_interval`参数定义它，如下所示：

```python
with DAG("my_daily_dag", schedule_interval="@daily"):
    ...
```

`schedule_interval`参数采用任何有效的 Crontab 计划值，因此您也可以这样做：

```python
with DAG("my_daily_dag", schedule_interval="0 * * * *"):
    ...
```

### 2.1.5 DAG的配置参数

其中，可以为一个DAG声明`default_args`默认参数，会将这些参数传递给其中的每个Operator

```python
import pendulum

with DAG(
    dag_id='my_dag',
    start_date=pendulum.datetime(2016, 1, 1, tz="UTC"),
    schedule_interval='@daily',
    catchup=False,
    # 这部分参数会传递给每个Operator
    default_args={'retries': 2},
) as dag:
    op = BashOperator(task_id='dummy', bash_command='Hello World!')
    print(op.retries)  # 2
```



## 2.2 声明Task依赖关系

Task/Operator 通常不会单独存在

它依赖于其他Task（上游），而其他Task依赖于它（下游）。声明任务之间的这些依赖关系构成了 DAG 结构（有向无环图的边）。

通常有两种方式声明单个任务依赖关系。 推荐的一种是使用 >> 和 << 运算符：

### 2.2.1 >>和 <<

first_task的下游有两个任务 second_task, third_task

third_task的上游有一个任务 fourth_task

```python
first_task >> [second_task, third_task]
third_task << fourth_task
```

### 2.2.2  显式set_upsteream

```python
first_task.set_downstream(second_task, third_task)
third_task.set_upstream(fourth_task)
```

和2.2.1语义相同

### 2.2.3 复杂依赖需要cross_downstream操作

还有一些捷径可以声明更复杂的依赖关系。 如果要让两个任务列表相互依赖，则不能使用上述任何一种方法，因此需要使用 cross_downstream：

```python
from airflow.models.baseoperator import cross_downstream

# Replaces
# [op1, op2] >> op3
# [op1, op2] >> op4
cross_downstream([op1, op2], [op3, op4])
```

会要求所有的下游到所有的上游都有依赖

### 2.2.4 chain链式依赖

如果想将依赖项链接在一起

```python
from airflow.models.baseoperator import chain

# Replaces op1 >> op2 >> op3 >> op4
chain(op1, op2, op3, op4)

# You can also do it dynamically
chain(*[DummyOperator(task_id='op' + i) for i in range(1, 6)])
```

Chain 还可以对相同大小的列表进行成对依赖（这与 cross_downstream 完成的交叉依赖不同！）：

此处是成对依赖而不是交叉依赖

```python
from airflow.models.baseoperator import chain

# Replaces
# op1 >> op2 >> op4 >> op6
# op1 >> op3 >> op5 >> op6
chain(op1, [op2, op3], [op4, op5], op6)
```



## 2.3  DAG和Task / Operator的关系

1. 要点1：必须将每个操作员/任务分配给 DAG 才能运行。
2. 隐式传递Task/Operator的方式
   1. 在 with DAG 块中声明的 Operator
   2. 在 @dag 装饰器中声明的 Operator，
   3. 将 Operator 置于具有 DAG 的 Operator 的上游或下游

否则，必须使用 dag= 将其传递给每个 Operator。



## 2.4 Operator

#### BaseOperator 简介

所有的 Operator 都是从 BaseOperator 派生而来，并通过继承获得更多功能。这也是引擎的核心，所以有必要花些时间来理解 BaseOperator 的参数，以了解 Operator 基本特性。

先看一下构造函数的原型：

```rust
class airflow.models.BaseOperator(task_id, owner='Airflow', email=None, email_on_retry=True, email_on_failure=True, retries=0, retry_delay=datetime.timedelta(0, 300), retry_exponential_backoff=False, max_retry_delay=None, start_date=None, end_date=None, schedule_interval=None, depends_on_past=False, wait_for_downstream=False, dag=None, params=None, default_args=None, adhoc=False, priority_weight=1, weight_rule=u'downstream', queue='default', pool=None, sla=None, execution_timeout=None, on_failure_callback=None, on_success_callback=None, on_retry_callback=None, trigger_rule=u'all_success', resources=None, run_as_user=None, task_concurrency=None, executor_config=None, inlets=None, outlets=None, *args, **kwargs)
```

`start_date` 决定了任务第一次运行的时间，最好的实践是设置 start_date 在 schedule_interval 的附近。比如每天跑的任务开始日期设为'2018-09-21 00:00:00'，每小时跑的任务设置为 '2018-09-21 05:00:00'，airflow 将 start_date 加上 schedule_interval 作为执行日期。需要注意的是任务的依赖需要及时排除，例如任务 A 依赖任务 B，但由于两者 start_date 不同导致执行日期不同，那么任务 A 的依赖永远不会被满足。如果你需要执行一个日常任务，比如每天下午 2 点开始执行，你可以在 DAG中使用 cron 表达式

```bash
schedule_interval="0 14 * * *"
```

#### BashOperator

官方提供的 DAG 示例－tutorial 就是一个典型的 BashOperator，调用 bash 命令或脚本，传递模板参数就可以参考 tutorial

```python
"""
### Tutorial Documentation
Documentation that goes along with the Airflow tutorial located
[here](http://pythonhosted.org/airflow/tutorial.html)
"""
import airflow
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import timedelta


# these args will get passed on to each operator
# you can override them on a per-task basis during operator initialization
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': airflow.utils.dates.days_ago(2),
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    # 'queue': 'bash_queue',
    # 'pool': 'backfill',
    # 'priority_weight': 10,
    # 'end_date': datetime(2016, 1, 1),
    # 'wait_for_downstream': False,
    # 'dag': dag,
    # 'adhoc':False,
    # 'sla': timedelta(hours=2),
    # 'execution_timeout': timedelta(seconds=300),
    # 'on_failure_callback': some_function,
    # 'on_success_callback': some_other_function,
    # 'on_retry_callback': another_function,
    # 'trigger_rule': u'all_success'
}

dag = DAG(
    'tutorial',
    default_args=default_args,
    description='A simple tutorial DAG',
    schedule_interval=timedelta(days=1))

# t1, t2 and t3 are examples of tasks created by instantiating operators
t1 = BashOperator(
    task_id='print_date',   #这里也可以是一个 bash 脚本文件
    bash_command='date',
    dag=dag)

t1.doc_md = """\
#### Task Documentation
You can document your task using the attributes `doc_md` (markdown),
`doc` (plain text), `doc_rst`, `doc_json`, `doc_yaml` which gets
rendered in the UI's Task Instance Details page.
![img](http://montcs.bloomu.edu/~bobmon/Semesters/2012-01/491/import%20soul.png)
"""

dag.doc_md = __doc__

t2 = BashOperator(
    task_id='sleep',
    depends_on_past=False,
    bash_command='sleep 5',
    dag=dag)

templated_command = """
{% for i in range(5) %}
    echo "{{ ds }}"
    echo "{{ macros.ds_add(ds, 7)}}"
    echo "{{ params.my_param }}"
{% endfor %}
"""

t3 = BashOperator(
    task_id='templated',
    depends_on_past=False,
    bash_command=templated_command,
    params={'my_param': 'Parameter I passed in'},
    dag=dag)

t2.set_upstream(t1)
t3.set_upstream(t1)
```

这里 t1 和 t2 都很容易理解，直接调用的是 bash 命令，其实也可以传入带路径的 bash 脚本, t3 使用了 Jinja 模板，"{% %}" 内部是 for 标签，用于循环操作。"{{ }}" 内部是变量，其中 ds 是执行日期，是 airflow 的宏变量，params.my_param 是自定义变量。根据官方提供的模板，稍加修改即可满足我们的日常工作所需。

#### PythonOperator

PythonOperator 可以调用 Python 函数，由于 Python 基本可以调用任何类型的任务，如果实在找不到合适的 Operator，将任务转为 Python 函数，再使用 PythonOperator 也是一种选择。下面是官方文档给出的 PythonOperator 使用的样例。



```python
from __future__ import print_function
from builtins import range
import airflow
from airflow.operators.python_operator import PythonOperator
from airflow.models import DAG

import time
from pprint import pprint

args = {
    'owner': 'airflow',
    'start_date': airflow.utils.dates.days_ago(2)
}

dag = DAG(
    dag_id='example_python_operator', default_args=args,
    schedule_interval=None)


def my_sleeping_function(random_base):
    """This is a function that will run within the DAG execution"""
    time.sleep(random_base)


def print_context(ds, **kwargs):
    pprint(kwargs)
    print(ds)
    return 'Whatever you return gets printed in the logs'

run_this = PythonOperator(
    task_id='print_the_context',
    provide_context=True,
    python_callable=print_context,
    dag=dag)

# Generate 10 sleeping tasks, sleeping from 0 to 9 seconds respectively
for i in range(10):
    task = PythonOperator(
        task_id='sleep_for_' + str(i),
        python_callable=my_sleeping_function,
        op_kwargs={'random_base': float(i) / 10},
        dag=dag)

    task.set_upstream(run_this)
```

通过以上代码我们可以看到，任务 task 及依赖关系都是可以动态生成的，这在实际使用中会减少代码编写数量，逻辑也非常清晰，非常方便使用。PythonOperator 与 BashOperator 基本类似，不同的是 python_callable 传入的是 Python 函数，而后者传入的是 bash 指令或脚本。通过 op_kwargs 可以传入任意多个参数。

#### HiveOperator

hive 是基于 Hadoop 的一个数据仓库工具，可以将结构化的数据文件映射为一张数据库表，并提供简单的 sql 查询功能，可以将 sql 语句转换为 MapReduce 任
 务进行运行。在 airflow 中调用 hive 任务，首先需要安装依赖

```css
pip install apache-airflow[hive]
```

下面是使用示例：

```bash
t1 = HiveOperator(
    task_id='simple_query',
    hql='select * from cities',
    dag=dag)
```

常见的 Operator 还有 DockerOperator，OracleOperator，MysqlOperator，DummyOperator，SimpleHttpOperator 等使用方法类似，不再一一介绍。

#### 如何自定义Operator

如果官方的 Operator 仍不满足需求, 那么我们就自己开发一个 Operator。 开发 Operator 比较简单，继承 BaseOperator 并实现 execute 方法即可：

```python
from airflow.models import BaseOperator

class MyOperator(BaseOperator):

    def __init__(*args, **kwargs):
        super(MyOperator, self).__init__(*args, **kwargs)
    
    def execute(self, context):
        ###do something here
```

除了 execute 方法外，还可以实现以下方法：
 on_kill: 在 task 被 kill 的时候执行。

airflow 是支持Jinjia模板语言的，那么如何在自定义的 Operator 中加入Jinjia模板语言的支持呢？
 其实非常简单，只需要在自定义的Operator类中加入属性

```undefined
template_fields = (attributes_to_be_rendered_with_jinja)
```

即可，例如官方的 bash_operator中是这样的：

```bash
template_fields = ('bash_command', 'env')
```

这样，在任务执行之前，airflow 会自动渲染 bash_command 或 env 中的属性再执行任务。



# 3. 整体思路

1. 将每个操作封装成为`BashOperator`或者`PythonOperator`，前者使用exec命令执行.py文件(实现py独立算法)，后者使用http端口通信(实现clickhouse已实现接口)
2. 逐个读取airflow工作区，得到每一步操作，定义为DAG中的函数`def func A(args)`，同时引入后置依赖 如 A->B，直接用python stream语法` A>>B`置于文件最后(也可以通过维护一个单独set)存储每个依赖，最后写入DAG.py
3. 组装DAG的上下文格式



# 4.代码解释

## 4.1  WebSocketResolveServiceImpl  启动入口

```java
package com.bdilab.dataflow.service.impl;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.bdilab.dataflow.common.enums.OperatorDataSourceReadyEnum;
import com.bdilab.dataflow.common.enums.OperatorOutputTypeEnum;
import com.bdilab.dataflow.dto.jobdescription.ScalarDescription;
import com.bdilab.dataflow.service.WebSocketResolveService;
import com.bdilab.dataflow.utils.dag.DagFilterManager;
import com.bdilab.dataflow.utils.dag.DagNode;
import com.bdilab.dataflow.utils.dag.RealTimeDag;
import java.util.List;
import javax.annotation.Resource;

import com.bdilab.dataflow.utils.dag.dto.DagNodeInputDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;


/**
 * Websocket parser implementation class.
 *
 * @author wjh
 */
@Service
@Slf4j
public class WebSocketResolveServiceImpl implements WebSocketResolveService {

  @Resource
  RealTimeDag realTimeDag;
  @Resource
  ScheduleServiceImpl scheduleService;
  @Resource
  DagFilterManager dagFilterManager;
  @Resource
  MaterializeJobServiceImpl materializeJobService;

  @Override
  public void resolve(String jsonString) {
    JSONObject jsonObject = JSONObject.parseObject(jsonString);
    String operatorType = jsonObject.getString("operatorType");
    String dagType = jsonObject.getString("dagType");
    String workspaceId = jsonObject.getString("workspaceId");
    String operatorId = (String) jsonObject.getOrDefault("operatorId", "");
    JSONObject desc = jsonObject.getJSONObject(operatorType + "Description");
    JSONArray dataSources = desc.getJSONArray("dataSource");
    String nodeType = "";

    switch (dagType) {
      case "addNode":
        DagNodeInputDto dagNodeInputDto = new DagNodeInputDto(operatorId,operatorType,desc);
        realTimeDag.addNode(workspaceId,dagNodeInputDto);
        if(isDataSourceReady(dataSources)){
          scheduleService.executeTask(workspaceId, operatorId);
        }
        break;
      case "updateNode":
        realTimeDag.updateNode(workspaceId, operatorId, desc);
        DagNode node = realTimeDag.getNode(workspaceId, operatorId);
        List<String> inputDataSources = node.getInputDataSources();
        if(isDataSourceReady(inputDataSources,node.getNodeType())){
          scheduleService.executeTask(workspaceId, operatorId);
        }
        break;
      case "removeNode":
        List<DagNode> nextNodes = realTimeDag.getNextNodes(workspaceId, operatorId);
        nodeType = realTimeDag.getNode(workspaceId, operatorId).getNodeType();
        realTimeDag.removeNode(workspaceId, operatorId);
        if(OperatorOutputTypeEnum.isFilterOutput(nodeType)) {
          for (DagNode dagNode : nextNodes) {
            scheduleService.executeTask(workspaceId, dagNode.getNodeId());
          }
          dagFilterManager.deleteFilter(workspaceId, operatorId);
        }
        break;
      case "addEdge":
        String addPreNodeId = desc.getString("preNodeId");
        String addNextNodeId = desc.getString("nextNodeId");
        String addSlotIndex = desc.getString("slotIndex");
        realTimeDag.addEdge(workspaceId, addPreNodeId, addNextNodeId, Integer.valueOf(addSlotIndex));
        DagNode addEdgeNode = realTimeDag.getNode(workspaceId, addNextNodeId);
        List<String> nextDataSources = addEdgeNode.getInputDataSources();
        if(isDataSourceReady(nextDataSources,addEdgeNode.getNodeType())){
          scheduleService.executeTask(workspaceId, addNextNodeId);
        }
        break;
      case "removeEdge":
        String rmPreNodeId = desc.getString("preNodeId");
        String rmNextNodeId = desc.getString("nextNodeId");
        Integer rmSlotIndex = desc.getInteger("slotIndex");
        nodeType = realTimeDag.getNode(workspaceId, rmPreNodeId).getNodeType();
        realTimeDag.removeEdge(workspaceId,rmPreNodeId,rmNextNodeId,rmSlotIndex);
        if(OperatorOutputTypeEnum.isFilterOutput(nodeType)) {
          scheduleService.executeTask(workspaceId, rmNextNodeId);
        }
        break;
      case "updateEdge":
        String udPreNodeId = desc.getString("preNodeId");
        String udNextNodeId = desc.getString("nextNodeId");
        Integer udSlotIndex = desc.getInteger("slotIndex");
        String udEdgeType = desc.getString("edgeType");
        realTimeDag.updateEdge(workspaceId, udPreNodeId, udNextNodeId, udSlotIndex, udEdgeType);
        scheduleService.executeTask(workspaceId, udNextNodeId);
        break;
      case "updateDateSource":
        break;
      case "deleteDateSource":
        break;
      default:
        throw new RuntimeException("not exist this dagType !");
    }

  }

  private boolean isDataSourceReady(JSONArray dataSources) {
    for (Object dataSource : dataSources) {
      if(StringUtils.isEmpty(dataSource)) {
        return false;
      }
    }
    return true;
  }

  private boolean isDataSourceReady(List<String> dataSources,String operatorType) {
    if(OperatorDataSourceReadyEnum.isOperatorNeedAllReady(operatorType)){
      for (String dataSource : dataSources) {
        if(StringUtils.isEmpty(dataSource)) {
          return false;
        }
      }
    }else{
      for (String dataSource : dataSources) {
        if(!StringUtils.isEmpty(dataSource)) {
          return true;
        }
      }
    }
    return true;
  }
}
```



### 4.1.1 RealTimeDag

用来实时修改Redis中的Dag

DagNode的结构见<a href="#DagNodeDesc" >DagNode结构解释</a>

```java
package com.bdilab.dataflow.utils.dag;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.bdilab.dataflow.common.annotation.LogMethodTime;
import com.bdilab.dataflow.common.consts.CommonConstants;
import com.bdilab.dataflow.common.enums.OperatorOutputTypeEnum;
import com.bdilab.dataflow.utils.clickhouse.ClickHouseManager;
import com.bdilab.dataflow.utils.dag.consts.DagConstants;
import com.bdilab.dataflow.utils.dag.dto.DagNodeInputDto;
import com.bdilab.dataflow.utils.redis.RedisUtils;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

/**
 * Real time dag for dataflow.
 * You can use it to modify redis DAG graphs in real time.
 * 
 * @author wh
 * @date 2021/11/14
 */
@Slf4j
@Component
public class RealTimeDag {
  @Resource
  RedisUtils redisUtils;
  @Resource
  ClickHouseManager clickhouseManager;

  /**
   * Add a node to the dag.
   * redisTemplate.opsForHash().put(key, item, value);
   * 为哈希表key中的item赋值，实际上key是一个工作区Id,这一步将一个Key = DagNodeId，Value = DagNode的k-v放入workspace
   *
   * @param workspaceId workspace ID
   * @param dagNodeInputDto the nodeDto being added
   *  DagNode(DagNodeInputDto dagNodeInputDto)定义了一个Dag
   */
  @LogMethodTime
  public void addNode(String workspaceId, DagNodeInputDto dagNodeInputDto) {
      //
      redisUtils.hset(workspaceId, dagNodeInputDto.getNodeId(), new DagNode(dagNodeInputDto));
      
	/**
	public boolean hset(String key, String item, Object value) {
		redisTemplate.opsForHash().put(key, item, value);
		return true;
	}
	*/
    log.info("Add node [{}] to [{}].", dagNodeInputDto.getNodeId(), workspaceId);
  }

  /**
   * Add an edge to the dag.
   * Insert together. To prevent a insertion is successful, the other is a failure。
   *
   * @param workspaceId workspace ID
   * @param preNodeId ID of preceding node of the edge
   * @param nextNodeId ID of subsequent node of the edge
   * slot是数据槽，两个Node的连接是前节点的slot到下一个节点的slot，一个Node可以有多个输入slot，但是只能有1个输出slot
   * 原来是pre.outSlot  ->  next.inputSlot，这样的关系表示一条边
   * 现在需要
   * 
   */
  @LogMethodTime
  public void addEdge(String workspaceId, String preNodeId, String nextNodeId, Integer slotIndex) {
      /**
      	
      	* 根据key，从工区中拿到这个工区的map
      	* @param key key
        * @return Corresponding to multiple key values.
      	
      	public Map<Object, Object> hmget(String key) {
          	return redisTemplate.opsForHash().entries(key);
      	}
        
        
        * 根据key，将map设置为这个工区的map
        * @param key key
        * @param map Corresponding to multiple key values
        * @return True is success, false is failure
        
        public boolean hmset(String key, Map<?, ?> map) {
        	redisTemplate.opsForHash().putAll(key, map);
        	return true;
        }
        */
      //得到这个工区的DAG图
      Map<Object, Object> dagMap = redisUtils.hmget(workspaceId);
      //得到一条边的前置node
      DagNode preNode = (DagNode) dagMap.get(preNodeId);
      //得到一条边的后置node
      DagNode nextNode = (DagNode) dagMap.get(nextNodeId);
      
      if (!StringUtils.isEmpty(nextNode.getPreNodeId(slotIndex))) {
          //本数据槽已经被连了，需要替换
          DagNode oldPreNode = (DagNode) dagMap.get(nextNode.getPreNodeId(slotIndex));
          oldPreNode.removeOutputSlot(new OutputDataSlot(nextNodeId, slotIndex));
      }

      //为前节点的输出槽
    preNode.getOutputDataSlots().add(new OutputDataSlot(nextNodeId, slotIndex));
    String deleteInputTableName = "";
    String[] copyTableNames = new String[2];
    if (OperatorOutputTypeEnum.isFilterOutput(preNode.getNodeType())) {
      nextNode.getFilterId(slotIndex).add(preNodeId);
      //自动填充数据集
      String fillDataSource = preNode.getInputDataSource(0);
      if (StringUtils.isEmpty(nextNode.getInputDataSource(slotIndex))
          && preNode.getInputSlotSize() == 1
          && !StringUtils.isEmpty(fillDataSource)) {
        copyTableNames[0] = fillDataSource;
        copyTableNames[1] = CommonConstants.CPL_TEMP_INPUT_TABLE_PREFIX + nextNodeId;
        nextNode.setDataSource(slotIndex, copyTableNames[1]);
      }
    } else {
      deleteInputTableName = nextNode.getInputDataSource(slotIndex);
      nextNode.setPreNodeId(slotIndex, preNodeId);
      nextNode.setDataSource(slotIndex, CommonConstants.CPL_TEMP_TABLE_PREFIX + preNodeId);
    }
    Map<String, Object> map = new HashMap<String, Object>(2) {
      {
        this.put(preNodeId, preNode);
        this.put(nextNodeId, nextNode);
      }
    };
    redisUtils.hmset(workspaceId, map);
    log.info("Add edge between [{}] to slot [{}] of [{}] in [{}].",
        preNodeId, slotIndex, nextNodeId, workspaceId);

    if (!StringUtils.isEmpty(deleteInputTableName)) {
      clickhouseManager.deleteInputTable(deleteInputTableName);
    }
    if (!StringUtils.isEmpty(copyTableNames[1])) {
      clickhouseManager.copyToTable(copyTableNames[0],
          copyTableNames[1]);
    }
  }

  /**
   * Remove node from the dag.
   *
   * @param workspaceId workspace ID
   * @param deletedNodeId the ID of node that will be deleted
   */
  @LogMethodTime
  public void removeNode(String workspaceId, String deletedNodeId) {
    Map<Object, Object> dagMap = redisUtils.hmget(workspaceId);
    DagNode deletedNode = (DagNode) dagMap.get(deletedNodeId);
    for (int i = 0;  i < deletedNode.getInputDataSlots().length; i++) {
      //删除前节点的next信息
      InputDataSlot inputDataSlot = deletedNode.getInputDataSlots()[i];
      String preNodeId = inputDataSlot.getPreNodeId();
      List<String> filterIds = inputDataSlot.getFilterId();
      OutputDataSlot deletedSlot = new OutputDataSlot(deletedNodeId, i);
      if (!StringUtils.isEmpty(preNodeId)) {
        ((DagNode) dagMap.get(preNodeId)).getOutputDataSlots().remove(deletedSlot);
      }
      for (String filterId : filterIds) {
        ((DagNode) dagMap.get(filterId)).getOutputDataSlots().remove(deletedSlot);
      }
    }

    List<String> deleteInputTableName = new ArrayList<>();
    String deleteTableName = "";
    String[] copyTableNames = new String[2];
    if (OperatorOutputTypeEnum.isFilterOutput(deletedNode.getNodeType())) {
      //本节点为filter
      for (OutputDataSlot outputDataSlot : deletedNode.getOutputDataSlots()) {
        //删除后节点的filter信息
        DagNode nextNode = (DagNode) dagMap.get(outputDataSlot.getNextNodeId());
        nextNode.getFilterId(outputDataSlot.getNextSlotIndex()).remove(deletedNodeId);
        nextNode.getEdgeTypeMap(outputDataSlot.getNextSlotIndex()).remove(deletedNodeId);
      }
    } else {
      //本节点为table
      deleteTableName = CommonConstants.CPL_TEMP_TABLE_PREFIX + deletedNodeId;
      if (deletedNode.getOutputDataSlots().size() > 0) {
        copyTableNames[0] = CommonConstants.CPL_TEMP_TABLE_PREFIX + deletedNodeId;
        copyTableNames[1] = CommonConstants.CPL_TEMP_INPUT_TABLE_PREFIX + deletedNodeId;
        for (OutputDataSlot outputDataSlot : deletedNode.getOutputDataSlots()) {
          //删除后节点的table信息
          DagNode nextNode = (DagNode) dagMap.get(outputDataSlot.getNextNodeId());
          nextNode.setPreNodeId(outputDataSlot.getNextSlotIndex(), null);
          nextNode.setDataSource(outputDataSlot.getNextSlotIndex(), copyTableNames[1]);
        }
      }
    }

    //删除输入
    for (InputDataSlot inputDataSlot : deletedNode.getInputDataSlots()) {
      if (StringUtils.isEmpty(inputDataSlot.getPreNodeId())) {
        deleteInputTableName.add(inputDataSlot.getDataSource());
      }
    }

    dagMap.remove(deletedNodeId);
    redisUtils.hdel(workspaceId, deletedNodeId);
    redisUtils.hmset(workspaceId, dagMap);
    log.info("Remove node [{}] in [{}].", deletedNodeId, workspaceId);

    if (!deleteInputTableName.isEmpty()) {
      deleteInputTableName.forEach((name) -> {
        clickhouseManager.deleteInputTable(name);
      });
    }
    if (!StringUtils.isEmpty(copyTableNames[1])) {
      clickhouseManager.copyToTable(copyTableNames[0],
          copyTableNames[1]);
    }
    if (!StringUtils.isEmpty(deleteTableName)) {
      clickhouseManager.deleteTable(CommonConstants.CPL_TEMP_TABLE_PREFIX + deletedNodeId);
    }
  }

  /**
   * Remove edge from the dag.
   *
   * @param workspaceId workspace ID
   * @param preNodeId the ID of preceding node
   * @param nextNodeId the ID of subsequent node
   */
  @LogMethodTime
  public void removeEdge(String workspaceId,
                         String preNodeId,
                         String nextNodeId,
                         Integer slotIndex) {
    DagNode preNode = (DagNode) redisUtils.hget(workspaceId, preNodeId);
    DagNode nextNode = (DagNode) redisUtils.hget(workspaceId, nextNodeId);
    preNode.getOutputDataSlots().remove(new OutputDataSlot(nextNodeId, slotIndex));
    String[] copyTableNames = new String[2];
    if (OperatorOutputTypeEnum.isFilterOutput(preNode.getNodeType())) {
      //filter边
      nextNode.getFilterId(slotIndex).remove(preNodeId);
      nextNode.getEdgeTypeMap(slotIndex).remove(preNodeId);
    } else {
      //table边
      nextNode.getInputDataSlots()[slotIndex].setPreNodeId(null);
      copyTableNames[0] = CommonConstants.CPL_TEMP_TABLE_PREFIX + preNodeId;
      copyTableNames[1] = CommonConstants.CPL_TEMP_INPUT_TABLE_PREFIX + preNodeId;
      nextNode.setPreNodeId(slotIndex, null);
      nextNode.setDataSource(slotIndex, copyTableNames[1]);
    }
    Map<String, Object> map = new HashMap<String, Object>(2) {
      {
        this.put(preNodeId, preNode);
        this.put(nextNodeId, nextNode);
      }
    };
    redisUtils.hmset(workspaceId, map);
    log.info("Add edge between [{}] to slot [{}] of [{}] in [{}].",
        preNodeId, slotIndex, nextNodeId, workspaceId);

    if (!StringUtils.isEmpty(copyTableNames[1])) {
      clickhouseManager.copyToTable(copyTableNames[0], copyTableNames[1]);
    }
  }

  /**
   * Clear dag.
   *
   * @param workspaceId workspace ID
   */
  @LogMethodTime
  public void clearDag(String workspaceId) {
    Map<Object, Object> dagMap = redisUtils.hmget(workspaceId);
    redisUtils.del(workspaceId);
    log.info("Clear dag with workspace ID [{}].", workspaceId);

    List<String> inputDataSources = new ArrayList<>();
    List<String> outputDataSources = new ArrayList<>();
    for (Map.Entry<Object, Object> node : dagMap.entrySet()) {
      DagNode value = (DagNode) node.getValue();
      inputDataSources.addAll(value.getInputDataSources());
      if (!OperatorOutputTypeEnum.isFilterOutput(value.getNodeType())) {
        outputDataSources.add(CommonConstants.CPL_TEMP_TABLE_PREFIX + value.getNodeId());
      }
    }
    for (String inputDataSource : inputDataSources) {
      clickhouseManager.deleteInputTable(inputDataSource);
    }
    for (String outputDataSource : outputDataSources) {
      clickhouseManager.deleteTable(outputDataSource);
    }
  }

  /**
   * Updating node information.
   *
   * @param workspaceId workspace ID
   * @param nodeId new node
   * @param nodeDescription node description
   */
  @LogMethodTime
  public void updateNode(String workspaceId, String nodeId, Object nodeDescription) {
    DagNode node = (DagNode) redisUtils.hget(workspaceId, nodeId);
    JSONObject newNodeDescription = (JSONObject) nodeDescription;
    JSONArray newDataSources = newNodeDescription.getJSONArray("dataSource");
    JSONArray oldDataSources = ((JSONObject) node.getNodeDescription()).getJSONArray("dataSource");
    if (newDataSources.size()  != oldDataSources.size()) {
      log.error("Input [dataSource] size error !");
      throw new RuntimeException("Input [dataSource] size error !");
    }
    newNodeDescription.put("dataSource", oldDataSources);
    node.setNodeDescription(nodeDescription);
    //    List<String> deleteInputTableName = new ArrayList<>();
    //    if (!newDataSources.equals(oldDataSources)) {
    //      for (int i = 0; i < newDataSources.size(); i++) {
    //        String oldDataSource = oldDataSources.getString(i);
    //        String newDataSource = newDataSources.getString(i);
    //        if (!oldDataSource.equals(newDataSource)) {
    //          deleteInputTableName.add(oldDataSource);
    //          node.setDataSource(i, newDataSource);
    //        }
    //      }
    //    }
    redisUtils.hset(workspaceId, nodeId, node);
    log.info("Update node [{}] in [{}]", nodeId, workspaceId);

    //    deleteInputTableName.forEach((name) -> {
    //      clickhouseManager.deleteInputTable(name);
    //    });
  }

  /**
   * Update edge.
   *
   * @param workspaceId workspace Id
   * @param preNodeId preNode Id
   * @param nextNodeId nextNode Id
   * @param slotIndex slot index
   * @param edgeType edge type
   */
  @LogMethodTime
  public void updateEdge(String workspaceId,
                         String preNodeId,
                         String nextNodeId,
                         Integer slotIndex,
                         String edgeType) {
    DagNode nextNode = (DagNode) redisUtils.hget(workspaceId, nextNodeId);
    DagNode preNode = (DagNode) redisUtils.hget(workspaceId, preNodeId);
    switch (edgeType) {
      case DagConstants.DEFAULT_LINE:
        break;
      case DagConstants.DASHED_LINE:
        if (!OperatorOutputTypeEnum.isFilterOutput(preNode.getNodeType())) {
          throw new RuntimeException("For dashed edge, the output node must be of type Filter !");
        }
        break;
      case DagConstants.BRUSH_LINE:
        if (!OperatorOutputTypeEnum.isChart(preNode.getNodeType())
            || !OperatorOutputTypeEnum.isChart(nextNode.getNodeType())) {
          throw new RuntimeException(
                  "For brush edge, both of output and input node must be Chart !");
        }
        break;
      default:
        throw new RuntimeException("Error edge type !");
    }
    nextNode.getEdgeTypeMap(slotIndex).put(preNodeId, edgeType);
    redisUtils.hset(workspaceId, nextNodeId, nextNode);

  }

  /**
   * Get node.
   *
   * @param workspaceId workspace ID
   * @param nodeId node ID
   * @return DagNode
   */
  public DagNode getNode(String workspaceId, String nodeId) {
    return (DagNode) redisUtils.hget(workspaceId, nodeId);
  }

  /**
   * Gets the subsequent nodes of this node.
   *
   * @param workspaceId workspace ID
   * @param nodeId node ID
   * @return list of dag node
   */
  public List<DagNode> getNextNodes(String workspaceId, String nodeId) {
    Map<Object, Object> dagMap = redisUtils.hmget(workspaceId);
    DagNode node = (DagNode) dagMap.get(nodeId);
    List<DagNode> nextNodes = new ArrayList<>();
    node.getOutputDataSlots().forEach((outputDataSlot) -> {
      nextNodes.add((DagNode) dagMap.get(outputDataSlot.getNextNodeId()));
    });
    return nextNodes;
  }

  /**
   * Gets the preceding node of this node.
   *
   * @param workspaceId workspace ID
   * @param nodeId node ID
   * @return list of dag node
   */
  public List<DagNode> getPreNodes(String workspaceId, String nodeId) {
    Map<Object, Object> dagMap = redisUtils.hmget(workspaceId);
    DagNode node = (DagNode) dagMap.get(nodeId);
    List<DagNode> preNodes = new ArrayList<>();
    for (InputDataSlot inputDataSlot : node.getInputDataSlots()) {
      preNodes.add((DagNode) dagMap.get(inputDataSlot.getPreNodeId()));
    }
    return preNodes;
  }

  /**
   * Gets the preceding filter node of this node.
   *
   * @param workspaceId workspace ID
   * @param nodeId node ID
   * @return list of dag node
   */
  public List<DagNode> getFilterNodes(String workspaceId, String nodeId, Integer slotIndex) {
    Map<Object, Object> dagMap = redisUtils.hmget(workspaceId);
    DagNode node = (DagNode) dagMap.get(nodeId);
    List<DagNode> preNodes = new ArrayList<>();
    InputDataSlot inputDataSlot = node.getInputDataSlots()[slotIndex];
    inputDataSlot.getFilterId().forEach((filterId) -> {
      preNodes.add((DagNode) dagMap.get(filterId));
    });
    return preNodes;
  }

  /**
   * Get edge type.
   *
   * @param workspaceId workspace ID
   * @param nodeId node ID
   * @param slotIndex slot index
   * @param preNodeId preNode ID
   * @return edge type
   */
  public String getEdgeType(String workspaceId,
                            String nodeId,
                            Integer slotIndex,
                            String preNodeId) {
    DagNode node = (DagNode) redisUtils.hget(workspaceId, nodeId);
    return node.getEdgeType(slotIndex, preNodeId);
  }

  /**
   * Is default edge or not.
   *
   * @param workspaceId workspace ID
   * @param nodeId node ID
   * @param slotIndex slot index
   * @param preNodeId preNode ID
   * @return edge type
   */
  public boolean isDefaultEdge(String workspaceId,
                              String nodeId,
                              Integer slotIndex,
                              String preNodeId) {
    DagNode node = (DagNode) redisUtils.hget(workspaceId, nodeId);
    return node.isDefaultEdge(slotIndex, preNodeId);
  }

  /**
   * Is dashed edge or not.
   *
   * @param workspaceId workspace ID
   * @param nodeId node ID
   * @param slotIndex slot index
   * @param preNodeId preNode ID
   * @return edge type
   */
  public boolean isDashedEdge(String workspaceId,
                             String nodeId,
                             Integer slotIndex,
                             String preNodeId) {
    DagNode node = (DagNode) redisUtils.hget(workspaceId, nodeId);
    return node.isDashedEdge(slotIndex, preNodeId);
  }

  /**
   * Is brush edge or not.
   *
   * @param workspaceId workspace ID
   * @param nodeId node ID
   * @param slotIndex slot index
   * @param preNodeId preNode ID
   * @return edge type
   */
  public boolean isBrushEdge(String workspaceId,
                             String nodeId,
                             Integer slotIndex,
                             String preNodeId) {
    DagNode node = (DagNode) redisUtils.hget(workspaceId, nodeId);
    return node.isBrushEdge(slotIndex, preNodeId);
  }

  /**
   * Get this dag list.
   *
   * @param workspaceId workspace ID
   * @return all nodes
   */
  public List<DagNode> getDag(String workspaceId) {
    List<DagNode> dag = new ArrayList<>();
    redisUtils.hmget(workspaceId).forEach((k, v) -> {
      dag.add((DagNode) v);
    });
    return dag;
  }

  private boolean isHeadNode(InputDataSlot[] inputDataSlots) {
    for (InputDataSlot inputDataSlot : inputDataSlots) {
      if (!StringUtils.isEmpty(inputDataSlot.getPreNodeId())
          || !inputDataSlot.getFilterId().isEmpty()) {
        return false;
      }
    }
    return true;
  }
}
```