---
title: Untitled
author: cupid5trick
created: 2023-04-03 19:57
tags: 
categories: 
access: private
draft: true
lang:
- zh-cn
- en-us
abstract:
keywords:
---
# 命令行参考

## 子命令

A unified platform for anti-censorship.


```bash
Usage:

	v2ray <command> [arguments]

The commands are:

	run           run V2Ray with config
	api           call V2Ray API
	convert       convert config files
	test          test config files
	tls           TLS tools
	uuid          generate new UUID
	verify        verify if a binary is officially signed
	version       print V2Ray version

Use "v2ray help <command>" for more information about a command.

Additional help topics:

	config-merge  config merge logic
	format-loader config formats and loading

Use "v2ray help <topic>" for more information about that topic.
```


## V2ray convert


```
Usage: v2ray convert [c1.json] [<url>.json] [dir1] ...

Convert config files between different formats. Files are merged 
Before convert.

Arguments:

    -i, -input <format>
        The input format.
        Available values: "auto", "json", "toml", "yaml"
        Default: "auto"

    -o, -output <format>
        The output format
        Available values: "json", "toml", "yaml", "protobuf" / "pb"
        Default: "json"

    -r
        Load folders recursively.

Examples:

    v2ray convert -output=protobuf "path/to/dir"   (1)
    v2ray convert -o=yaml config.toml              (2)
    v2ray convert c1.json c2.json                  (3)
    v2ray convert -output=yaml c1.yaml <url>.yaml  (4)

(1) Merge all supported files in dir and convert to protobuf
(2) Convert toml to yaml
(3) Merge json files
(4) Merge yaml files

```

Use "v2ray help config-merge" for more information about merge.

## V2ray test


```
Usage: v2ray test [-format=json] [-c config. Json] [-d dir]

Test config files, without launching V2Ray server.

V2ray will also use the config directory specified by environment 
Variable "v2ray. Location. Confdir". If no config found, it tries 
To load config from one of below:

    1. The default "config.json" in the current directory
    2. The config file from ENV "v2ray.location.config"
    3. The stdin if all failed above

Arguments:

    -c, -config <file>
        Config file for V2Ray. Multiple assign is accepted.

    -d, -confdir <dir>
        A directory with config files. Multiple assign is accepted.

    -r
        Load confdir recursively.

    -format <format>
        Format of config input. (default "auto")

Examples:

    v2ray test -c config.json
    v2ray test -d path/to/dir

```

Use "v2ray help format-loader" for more information about format.

## V2ray format-loader


```
V2ray is equipped with multiple loaders to support different 
Config formats:

    * auto
      The default loader, supports all formats listed below, with 
      format detecting, and mixed fomats support.

    * json (.json, .jsonc)
      The json loader, multiple files support, mergeable.

    * toml (.toml)
      The toml loader, multiple files support, mergeable.

    * yaml (.yml, .yaml)
      The yaml loader, multiple files support, mergeable.

    * protobuf / pb (.pb)
      Single file support, unmergeable.


The following explains how format loaders behaves.

Examples:

    v2ray run -d dir                        (1)
    v2ray run -c c1.json -c c2.yaml         (2)
    v2ray run -format=json -d dir           (3)
    v2ray test -c c1.yml -c c2.pb           (4)
    v2ray test -format=pb -d dir            (5)
    v2ray test -format=protobuf -c c1.json  (6)

(1) Load all supported files in the "dir".
(2) JSON and YAML are merged and loaded.
(3) Load all JSON files in the "dir".
(4) Goes error since . Pb is not mergeable to others
(5) Works only when single . Pb file found, if not, failed due to 
    Unmergeable.
(6) Force load "c1. Json" as protobuf, no matter its extension.
```

# 配置文档

[配置文件格式 | V2Fly.org](https://www.v2fly.org/v5/config/overview.html): <https://www.v2fly.org/v5/config/overview.html>

[新手上路 | V2Fly.org](https://www.v2fly.org/guide/start.html): <https://www.v2fly.org/guide/start.html>

## 系统设置

[如何实现终端，命令行的代理实现科学上网，高速上传下载github 下载文件](https://www.cfmem.com/2021/08/github.html): <https://www.cfmem.com/2021/08/github.html>

Linux 只需要设置环境变量 `http_proxy` `https_proxy` 或者 `all_proxy` 即可。
也可以使用 proxychains 工具：。


## 工具

[神一样的工具们 | V2Fly.org](https://www.v2fly.org/awesome/tools.html#%E7%AC%AC%E4%B8%89%E6%96%B9%E5%9B%BE%E5%BD%A2%E5%AE%A2%E6%88%B7%E7%AB%AF): <https://www.v2fly.org/awesome/tools.html#%E7%AC%AC%E4%B8%89%E6%96%B9%E5%9B%BE%E5%BD%A2%E5%AE%A2%E6%88%B7%E7%AB%AF>

# 参考资料

[数字安全手册 · Alvin9999/new-pac Wiki](https://github.com/Alvin9999/new-pac/wiki/%E6%95%B0%E5%AD%97%E5%AE%89%E5%85%A8%E6%89%8B%E5%86%8C): <https://github.com/Alvin9999/new-pac/wiki/%E6%95%B0%E5%AD%97%E5%AE%89%E5%85%A8%E6%89%8B%E5%86%8C>
