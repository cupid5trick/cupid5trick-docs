---
scope: work
draft: true
---
# 安装docker（[centos](https://docs.docker.com/engine/install/centos/)）

[Ubuntu安装docker](https://docs.docker.com/engine/install/ubuntu/)。

**Set up the repository**

Install the `yum-utils` package (which provides the `yum-config-manager` utility) and set up the **stable** repository.

```
$ sudo yum install -y yum-utils

$ sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

```




安装最新版本：

```bash
sudo yum install docker-ce docker-ce-cli containerd.io
```

安装指定版本：

```bash
 yum list docker-ce --showduplicates | sort -r
```

此命令会显示软件仓库中可用的版本，版本号是冒号和连字符中间的部分。安装选定版本的docker：

```bash
sudo yum install docker-ce-<VERSION_STRING> docker-ce-cli-<VERSION_STRING> containerd.io
```



这里安装`docker 18.06`版本：

```bash
yum install docker-ce-18.06.3.ce docker-ce-cli-18.06.3.ce containerd.io
```



```bash
# 启动docker
sudo systemctl start docker
# 测试hello-world
sudo docker run hello-world
```

# [Manage Docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)

需要创建一个`docker`用户组。

To create the `docker` group and add your user:

1. Create the `docker` group.

   ```bash
   $ sudo groupadd docker
   ```

2. Add your user to the `docker` group.

   ```bash
   $ sudo usermod -aG docker $USER
   ```

3. 重新登陆用户刷新用户组身份。

   执行以下命令，使用户组生效：

   ```bash
   $ newgrp docker 
   ```

4. 测试一下：Verify that you can run `docker` commands without `sudo`.

   ```bash
   $ docker run hello-world
   ```

   这个命令会从`docker hub`下载测试镜像，并在容器中运行。

   如果在添加用户组之前已经运行过`docker run hello-world`，可能会出现下面的错误。这是因为由root用户运行之后导致的`~/.docker`路径的权限错误。

   ```bash
   WARNING: Error loading config file: /home/user/.docker/config.json -
   stat /home/user/.docker/config.json: permission denied
   ```

   使用下面的命令修改路径的权限即可：

   ```bash
   $ sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
   $ sudo chmod g+rwx "$HOME/.docker" -R
   ```

# [设置docker镜像源](https://blog.csdn.net/qq_35606010/article/details/104750391)

编辑或新建`/etc/docker/daemon.json`:

```bash
# cat /etc/docker/daemon.json
cat >/etc/docker/daemon.json <<EOF
{
    "registry-mirrors":[
        "https://lwll293m.mirror.aliyuncs.com",
        "https://registry.docker-cn.com",
        "http://hub-mirror.c.163.com",
        "https://docker.mirrors.ustc.edu.cn",
        "https://pee6w651.mirror.aliyuncs.com"
    ],
    "live-restore": true
}
EOF
```

然后重启`docker`：

```bash
sudo systemctl restart docker
```

# 设置远程连接 docker

在 `/etc/docker/daemon.json`添加 hosts 配置项。

```json
{
    "hosts": [
        "unix://var/lib/docker.sock",
        "tcp://0.0.0.0:2375"
    ]
}
```

然后 开放端口：

```bash
firewall-cmd --add-port 2375/tcp --permanent
firewall-cmd --reload
```





# docker常用命令

```
docker ps
docker container ls
docker images -f [key1=name1,...]
# key=
```

# 使用docker运行容器

命令格式：

```bash
docker run [OPTIONS] IMAGE[:TAG|@DIGEST] [COMMAND] [ARG...]
```

**前后台**：

- 后台运行`[-d]`：

通过`[-d]`参数指定后台运行的容器，在容器的根进程退出时容器直接关闭。

参数`--rm`。

- 前台运行：



```bash
-a=[]           : Attach to `STDIN`, `STDOUT` and/or `STDERR`
-t              : Allocate a pseudo-tty
--sig-proxy=true: Proxy all received signals to the process (non-TTY mode only)
-i              : Keep STDIN open even if not attached
```



**设置网络**[[docker网络设置](https://docs.docker.com/engine/reference/run/#network-settings)]：

```bash
--dns=[]           : Set custom dns servers for the container
--network="bridge" : Connect a container to a network
                      'bridge': create a network stack on the default Docker bridge
                      'none': no networking
                      'container:<name|id>': reuse another container's network stack
                      'host': use the Docker host network stack
                      '<network-name>|<network-id>': connect to a user-defined network
--network-alias=[] : Add network-scoped alias for the container
--add-host=""      : Add a line to /etc/hosts (host:IP)
--mac-address=""   : Sets the container's Ethernet device's MAC address
--ip=""            : Sets the container's Ethernet device's IPv4 address
--ip6=""           : Sets the container's Ethernet device's IPv6 address
--link-local-ip=[] : Sets one or more container's Ethernet device's link local IPv4/IPv6 addresses
```

`--net`支持的网络设置有 :

| Network                  | Description                                                  |
| :----------------------- | :----------------------------------------------------------- |
| **none**                 | No networking in the container.                              |
| **bridge** (default)     | Connect the container to the bridge via veth interfaces.     |
| **host**                 | Use the host's network stack inside the container.           |
| **container**:<name\|id> | Use the network stack of another container, specified via its *name* or *id*. |
| **NETWORK**              | Connects the container to a user created network (using `docker network create` command) |

通过`--add-host`可以给容器添加主机名到ip的映射，相当于修改了容器的`/etc/hosts`。

```bash
$ docker run -it --add-host db-static:86.75.30.9 ubuntu cat /etc/hosts

172.17.0.22     09d03f76bf2c
fe00::0         ip6-localnet
ff00::0         ip6-mcastprefix
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters
127.0.0.1       localhost
::1	            localhost ip6-localhost ip6-loopback
86.75.30.9      db-static
```

# 添加容器数据卷VOLUME (shared filesystems)

```bash
-v, --volume=[host-src:]container-dest[:<options>]: Bind mount a volume.
The comma-delimited `options` are [rw|ro], [z|Z],
[[r]shared|[r]slave|[r]private], and [nocopy].
The 'host-src' is an absolute path or a name value.

If neither 'rw' or 'ro' is specified then the volume is mounted in
read-write mode.

The `nocopy` mode is used to disable automatically copying the requested volume
path in the container to the volume storage location.
For named volumes, `copy` is the default mode. Copy modes are not supported
for bind-mounted volumes.

--volumes-from="": Mount all volumes from the given container(s)
```



