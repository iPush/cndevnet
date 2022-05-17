# cndevnet

由于某些原因，国内开发者需要的不少技术站点或者镜像源都无法直接访问，这使得在开发者在日常工作中会消耗额外的时间，去设置各种代理或者寻找国内的可替代的镜像源来使用。

在开源软件的世界里，几乎所有的知名项目，原本只要把代码 clone 回来，不需要做额外任何配置，只需要按照它的说明就可以直接编译源码。但由于网络的原因，在国内甚至连开源软件的源码都不太方便直接下载，一些原本只需要从 GitHub 拉下来代码就可以直接编译成功的项目，在国内也是连编译都编译不过。

国内开发者群体是非常庞大的，所以我看到了很多知名的开源项目为中国用户在 README.md 文档或是页面的显著位置都增加了中文提示，去引导国内开发者去使用国内的镜像。

[Flutter](https://flutter.dev/)

![](https://raw.githubusercontent.com/lewangdev/picb0/main/oh-my-notes/8370906848784f34a368a35724c2532c.jpg)

[powerlevel10k](https://github.com/romkatv/powerlevel10k#manual)

![](https://raw.githubusercontent.com/lewangdev/picb0/main/oh-my-notes/96b11231089b47469e9d2d6e8d6395a5.jpg)

但是，我想这种做法应该不属于 i18n，因为我很少看到有引导日本的开发者去用日本的镜像，或者引导德国的开发者去用德国的镜像，这看似解决了访问慢或者无法访问的问题，但其实是加剧了国内开发者与全球互联网的割裂，在开发者的世界里面，也形成了国内和国外两个网络。

给系统或软件单独设置代理，或者寻找国内的可替代的镜像源我都觉得不是一个好方案，因为这样在国内的你总会遇到各种各样的国外开发者就不会遇到的问题，最好还是能够拥有一个与国外开发者“用起来”好像是一样的网络环境。

[cndevnet](https://github.com/lewangdev/cndevnet) 就是为了解决这个问题而创建的，希望能帮助到和我一样遇到相同问题的国内开发者，尤其是受此困扰的初学者。

## 从 Linux 开始

cndevnet 可以在 Linux 环境下开启一个专为国内开发者设置的网络，搭配使用 vscode 进行远程开发是一种不错的体验，适合开发或者学习 python/golang/js/typescript/php/vue/react 等。

Linux 环境可以是在国内云平台上的一台云主机，也可以是运行在本地虚拟机里面的主机，或者是局域网中的一台 Linux 主机。

Debian 是一个非常棒的 Linux 发行版，推荐希望学习 Linux 的初学者使用。如果希望使用带有图形界面的 Linux 系统，Ubuntu 也是一个非常好的选择。

## cndevnet 使用了以下软件和服务

* [Debian](https://www.debian.org/)：目前支持的 Linux 系统
* iptables + ipset：结合 chnroute 和 cfroute 用于区分国内国外cf IP
* [Docker](https://docs.docker.com/engine/install/debian/): 用于运行 gost 和 smartdns 服务
* [gost](https://github.com/ginuerzh/gost): 用于建立 WSS(Websocket over TLS) 服务
* [smartdns](https://github.com/pymumu/smartdns)： 用于解决 DNS 污染
* [dnsmasq-china-list](https://github.com/felixonmars/dnsmasq-china-list/)： 国内域名
* [Cloudflare IP Range](https://www.cloudflare.com/zh-cn/ips/): Cloudflare 的 IP 范围
* [Cloudflare](https://www.cloudflare.com/zh-cn/ips/): Cloudflare 的 WSS 代理服务
* [Oracle Cloud](https://cloud.oracle.com): Oracle Cloud 的云主机

## cndevnet 原理

cndevnet 通过 iptables 等工具和数据实现了系统的透明代理，由于是系统级的透明代理，所以在启用了 cndevnet 的 Linux 系统上，是不需要为系统或者各类开发工具或者服务单独设置代理。

## cndevnet 是免费的

cndevnet 所使用的所有的软件都是开源免费的，另外 cndevnet 使用了 Cloudflare 的免费版域名和 CDN 服务以及 Oracle Cloud 的永久免费的云主机。

正是因为有 Cloudflare 和 Oracle Cloud 的免费服务，我才想到可以用它们来搭建一个给国内初学者使用的开发环境。

但是不得不说，这是一种薅羊毛的行为。资源有限，为了防止滥用，cndevnet 的密钥每天会在北京时间 0 点重新生成，如果希望继续使用，请在使用前，从 GitHub 拉取最新的代码来获取正确的密钥。

## 安装

### 准备

* Docker (如果你对 Docker 还不太熟悉，可以参考这里安装 [Docker](https://docs.docker.com/engine/install/debian/))
* 一台运行的 Debian 11 系统的主机，虚拟机或者云主机都可以
* 主机的内存至少有 1GB，推荐 2GB 以上
* 主机能够访问互联网

### 步骤

1. 下载 cndevnet 项目

```sh
git clone --depth=1 https://github.com/lewangdev/cndevnet.git ~/.cndevnet
```

2. 进入项目目录

```sh
cd ~/.cndevnet
```

3. 启动 cndevnet

```sh
sudo ./cndevnet -s start

```

## 使用帮助

```sh
cd ~/.cndevnet

./cndevnet -h
https://github.com/lewangdev/cndevnet
v1.0.0
Usage: cndevnet <command> ... [parameters ...]
Commands:
  -h, --help                 Show this help message.
  -v, --version              Show version info.
  -s <start|stop|restart>    Command to start/stop/restart cndevnet.
  --update-cfroute           Update Cloudflare IP range.
  --update-chnroute          Update China IP range.
  --update-smartdns-china    Update China domain list.


```

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

## 视频教程


* [小码哥的 YouTube 频道](https://www.youtube.com/channel/UCCplvOAql3tou-cyjxxXfqw)
