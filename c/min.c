/*

  Find the minimum element in array. (recursion)
  self.is_vvoody <wxj.g.sh@gmail.com>

*/

#include <stdio.h>

int min(const int a[], int len);

int main(void)
{
  int array[7]={7,6,1,2,9,20,70};
  printf("Min is %d\n", min(array, 7));
  return 0;
}

int min(const int a[], int len)
{
  //  int i=0;
  if(len == 1) return a[0];
  if(a[0] > a[1]) {
    return min(a + 1, len - 1);
  }
  else {
    if(len == 2) return a[0];
    int next = min(a + 2, len - 2);
    return a[0] > next ? next: a[0];
  }
}
