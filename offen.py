# -*- coding:utf-8 -*-
import urllib.request
DATA=b'some data'
req = urllib.request.Request(url='http://125.88.146.204', data=DATA,method='PUT')
f = urllib.request.urlopen(req)
print(f.status)
print(f.reason)

ip=('125.88.146.204','114.248.118.240')

remote_addr='125.88.146.76:15350'

url=['http://admin.sqqmall.com/download/qssqian.apk']