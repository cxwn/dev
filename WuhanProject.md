# Work step

## Step One:Ready

The on-premise k8s cluster for Speech services and Docker registry is ready:

||||
|:--:|:--:|:--:|
Machine|Role|Status
10.163.4.18|DockerRegistry|Ready
10.163.4.19|Master|Ready
10.163.4.20|Worker|Ready
10.163.4.27|Worker|Ready
10.163.4.28|Worker|Ready
10.163.4.60|Worker|Ready

## Step Two:Pull Images

You can log on to master node and run kubectl get nodes to see the details.

Also, I deployed one registry service on 10.163.4.18:

1 .You can save and copy images to this machine, put the files under /es/microsoft_docker  folder,
Then run docker load -i … to load the image, then tag the image as localhost:5000/your_image_name:tag.

For example, I’ve tagged one as localhost:5000/registry:latest. Then you can push this image to the local registry.

2 .All the k8s nodes already know this insecure registry, in your deployment yaml files, just reference these images.

As 10.163.4.18:5000/your_image_name:tag, and k8s will know where to find these images.

I’ve tested the cluster as well as the registry. Please feel free to deploy your services to the cluster, then we can switch
SR/TTS calls.

You may need vpn to access these machines:
地址：116.211.91.244
账号：szrx_003
密码：szzx12345-wr
You need to access this address, then in options tab, choose to download the svn client
Then you can use the client to access this vpn. Only one user is allowed to connect at one time.

## Step Three Run Container

Richland:

sudo docker run -e MODELSPATH="/usr/local/models" -e ENGINE_CONFIG_OVERRIDE="/usr/local/models/models3.json" --rm -p 50051:50051 -v /root/MS_ASR/models/Model_0219:/usr/local/models:z -ti d2a20834f71e

Speech host:

sudo docker run --privileged --cap-add sys_ptrace --net=host --rm -e SR_URL=localhost:50051 -v /root/MS_ASR/images/SpeechHost:/home/henlin/SpeechHost:z -ti speechhost
