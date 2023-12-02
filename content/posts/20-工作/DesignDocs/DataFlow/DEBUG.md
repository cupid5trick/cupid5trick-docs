---
scope: work
draft: true
---
# BugList

[WebSocket Debug Tool](http://jxy.me/websocket-debug-tool/)
[JSON在线 | JSON解析格式化—SO JSON在线工具](https://www.sojson.com/)
[Swagger UI](http://47.104.202.153:8080/swagger-ui.html)

## Table 操作符保存到仪表盘显示空白
操作使用的工作区和仪表盘：
工作区 ID：f02aa428-4960-402b-b05c-adb941cebe5c
仪表盘 ID：62d51464-f1f9-4982-95bb-01354ce5d947
operatorId："1658215965701"
![](_attachments/DEBUG/Pasted%20image%2020220719161041.png)
![](_attachments/DEBUG/Pasted%20image%2020220719161207.png)
仪表盘渲染 Chart 的请求体：
![](_attachments/DEBUG/Pasted%20image%2020220719160351.png)
从仪表盘渲染 Table 的请求参数：
![](_attachments/DEBUG/Pasted%20image%2020220719160611.png)

报错日志：
![](_attachments/DEBUG/Pasted%20image%2020220719155145.png)

> at com.bdilab.dataflow.workflow.store.service.impl.DagServiceImpl\$\$EnhancerBySpringCGLIB\$\$9dd23718.updateNode(\<generated>) ~\[workflow-1.0-SNAPSHOT.jar!/:1.0-SNAPSHOT]
> at com.bdilab.dataflow.workflow.store.service.impl.RealTimeStoreServiceImpl.updateNode(RealTimeStoreServiceImpl.java:103) ~\[workflow-1.0-SNAPSHOT.jar!/:1.0-SNAPSHOT]
> at com.bdilab.dataflow.service.impl.WebSocketResolveServiceImpl.resolve(WebSocketResolveServiceImpl.java:62) ~\[config-1.0-SNAPSHOT.jar!/:1.0-SNAPSHOT]

解析 "updateNode" 任务时执行 `DagServiceImpl.updateNode` 找不到 `workspaceId` 所以出现 `NullPointerException`。
## `WebsocketServer` 返回数据时出现 endpoint incorrect state for call
javax.websocket.Session#getBasicRemote
com/bdilab/dataflow/service/WebSocketServer.java:207

## `Websocket` 发送消息时 出现 `EOFException`
NginX 代理 WebSocket 请求时有readTimeout，超时之后就会自动断开 WebSocket 连接。要解决这个问题一般要在 WebSocketServer 里面添加心跳机制。服务端给 WebSocket 客户端发送 PING 数据包，如果客户端在一定间隔内没有回复一个 PONG 数据包，服务端就断开和客户端的连接。


## `Transpose` 操作符没有对输入字符串转义

**org.springframework.jdbc.UncategorizedSQLException: StatementCallback; uncategorized SQLException**
```sql
DROP VIEW IF EXISTS dataflow.temp_1658408306285;CREATE VIEW dataflow.temp_1658408306285 AS (SELECT Accepted,Employed,Married, countIf(Employed, EducationLevel = '5th - 6th grade')  AS `5th - 6th grade_Employed_count`, countIf(PurchasePrice, EducationLevel = '5th - 6th grade')  AS `5th - 6th grade_PurchasePrice_count`, countIf(LeasePrice, EducationLevel = '5th - 6th grade')  AS `5th - 6th grade_LeasePrice_count`, countIf(Accepted, EducationLevel = '5th - 6th grade')  AS `5th - 6th grade_Accepted_count`, countIf(Employed, EducationLevel = 'Associate's degree, occupational')  AS `Associate's degree, occupational_Employed_count`, countIf(PurchasePrice, EducationLevel = 'Associate's degree, occupational')  AS `Associate's degree, occupational_PurchasePrice_count`, countIf(LeasePrice, EducationLevel = 'Associate's degree, occupational')  AS `Associate's degree, occupational_LeasePrice_count`, countIf(Accepted, EducationLevel = 'Associate's degree, occupational')  AS `Associate's degree, occupational_Accepted_count`, countIf(Employed, EducationLevel = '1st - 4th grade')  AS `1st - 4th grade_Employed_count`, countIf(PurchasePrice, EducationLevel = '1st - 4th grade')  AS `1st - 4th grade_PurchasePrice_count`, countIf(LeasePrice, EducationLevel = '1st - 4th grade')  AS `1st - 4th grade_LeasePrice_count`, countIf(Accepted, EducationLevel = '1st - 4th grade')  AS `1st - 4th grade_Accepted_count`, countIf(Employed, EducationLevel = 'Professional degree')  AS `Professional degree_Employed_count`, countIf(PurchasePrice, EducationLevel = 'Professional degree')  AS `Professional degree_PurchasePrice_count`, countIf(LeasePrice, EducationLevel = 'Professional degree')  AS `Professional degree_LeasePrice_count`, countIf(Accepted, EducationLevel = 'Professional degree')  AS `Professional degree_Accepted_count`, countIf(Employed, EducationLevel = '11th grade2')  AS `11th grade2_Employed_count`, countIf(PurchasePrice, EducationLevel = '11th grade2')  AS `11th grade2_PurchasePrice_count`, countIf(LeasePrice, EducationLevel = '11th grade2')  AS `11th grade2_LeasePrice_count`, countIf(Accepted, EducationLevel = '11th grade2')  AS `11th grade2_Accepted_count`, countIf(Employed, EducationLevel = 'Bachelor's degree')  AS `Bachelor's degree_Employed_count`, countIf(PurchasePrice, EducationLevel = 'Bachelor's degree')  AS `Bachelor's degree_PurchasePrice_count`, countIf(LeasePrice, EducationLevel = 'Bachelor's degree')  AS `Bachelor's degree_LeasePrice_count`, countIf(Accepted, EducationLevel = 'Bachelor's degree')  AS `Bachelor's degree_Accepted_count`, countIf(Employed, EducationLevel = 'Master's degree')  AS `Master's degree_Employed_count`, countIf(PurchasePrice, EducationLevel = 'Master's degree')  AS `Master's degree_PurchasePrice_count`, countIf(LeasePrice, EducationLevel = 'Master's degree')  AS `Master's degree_LeasePrice_count`, countIf(Accepted, EducationLevel = 'Master's degree')  AS `Master's degree_Accepted_count`, countIf(Employed, EducationLevel = 'Some college, no degree')  AS `Some college, no degree_Employed_count`, countIf(PurchasePrice, EducationLevel = 'Some college, no degree')  AS `Some college, no degree_PurchasePrice_count`, countIf(LeasePrice, EducationLevel = 'Some college, no degree')  AS `Some college, no degree_LeasePrice_count`, countIf(Accepted, EducationLevel = 'Some college, no degree')  AS `Some college, no degree_Accepted_count`, countIf(Employed, EducationLevel = 'None')  AS `None_Employed_count`, countIf(PurchasePrice, EducationLevel = 'None')  AS `None_PurchasePrice_count`, countIf(LeasePrice, EducationLevel = 'None')  AS `None_LeasePrice_count`, countIf(Accepted, EducationLevel = 'None')  AS `None_Accepted_count`, countIf(Employed, EducationLevel = 'Doctoral degree')  AS `Doctoral degree_Employed_count`, countIf(PurchasePrice, EducationLevel = 'Doctoral degree')  AS `Doctoral degree_PurchasePrice_count`, countIf(LeasePrice, EducationLevel = 'Doctoral degree')  AS `Doctoral degree_LeasePrice_count`, countIf(Accepted, EducationLevel = 'Doctoral degree')  AS `Doctoral degree_Accepted_count`  FROM (select * from dataflow.temp_1657568614674 where 1 = 1) GROUP BY Accepted,Employed,Married);
```

## `MutualInformation` 操作符初始应该返回 JOB_FAILED

## `config` 模块的循环依赖
`config` 模块原来混杂了 工作区、仪表盘、`WebsocketServer`、调度服务（`NewTestScheduleServiceImpl`）、Airflow 等代码，仪表盘在实现统计数据连接等数量时就出现了循环依赖的问题。需要做一次模块拆分才有利于后续编程和代码维护。

- 工作区和数据准备模块相互依赖，把工作区相关的代码单独提取出来作为一个模块
- 仪表盘现在可能需要统计其他模块的对象数量（需要依赖其他模块），所以也需要单独作为一个模块。
- WebsocketServer 和 WebsocketResolveService 被很多模块调用，暂时留在 `config` 作为一个单独模块。
- 调度服务 和 Airflow 相关代码移动到 workflow模块。

## `TableMetadataServiceImpl` 

## 调度模块无法更新边
核心问题就是删除旧的边以后，后节点的 `nodeDescription` 还是保持原状。一旦收到添加新边的联动请求，查数据库的时候就会出现新数据源和旧的 `nodeDescription` 发生冲突，用 A 表的表名去查 B 表的数据当然会出错 （`ClickHouse 47. DB::Exception`）。

比如一开始是 `Table/825` （promotion_lease_transactions 表）和 `Chart/981` 连接，然后我们把 `Table/825=>Chart/981` 之间的连线删除，换成另一张表 `Table/547` （car_sales_transactions 表）连接到 `Chart/981` 上。这个过程中 `removeEdge` 和 `addEdge` 只改变了数据源 （nodeDescription里的dataSource 字段），所以 `addEdge` 联动请求执行时除了 dataSource 字段，nodeDescription的其他字段都是来自于 `Table/825` 节点的数据，等到程序去查 ClickHouse的时候就会发现 新表 `temp_1658499600547` 里面根本没有 nodeDescription 描述的一些数据。
下面是一条实际的报错信息，`temp_1658499600547` 是 `car_sales_transactions` 表的视图，这张表里没有 `LeasePrice`、`Married` 这些字段，所以 读取 ClickHouse 就出现异常：
```
Code: 47. DB::Exception: Missing columns: 'LeasePrice' 'Married' while processing query: 'SELECT Married, max(LeasePrice) AS LeasePrice_max FROM (SELECT * FROM dataflow.temp_1658499600547 WHERE 1 = 1) GROUP BY Married ORDER BY Married ASC', required columns: 'Married' 'LeasePrice' 'Married' 'LeasePrice'. (UNKNOWN_IDENTIFIER) (version 21.10.5.3 (official build))
```

为了删除边之后把新的操作符连接上来还能正常运行，比如把 `preNode1=>nextNode` 这条边删除再把 `preNode2` 连接到 `nextNode` 上，`nextNode` 必须还能表现正常、不报错，那在删除 `preNode=>nextNode` 边之后必须把 `nextNode` 的 `nodeDescription` 数据恢复到初始状态。每一种操作符都有预先定义的 nodeDescription 数据结构 ，恢复时必须根据当前节点是哪一种操作符来恢复到相应的初始状态。

## `Join` 操作符数据源问题
前端发送的数据源没有带 'temp' 前缀，后端查找 ClickHouse 找不到对应的表。

```Json
{
    "job": "start_job",
    "undefinedDescription": {
        "dataSource": [
            "1658504783314",
            "1658504783314"
        ],
        "joinType": "inner join",
        "joinKeys": [
            {
                "left": "DealerId",
                "right": "DealerId"
            }
        ],
        "includePrefixes": false,
        "prefixsAll": true,
        "leftPrefix": "left_",
        "rightPrefix": "right_",
        "move": true
    },
    "dagType": "updateNode",
    "operatorId": "1658504860422",
    "workspaceId": "20e5973b-01d1-4722-af59-b50996f4a5be"
}
```

## Redis 序列化问题
![](_attachments/DEBUG/image-20220728010427886.png)
HttpMediaTypeNotSupportedException: Content type 'application/json;charset=UTF-8' not supported
[java - "Content type 'application/json;charset=UTF-8' not supported" in Spring Rest application - Stack Overflow](https://stackoverflow.com/questions/50563593/content-type-application-jsoncharset-utf-8-not-supported-in-spring-rest-app)

## Swagger
timeDeltaUnit
isDeleted
type 数据集类型

# Workspaces

工作区列表：

| 工作区名称   | 工作区 id                            |
| ------------ | ------------------------------------ |
| 仪表盘测试   | d89c807a-0664-4b74-bd69-1456e0286b5f |
| 联动测试工区 | 20e5973b-01d1-4722-af59-b50996f4a5be |
|              |                                      |

仪表盘列表：
| 仪表盘名称 | 仪表盘id                             | 工作区id                             |
| ---------- | ------------------------------------ | ------------------------------------ |
| 仪表盘操作 | 86c9f1a0-604f-46f3-9864-f286e1ec4e13 | d89c807a-0664-4b74-bd69-1456e0286b5f |
| 仪表盘下钻 | 1ddc865d-0818-425a-9ff7-eee92fb048cd |                                      |
|            |                                      |                                      |




## clickhouse-jdbc-bridge
DB::Exception: clickhouse-jdbc-bridge is not running. Please, start it manually. (EXTERNAL_SERVER_IS_NOT_RESPONDING)
[ClickHouse/clickhouse-jdbc-bridge: A JDBC proxy from ClickHouse to external databases](https://github.com/ClickHouse/clickhouse-jdbc-bridge#usage)

HttpResponseProxy{HTTP/1.1 404 Not Found [Date: Mon, 11 Jul 2022 17:33:22 GMT, Connection: Keep-Alive, Content-Type: text/plain; charset=UTF-8, X-ClickHouse-Server-Display-Name: dataflow1, Transfer-Encoding: chunked, X-ClickHouse-Exception-Code: 60, Keep-Alive: timeout=3, X-ClickHouse-Summary: {"read_rows":"0","read_bytes":"0","written_rows":"0","written_bytes":"0","total_rows_to_read":"0"}] ResponseEntityProxy{[Content-Type: text/plain; charset=UTF-8,Chunked: true]}}




## 操作符快照

```json
{  
    "@type":"com.bdilab.dataflow.workflow.store.dag.pojo.DagNode",  
    "inputDataSlots":[  
        {  
            "@type":"com.bdilab.dataflow.workflow.store.dag.pojo.InputDataSlot",  
            "dataSource":"dataflow.promotion_leases_transactions",  
            "edgeType":{  
                "@type":"java.util.HashMap"  
            },  
            "filterId":[  
  
            ]  
        }  
    ],  
    "nodeDescription":{  
        "@type":"com.alibaba.fastjson.JSONObject",  
        "filter":"",  
        "move":true,  
        "limit":2000,  
        "project":[  
            "*"        
        ],  
        "jobType":"table",  
        "dataSource":[  
            "dataflow.promotion_leases_transactions"  
        ],  
        "group":[]  
    },  
    "nodeId":"1657124547958",  
    "nodeType":"table",  
    "outputDataSlots":[  
        {  
            "nextNodeId":"1657124569108",  
            "nextSlotIndex":0  
        }  
    ]  
},
{  
    "@type":"com.bdilab.dataflow.workflow.store.dag.pojo.DagNode",  
    "inputDataSlots":[  
        {  
            "@type":"com.bdilab.dataflow.workflow.store.dag.pojo.InputDataSlot",  
            "dataSource":"dataflow.promotion_leases_transactions",  
            "edgeType":{  
                "@type":"java.util.HashMap"  
            },  
            "filterId":[  
  
            ]  
        }  
    ],  
    "nodeDescription":{  
        "@type":"com.alibaba.fastjson.JSONObject",  
        "filter":"",  
        "move":true,  
        "limit":2000,  
        "project":[  
            "*"  
        ],  
        "jobType":"table",  
        "dataSource":[  
            "dataflow.promotion_leases_transactions"  
        ],  
        "group":[  
  
        ]  
    },  
    "nodeId":"1657125071420",  
    "nodeType":"table",  
    "outputDataSlots":[  
        {  
            "nextNodeId":"1657125074838",  
            "nextSlotIndex":0  
        }  
    ]  
}
```

# Dashboards
## 仪表盘下钻
GET
[/api/v1/workspace/getDrillDownList](http://47.104.202.153:8080/swagger-ui.html#/operations/workspace/getDrillDownListUsingGET)

# Websocket
## NginX 代理 Websocket 请求
Curl 测试 Websocket
对 NginX 发送 Websocket 连接请求发现返回 404，而对 Java 后端程序 发送 Websocket 连接请求能够成功连接。
```bash
# NginX
curl --no-buffer -H "Connection: keep-alive, Upgrade" -H "Upgrade: websocket" -H "Sec-Websocket-Version: 13" -H "Sec-Websocket-Key: websocket" -H "Authorization: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJmN2MwNDBlZi04YzJjLTRlNmItOTg0ZS1jYWFhMzcxMWUyN2MiLCJpc3MiOiJjb20uYmRpbGFiLmRhdGFmbG93Iiwiand0LXVzZXItbmFtZS1rZXkiOiJhZG1pbiIsImV4cCI6MTY1ODQyOTAxNCwiaWF0IjoxNjU3NTY1MDE0fQ.e_8I2PErsnzP46xr4vodPnIxUVhKx0y1OBaZuAZYxbM" -v http://192.168.153.129/api3/webSocket/workspace-a615416d69e14dea954b15ab5fe3b519

# Java 后端
curl --no-buffer -H "Connection: keep-alive, Upgrade" -H "Upgrade: websocket" -H "Sec-Websocket-Version: 13" -H "Sec-Websocket-Key: websocket" -H "Authorization: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJmN2MwNDBlZi04YzJjLTRlNmItOTg0ZS1jYWFhMzcxMWUyN2MiLCJpc3MiOiJjb20uYmRpbGFiLmRhdGFmbG93Iiwiand0LXVzZXItbmFtZS1rZXkiOiJhZG1pbiIsImV4cCI6MTY1ODQyOTAxNCwiaWF0IjoxNjU3NTY1MDE0fQ.e_8I2PErsnzP46xr4vodPnIxUVhKx0y1OBaZuAZYxbM" -v http://192.168.153.1:8080/webSocket/workspace-a615416d69e14dea954b15ab5fe3b519
```

问题原因是 NginX 默认不能代理 websocket 请求，需要在配置文件中设置转发请求时添加 升级Websocket连接的 首部。
[WebSocket 代理 - Nginx中文文档](https://docshome.gitbook.io/nginx-docs/how-to/websocket-dai-li)
[WebSocket proxying](http://nginx.org/en/docs/http/websocket.html)
There is one subtlety however: since the “Upgrade” is a [hop-by-hop](https://datatracker.ietf.org/doc/html/rfc2616#section-13.5.1) header, it is not passed from a client to proxied server. With forward proxying, clients may use the `CONNECT` method to circumvent this issue. This does not work with reverse proxying however, since clients are not aware of any proxy servers, and special processing on a proxy server is required.

Since version 1.3.13, nginx implements special mode of operation that allows setting up a tunnel between a client and proxied server if the proxied server returned a response with the code 101 (Switching Protocols), and the client asked for a protocol switch via the “Upgrade” header in a request.

As noted above, hop-by-hop headers including “Upgrade” and “Connection” are not passed from a client to proxied server, therefore in order for the proxied server to know about the client’s intention to switch a protocol to WebSocket, these headers have to be passed explicitly:

> location /chat/ {
>     proxy_pass http://backend;
>     proxy_http_version 1.1;
>     proxy_set_header Upgrade $http_upgrade;
>     proxy_set_header Connection "upgrade";
> }

A more sophisticated example in which a value of the “Connection” header field in a request to the proxied server depends on the presence of the “Upgrade” field in the client request header:

> http {
>     map $http_upgrade $connection_upgrade {
>         default upgrade;
>         ''      close;
>     }
> 
>     server {
>         ...
> 
>         location /chat/ {
>             proxy_pass http://backend;
>             proxy_http_version 1.1;
>             proxy_set_header Upgrade $http_upgrade;
>             proxy_set_header Connection $connection_upgrade;
>         }
>     }
By default, the connection will be closed if the proxied server does not transmit any data within 60 seconds. This timeout can be increased with the [proxy_read_timeout](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_read_timeout) directive. Alternatively, the proxied server can be configured to periodically send WebSocket ping frames to reset the timeout and check if the connection is still alive.

```
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
            proxy_read_timeout 600;

```

## Websocket 连接管理
Yup, i solved it. This exception will happen after client or server was interrupted or stopped without calling close socket method(maybe lost internet, or shutdown laptop or mobile when using socket). So if we would like to solve this problem, we have to implement ping/pong mechanism, after interval if we cannot get pong response from client, we will close this socket. Another way, we can catch this exception, then we will close old socket.

[Java 实现服务端的心跳机制](https://dzone.com/articles/ping-pong-implementation-jsr-356)
Javacord 的心跳实现


## Netty 心跳机制

[netty心跳检测 - 掘金](https://juejin.cn/post/6937951570424234021)

[Netty基础篇3-应用案例(群聊、心跳检测、WebSocket) - 掘金](https://juejin.cn/post/7094927990403891208)
[A Guide to the Java API for WebSocket | Baeldung](https://www.baeldung.com/java-websockets)




## DAG 数据

### DAG_DEBUG_1
SQL:
```sql
INSERT INTO `dataflow`.`dag_snapshot` (`id`, `workspace_id`, `snapshot`, `create_time`, `update_time`) VALUES ('1574336955227222018', 'd30c0982-6d5c-4f97-a96e-251ea597dc97', '{\"cells\":[{\"position\":{\"x\":50,\"y\":470},\"size\":{\"width\":400,\"height\":320},\"view\":\"react-shape-view\",\"shape\":\"react-shape\",\"id\":\"1664186213161\",\"portMarkup\":[{\"tagName\":\"foreignObject\",\"selector\":\"fo\",\"children\":[{\"ns\":\"http://www.w3.org/1999/xhtml\",\"tagName\":\"body\",\"selector\":\"foBody\",\"attrs\":{\"xmlns\":\"http://www.w3.org/1999/xhtml\"},\"style\":{\"width\":\"100%\",\"height\":\"100%\",\"background\":\"transparent\"},\"children\":[{\"tagName\":\"div\",\"selector\":\"foContent\",\"style\":{\"width\":\"100%\",\"height\":\"100%\"}}]}]},{\"tagName\":\"circle\",\"selector\":\"portBody\"}],\"data\":{\"dataSource\":[\"dataflow.DBDf1bb9462ab2aea41baa928dac18027f8876b\"],\"jobType\":\"table\",\"filter\":\"\",\"project\":[\"*\"],\"group\":[],\"move\":true,\"limit\":2000},\"component\":\"table\",\"tools\":{\"items\":[{\"name\":\"button-remove\",\"args\":{\"x\":\"100%\",\"y\":10,\"offset\":{\"x\":-5,\"y\":10}}}]},\"ports\":{\"items\":[{\"group\":\"in\",\"name\":\"dataSource\",\"id\":\"dataSource-1664186213161\"},{\"group\":\"out\",\"name\":\"dataOutput\",\"id\":\"dataOutput-1664186213161\"}],\"groups\":{\"in\":{\"position\":{\"name\":\"absolute\",\"args\":{\"x\":0.47,\"y\":1}},\"attrs\":{\"fo\":{\"magnet\":\"passive\",\"width\":18,\"height\":12,\"fill\":\"#999999\",\"y\":-20}},\"zIndex\":10},\"out\":{\"position\":{\"name\":\"absolute\",\"args\":{\"x\":\"50%\",\"y\":\"105%\"}},\"attrs\":{\"portBody\":{\"magnet\":true,\"r\":8,\"fill\":\"#999999\"}}}}},\"zIndex\":2},{\"position\":{\"x\":540,\"y\":450},\"size\":{\"width\":400,\"height\":360},\"view\":\"react-shape-view\",\"shape\":\"react-shape\",\"id\":\"1664186229889\",\"portMarkup\":[{\"tagName\":\"foreignObject\",\"selector\":\"fo\",\"children\":[{\"ns\":\"http://www.w3.org/1999/xhtml\",\"tagName\":\"body\",\"selector\":\"foBody\",\"attrs\":{\"xmlns\":\"http://www.w3.org/1999/xhtml\"},\"style\":{\"width\":\"100%\",\"height\":\"100%\",\"background\":\"transparent\"},\"children\":[{\"tagName\":\"div\",\"selector\":\"foContent\",\"style\":{\"width\":\"100%\",\"height\":\"100%\"}}]}]},{\"tagName\":\"circle\",\"selector\":\"portBody\"}],\"minHeight\":360,\"data\":{\"dataSource\":[\"dataflow.car_sales_transactions\"],\"chartType\":\"bar\",\"drillDown\":[],\"isDrillDown\":false,\"jobType\":\"chart\",\"move\":true,\"limit\":-1,\"filter\":\"\",\"onlyUpdateFilter\":false,\"menus\":[{\"aggregation\":\"none\",\"attribute\":\"Type\",\"binning\":\"none\",\"menu\":\"x-axis\",\"sort\":\"none\"},{\"aggregation\":\"none\",\"attribute\":\"Price\",\"binning\":\"none\",\"menu\":\"y-axis\",\"sort\":\"none\"},{\"aggregation\":\"none\",\"attribute\":\"none\",\"binning\":\"none\",\"menu\":\"color\",\"sort\":\"none\"},{\"aggregation\":\"none\",\"attribute\":\"none\",\"binning\":\"none\",\"menu\":\"size\",\"sort\":\"none\"},{\"aggregation\":\"none\",\"attribute\":\"none\",\"binning\":\"none\",\"menu\":\"row\",\"sort\":\"none\"},{\"aggregation\":\"none\",\"attribute\":\"none\",\"binning\":\"none\",\"menu\":\"column\",\"sort\":\"none\"}]},\"component\":\"chart\",\"tools\":{\"items\":[{\"name\":\"button-remove\",\"args\":{\"x\":\"100%\",\"y\":10,\"offset\":{\"x\":-5,\"y\":10}}}]},\"ports\":{\"items\":[{\"group\":\"in\",\"name\":\"dataSource\",\"id\":\"dataSource-1664186229889\"},{\"group\":\"out\",\"name\":\"dataOutput\",\"id\":\"dataOutput-1664186229889\"}],\"groups\":{\"in\":{\"position\":{\"name\":\"absolute\",\"args\":{\"x\":0.47,\"y\":1}},\"attrs\":{\"fo\":{\"magnet\":\"passive\",\"width\":18,\"height\":12,\"fill\":\"#999999\",\"y\":-20}},\"zIndex\":10},\"out\":{\"position\":{\"name\":\"absolute\",\"args\":{\"x\":\"50%\",\"y\":\"105%\"}},\"attrs\":{\"portBody\":{\"magnet\":true,\"r\":8,\"fill\":\"#999999\"}}}}},\"zIndex\":3},{\"shape\":\"edge\",\"attrs\":{\"line\":{\"stroke\":\"#999999\",\"targetMarker\":{\"name\":\"block\",\"width\":12,\"height\":18,\"fill\":\"white\",\"stroke\":\"#999999\",\"offset\":8}}},\"id\":\"6776a922-2b9c-4758-92d4-9da3ce53c2d1\",\"source\":{\"cell\":\"1664186213161\",\"port\":\"dataOutput-1664186213161\"},\"target\":{\"cell\":\"1664186229889\",\"port\":\"dataSource-1664186229889\"},\"zIndex\":4},{\"position\":{\"x\":20,\"y\":860},\"size\":{\"width\":400,\"height\":360},\"view\":\"react-shape-view\",\"shape\":\"react-shape\",\"id\":\"1664186275225\",\"portMarkup\":[{\"tagName\":\"foreignObject\",\"selector\":\"fo\",\"children\":[{\"ns\":\"http://www.w3.org/1999/xhtml\",\"tagName\":\"body\",\"selector\":\"foBody\",\"attrs\":{\"xmlns\":\"http://www.w3.org/1999/xhtml\"},\"style\":{\"width\":\"100%\",\"height\":\"100%\",\"background\":\"transparent\"},\"children\":[{\"tagName\":\"div\",\"selector\":\"foContent\",\"style\":{\"width\":\"100%\",\"height\":\"100%\"}}]}]},{\"tagName\":\"circle\",\"selector\":\"portBody\"}],\"minHeight\":360,\"data\":{\"dataSource\":[\"dataflow.car_sales_transactions\"],\"chartType\":\"bar\",\"drillDown\":[],\"isDrillDown\":false,\"jobType\":\"chart\",\"move\":true,\"limit\":-1,\"filter\":\"\",\"onlyUpdateFilter\":false,\"menus\":[{\"aggregation\":\"none\",\"attribute\":\"Model\",\"binning\":\"none\",\"menu\":\"x-axis\",\"sort\":\"none\"},{\"aggregation\":\"none\",\"attribute\":\"Price\",\"binning\":\"none\",\"menu\":\"y-axis\",\"sort\":\"none\"},{\"aggregation\":\"none\",\"attribute\":\"none\",\"binning\":\"none\",\"menu\":\"color\",\"sort\":\"none\"},{\"aggregation\":\"none\",\"attribute\":\"none\",\"binning\":\"none\",\"menu\":\"size\",\"sort\":\"none\"},{\"aggregation\":\"none\",\"attribute\":\"none\",\"binning\":\"none\",\"menu\":\"row\",\"sort\":\"none\"},{\"aggregation\":\"none\",\"attribute\":\"none\",\"binning\":\"none\",\"menu\":\"column\",\"sort\":\"none\"}]},\"component\":\"chart\",\"tools\":{\"items\":[{\"name\":\"button-remove\",\"args\":{\"x\":\"100%\",\"y\":10,\"offset\":{\"x\":-5,\"y\":10}}}]},\"ports\":{\"items\":[{\"group\":\"in\",\"name\":\"dataSource\",\"id\":\"dataSource-1664186275225\"},{\"group\":\"out\",\"name\":\"dataOutput\",\"id\":\"dataOutput-1664186275225\"}],\"groups\":{\"in\":{\"position\":{\"name\":\"absolute\",\"args\":{\"x\":0.47,\"y\":1}},\"attrs\":{\"fo\":{\"magnet\":\"passive\",\"width\":18,\"height\":12,\"fill\":\"#999999\",\"y\":-20}},\"zIndex\":10},\"out\":{\"position\":{\"name\":\"absolute\",\"args\":{\"x\":\"50%\",\"y\":\"105%\"}},\"attrs\":{\"portBody\":{\"magnet\":true,\"r\":8,\"fill\":\"#999999\"}}}}},\"zIndex\":5},{\"shape\":\"edge\",\"attrs\":{\"line\":{\"stroke\":\"#999999\",\"targetMarker\":{\"name\":\"block\",\"width\":12,\"height\":18,\"fill\":\"white\",\"stroke\":\"#999999\",\"offset\":8}}},\"id\":\"ed7025af-2a71-46a8-81a7-733f9393909b\",\"source\":{\"cell\":\"1664186229889\",\"port\":\"dataOutput-1664186229889\"},\"target\":{\"cell\":\"1664186275225\",\"port\":\"dataSource-1664186275225\"},\"zIndex\":6},{\"position\":{\"x\":520,\"y\":870},\"size\":{\"width\":400,\"height\":360},\"view\":\"react-shape-view\",\"shape\":\"react-shape\",\"id\":\"1664186308007\",\"portMarkup\":[{\"tagName\":\"foreignObject\",\"selector\":\"fo\",\"children\":[{\"ns\":\"http://www.w3.org/1999/xhtml\",\"tagName\":\"body\",\"selector\":\"foBody\",\"attrs\":{\"xmlns\":\"http://www.w3.org/1999/xhtml\"},\"style\":{\"width\":\"100%\",\"height\":\"100%\",\"background\":\"transparent\"},\"children\":[{\"tagName\":\"div\",\"selector\":\"foContent\",\"style\":{\"width\":\"100%\",\"height\":\"100%\"}}]}]},{\"tagName\":\"circle\",\"selector\":\"portBody\"}],\"minHeight\":360,\"data\":{\"dataSource\":[\"dataflow.car_sales_transactions\"],\"chartType\":\"bar\",\"drillDown\":[],\"isDrillDown\":false,\"jobType\":\"chart\",\"move\":false,\"limit\":-1,\"filter\":\"\",\"onlyUpdateFilter\":false,\"menus\":[{\"aggregation\":\"none\",\"attribute\":\"CarMileage\",\"binning\":\"none\",\"menu\":\"x-axis\",\"sort\":\"none\"},{\"aggregation\":\"none\",\"attribute\":\"Price\",\"binning\":\"none\",\"menu\":\"y-axis\",\"sort\":\"none\"},{\"aggregation\":\"none\",\"attribute\":\"none\",\"binning\":\"none\",\"menu\":\"color\",\"sort\":\"none\"},{\"aggregation\":\"none\",\"attribute\":\"none\",\"binning\":\"none\",\"menu\":\"size\",\"sort\":\"none\"},{\"aggregation\":\"none\",\"attribute\":\"none\",\"binning\":\"none\",\"menu\":\"row\",\"sort\":\"none\"},{\"aggregation\":\"none\",\"attribute\":\"none\",\"binning\":\"none\",\"menu\":\"column\",\"sort\":\"none\"}]},\"component\":\"chart\",\"tools\":{\"items\":[{\"name\":\"button-remove\",\"args\":{\"x\":\"100%\",\"y\":10,\"offset\":{\"x\":-5,\"y\":10}}}]},\"ports\":{\"items\":[{\"group\":\"in\",\"name\":\"dataSource\",\"id\":\"dataSource-1664186308007\"},{\"group\":\"out\",\"name\":\"dataOutput\",\"id\":\"dataOutput-1664186308007\"}],\"groups\":{\"in\":{\"position\":{\"name\":\"absolute\",\"args\":{\"x\":0.47,\"y\":1}},\"attrs\":{\"fo\":{\"magnet\":\"passive\",\"width\":18,\"height\":12,\"fill\":\"#999999\",\"y\":-20}},\"zIndex\":10},\"out\":{\"position\":{\"name\":\"absolute\",\"args\":{\"x\":\"50%\",\"y\":\"105%\"}},\"attrs\":{\"portBody\":{\"magnet\":true,\"r\":8,\"fill\":\"#999999\"}}}}},\"zIndex\":7},{\"shape\":\"edge\",\"attrs\":{\"line\":{\"stroke\":\"#999999\",\"targetMarker\":{\"name\":\"block\",\"width\":12,\"height\":18,\"fill\":\"white\",\"stroke\":\"#999999\",\"offset\":8}}},\"id\":\"919c783e-e292-48f4-8a0f-e0b84b3c00d5\",\"source\":{\"cell\":\"1664186275225\",\"port\":\"dataOutput-1664186275225\"},\"target\":{\"cell\":\"1664186308007\",\"port\":\"dataSource-1664186308007\"},\"zIndex\":8},{\"position\":{\"x\":1000,\"y\":870},\"size\":{\"width\":400,\"height\":360},\"view\":\"react-shape-view\",\"shape\":\"react-shape\",\"id\":\"1664186373565\",\"portMarkup\":[{\"tagName\":\"foreignObject\",\"selector\":\"fo\",\"children\":[{\"ns\":\"http://www.w3.org/1999/xhtml\",\"tagName\":\"body\",\"selector\":\"foBody\",\"attrs\":{\"xmlns\":\"http://www.w3.org/1999/xhtml\"},\"style\":{\"width\":\"100%\",\"height\":\"100%\",\"background\":\"transparent\"},\"children\":[{\"tagName\":\"div\",\"selector\":\"foContent\",\"style\":{\"width\":\"100%\",\"height\":\"100%\"}}]}]},{\"tagName\":\"circle\",\"selector\":\"portBody\"}],\"minHeight\":360,\"data\":{\"dataSource\":[\"\"],\"jobType\":\"table\",\"filter\":\"\",\"project\":[\"*\"],\"group\":[],\"move\":true,\"limit\":2000},\"component\":\"table\",\"tools\":{\"items\":[{\"name\":\"button-remove\",\"args\":{\"x\":\"100%\",\"y\":10,\"offset\":{\"x\":-5,\"y\":10}}}]},\"ports\":{\"items\":[{\"group\":\"in\",\"name\":\"dataSource\",\"id\":\"dataSource-1664186373565\"},{\"group\":\"out\",\"name\":\"dataOutput\",\"id\":\"dataOutput-1664186373565\"}],\"groups\":{\"in\":{\"position\":{\"name\":\"absolute\",\"args\":{\"x\":0.47,\"y\":1}},\"attrs\":{\"fo\":{\"magnet\":\"passive\",\"width\":18,\"height\":12,\"fill\":\"#999999\",\"y\":-20}},\"zIndex\":10},\"out\":{\"position\":{\"name\":\"absolute\",\"args\":{\"x\":\"50%\",\"y\":\"105%\"}},\"attrs\":{\"portBody\":{\"magnet\":true,\"r\":8,\"fill\":\"#999999\"}}}}},\"zIndex\":9},{\"shape\":\"edge\",\"attrs\":{\"line\":{\"stroke\":\"#999999\",\"targetMarker\":{\"name\":\"block\",\"width\":12,\"height\":18,\"fill\":\"white\",\"stroke\":\"#999999\",\"offset\":8}}},\"id\":\"939d84e9-7da5-49b0-ad1d-9c5220fcc986\",\"source\":{\"cell\":\"1664186308007\",\"port\":\"dataOutput-1664186308007\"},\"target\":{\"cell\":\"1664186373565\",\"port\":\"dataSource-1664186373565\"},\"zIndex\":10}]}', '2022-09-26 17:55:55', '2022-09-26 18:04:07');

```

redis:
```bash
HMSET "d30c0982-6d5c-4f97-a96e-251ea597dc97" "1664186275225" "{\"@type\":\"com.bdilab.dataflow.core.store.dag.pojo.DagNode\",\"inputDataSlots\":[{\"@type\":\"com.bdilab.dataflow.core.store.dag.pojo.InputDataSlot\",\"dataSource\":\"dataflow.car_sales_transactions\",\"edgeType\":{\"@type\":\"java.util.HashMap\"},\"filterId\":[\"1664186229889\"]}],\"nodeDescription\":{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"drillDown\":[],\"filter\":\"\",\"move\":true,\"onlyUpdateFilter\":false,\"chartType\":\"bar\",\"limit\":-1,\"isDrillDown\":false,\"menus\":[{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"aggregation\":\"none\",\"binning\":\"none\",\"attribute\":\"Model\",\"sort\":\"none\",\"menu\":\"x-axis\"},{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"aggregation\":\"none\",\"binning\":\"none\",\"attribute\":\"Price\",\"sort\":\"none\",\"menu\":\"y-axis\"},{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"aggregation\":\"none\",\"binning\":\"none\",\"attribute\":\"none\",\"sort\":\"none\",\"menu\":\"color\"},{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"aggregation\":\"none\",\"binning\":\"none\",\"attribute\":\"none\",\"sort\":\"none\",\"menu\":\"size\"},{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"aggregation\":\"none\",\"binning\":\"none\",\"attribute\":\"none\",\"sort\":\"none\",\"menu\":\"row\"},{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"aggregation\":\"none\",\"binning\":\"none\",\"attribute\":\"none\",\"sort\":\"none\",\"menu\":\"column\"}],\"jobType\":\"chart\",\"dataSource\":[\"dataflow.car_sales_transactions\"]},\"nodeId\":\"1664186275225\",\"nodeType\":\"chart\",\"outputDataSlots\":[{\"nextNodeId\":\"1664186308007\",\"nextSlotIndex\":0}]}" "1664186229889" "{\"@type\":\"com.bdilab.dataflow.core.store.dag.pojo.DagNode\",\"inputDataSlots\":[{\"@type\":\"com.bdilab.dataflow.core.store.dag.pojo.InputDataSlot\",\"dataSource\":\"dataflow.car_sales_transactions\",\"edgeType\":{\"@type\":\"java.util.HashMap\"},\"filterId\":[],\"preNodeId\":\"1664186213161\"}],\"nodeDescription\":{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"drillDown\":[],\"filter\":\"\",\"move\":true,\"onlyUpdateFilter\":false,\"chartType\":\"bar\",\"limit\":-1,\"isDrillDown\":false,\"menus\":[{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"aggregation\":\"none\",\"binning\":\"none\",\"attribute\":\"Type\",\"sort\":\"none\",\"menu\":\"x-axis\"},{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"aggregation\":\"none\",\"binning\":\"none\",\"attribute\":\"Price\",\"sort\":\"none\",\"menu\":\"y-axis\"},{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"aggregation\":\"none\",\"binning\":\"none\",\"attribute\":\"none\",\"sort\":\"none\",\"menu\":\"color\"},{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"aggregation\":\"none\",\"binning\":\"none\",\"attribute\":\"none\",\"sort\":\"none\",\"menu\":\"size\"},{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"aggregation\":\"none\",\"binning\":\"none\",\"attribute\":\"none\",\"sort\":\"none\",\"menu\":\"row\"},{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"aggregation\":\"none\",\"binning\":\"none\",\"attribute\":\"none\",\"sort\":\"none\",\"menu\":\"column\"}],\"jobType\":\"chart\",\"dataSource\":[\"dataflow.car_sales_transactions\"]},\"nodeId\":\"1664186229889\",\"nodeType\":\"chart\",\"outputDataSlots\":[{\"nextNodeId\":\"1664186275225\",\"nextSlotIndex\":0}]}" "1664186373565" "{\"@type\":\"com.bdilab.dataflow.core.store.dag.pojo.DagNode\",\"inputDataSlots\":[{\"@type\":\"com.bdilab.dataflow.core.store.dag.pojo.InputDataSlot\",\"dataSource\":\"dataflow.temp_input_1664186373565\",\"edgeType\":{\"@type\":\"java.util.HashMap\"},\"filterId\":[\"1664186308007\"]}],\"nodeDescription\":{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"filter\":\"\",\"move\":true,\"limit\":2000,\"project\":[\"*\"],\"jobType\":\"table\",\"dataSource\":[\"dataflow.temp_input_1664186373565\"],\"group\":[]},\"nodeId\":\"1664186373565\",\"nodeType\":\"table\",\"outputDataSlots\":[]}" "1664186308007" "{\"@type\":\"com.bdilab.dataflow.core.store.dag.pojo.DagNode\",\"inputDataSlots\":[{\"@type\":\"com.bdilab.dataflow.core.store.dag.pojo.InputDataSlot\",\"dataSource\":\"dataflow.car_sales_transactions\",\"edgeType\":{\"@type\":\"java.util.HashMap\"},\"filterId\":[\"1664186275225\"]}],\"nodeDescription\":{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"drillDown\":[],\"filter\":\"\",\"move\":true,\"onlyUpdateFilter\":false,\"chartType\":\"bar\",\"limit\":-1,\"isDrillDown\":false,\"menus\":[{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"aggregation\":\"none\",\"binning\":\"none\",\"attribute\":\"CarMileage\",\"sort\":\"none\",\"menu\":\"x-axis\"},{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"aggregation\":\"none\",\"binning\":\"none\",\"attribute\":\"Price\",\"sort\":\"none\",\"menu\":\"y-axis\"},{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"aggregation\":\"none\",\"binning\":\"none\",\"attribute\":\"none\",\"sort\":\"none\",\"menu\":\"color\"},{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"aggregation\":\"none\",\"binning\":\"none\",\"attribute\":\"none\",\"sort\":\"none\",\"menu\":\"size\"},{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"aggregation\":\"none\",\"binning\":\"none\",\"attribute\":\"none\",\"sort\":\"none\",\"menu\":\"row\"},{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"aggregation\":\"none\",\"binning\":\"none\",\"attribute\":\"none\",\"sort\":\"none\",\"menu\":\"column\"}],\"jobType\":\"chart\",\"dataSource\":[\"dataflow.car_sales_transactions\"]},\"nodeId\":\"1664186308007\",\"nodeType\":\"chart\",\"outputDataSlots\":[{\"nextNodeId\":\"1664186373565\",\"nextSlotIndex\":0}]}" "1664186213161" "{\"@type\":\"com.bdilab.dataflow.core.store.dag.pojo.DagNode\",\"inputDataSlots\":[{\"@type\":\"com.bdilab.dataflow.core.store.dag.pojo.InputDataSlot\",\"dataSource\":\"dataflow.DBDf1bb9462ab2aea41baa928dac18027f8876b\",\"edgeType\":{\"@type\":\"java.util.HashMap\"},\"filterId\":[]}],\"nodeDescription\":{\"@type\":\"com.alibaba.fastjson.JSONObject\",\"filter\":\"\",\"move\":true,\"limit\":2000,\"project\":[\"*\"],\"jobType\":\"table\",\"dataSource\":[\"dataflow.DBDf1bb9462ab2aea41baa928dac18027f8876b\"],\"group\":[]},\"nodeId\":\"1664186213161\",\"nodeType\":\"table\",\"outputDataSlots\":[{\"nextNodeId\":\"1664186229889\",\"nextSlotIndex\":0}]}"
```

## Redis 读出空值
```yaml
redis_version: 6.2.6
redis_git_sha1: 00000000
redis_git_dirty: 0
redis_build_id: 1527eab61b27d3bf
redis_mode: standalone
os: Linux3.10.0-957.21.3.el7.x86_64x86_64
arch_bits: 64
multiplexing_api: epoll
atomicvar_api: atomic-builtin
gcc_version: 10.2.1
process_id: 1
process_supervised: no
run_id: b9a371934aaed1ce2667803f8cb514b76433246e
tcp_port: 6379
server_time_usec: 1667393053375309
uptime_in_seconds: 9609694
uptime_in_days: 111
hz: 10
configured_hz: 10
lru_clock: 6448669
executable: /data/redis-server
config_file: /etc/redis/redis.conf
io_threads_active: 0
connected_clients: 21
cluster_connections: 0
maxclients: 10000
client_recent_max_input_buffer: 120
client_recent_max_output_buffer: 0
blocked_clients: 0
tracking_clients: 0
clients_in_timeout_table: 0
used_memory: 2880832
used_memory_human: 2.75M
used_memory_rss: 4210688
used_memory_rss_human: 4.02M
used_memory_peak: 60999568
used_memory_peak_human: 58.17M
used_memory_peak_perc: 4.72%
used_memory_overhead: 1257520
used_memory_startup: 810104
used_memory_dataset: 1623312
used_memory_dataset_perc: 78.39%
allocator_allocated: 3084008
allocator_active: 3657728
allocator_resident: 6938624
total_system_memory: 16109654016
total_system_memory_human: 15.00G
used_memory_lua: 37888
used_memory_lua_human: 37.00K
used_memory_scripts: 0
used_memory_scripts_human: 0B
number_of_cached_scripts: 0
maxmemory: 0
maxmemory_human: 0B
maxmemory_policy: noeviction
allocator_frag_ratio: 1.19
allocator_frag_bytes: 573720
allocator_rss_ratio: 1.90
allocator_rss_bytes: 3280896
rss_overhead_ratio: 0.61
rss_overhead_bytes: -2727936
mem_fragmentation_ratio: 1.46
mem_fragmentation_bytes: 1331632
mem_not_counted_for_evict: 4
mem_replication_backlog: 0
mem_clients_slaves: 0
mem_clients_normal: 430728
mem_aof_buffer: 8
mem_allocator: jemalloc-5.1.0
active_defrag_running: 0
lazyfree_pending_objects: 0
lazyfreed_objects: 0
loading: 0
current_cow_size: 0
current_cow_size_age: 0
current_fork_perc: 0.00
current_save_keys_processed: 0
current_save_keys_total: 0
rdb_changes_since_last_save: 78
rdb_bgsave_in_progress: 0
rdb_last_save_time: 1667391536
rdb_last_bgsave_status: ok
rdb_last_bgsave_time_sec: 0
rdb_current_bgsave_time_sec: -1
rdb_last_cow_size: 671744
aof_enabled: 1
aof_rewrite_in_progress: 0
aof_rewrite_scheduled: 0
aof_last_rewrite_time_sec: 0
aof_current_rewrite_time_sec: -1
aof_last_bgrewrite_status: ok
aof_last_write_status: ok
aof_last_cow_size: 651264
module_fork_in_progress: 0
module_fork_last_cow_size: 0
aof_current_size: 34072410
aof_base_size: 307600
aof_pending_rewrite: 0
aof_buffer_length: 0
aof_rewrite_buffer_length: 0
aof_pending_bio_fsync: 0
aof_delayed_fsync: 0
total_connections_received: 83957
total_commands_processed: 1667222
instantaneous_ops_per_sec: 2
total_net_input_bytes: 543350052
total_net_output_bytes: 651231324
instantaneous_input_kbps: 0.11
instantaneous_output_kbps: 8.65
rejected_connections: 0
sync_full: 0
sync_partial_ok: 0
sync_partial_err: 0
expired_keys: 391
expired_stale_perc: 0.00
expired_time_cap_reached_count: 0
expire_cycle_cpu_milliseconds: 245881
evicted_keys: 0
keyspace_hits: 110185
keyspace_misses: 1253215
pubsub_channels: 0
pubsub_patterns: 0
latest_fork_usec: 423
total_forks: 2609
migrate_cached_sockets: 0
slave_expires_tracked_keys: 0
active_defrag_hits: 0
active_defrag_misses: 0
active_defrag_key_hits: 0
active_defrag_key_misses: 0
tracking_total_keys: 0
tracking_total_items: 0
tracking_total_prefixes: 0
unexpected_error_replies: 0
total_error_replies: 2168
dump_payload_sanitizations: 0
total_reads_processed: 1734152
total_writes_processed: 1597186
io_threaded_reads_processed: 0
io_threaded_writes_processed: 0
role: master
connected_slaves: 0
master_failover_state: no-failover
master_replid: fa79dda50ebcc2b50b35ff7e9533e313187a153d
master_replid2: 0000000000000000000000000000000000000000
master_repl_offset: 0
second_repl_offset: -1
repl_backlog_active: 0
repl_backlog_size: 1048576
repl_backlog_first_byte_offset: 0
repl_backlog_histlen: 0
used_cpu_sys: 3290.877619
used_cpu_user: 5477.040345
used_cpu_sys_children: 5.937438
used_cpu_user_children: 6.837747
used_cpu_sys_main_thread: 3279.067900
used_cpu_user_main_thread: 5467.340921
errorstat_ERR: count=931
errorstat_NOAUTH: count=918
errorstat_WRONGPASS: count=319
cluster_enabled: 0
db0: keys=309,expires=4,avg_ttl=1360369643
```