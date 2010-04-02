/* convert tabs in standard input to spaces in */
/* standard output while maintaining columns */

#include <stdio.h>
#define TABSIZE 6

/* prototype for function findstop */
int findstop(int *);

int main()
{
  int c;        /* character read from stdio */
  int posn = 0; /* column position of character */
  int inc;      /* column increment to tab stop */

  while(( c = getchar() ) != EOF) {
    switch(c) {
    case '\t': /* c is a tab */
      inc = findstop(&posn);
      for(; inc > 0; --inc)
	putchar(' ');
      break;
    case '\n': /* c is a newline */
      putchar(c);
      posn = 0;
      break;
    default: /* c is a anything else */
      putchar(c);
      ++posn;
      break;
    }
  }
  return 0;
}

/* compute size of increment to next tab stop */

int findstop(int *col)
{
  int retval;
  retval = (TABSIZE - (*col % TABSIZE));
  
  /* increment argument (current column position) to next tabstop */
  *col += retval;

  return retval; /* main gets how many blanks for filling */
}
