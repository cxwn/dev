#!/bin/bash
systemctl stop firewalld
systemctl disable firewalld
sed -i 's/=enforcing/=disabled/' /etc/selinux/config
echo "172.31.2.11 k8s-m
172.31.2.12 k8s-n1">>/etc/hosts
echo "net.ipv4.ip_forward = 1">>/etc/sysctl.conf
echo 'net.bridge.bridge-nf-call-iptables = 1'>>/etc/sysctl.conf
echo 'net.bridge.bridge-nf-call-ip6tables = 1'>>/etc/sysctl.conf
sysctl -p
curl -C - -O http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
mv docker-ce.repo /etc/yum.repos.d/
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
yum list docker-ce --showduplicates|grep "^doc"|sort -r
yum -y install docker-ce-18.06.0.ce-3.el7
systemctl enable docker && systemctl start docker
echo '[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg'>/etc/yum.repos.d/kubernetes.repo
yum install -y kubelet-1.12.1-0.x86_64 kubeadm-1.12.1-0.x86_64 kubectl-1.12.1-0.x86_64 --disableexcludes=kubernetes
systemctl enable kubelet && systemctl start kubelet
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver-amd64:v1.12.1
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager-amd64:v1.12.1
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler-amd64:v1.12.1
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy-amd64:v1.12.1
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/etcd-amd64:3.2.24
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.2.2
docker pull registry.cn-shenzhen.aliyuncs.com/cp_m/flannel:v0.10.0-amd64
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1 k8s.gcr.io/pause:3.1
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.2.2 k8s.gcr.io/coredns:1.2.2
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/etcd-amd64:3.2.24 k8s.gcr.io/etcd:3.2.24
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler-amd64:v1.12.1 k8s.gcr.io/kube-scheduler:v1.12.1
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager-amd64:v1.12.1 k8s.gcr.io/kube-controller-manager:v1.12.1
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver-amd64:v1.12.1 k8s.gcr.io/kube-apiserver:v1.12.1
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy-amd64:v1.12.1 k8s.gcr.io/kube-proxy:v1.12.1
docker tag registry.cn-shenzhen.aliyuncs.com/cp_m/flannel:v0.10.0-amd64 quay.io/coreos/flannel:v0.10.0-amd64
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver-amd64:v1.12.1
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager-amd64:v1.12.1
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler-amd64:v1.12.1
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy-amd64:v1.12.1
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/etcd-amd64:3.2.24
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.2.2
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy-amd64:v1.12.1
echo 'KUBELET_KUBEADM_ARGS=--cgroup-driver=cgroupfs  --cni-bin-dir=/opt/cni/bin --cni-conf-dir=/etc/cni/net.d --network-plugin=cni'>/var/lib/kubelet/kubeadm-flags.env
cat /var/lib/kubelet/kubeadm-flags.env
kubeadm init --kubernetes-version=1.12.1 --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=172.31.3.11
kubeadm join 172.31.3.11:6443 --token nmrljc.ikxkuwo3cvxkn04z --discovery-token-ca-cert-hash sha256:cde612f2a687c780d828906bc55ac738e84b8133c9116b1f872d91399032b5b8