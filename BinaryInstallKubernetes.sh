```bash
[root@gysl-m ~]# mkdir -p /etc/kubernetes/ssl
[root@gysl-m ~]# cd /etc/kubernetes/ssl/
[root@gysl-m ssl]# openssl genrsa -out ca.key 2048
Generating RSA private key, 2048 bit long modulus
..................+++
................+++
e is 65537 (0x10001)
[root@gysl-m ssl]# openssl req -x509 -new -nodes -key ca.key -subj "/CN=k8s-master" -days 5000 -out ca.pem
[root@gysl-m ssl]# echo \
'[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
DNS.5 = k8s_master
IP.1 = 10.1.1.8
IP.2 = 172.31.3.11'>../openssl.conf
[root@gysl-m ssl]# openssl genrsa -out server.key 2048
Generating RSA private key, 2048 bit long modulus
...........+++
..........................................................+++
e is 65537 (0x10001)
[root@gysl-m ssl]# openssl req -new -key server.key -subj "/CN=gysl-m" -config ../openssl.conf -out server.csr
[root@gysl-m ssl]# openssl x509 -req -in server.csr -CA ca.pem -CAkey ca.key -CAcreateserial -days 5000 -extensions v3_req -extfile ../openssl.conf -out server.crt
Signature ok
subject=/CN=gysl-m
Getting CA Private Key
[root@gysl-m ssl]# openssl genrsa -out client.key 2048
Generating RSA private key, 2048 bit long modulus
...............................+++
...............................................................+++
e is 65537 (0x10001)
[root@gysl-m ssl]# openssl req -new -key client.key -subj "/CN=gysl-m" -out client.csr
[root@gysl-m ssl]# openssl x509 -req -in client.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out client.crt -days 5000
Signature ok
subject=/CN=gysl-m
Getting CA Private Key
[root@gysl-m ssl]# ls
ca.key  ca.pem  ca.srl  client.crt  client.csr  client.key  server.crt  server.csr  server.key
```

#### 3.5.2 安装配置etcd服务

```bash
[root@gysl-m ~]# tar -xvzf etcd-v3.2.26-linux-amd64.tar.gz
[root@gysl-m ~]# mv etcd-v3.2.26-linux-amd64/{etcd,etcdctl} /usr/local/bin/
[root@gysl-m ~]# echo \
'[Unit]
Description=Etcd Server
After=network.target
[Service]
Type=simple
EnvironmentFile=-/etc/etcd.conf
WorkingDirectory=/var/lib/etcd
ExecStart=/usr/local/bin/etcd
Restart=on-failure
[Install]
WantedBy=multi-user.target'>/usr/lib/systemd/system/etcd.service
[root@gysl-m ~]# mkdir -p /var/lib/etcd/
[root@gysl-m ~]# touch /etc/etcd.conf
[root@gysl-m ~]# systemctl daemon-reload
[root@gysl-m ~]# systemctl start etcd
[root@gysl-m ~]# systemctl enable etcd
Created symlink from /etc/systemd/system/multi-user.target.wants/etcd.service to /usr/lib/systemd/system/etcd.service.
[root@gysl-m ~]# etcdctl cluster-health
member 8e9e05c52164694d is healthy: got healthy result from http://localhost:2379
cluster is healthy
```

#### 3.5.3 安装配置kube-apiserver服务

```bash
[root@gysl-m ~]# tar -xzf kubernetes-server-linux-amd64.tar.gz
[root@gysl-m ~]# mv kubernetes/server/bin/kube-apiserver /usr/local/bin/
[root@gysl-m ~]# mkdir /etc/kubernetes/
[root@gysl-m ~]# echo \
'KUBE_API_ARGS="--advertise-address=172.31.3.11 \
--storage-backend=etcd3 \
--etcd-servers=http://172.31.3.11:2379 \
--bind-address=172.31.3.11 \
--service-cluster-ip-range=10.1.1.0/24 \
--service-node-port-range=30000-65535 \
--enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \
--logtostderr=false \
--log-dir=/var/log/kubernetes/apiserver \
--v=2 \
--client-ca-file=/etc/kubernetes/ssl/ca.pem \
--tls-private-key-file=/etc/kubernetes/ssl/server.key \
--tls-cert-file=/etc/kubernetes/ssl/server.crt"'>/etc/kubernetes/apiserver.conf
[root@gysl-m ~]# echo \
'[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=etcd.service
Wants=etcd.service

[Service]
Type=simple
WorkingDirectory=/var/lib/kubernetes/kube-apiserver/
EnvironmentFile=/etc/kubernetes/apiserver.conf
ExecStart=/usr/local/bin/kube-apiserver  $KUBE_API_ARGS
Restart=on-failure
LimitNOFIFE=65536

[Install]
WantedBy=multi-user.target'>/usr/lib/systemd/system/kube-apiserver.service
[root@gysl-m ~]# mkdir -p /var/lib/kubernetes/kube-apiserver/
[root@gysl-m ~]# mkdir -p /var/log/kubernetes/apiserver
[root@gysl-m ~]# systemctl daemon-reload
[root@gysl-m ~]# systemctl start kube-apiserver
[root@gysl-m ~]# systemctl enable kube-apiserver
Created symlink from /etc/systemd/system/multi-user.target.wants/kube-apiserver.service to /usr/lib/systemd/system/kube-apiserver.service.
[root@gysl-m ~]# systemctl status kube-apiserver
● kube-apiserver.service - Kubernetes API Server
   Loaded: loaded (/usr/lib/systemd/system/kube-apiserver.service; enabled; vendor preset: disabled)
   Active: active (running)
```

至此，kube-apiser部署成功。一些启动参数如下：

- etcd_servers: 指定etcd服务的URL。
- insecure-bind-address： apiserver绑定主机的非安全端口，设置0.0.0.0表示绑定所有IP地址
- insecure-port: apiserver绑定主机的非安全端口号，默认为8080。
- service-cluster-ip-range: Kubernetes集群中service的虚拟IP地址范围，以CIDR表示，该IP范围不能与物理机的真实IP段有重合。
- service-node-port-range: kubernetes集群中Service可映射的物理机端口号范围，默认为30000–32767。
- admission_control: kubernetes集群的准入控制设置，各控制模块以插件的形式依次生效。
- logtostderr: 设置为false表示将日志写入文件，不写入stderr。
- log-dir: 日志目录。
- v: 日志级别。
  
#### 3.5.4 准备kubeconfig文件

文件内容如下：

```yaml
apiVersion: v1
kind: Config
users:
- name: gysl
  user:
    client-certificate: /etc/kubernetes/ssl/client.crt
    client-key: /etc/kubernetes/ssl/client.key
clusters:
- name: gysl-cluster
  cluster:
    certificate-authority: /etc/kubernetes/ssl/ca.pem
contexts:
- context:
    cluster: gysl-cluster
    user: gysl
  name: gysl-context
current-context: gysl-context
```

```bash
[root@gysl-m ~]# echo \
'apiVersion: v1
kind: Config
users:
- name: gysl
  user:
    client-certificate: /etc/kubernetes/ssl/client.crt
    client-key: /etc/kubernetes/ssl/client.key
clusters:
- name: gysl-cluster
  cluster:
    certificate-authority: /etc/kubernetes/ssl/ca.pem
contexts:
- context:
    cluster: gysl-cluster
    user: gysl
  name: gysl-context
current-context: gysl-context'>/etc/kubernetes/kubeconfig.yaml
```

#### 3.5.5 安装配置kube-controller-manager服务

```bash
[root@gysl-m ~]# mv kubernetes/server/bin/kube-controller-manager /usr/local/bin/
[root@gysl-m ~]# echo \
'KUBE_CONTROLLER_MANAGER_ARGS=" \
--master=https://172.31.3.11:6443 \
--service-account-private-key-file=/etc/kubernetes/ssl/server.key \
--root-ca-file=/etc/kubernetes/ssl/ca.pem \
--kubeconfig=/etc/kubernetes/kubeconfig.yaml \
--logtostderr=false \
--log-dir=/var/log/kubernetes/controller-manager \
--v=2"'>/etc/kubernetes/controller-manager.conf
[root@gysl-m ~]# mkdir -p /var/log/kubernetes/controller-manager
[root@gysl-m ~]# echo \
'[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=kube-apiserver.service
Requires=kube-apiserver.service

[Service]
WorkingDirectory=/var/lib/kubernetes/kube-controller-manager/
EnvironmentFile=/etc/kubernetes/controller-manager.conf
ExecStart=/usr/local/bin/kube-controller-manager $KUBE_CONTROLLER_MANAGER_ARGS
Restart=on-failure
LimitNOFIFE=65536

[Install]
WantedBy=multi-user.target'>/usr/lib/systemd/system/kube-controller-manager.service
[root@gysl-m ~]# mkdir -p /var/lib/kubernetes/kube-controller-manager
[root@gysl-m ~]# systemctl daemon-reload
[root@gysl-m ~]# systemctl start kube-controller-manager
[root@gysl-m ~]# systemctl enable kube-controller-manager
Created symlink from /etc/systemd/system/multi-user.target.wants/kube-controller-manager.service to /usr/lib/systemd/system/kube-controller-manager.service.
[root@gysl-m ~]# systemctl status kube-controller-manager
● kube-controller-manager.service - Kubernetes Controller Manager
   Loaded: loaded (/usr/lib/systemd/system/kube-controller-manager.service; enabled; vendor preset: disabled)
   Active: active (running) 
```

kube-controller-manager服务安装配置成功！

#### 3.5.6 安装配置kube-scheduler服务

```bash
[root@gysl-m ~]# echo \
'KUBE_SCHEDULER_ARGS="\
--master=https://172.31.3.11:6443 \
--kubeconfig=/etc/kubernetes/kubeconfig.yaml \
--logtostderr=false \
--log-dir=/var/log/kubernetes/scheduler \
--v=2"'>/etc/kubernetes/scheduler.conf
[root@gysl-m ~]# mkdir /var/log/kubernetes/scheduler
[root@gysl-m ~]# echo \
'[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=kube-apiserver.service
Wants=kube-apiserver.service

[Service]
WorkingDirectory=/var/lib/kubernetes/kube-scheduler/
EnvironmentFile=/etc/kubernetes/scheduler.conf
ExecStart=/usr/local/bin/kube-scheduler $KUBE_SCHEDULER_ARGS
LimitNOFIFE=65536
Restart=on-failure

[Install]
WantedBy=multi-user.target'>/usr/lib/systemd/system/kube-scheduler.service
[root@gysl-m ~]# mkdir -p /var/lib/kubernetes/kube-scheduler/
[root@gysl-m ~]# systemctl daemon-reload
[root@gysl-m ~]# systemctl start kube-scheduler
[root@gysl-m ~]# systemctl enable kube-scheduler
Created symlink from /etc/systemd/system/multi-user.target.wants/kube-scheduler.service to /usr/lib/systemd/system/kube-scheduler.service.
[root@gysl-m ~]# systemctl status kube-scheduler
● kube-scheduler.service - Kubernetes Scheduler
   Loaded: loaded (/usr/lib/systemd/system/kube-scheduler.service; enabled; vendor preset: disabled)
   Active: active (running) 
```

kube-scheduler服务安装配置成功。