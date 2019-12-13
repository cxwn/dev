# Thank and do

Some daily practice code blocks.

## 安装 virtualenv

```bash
pip install virtualenv
```

## 创建虚拟环境

```bash
virtualenv env --no-site-packages
```

## 激活虚拟环境

错误信息：

```txt
\mysite\env\Scripts> .\activate
.\activate : File C:\Users\v-ruidu\Documents\GitHub\think-and-do\mysite\env\Scripts\activate.ps1 cannot be loaded because running scripts is disabled on this syste
m. For more information, see about_Execution_Policies at https:/go.microsoft.com/fwlink/?LinkID=135170.
At line:1 char:1
+ .\activate
+ ~~~~~~~~~~
    + CategoryInfo          : SecurityError: (:) [], PSSecurityException
    + FullyQualifiedErrorId : UnauthorizedAcces
```

```powershell
Set-ExecutionPolicy unrestricted # 输入 A
```

Linux:

```bash
source activate
```

## 升级 pip, 并安装 Django

```bash
python -m pip install pip --upgrade
pip install django==1.11 #等号左右无空格
```

将虚拟环境的Scripts目录加入环境变量。

创建一个django项目：

```bash
django-admin startprojetc
```