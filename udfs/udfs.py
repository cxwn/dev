# -*- coding:utf-8 -*-

from flask import Flask

app = Flask(__name__)

@app.route('/')

def hello():
    return '<h1>My name is ivan du.<h1>'

if __name__ == '__main__':
    app.run(debug=True)
    