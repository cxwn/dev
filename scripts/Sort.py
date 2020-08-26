# -*- coding:utf-8 -*-
import numpy as np

random_seed = np.random.RandomState(2)  # 产生随机种子
array = np.zeros((6, 7), dtype=float)  # 定义数组形状
tuple_list = []
list_x = []
list_y = []
for m in range(6):
    for n in range(7):
        array[m][n] = round(random_seed.uniform(0, 20), 2)
max_value = array.max()
min_value = array.min()
test_num = 0
temp_list = [max_value]
while test_num < 7:
    for x in range(6):
        for y in range(7):
            if array[x][y] == max_value:
                tuple_list.append((x, y))
                list_x.append(tuple_list[len(tuple_list)-1][0])
                list_y.append(tuple_list[len(tuple_list)-1][1])
                array[x][y] = array.min()
                test_num = test_num + 1
            if array[x][y] == array.max() and x not in list_x and y not in list_y:
                temp_list.append(array[x][y])
                tuple_list.append((x, y))
                array[x][y] = array.min()

print(temp_list)
print(len(temp_list))
print(tuple_list)
print(list_x)
print(list_y)

