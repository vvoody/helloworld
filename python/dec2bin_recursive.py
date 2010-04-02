#!/usr/bin/python
# Display the binary form of a decimal number by a recursive  method.
#
# For example, you input 11 and we will display '1011'.
#
# Copyright (C) vvoody <wxj.g.sh@gmail.com>
#
# GNU GPLv2 licenced.

def dec2bin( dec ):
    if(dec != 0 and not(dec2bin( dec / 2 ))):
        print dec & 1,

dec2bin(11)
