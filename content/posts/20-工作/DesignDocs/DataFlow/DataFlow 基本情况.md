---
scope: work
draft: true
---
# DataFlow
# 项目需求

[UC-1 系统登录 · 语雀](https://cdev.yuque.com/goaibu/me6vqg/gzsffl)
[UC-2 首页 · 语雀](https://cdev.yuque.com/goaibu/me6vqg/kbe6mg)
[UC-3 数据管理 · 语雀](https://cdev.yuque.com/goaibu/me6vqg/musarn)
[UC-4 数据分析 · 语雀](https://cdev.yuque.com/goaibu/me6vqg/fusd2q)
[UC-5 仪表盘 · 语雀](https://cdev.yuque.com/goaibu/me6vqg/rsc3ed)
[UC-6 操作符 · 语雀](https://cdev.yuque.com/goaibu/me6vqg/or2f6p)
[UC-7 数据作业 · 语雀](https://cdev.yuque.com/goaibu/me6vqg/ztf31b)
[UC-8 系统管理 · 语雀](https://cdev.yuque.com/goaibu/me6vqg/rg4yp5)

1 工作区改名 -> 流程 -> 层级结构显示（文件夹）
*2 仪表盘跳向其他仪表盘（地图 -> 矿） 配合权限（针对不同的用户、地点有不同的权限）
3 仪表盘主题切换（light dark）
4 消息通知（问题、共享） -> 设置消息类型（定时、触发） -> 做成操作符 
5 文件管理（图标区分 下载 文件信息）
6 页面详细提示、tab页
7 管理员看到在线用户数量

# 项目资源

## 服务器

### 47.104.202.153
bdilab@1308



## 代码仓库

### gitee

dataflow-clone

前端：master

https://e.gitee.com/xd-bdilab/repos/xd-bdilab/dataflow-clone/

databoard-gluttony

不活跃仓库

https://e.gitee.com/xd-bdilab/repos/xd-bdilab/databoard-gluttony/

### github

DataFlow

后端：develop

前端：WY, frontend_glx

https://github.com/xdsselab/DataFlow

# 代码工具

## maven

### 清理maven 本地仓库中的 .lastUpdated 文件

Remove *.lastUpdated files in local maven repository.

```bash
@echo off
rem create by NettQun
  
rem 这里写你的仓库路径
set REPOSITORY_PATH=D:\install\x86_64\Java\maven\local_repos
rem 正在搜索...
for /f "delims=" %%i in ('dir /b /s "%REPOSITORY_PATH%\*lastUpdated*"') do (
    echo %%i
    del /s /q "%%i"
)
rem 搜索完毕
pause

dir /b /s "D:\install\x86_64\Java\maven\local_repos\*lastUpdated*"
```

