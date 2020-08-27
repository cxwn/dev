# README

## 一 环境配置

```bash
sudo yum -y install python3
python3 --version
pip install pip -U
pip -V
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
echo "export PATH=$PATH:$HOME/.local/bin">>~/.bashrc
source ~/.bashrc
virtualenv env
mdkir ~/dev/udfs
cd ~/dev/udfs
virtualenv --system-site-packages env
source env/bin/activate
# deactivate
pip install django==2.2.15
django-admin startproject udfs
cd udfs
django-admin startapp udfs
# mkvirtualenv zqxt：创建运行环境zqxt
# workon zqxt: 工作在 zqxt 环境 或 从其它环境切换到 zqxt 环境
# deactivate: 退出终端环境
# rmvirtualenv ENV：删除运行环境ENV
# mkproject mic：创建mic项目和运行环境mic
# mktmpenv：创建临时运行环境
# lsvirtualenv: 列出可用的运行环境
# lssitepackages: 列出当前环境安装了的包

curl -L -C - -O https://www.sqlite.org/2020/sqlite-autoconf-3330000.tar.gz
tar -xvzf sqlite-autoconf-3330000.tar.gz
cd sqlite-autoconf-3330000
./configuration
make
make test
make install
```

```Dockerfile
FROM centos:7.8.2003

LABEL author="ivandu" e-mail="mrivandu@hotmail.com" version="1.0.20200827" python_version="3.6.8"

RUN set -eux; \
    yum -y install python3; \
    pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U; \
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

```Dockerfile
FROM python:3.6.8

LABEL author="ivandu" e-mail="mrivandu@hotmail.com" version="1.0.20200827" flask_version="1.1.2"

RUN set -eux; \
    useradd -u 1000 ivandu; \
    yum -y install vim; \
    pip install flask==1.1.2

USER 1000

WORKDIR /home/ivandu

RUN set -eux; \
    sed -i "\$a alias vi='vim'" /home/ivandu/.bashrc; \
    mkdir dev; \
    cd dev; \
    python3 -m venv --without-pip --system-site-packages env

VOLUME /home/ivandu/dev\

EXPOSE 5000

CMD ["/bin/bash"]
```

```bash
docker run -it --net host --name flask --hostname devops -v ${PWD}:/home/ivandu/dev flask:1.1.2
```
