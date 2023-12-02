---
scope: work
draft: true
---
# DataFlow 数据库设计

# 用户表 user

| name | type    | desc   |
| ---- | ------- | ------ |
| id   | bigint  | 用户ID |
| name | varchar | 用户名 |
|      |         |        |



# 工作区表 work_area

| name        | type     | desc                   |
| ----------- | -------- | ---------------------- |
| id          | bigint   | 主键                   |
| name        | varchar  | 工作区名称             |
| update_time | datetime | 更新时间               |
| description | varchar  | 工作区描述             |
| tag         | varchar  | 可用于搜索的工作区标签 |
|             |          |                        |

## 协作关系表 partnership

| name            | type   | desc             |
| --------------- | ------ | ---------------- |
| id              | bigint | 主键。           |
| fk_work_area_id | bigint | 外键。工作区id   |
| fk_user_id      | bigint | 外键。协作用户id |
|                 |        |                  |



# 数据集表 dataset

| name                | type            | desc                                   |
| ------------------- | --------------- | -------------------------------------- |
| id                  | bigint          | 主键                                   |
| name                | varchar(20)     | 数据集名称                             |
| type                | varchar(20)     | 数据集类型                             |
| ~~work_area_id~~    | ~~varchar(20)~~ | ~~外键。指向数据集所属的工作区~~       |
| storage_path        | varchar(20)     | 数据集数据的存储位置。                 |
| ~~parentId~~        | ~~int~~         | ~~外键。指向父数据集~~                 |
| ~~parentOperation~~ | ~~int~~         | ~~由父数据集生成本数据集所用的操作。~~ |
| create_date         | datetime        | 数据集创建时间                         |
| is_deleted          | bool            | 是否删除                               |

## 数据集、工作区之间的多对多关系表 workarea_dataset

| name           | type   | desc                               |
| -------------- | ------ | ---------------------------------- |
| id             | bigint | 主键。                             |
| fk_workarea_id | bigint | 外键。指向数据集关联的工作区。     |
| fk_dataset_id  | bigint | 外键。指向工作区关联的一个数据集。 |
|                |        |                                    |



# 快照表 snapshot

| name            | type     | desc             |
| --------------- | -------- | ---------------- |
| id              | bigint   | 主键             |
| fk_work_area_id | bigint   | 外键。工作区的ID |
| create_time     | datetime | 创建时间         |
| snap_string     | String   | 快照字符串       |



## ~~快照包含的数据帧表 SnapshotFrame~~

| ~~name~~              | ~~type~~    | ~~desc~~                               |
| --------------------- | ----------- | -------------------------------------- |
| ~~pk~~                |             | ~~主键~~                               |
| ~~fkSnapshotId~~      |             | ~~快照ID~~                             |
| ~~fkSrcDataFrameId~~  |             | ~~源数据帧~~                           |
| ~~fkDestDataFrameId~~ |             | ~~目标数据帧~~                         |
| ~~fkOperatorId~~      |             | ~~从源数据帧到目标数据帧使用的操作符~~ |
| ~~completed~~         | ~~Boolean~~ | ~~是否计算完成~~                       |
| ~~storePosition~~     | ~~String~~  | ~~快照数据存储位置~~                   |
|                       |             |                                        |







# ~~数据帧表 DataFrame~~









