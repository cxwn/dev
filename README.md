# README

## PIP

```shell
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple some-package
# 注意，simple 不能少, 是 https 而不是 http

# 设为默认，升级 pip 到最新的版本 (>=10.0.0) 后进行配置：

python -m pip install pip -U
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 如果您到 pip 默认源的网络连接较差，临时使用本镜像站来升级 pip：
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U
```
