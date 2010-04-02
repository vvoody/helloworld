#!/usr/bin/env python
#
# This program simulates how CRC works, which is written by Python.
#
# by vvoody <wxj.g.sh{AT}@gmail.com>
# 
# Updated Mon Nov 17 CST 2008
# 
# In this program, I use many xxx2xxx functions. For instance, convert
# binary string to decimal (binStr2dec) and convert decimal to binary
# string(dec2bin). Maybe this is complicated. But I think, actually in
# the working machine, the CRC procedure just does with digits. So the
# emphasis of CRC.py is the xor_div() function. It actually simulates
# how CRC works.
# 
# ##################################
# M = 1011011, n = 3, P = 1101
#                
#           _____1100101__
# P--> 1101 ) 1011011000
#             1101   ---
#             ----    |-----> append n bits
#              1100
#              1101
#              ----
#               0011
#               0000
#               ----
#                0111
#                0000
#                ----
#                 1110
#                 1101
#                 ----
#                  0110
#                  0000
#                  ----
#                   1100
#                   1101
#                   ----
#                    001 --> R(FCS)
#
# send << M + FCS = 1011011_001
#
# ##################################


import sys

def isBinary( num ):
    """This function checks if the number is a binary number.

    If num is a binary then return True, otherwise False."""

    for i in num:
        if not (i=='0' or i=='1'):
            print "Invalid number!"
            return False
    return True

# int(bin, 2) is better ;-) I was stupid.
def binStr2dec( bin ):
    """This function makes the binary string exchange to decimal.

    For example:
    '10101' -> 21"""

    sum = 0
    #l = len(bin)
    for i in range( len(bin) ):
        sum += pow(2, i) * int(bin[-i-1])
    return sum

def dec2bin( dec ):
    """This function displays a binary form of a decimal number by a recursive method.

    For example:
    729 -> '1 0 1 1 0 1 1 0 0 1'"""

    if(dec != 0 and not(dec2bin(dec / 2))):
        print dec & 1,

def getNum( num ):
    """Let user input the numbers and do an easy check.

    """
    print num,
    var = raw_input(" is ? ")
    while(not isBinary(var)):
        print
        print "Invalid number!"
        print num,
        var = raw_input(" is ? ")
    
    return var

def xor_div(dividend, divisor, len_dividend, n):
    """This function runs the procedure above.

    'dividend' is M. 'divisor' is P. 'L' is the length of M.
    * send    : xor_div(M<<n, P, len_M+n, n)
    * receive : xor_div(M, P, len_M, n)
    * R is remainder. FCS = R"""

    M = dividend
    P = divisor

    # How long left moves depends on 'step'
    step = len_dividend-n-1

    left = M >> step
    right = P 
    R = left^right
    step -= 1

    while(step != -1):
        # next bit is 0 or 1.
        flag = (M>>(step)) & 1
        left = (R<<1) | flag

        if(left>>n):
            right = P
        else:
            right = 0

        R = left^right
        step -= 1

    return R

def getFCS(M, P, len_M, n):
    """This function just calls xor_div().

    """
    return xor_div(M, P, len_M, n)

######################### MAIN #########################

# MAIN is so ugly... Use the arg option!

print "Do you want send a number or check the number received ?"

choice = raw_input("Make your choice(s/c)? ")

while(not (choice == 's' or choice == 'c')):
    print "I cannot understand your choice. 's' or 'c', please."
    print
    choice = raw_input("Make your choice(s/c)? ")

print "M is what you want to send or you receive. n is the length of FCS. P is the divisor."
print

M = getNum('M')
len_M = len(M)
M = binStr2dec(M)

n = int(raw_input("n is ? "))

P = getNum('P')
len_P = len(P)

if(len_P != n+1):
    print "Error! The length of P must be %d !" % (n+1, )
    sys.exit(0)

P = binStr2dec(P)

if(choice == 's'):
    print
    FCS = getFCS(M<<n, P, len_M+n, n)
    print "FCS is ",
    dec2bin(FCS)
    print ", the data to be sent is ",
    dec2bin((M<<n) | FCS)
elif(choice == 'c'):
    print
    if( 0 == getFCS(M, P, len_M, n) ):
        print "The data you received is correct."
    else:
        print "The data you received is incorrect."
