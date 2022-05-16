# cndevnet

由于某些原因，国内开发者需要的不少技术站点或者镜像源都无法直接访问，这使得在开发者在日常工作中会消耗额外的时间，去设置各种代理或者寻找国内的可替代的镜像源来使用。

甚至由于网络的原因，一些原本只需要从 GitHub 拉下来代码就可以直接编译成功的项目，在国内也是连编译都编译不过。

为了解决这个问题，可以在 Linux 环境下搭建一个专为开发者设置的开发网络，然后通过远程开发的方式来进行开发，搭配使用 vscode 进行远程开发是一种不错的体验。

Linux 环境可以是在国内云平台上的一台云主机，也可以是运行在本地虚拟机里面的主机，或者是局域网中的一台 Lnux 主机

## cndevnet 使用了以下软件

* [Debian](https://www.debian.org/)：目前支持的 Linux 系统
* iptables + ipset：结合 chnroute 和 cfroute 用于区分国内国外cf IP
* [Docker](https://docs.docker.com/engine/install/debian/): 用于运行 gost 和 smartdns 服务
* [gost](https://github.com/ginuerzh/gost): 用于建立 WSS 服务
* [smartdns](https://github.com/pymumu/smartdns)： 用于解决 DNS 污染
* [dnsmasq-china-list](https://github.com/felixonmars/dnsmasq-china-list/)： 国内域名
* [Cloudflare IP Range](https://www.cloudflare.com/zh-cn/ips/): Cloudflare 的 IP 范围

## 常用的代理设置

### 终端命令行

```
export http_proxy="socks5://127.0.0.1:1080"
export https_proxy="socks5://127.0.0.1:1080"
```

或者 

```
export http_proxy="http://127.0.0.1:1087"
export https_proxy="http://127.0.0.1:1087"

```

### Docker

创建目录和文件：

```
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo touch /etc/systemd/system/docker.service.d/http-proxy.conf
```

添加以下内容到配置文件 http-proxy.conf 中

```
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:1087"
Environment="NO_PROXY=localhost,127.0.0.1"
```

然后重启 Docker 服务。

### apt

编辑文件 `/etc/apt/apt.conf`，在文件末尾加入下面这行

```
Acquire::http::Proxy "http://127.0.0.1:1087"
```

### yum

修改 /etc/yum.conf 文件，添加代理配置

```
proxy=http://127.0.0.1:1087

```

### git

```
git config --global http.proxy 'socks5://127.0.0.1:1080' 
git config --global https.proxy 'socks5://127.0.0.1:1080'
```

