# -*- coding:utf-8 -*-
# Create your views here.
from django.shortcuts import render
from django.http import HttpResponse

def hello(request):
    return HttpResponse("Hello World!")