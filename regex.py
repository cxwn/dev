# -*- coding:utf-8 -*-
import re

"""
test_str = '<h1>my test regex.</h1><p>my test context.</p>'
test_re = re.compile("\\w*")
li = re.findall(test_re, test_str)
while '' in li:
    li.remove('')
for i in range(1,5,2):
    print(i)
print(li)
"""

tuple_test = (2, 4)
new_tuple = tuple_test.__add__((3,4))
print(new_tuple.count(4))
print(tuple_test.index(4))
print(tuple_test)
print(new_tuple)