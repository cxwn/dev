# Kubernetes

1. Pod 的 containerPort 字段不能重新指定容器默认的端口，和 hostPort 搭配使用时，containerPort 不能省略，否则会报错。也就是说，只指定 hostPort 而没有 containerPort 是不行的。如果部署的应用有端口需要暴露，那么 containerPort 也是不能省略的，必须与制作镜像时指定暴露的端口一致。

2. 如果一个 Pod 已经部署成功，那么在更新这个 Pod 时，里面的 container 个数不能增加也不能减少，但是可以用其他镜像进行替换。