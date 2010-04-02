#!/usr/bin/env python
#coding=gb2312
# classtable-0.5.0.py
#
# This program can *only*
# 1. deel with one table,
# 2. no auto-col-width, 
# 3. and won't write the classes 
#    which have no classDay, classNum and classRoom
#

import sys
from pyExcelerator import *

def getClassDay( element ):
    '''Get the class days.

    We can know which day in the week we will have the class.
 
    Type:    string list
    Format:
    ['classDay_1', 'classDay_2']'''
    
    return ( element.split('[') )[0]

def getClassNum( element ):
    '''Get the class numbers.

    We can know when our class starts and ends.
    
    Type:    integer list
    Format:
    [[1, 2], [7, 8]]'''
    
    element = element.split('(')[0]
    element = element.split('[')[1]
    element = element.split('-')
    element[0] = int(element[0])
    element[1] = int(element[1])
    return element

def getClassRoom( element ):
    '''Get the class room.

    We can know where we should have the class.

    Type:    string list
    Format:
    ['classRoom_1', 'classRoom_2']'''
    
    element = element.split('(')[1]
    return ( element.split(')') )[0]

# open file to import the data
try:
    f = open("classtable.txt")
except IOError:
    print >> sys.stderr, "数据文件的文件名不正确，必须为classtable.txt"
    sys.exit(1)

# create a Excel Workbook
# the students' classtables of one whole class will be stored in 'wb'.
wb = Workbook()

# sheet font & style
align0 = Alignment()
align0.horz = Alignment.HORZ_CENTER
align0.vert = Alignment.VERT_CENTER

style0 = XFStyle()
style0.alignment = align0

# How many students there are.
userCount = 1
sheet = wb.add_sheet('user_%d' % userCount)

# a dictionary about to be written into the sheet
recordDict = {'className'    : '',
	      'classTeacher' : '',
	      'classDay'     : [],
	      'classNum'     : [],
	      'classRoom'    : []
	      }

# a easy way to change classDay( string ) to number( integer )
day2num = {'星期一' : 1,
	   '星期二' : 2,
	   '星期三' : 3,
	   '星期四' : 4,
	   '星期五' : 5
	   }

# Get one line from file each time. 'record' is a string to split.
record = f.readline()

while( record != ""): # End-Of-File
    fields = record.split()
    recordDict['className'] = fields[0]
    recordDict['classTeacher'] = fields[1]
    
    fieldsLength = len(fields)

    # get classDay
    tempList = [] # store classDay
    for i in range(2, fieldsLength):
	tempList.append( getClassDay(fields[i]) )
    
    recordDict['classDay'] = tempList
    del tempList

    # get classNum
    tempList = []
    for i in range(2, fieldsLength):
	tempList.append( getClassNum(fields[i]) )
    
    recordDict['classNum'] = tempList
    del tempList

    # get classRoom
    tempList = []
    for i in range(2, fieldsLength):
	tempList.append( getClassRoom(fields[i]) )

    recordDict['classRoom'] = tempList
    del tempList
    
    # Write the recordDict to sheet
    t = 0
    for day in recordDict['classDay']:
	col = day2num[day] - 1
	row = recordDict['classNum'][t]
	sheet.write_merge(row[0]-1, row[1]-1, col, col, (recordDict['className'] + recordDict['classRoom'][t]).decode('gb2312'), style0)
	t += 1

    record = f.readline()

wb.save("classtable.xls")
