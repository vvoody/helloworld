#include "stdio.h"
#include "stdlib.h"
#include "string.h"

char word[500][50];

int readWords(FILE *, char dir[]);	//读入文件中的单词，并返回单词个数
void crazyRecitation(int counts);	//疯狂地随机背诵dic.txt的所有单词
void circleRecitation(int counts);      //循环背诵一些单词，背熟为止


int main()
{
       	FILE *fp;
	int wordCounts;
	wordCounts=readWords(fp,"/home/vvoody/dic.txt") - 1;
	char key;
	printf("dic.txt中共有_%d_个单词\n",wordCounts+1);
	printf("选择背诵模式，ctrl+c退出：\na.疯狂\nb.循环\n");
	key = getchar();
	if(key == 'a')
	  crazyRecitation(wordCounts);
	else if(key =='b')
	  circleRecitation(wordCounts);
	else
		printf("还没这模式了，改天叫作者加入:)\n");
	return 0;
}

int readWords(FILE *fp, char dir[])
{
	if( ( fp = fopen(dir,"r") ) == NULL )
	{
		printf("cant open the file.\n");
		exit(0);	
	}
	printf("......\n");
	int i=0,k;
	char c;
	c=getc(fp);
	while(! feof(fp))
	{
		k=0;
		while(c != '\n')
		{
			word[i][k]=c;
			k++;
			c=getc(fp);
		}
		word[i][k]='\0';
		i++;
		c=getc(fp);
	}
	return i;
}

void crazyRecitation(int counts)
{
	char key;
	srand(time(NULL));
	key = getchar();
	while(1)
	{
		printf("%s\n",word[rand()%counts]);
		key = getchar();
	}
}

void circleRecitation(int counts)
{
	char circleWord[30][50];
	int n;
	printf("请输入要循环背诵单词的数量，不要太多哦<=30：");
	scanf("%d",&n);
	while(n<0 || n>30)
	{
		printf("你背得完这么多吗？呵呵，重新输入吧……");
		scanf("%d",&n);
	}
	srand(time(NULL));
	int i;
	for(i=0;i<n;i++)
		strcpy(circleWord[i] , word[rand() % counts]);
	char key;
	key = getchar();
	while(1)
	{
		printf("%s\n",circleWord[rand() % n]);
		key = getchar();
	}
}

