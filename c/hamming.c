/*
 * $ hamming snd_code rcv_code
 *
 * Usage:
 *       'hamming 11001010'         encode.
 *       'hamming -c 001110001010'  checks the code whether it is right or not.
 *
 * You can use the following command to check whether my program is correct or not.
 *
 * $ hamming 101101010101010111001 | hamming -c -
 * and
 * $ hamming 1101 # output 1010101 --|
 * $ hamming -c 1110101   <----------'
 * 
 * by vvoody <wxj.g.sh{AT}gmail.com> Mon Nov 17 21:23:36 CST 2008
 * The end of this program is the introduction of Hamming code.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LEN 100

int hamming_check( char * );
void encode_hamming( char *, char * );
int power( int, int );

int
main(int argc, char *argv[])
{
  if(argc == 1) {
    printf(" hamming 11001010\t\twill show you the code encoded with Hamming.\n");
    printf(" hamming -c 001110001010\twill check the code whether it is right or not.\n");
    exit(1);
  }
  if(strcmp(argv[1], "-c") == 0) { // check code. Ensure the code entered and correct.
    if(argc == 2) {
      printf("We need a code!\n");
      exit(1);
    }
    int result;
    result = hamming_check( argv[2] );
    if( 0 == result )
      printf("%d: Your code is Correct!\n", result);
    else { // show which bit is incorrect.
      printf("The %d(th) bit is Wrong!\n", result);
    }
  }
  else { // encode
    char hamming_code[MAX_LEN] = {0};
    //    printf(hamming_code);
    encode_hamming( argv[1], hamming_code );
    printf(hamming_code);
    printf("\n");
  }
  return 0;
}

/* reverse the result output later*/
/* 11001010
 * _,_,1_,1,0,0,_,1,0,1,0
 *
 *  0000 0
 * ^0011 3
 * --------
 *  0011
 * ^0101 5
 * --------
 *  0110
 * ^1001 9
 * --------
 *  1111
 * ^1011 11
 * --------
 *  0100 4 (return) 0 is ok!
 *  reverse '0100' to '0010' and fill to the blank
 */
int
hamming_check( char *code ) {
  int i=0;
  int result=0;
  while(code[i] != '\0') {
    if(code[i] == '1')
      result ^= (i+1);
    ++i;
  }
  return result;
}

/* return base^exp */
int
power( int base, int exp)
{
  if(exp == 0) return 1;
  int product = 1;
  int i;
  for(i=0; i<exp; ++i)
    product *= base;

  return product;
}

void
encode_hamming( char * code, char * hamming_code )
{
  int i=0, j=0, k=0, x=0;

  // file the hamming_code[] with code[]
  k = power(2, j) - 1;
  while( code[i] != '\0' ) {
    if( x == k ) {
      ++j;
      k = power(2, j) - 1;
      hamming_code[x] = '.';
      ++x;
      continue;
    }
    hamming_code[x] = code[i];
    ++i;
    ++x;
  }
  hamming_code[x] = '\0';
  //  printf(hamming_code);

  // fill the 2^n bit
  int result = hamming_check( hamming_code );
  j = 0;
  k = power(2, j) - 1;
  while(k < x) {
    //hamming_code[k] = (result & 1) ? '1' : '0';
    hamming_code[k] = (result & 1) + 48;
    ++j;
    k = power(2, j) - 1;
    result = result >> 1;
  }
}

/*

 * hamming 1100101010 ->

_ _ 1 _ 1 0 0 _ 1 0 1 0 1 0

| |   |       |
| v   |       v
| 2   |       8
| 2^1 |       2^3
|     v
1     4
2^0   2^2

blank 2^n position

Position 3,5,9,11,13 is '1'. then    <-----------------------------------'
                                                                         |
3->    2^0 + 2^1                                                         |
5->    2^0 +     + 2^2                                                   |
9->    2^0 +           + 2^3                                             |
11->   2^0 + 2^1 +     + 2^3                                             |
13->   2^0 +     + 2^2 + 2^3                                             |
_______________________________                                          |
                                                                         |
         1     0     0     1    # even quantity 2^n is 1, odd is 0       |
                                                                         |
fill     |     |     |     |                                             |
pos      |     |     |     |                                             |
         | ----'     | ----'                                             |
         | |         | |                                                 |
         | |   |-----' |                                                 |
         v v   v       v                                                 |
                                                                         |
         _ _ 1 _ 1 0 0 _ 1 0 1 0 1 0                                     |
                                                                         |
Result:  1 0 1 0 1 0 0 1 1 0 1 0 1 0                                     |
         ___________________________                                     |
                      |                                                  |
                      |                                                  |
                      |                                                  |
                      V                                                  |
                                                                         |
 * hamming -c 10101001100010 # actually it like above --------------------

*/
