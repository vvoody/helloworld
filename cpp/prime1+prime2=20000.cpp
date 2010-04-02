/*2.哥德巴赫问题，编制主程序输入偶数 20000 ，计算可为多少对两个素数之和并输出素数对，调用子程序prime()判定素数。*/
/*
	判断 i 和 20000-i 是否都是素数，如果都是，则打印他们。
*/
#include <iostream>
#include <cmath>
using namespace std;

bool prime(int);

int main()
{
	int number;
	cin >> number;
	int i=1;
	while(i <= number/2)
	{
		if(prime(i) && prime(number-i))
		{
			cout << "\"" << i << " & " << number-i << "\"\t";
		}
		i++;	
	}
	cout << endl;
	return 0;
}

bool prime(int n)
{
	int i;
	if(1 == n || 2 == n)	return true;
	for(i=2;i<=(sqrt(n));i++)
	{
		if(0 == n%i)	return false;
	}
	return true;
}

