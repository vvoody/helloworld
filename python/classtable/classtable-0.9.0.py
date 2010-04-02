#!/usr/bin/env python
#coding=gb2312
# classtable-0.9.0.py
#
# (C) 2008 vvoody
# Licenced under GNU GPLv2 licence
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

# How many user sheets there are.
userCount = 0
# We let record = '\n' to create our first user sheet automatically
# from the next *while* program block.
# Otherwise, we will create our first sheet which won't be written
# anything into, if the data file(classtable.txt) begins with some
# blank lines.
record = '\n'

while( record != ""): # End-Of-File
    fields = record.split()
    if fields == []:
	print "It's a EMPTY line."
	record = f.readline()
	while( record.split() == [] ):
	    print "It's a EMPTY line."
	    record = f.readline()
	    if record == "":
		break
	
	userCount += 1
	print "\nNew sheet user_%d created.\n" % userCount
	# create a new sheet.
	sheet = wb.add_sheet('user_%d' % userCount)
	sheet.panes_frozen = True
	sheet.horz_split_pos = 6
	# initialize some var
	# We need to write the className and classTeacher
	# at the end of user's sheet.
	name_teacher = 0
	max_width_class_name = 0
	#
	max_width_col = [0, 0, 0, 0, 0]
	continue

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
    class_name = recordDict['className']
    width_class_name = len( class_name )

    if width_class_name > max_width_class_name:
	max_width_class_name = width_class_name    

    for day in recordDict['classDay']:
	col = day2num[day] - 1
	row = recordDict['classNum'][t]
	if width_class_name > max_width_col[col]:
	    max_width_col[col] = width_class_name
	print "max_width_col[%d] = %d " % (col, max_width_col[col]),
	sheet.write_merge(row[0]-1, row[1]-1, col, col, (class_name + '(' + recordDict['classRoom'][t]).decode('gb2312') + ')', style0)
	# Because we also have classRoom, so the width won't be 300 but 400.
	sheet.col(col).width = max_width_col[col] * 400
	t += 1
    
    print
    sheet.write(name_teacher, 7, class_name.decode('gb2312'), style0)
    sheet.write(name_teacher, 8, recordDict['classTeacher'].decode('gb2312'), style0)

    sheet.col(7).width = max_width_class_name * 300
    name_teacher += 1
    record = f.readline()

f.close()
wb.save("classtable.xls")
