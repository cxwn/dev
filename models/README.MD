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
