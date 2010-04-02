/*
	4. 打印输出某年的年历。日历的编排是每400年一个大循环周期，即今年的月、日、星期几和400年前的完全一样。现行天文历法根据天体运行规律，取每年365.2425天。这样，每400年共有365.2425×400＝146097天。如果以365天作为一年，每400年就少了0.2425×400＝97天。这97天要靠设置闰年（每年366）天来凑齐，所以，每400年要设置97个闰年。
	编程思路：按照以上背景知识可得判断闰年得规律：某年年份如果能被4整除但不能被100整除，或者能被400整除则是闰年。由此规则可推得计算万年历的公式：
S=X-1+(X-1)/4-(X-1)/100+(x-1)/400+C  上式中：X为公元年数（如2003年）；C 为从元旦起，到要算的那天总数（如2003年3月23日，C=31＋28＋23＝82）。S/7余数是星期几。
*/
#include <iostream>
#include <cstdlib>
using namespace std;

bool isRunNian(int);
int getStartOfMonth(int, int);
void printCalendar(int);

int daysOfPerMonth[13]={0,31,28,31,30,31,30,31,31,30,31,30,31};

int main(int argc, char** argv)
{
	if(argc!=2)
	{
		cout << "参数不对，try again." << endl;
	}
	else if(0 == strcmp(argv[1],"--help"))
	{
		cout << "rili [-year]" << endl;
		cout << "rili [year]" << endl;
	}
	else
	{
		int s,x,c;	// x为公元年数(如2003年)；c 为从元旦起，到要算的那天总数(如2003年3月23日，c=31＋28＋23＝82)。s=x-1+(x-1)/4-(x-1)/100+(x-1)/400+c, s/7余数是星期几。
		//argv[1]=x;
		x=abs(atoi(argv[1]));
		if(isRunNian(x))
		{
			daysOfPerMonth[2]=29;
		}
		printCalendar(x);
	}
	return 0;
}

bool isRunNian(int year)
{
	if((0 == year%4 && (0 != year%100)) || (0 == year%400) )	//某年年份如果能被4整除但不能被100整除，或者能被400整除则是闰年。
		return true;
	else return false;
}

int getStartOfMonth(int year, int month)
{
	int i,c=0;
	for(i=1;i<=month;i++)
		c = c + daysOfPerMonth[i-1];	//如果是c = c + daysOfPerMonth[i-1] + 1;的话下一个月的第一天会与上一个月的最后一个隔开1天
	c++;	//!!!
	return (year-1+(year-1)/4-(year-1)/100+(year-1)/400+c)%7;
}

void printCalendar(int year)
{
	int month,start;
	for(month=1;month<=12;month++)
	{
		cout << month << "月   日   一   二   三   四   五   六" << endl;
		start=getStartOfMonth(year , month);	//得到year年的第month个月的1日是星期几
		cout << "   ";
		int i;
		for(i=0;i<start;i++)	//根据position的值（也就是星期几）来打印1日前的空格
		{
			cout.width(5);
			cout << "";
		}
		i=1;
		while(i<=daysOfPerMonth[month])
		{
			cout.width(5);
			cout << i;
			start++;
			if(start>6)
			{
				start=0;
				cout << endl;
				cout << "   ";
			}
			i++;
		}
		cout << endl;

	}
}

/*VC6.0 + WinXP*/