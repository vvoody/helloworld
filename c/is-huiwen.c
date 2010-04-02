/*
  Check one string whether is a huiwen string or not. (recursion)
  "abcddcba", "12344321", etc is a huiwen string.
  "abc", "a1b2c3c2b2a", etc is not a huiwen string.

  self.is_vvoody <wxj.g.sh@gmail.com>

*/

#include <stdio.h>
#include <string.h>

#define MAX_ARRAY 100

int is_huiwen(const char a[], int count, int len); // by vvoody
int isPalindrome( char array[], int size ); // superwulei
bool check(char *first, char *last); // someone : check(st, st + strlen(st) - 1)
int Test(char *array,int num);     /*num为字符数目   */   
bool Test(char *str, int start, int end);
int w(char *s,int size);
int fun(char *begin, char *end)//初次调用时，end   =   begin+strlen(begin)-1

int main(void)
{
  char str[MAX_ARRAY];
  scanf("%s", str);

  if(is_huiwen(str, 0, strlen(str))) {
    printf("Is a huiwen str.\n");
  }
  else {
    printf("Not a huiwen str.\n");
  }
  return 0;
}

int is_huiwen(const char a[], int count, int len)
{
  static i = 0;
  i++;             // Make enable to read the over half of the str array.
  int n = count;
  n++;

  if(len%2 && count == len/2) // odd str array
    return 1;

  return ( count >= ((len+1)/2 - 1) || is_huiwen(a, n, len) ) && ( a[count] == a[i++] );
  // (len+1)/2 -1 is the position of the middle element of the str array. Attention: evev array
}

int isPalindrome( char array[], int size )
{
  if ( size <= 1 )
    return 1;
  if ( array[0] == array[ size - 1 ] )
    {
      return isPalindrome( array + 1, size - 2 );
    }
  /*
    忽略数组中的空格和逗号
  */
  else
    {
      if( ( array[ 0 ] == ' ' || array[ 0 ] == ',' ) &&
	  ( array[ size - 1] == ' ' || array[ size - 1 ] == ',' ) )
        {
	  return isPalindrome( array + 2, size - 2 );
        }
      else if( ( array[ 0 ] == ' ' || array[ 0 ] == ',' ) &&
	       !( array[ size - 1] == ' ' || array[ size - 1 ] == ',' ) )
        {
	  return isPalindrome( array + 2, size - 1 );
        }
      else if( !( array[ 0 ] == ' ' || array[ 0 ] == ',' ) &&
	       ( array[ size - 1] == ' ' || array[ size - 1 ] == ',' ) )
        {
	  return isPalindrome( array + 1, size - 2 );
        }
    }

  return 0;    
}

bool check(char *first, char *last)
{
  while( !isalpha(*first) )
    first++;
  while( !isalpha(*last))
    last--;

  if( first >= last ) return true;

  if( tolower(*last) == tolower(*first) )
    {
      return check( first + 1, last - 1 );
    }
  else
    return false;
}

int   Test(char   *array,int   num)     /*num为字符数目   */   
{   
  if(   num   ==   1   )   
    {   
      return   1;       /*   仅有一个字符，是回文*/     
    }           
  if(   array[0]   !=   array[num-1]   )   
    {   
      return   0;       /*   不是回文   */     
    }           
  else   if(   num   ==   2   )   
    {   
      return   1;     /*   是回文（两个相同字符）*/                 
    }           
  else   
    {       
      return   Test(array+1,num-2);             /*递归*/     
    }                     
}

bool   Test(   char   *str,   int   start,   int   end   )   
{   
  if(   str[start]!=str[end]   )   
    return   false;   
  if(   end   -   start   >2   )   
    return   Test(   str,   start+1,   end-1   );   
  return   true;   
}  

int w(char *s,int size)
{   
  if(size==1||size==0)     
    return   1;   
  else   
    return   (*s==s[size-1])   &&   w(++s,size-2);     
}


int fun(char *begin, char *end)//初次调用时，end   =   begin+strlen(begin)-1
{   
  return   begin   <=   end   &&   *begin   ==   *end   ?   fun(   ++begin,   --end   )   :   0   ;   
}  

/*

其实这样的问题用指针做效率最高了，何必用递归，如果字符串很长很长，效率更差了。看我用双指针做的：   
    
#include<stdio.h>               //本程序接受一个字符串并检查它是否回文。   
#include<string.h>   
void   main()   
{   
  char   C[50],*pa,*pb;//定义两个指针。   
  int   n,i,d;   
  printf("请输入一个字符串：\n");   
  scanf("   %s",C);   
  n=strlen(C);   
  pa=&C[0];                   //一个指向字符串之首。   
  pb=&C[n-1];             //一个指向其末。   
  d=1;   
    
  for   (;pa<pb;pa++,pb--)//前一个往后移，后一个往前移。   
    {                                           //直到两者相等，或前一个指针大于后者时。   
      if   (*pa!=*pb)//每一次移动后两个指针所指向的元素如果都相等，则该字符串是回文。   
	d=0;   
    }   
  if   (d==0)   
    
    printf("这不是回文！\n");   
  else   
    printf("这是回文。\n");   
}

*/

 /*
如果是数字就更容易了   
#include   <iostream>   
#include   <stdlib.h>   
    
using   namespace   std;   
bool   test(long   long   num);   
    
int   main(int   argc,   char   *argv[])   
{   
  long   t;   
  cin>>t;   
  cout<<test(t)<<endl;   
  system("PAUSE");   
  return   0;   
}   
    
bool   test(long   long   num)   
{   
  long   long   p=0,   q=num;   
  while(num){p*=10;p+=(num%10);num/=10;}   
  return   (p==q);   
}
*/

/*
wizard_numen(Wizard   Numen)   :   
    
int is(int num, int r, int c) //r为数的基，c为r的x-1次方，x是有效数位,如测试12321(10进制),用法：is(12321,   10,   10000)
{   
  return   c/r && num % r == num / c ? is((num/r)%(c/r), r, c/r/r) : c/r == 0;   
}   
*/
