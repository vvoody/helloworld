#coding=gb2312
# classtalbe.py

import sys
from pyExcelerator import *

try:
    f = open("classtable.txt")
except IOError:
    print "输入文本文件名不对，应该是classtable.txt\n"
else:
    for record in f:
	if record == '\n':
	    print
	    continue
	if record.find("星") == -1:
	    continue
	fields = record.split()
	print fields[0]+'+',
	print fields[1]+'+',
	print fields[2]
    f.close()

print "\n/****************************************/\n"

print fields[2]
str = fields[2][:]

strList1 = str.split(']')
print strList1[0]

strList2 = strList1[0].split('[') # get weekday strList2[0]
print strList2[0], '+', strList2[1]

strList3 = strList2[1].split(')')
strList4 = strList3[0].split('(')
print strList4[0], '+', strList4[1] # get classroom strList4[1]

strList5 = strList4[0].split('-')
print strList5[0], '+', strList5[1] # get classtime strList5[0] & strList[1]

print "星期：    教室：        时间："
print strList2[0].ljust(9),
print strList4[1].ljust(13),
print strList5[0], '~', strList5[1]

print fields[0]

w = Workbook()
ws1 = w.add_sheet('user%d' % 1)
ws1.write_merge(int(strList5[0])-1, int(strList5[1])-1, 0, 0, fields[0].decode('gb2312'))
ws1.col(0).width = len(fields[0])*300
w.save('table.xls')
