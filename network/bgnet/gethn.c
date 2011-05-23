#include <stdio.h>
#include <unistd.h>

int main(void)
{
	char hostname[100];
	gethostname(hostname, sizeof hostname);
	printf("%s\n", hostname);
	return 0;
}
