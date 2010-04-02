/*
 * Display the binary form of a decimal number by a recursive  method.
 *
 * For example, you input 11 and we will display '1011'.
 *
 * Copyright (C) vvoody <wxj.g.sh@gmail.com>
 *
 * GNU GPLv2 licenced.
 *
 */

#include <stdio.h>

int dec2bin(int dec)
{
  return (dec != 1) && !dec2bin( dec / 2 ) || printf("%d", dec & 1);
  // if use (dec > 0) or (dec != 0),
  // there will be another zero at the beginnig of the output.
  // Last recursive step is dec = 1. 
}

int main(void)
{
  int dec;
  scanf("%d", &dec);
  dec2bin(dec);
  printf("\n");
  //  printf("%d\n", dec2bin(dec));
  return 0;
}

/*
  11 / 2 = 5 ... 1
  5  / 2 = 2 ... 1
  2  / 2 = 1 ... 0
  1  / 2 = 0 ... 1
*/

// 11... 5 ... print 1
// 5 ... 2 ... print 1
// 2 ... 1 ... print 0
// 1 ... 0 ... print 1
// 0 ... x ... print 0
