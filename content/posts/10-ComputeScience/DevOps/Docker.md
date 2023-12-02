---
scope: learn
draft: true
---

# Dockerfile 命令参考手册

[Dockerfile reference | Docker Documentation](https://docs.docker.com/engine/reference/builder/)

## Dockerfile 指令

### Predefined ARGs

[Predefined ARGS](https://docs.docker.com/engine/reference/builder/#predefined-args)

Docker has a set of predefined `ARG` variables that you can use without a corresponding `ARG` instruction in the Dockerfile.

- `HTTP_PROXY`
- `http_proxy`
- `HTTPS_PROXY`
- `https_proxy`
- `FTP_PROXY`
- `ftp_proxy`
- `NO_PROXY`
- `no_proxy`
- `ALL_PROXY`
- `all_proxy`

To use these, pass them on the command line using the `--build-arg` flag, for example:

```
$ docker build --build-arg HTTPS_PROXY=https://my-proxy.example.com .
```

## Environment Replacement

[Environment replacement](https://docs.docker.com/engine/reference/builder/#environment-replacement)

Environment variables (declared with [the `ENV` statement](https://docs.docker.com/engine/reference/builder/#env)) can also be used in certain instructions as variables to be interpreted by the `Dockerfile`. Escapes are also handled for including variable-like syntax into a statement literally.

Environment variables are notated in the `Dockerfile` either with `$variable_name` or `${variable_name}`. They are treated equivalently and the brace syntax is typically used to address issues with variable names with no whitespace, like `${foo}_bar`.

The `${variable_name}` syntax also supports a few of the standard `bash` modifiers as specified below:

- `${variable:-word}` indicates that if `variable` is set then the result will be that value. If `variable` is not set then `word` will be the result.
- `${variable:+word}` indicates that if `variable` is set then `word` will be the result, otherwise the result is the empty string.

In all cases, `word` can be any string, including additional environment variables.

Escaping is possible by adding a `\` before the variable: `\$foo` or `\${foo}`, for example, will translate to `$foo` and `${foo}` literals respectively.

## 导入导出镜像

```bash
docker save images:tag -o image.tar
docker load -i image.tar

docker save images:tag >image.tar
docker load <image.tar
```

## 完整的 Dockerfile 实例

- MySQL 官方镜像 - [docker-library/mysql: Docker Official Image packaging for MySQL Community Server](https://github.com/docker-library/mysql)

# 最佳实践

[Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

- 使用多阶段构建
- 减少镜像层数
- 清理无用数据
- 构建缓存的利用

## 使用多阶段构建

多阶段构建也就是尽可能多利用临时镜像，在临时镜像中完成操作而只把需要的部分拷贝到目标镜像，在完成相应构建步骤之后临时镜像就被删除。

## 减少镜像层数

Dockerfile 的所有命令中只有 `FROM`，`ADD` 和 `RUN` 这三个会生成镜像层，所以在 Dockerfile 中要尽量把多个相同指令合并到一起去执行，。

## 清理无用数据

## 构建缓存的利用

# 不要轻易使用 Alpine 镜像来构建 Docker 镜像，有坑！

[ALPINE 镜像](https://hub.docker.com/_/alpine)

[不要轻易使用 Alpine 镜像来构建 Docker 镜像，有坑！ - DockOne.io](http://dockerone.com/article/10354)

本系列文章将分为三个部分：

[第一部分](http://dockone.io/article/10353)着重介绍多阶段构建（multi-stage builds），因为这是镜像精简之路至关重要的一环。在这部分内容中，我会解释静态链接和动态链接的区别，它们对镜像带来的影响，以及如何避免那些不好的影响。中间会穿插一部分对 Alpine 镜像的介绍。

第二部分将会针对不同的语言来选择适当的精简策略，其中主要讨论 Go，同时也涉及到了 Java，Node，Python，Ruby 和 Rust。这一部分也会详细介绍 Alpine 镜像的避坑指南。什么？你不知道 Alpine 镜像有哪些坑？我来告诉你。

第三部分将会探讨适用于大多数语言和框架的通用精简策略，例如使用常见的基础镜像、提取可执行文件和减小每一层的体积。同时还会介绍一些更加奇特或激进的工具，例如 Bazel，Distroless，DockerSlim 和 UPX，虽然这些工具在某些特定场景下能带来奇效，但大多情况下会起到反作用。

- 第一部分 - [两个奇技淫巧，将 Docker 镜像体积减小 99% - DockOne.io](http://dockone.io/article/10353)
- 第二部分 - [不要轻易使用 Alpine 镜像来构建 Docker 镜像，有坑！ - DockOne.io](http://dockerone.com/article/10354)
- 第三部分 -

原文来自 [Go (Golang) Programming Blog - Ardan Labs](https://www.ardanlabs.com/blog/)

- [Docker Images : Part I - Reducing Image Size](https://www.ardanlabs.com/blog/2020/02/docker-images-part1-reducing-image-size.html)
- [Docker Images : Part II - Details Specific To Different Languages](https://www.ardanlabs.com/blog/2020/02/docker-images-part2-details-specific-to-different-languages.html)
- [Docker Images : Part III - Going Farther To Reduce Image Size](https://www.ardanlabs.com/blog/2020/04/docker-images-part3-going-farther-reduce-image-size.html)

# 问题排查

- COPY 导致目录变为数据卷，于是目录内容无法改变：
[Docker executing cp or mv command in Dockerfile, but changes does not show up in an image - Stack Overflow](https://stackoverflow.com/questions/54108613/docker-executing-cp-or-mv-command-in-dockerfile-but-changes-does-not-show-up-in)
