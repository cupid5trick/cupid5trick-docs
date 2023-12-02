---
scope: work
draft: true
---
### 2.1.5 scalar

#### 2.1.5.1 添加节点

```json
{
  "job": "start_job",
  "scalarDescription": {
        "jobType":"scalar",
        "dataSource": ["dataflow.airuuid"],
	"limit": 2000,
	"target": "AQI",		// 列名
	"aggregation": "average"	//  聚合函数名
  },
  "operatorType": "scalar",
  "dagType": "addNode",
  "operatorId": "xxxxxx",
  "workspaceId": "xxxxx"
}
```

说明：

`job`：为 "start_job"

`scalarDescription`：与 scalar 的 REST API 一致。

`jobType`: 为"scalar"

`dataSource` : 数据源数组，scalar 只有一个数据源。数据源有两种形式，一种是dataflow.xxx（就是最初在clickhouse数据库存储的表，另一种为经过前一操作符处理后的视图名，为temp_[前一操作符id]）。

`target`：进行 scalar 操作聚合计算的列名。

`aggregation`：聚合函数。average、min、max、count、distinct count、sum、standard dev。

`operatorType`：为"scalar"

`dagType`: 为"addNode"

`operatorId`: 操作符id，前端生成，不能重复，

`workspaceId`：工作区id，前端生成。

#### 2.1.5.2 修改节点

```json
{
  "job": "start_job",
  "scalarDescription": {
        "jobType":"scalar",
        "dataSource": ["dataflow.airuuid"],
	"limit": 2000,
	"target": "AQI",		// 列名
	"aggregation": "average"	// 聚合函数名
  },
  "operatorType": "scalar",
  "dagType": "updateNode",
  "operatorId": "xxxxxx",
  "workspaceId": "xxxxx"
}
```

更新节点时 `dagType` 为 “updateNode”，其他参数与添加节点一致。



#### 2.1.5.3 删除节点

```json
{
  "job": "start_job",
  "dagDescription": {
        "jobType":"removeNode"
  },
  "operatorType": "dag",
  "dagType": "removeNode",
  "operatorId": "xxxxxx",
  "workspaceId": "xxxxx"
}
```

删除节点时是提交一个 `dag` 作业，`Description`、`operatorType`都变成 “dag”，`dagType` 和 `jobType` 都是 “removeNode”。删除节点时提交正确的 `operatorId`，根据操作符 ID 删除节点。

#### 2.1.5.4 联动操作场景

```json
//  添加一个 table 操作符
{
    "job": "start_job",
    "tableDescription": {
        "dataSource": [
            "dataflow.airuuid"
        ],
        "jobType": "table",
        "filter": "",
        "project": [
            "*"
        ],
        "group": [],
        "limit": 20
    },
    "operatorType": "table",
    "dagType": "addNode",
    "operatorId": "1638773419107",
    "workspaceId": "glxWorkspace"
}

// 模拟拖拽出一个孤立的 scalar 操作符
{
    "job": "start_job",
    "scalarDescription": {
        "jobType": "scalar",
        "dataSource": [
            ""
        ],
        "limit": 2000,
        "target": "",
        "aggregation": ""
    },
    "operatorType": "scalar",
    "dagType": "addNode",
    "operatorId": "1638773423426",
    "workspaceId": "glxWorkspace"
}

// 添加一条从 table 到 scalar 的边（连线操作）
{
    "job": "start_job",
    "dagDescription": {
        "jobType": "addEdge",
        "preNodeId": "1638773419107",
        "nextNodeId": "1638773423426",
        "slotIndex": "0"
    },
    "operatorType": "dag",
    "dagType": "addEdge",
    "workspaceId": "glxWorkspace"
}

// 更新 scalar 操作符
{
    "job": "start_job",
    "scalarDescription": {
        "jobType": "scalar",
        "dataSource": [
            "dataflow.airuuid"
        ],
        "limit": 2000,
        "target": "AQI",
        "aggregation": "average"
    },
    "operatorType": "scalar",
    "dagType": "updateNode",
    "operatorId": "1638773423426",
    "workspaceId": "glxWorkspace"
}
```





```json

{
  "job": "start_job",
  "requestId": "xxxxx",
  "tableDescription": {
    "jobType": "table",
    "dataSource": ["dataflow.airuuid"],
    "filter": "AQI >= 60 AND AQI <= 100",
    "limit": 20,
    "project": []
  },
    "operatorType": "table",
  "dagType": "addNode",
    "operatorId": "001",
  "workspaceId": "xxxxx"
}


{
  "job": "start_job",
  "scalarDescription": {
        "jobType":"scalar",
        "dataSource": [""],
	"limit": 2000,
    "target": "",
    "aggregation": ""
  },
  "operatorType": "scalar",
  "dagType": "addNode",
  "operatorId": "002",
  "workspaceId": "xxxxx"
}





{
  "job": "start_job",
  "scalarDescription": {
        "jobType":"scalar",
	"limit": 2000,
    "target": "AQI",
    "aggregation": "avg"
  },
  "operatorType": "scalar",
  "dagType": "updateNode",
  "operatorId": "002",
  "workspaceId": "xxxxx"
}

{
  "job": "start_job",
  "dagDescription": {
    "jobType": "addEdge",
    "preNodeId": "001",
    "nextNodeId": "002",
    "slotIndex": "0"
  },
  "operatorType": "dag",
  "dagType": "addEdge",
  "workspaceId": "xxxxx"
}

{
  "job": "start_job",
  "profilerDescription": {
            "jobType":"profiler",
            "dataSource": [""],
            "profilerColumnList":["time","city","AQI"]
  },
  "operatorType": "profiler",
  "dagType": "updateNode",
  "operatorId": "003",
  "workspaceId": "xxxxx"
}

{
  "job": "start_job",
  "profilerDescription": {
            "jobType":"profiler",
            "dataSource": [""],
            "profilerColumnList":["time","city","AQI"]
  },
  "operatorType": "profiler",
  "dagType": "addNode",
  "operatorId": "003",
  "workspaceId": "xxxxx"
}
```

