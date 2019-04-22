# -*- coding:utf-8 -*-
import requests
import multiprocessing

cpus = multiprocessing.cpu_count()
url = 'http://admin.sqqmall.com/admin/vcode.php'

def download():
  while True:
    with open("ip_pool.txt","r") as ip:
      ip_ports = ip.readlines()
    for ip_port in ip_ports:
      proxies = { "http":"http://" + ip_port.strip('\n') }
      res = requests.get(url, proxies=proxies)
      if res.status_code == 200 :
        with open("result.png", 'wb') as out:
          out.write(res.content)

if __name__ == "__main__":
  for i in range(cpus):
    try:
      p = multiprocessing.Process(target=download(), args=(i,))
      p.start()
    except:
      continue