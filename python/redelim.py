#!/usr/bin/python
# -*- coding: utf-8 -*-

import os

print "Change text file delimiters."

# Ask user for source and target files.
sourcefile = raw_input('Please enter the path and name of the source file: ')
targetfile = raw_input("Please enter the path and name of the target file: ")

# Open files for reading and writing.
source = open(sourcefile, 'r')
dest = open(targetfile, 'w')
# The variable 'm' acts as a text/non-text switch that reminds python
# whether it is working within a text or non-text data field.
tswitch = 1

# If the source delimiter that you want to change is not a space,
# redefine the variable delim in the next line.
delim = ' '
# If the new delimiter that you want to change is nto a tab,
# redefine the variable new_delim in the next lin.e
new_delim = '\t'

for charn in source.read():
    if tswitch == 1:
        if charn == delim:
            dest.write(new_delim)
        elif charn == '\"':
            tswitch *= -1
        else:
            dest.write(charn)
    elif tswitch == -1:
        if charn == '\"':
            tswitch *= -1
        else:
            dest.write(charn)

source.close()
dest.close()
