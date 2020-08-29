# -*- coding:utf-8 -*-

from flask import Flask
from flask import render_template
from flask import request
from flask import redirect
from flask import session

app = Flask(__name__)#,template_folder='html')

@app.route("/login",methods = ['GET','POST'])
def login():
    if request.method == 'GET':
        return render_template('login.html')
    user = request.form.get("user")
    pwd = request.form.get("pwd")
    if user == 'ivan' and pwd == '123':
        del session ['user_info']
        session['user_info'] = user
        return redirect('/index')
    else:
        return render_template('login.html',**{'msg':'用户名或密码错误'})

@app.route('/index')
def index():
    user_info = session.get('user_info')
    if not user_info:
        return redirect('/login')
    return "欢迎登录"

if __name__ == "__main__":
    app.run()
