from django.shortcuts import HttpResponse, redirect, render

from app import models


# Create your views here.
def publisher_list(request):
    ret = models.Publisher.objects.all().order_by('id')
    return render(request, "publisher_list.html", {"publisher_list": ret})

def add_publisher(request):
    error_msg = ''
    if request.method == "POST":
        new_name = request.POST.get("publisher_name")
        if new_name:
            models.Publisher.objects.create(name=new_name)
            return redirect("/publisher_list/")
        else:
            error_msg = "出版社的名称不能为空！"

    return render(request, "add_publisher.html", {"error": error_msg})

def delete_publisher(request):
    del_id = request.GET.get("id", None)
    if del_id:
        del_obj = models.Publisher.objects.get(id=del_id)
        del_obj.delete()
        return redirect("/publisher_list/")
#    elif del_id not in models.Publisher.obkects.all().get('id'):
#        return HttpResponse("请求的页面不存在！")
    else:
        return HttpResponse("要删除的数据不存在！")
    

def test(request):
    print(request.GET)
    print(request.GET.get("id"))
    return HttpResponse("OK")

def edit_publisher(request):
    if request.method == "POST":
        edit_id = request.POST.get("id")
        new_name = request.POST.get("publisher_name")
        edit_publisher = models.Publisher.objects.get(id=edit_id)
        edit_publisher.name = new_name
        edit_publisher.save()
        return redirect("/publisher_list/")

    edit_id = request.GET.get('id')
    if edit_id:
        publisher_obj = models.Publisher.objects.get(id=edit_id)
        return render(request, "edit_publisher.html", {"publisher": publisher_obj})
    else:
        return HttpResponse("编辑的出版社不存在！")
