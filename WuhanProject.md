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

## Stop Four Test

SpeechClient.exe -i ../../testAudio -h 13.78.128.75:34932 -l zh-CN -r 16000 –IsRealtime


Websocket参数：
ws://{host}/Transcribe?UseVad={useVad}&IsRealtime={isRealtime}              &AddPunctuation={addPunctuation}&TagKeyword={tagKeyword}&NeedIntermediateResult={needIntermediateResult}
                
参数说明：
参数	说明	示例
host	Websocket服务主机和端口	192.168.1.1:32934
UseVad	是否使用VAD断句	UseVad=True
IsRealtime	是否实时语音识别	IsRealtime=True
AddPunctuation	是否要在识别结果加标点符号	AddPunctuation=False
TagKeyword	是否要标出关键字	TagKeyword=False
NeedIntermediateResult	是否要返回中间识别结果	NeedIntermediateResult=False

示例代码(C#)：

public void Transcribe(string audioPath, string locale, int sampleRate, int batchSize, string host, bool useVad, bool isRealtime, bool addPunctuation, bool tagKeyword, bool needIntermediateResult)
{
    Console.WriteLine(du"Start connecting web socket server");
    string url = $"ws://{host}/Transcribe?UseVad={useVad}&IsRealtime={isRealtime}&AddPunctuation={addPunctuation}&TagKeyword={tagKeyword}&NeedIntermediateResult={needIntermediateResult}";

    webSocket = new WebSocket(url);
    webSocket.OnMessage += (sender, e) =>
    {
        var pack = JsonConvert.DeserializeObject<SocketPackServer>(e.Data);
        switch (pack.Type)
        {
            case MessageType.Sentence:
                 Console.WriteLine("{0}: {1} ", pack.Type.ToString(), pack.Message);
                 break;
            case MessageType.Intermediate:
                 Console.WriteLine("{0}: {1} ", pack.Type.ToString(), pack.Message);
                 break;
            case MessageType.Completion:
                 Console.WriteLine(GetTimeStamp() + "complete");
                 break;
            case MessageType.Error:
                 Console.WriteLine(GetTimeStamp() + "error {0}", pack.Message);
                 // Do something
                 break;
            default:
                 Console.WriteLine("Unknow Message type {0}", pack.Type);
                 break;
       }
    };

    webSocket.OnError += (sender, e) =>
    {
        // Do something
    };

    webSocket.OnClose += (sender, e) =>
    {
        // Do something
    };
     
    webSocket.Connect();

    Console.WriteLine("Start sending data: {0}", audioPath);

    byte[] audio = File.ReadAllBytes(audioPath);            
    using (var memStream = new MemoryStream(audio))
    {
        int totalBytesRead = 0;
        int bytesRead = 0;

        int batchLength = audio.Length;
        if (isRealtime)
        {
            batchLength = batchSize;
        }

        do
        {                    
            if (audio.Length - totalBytesRead < batchLength)
            {
                batchLength = audio.Length - totalBytesRead;
            }
            var buffer = new byte[batchLength];
            bytesRead = memStream.Read(buffer, 0, buffer.Length);
            if (bytesRead != 0)
            {
                totalBytesRead += bytesRead;
                var spack = new SocketPackClient();
                spack.Id = messageId++.ToString();
                spack.Audio = buffer;
                spack.Locale = locale;
                spack.SampleRate = sampleRate;
                webSocket.Send(JsonConvert.SerializeObject(spack));
                if (isRealtime)
                {
                    Thread.Sleep(10); // sleep to simulate the real scenario
                }
            }
        } while (totalBytesRead < audio.Length);
    }

    Console.WriteLine("All data sent");
    // send empty audio to indicate the end of audio stream
    if (isRealtime)
    {
        var spack = new SocketPackClient();
        spack.Id = messageId++.ToString();
        spack.Audio = new byte[0];
        spack.Locale = locale;
        spack.SampleRate = sampleRate;
        webSocket.Send(JsonConvert.SerializeObject(spack));
    }
    Console.WriteLine("All data sent + end");
}