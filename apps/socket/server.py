#! -*- coding:utf-8 -*-
import socket

s = socket.socket()
hostname = socket.gethostname()
port = 33200
s.bind((hostname,port))
s.listen(5)

while True:
    c,addr = s.accept()
#    print("连接地址："+ addr)
    s.send("欢迎使用本socket服务！")
    s.close()