#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void usage( const char *executable_name )
{
	printf("Usage:\n\t%s [-f frequency] [-l length] [-r reps] [-d delay] \n ", executable_name);
	exit(1);
}

void parse_cmd_line( char **argv )
{
	char *arg0 = *(argv++);
	while(*argv) {
		if(!strcmp(*argv, "-f")) {
			char *arg_f = *(++argv);
			printf("-f arg is %s\n", arg_f);
		}
		else if(!strcmp(*argv, "-l")) {
			char *arg_l = *(++argv);
			printf("-l arg is %s\n", arg_l);
		}
		else if(!strcmp(*argv, "-r")) {
			char *arg_r = *(++argv);
			printf("-r arg is %s\n", arg_r);
		}
		else if(!strcmp(*argv, "-d")) {
			char *arg_d = *(++argv);
			printf("-d arg is %s\n", arg_d);
		}
		else {
			fprintf(stderr, "Bad option: %s\n", *argv);
			usage( arg0 );
		}
		++argv;
	}
}

int main(int argc, char **argv)
{
	if(argc % 2 == 0) {	// You can not leave the option without its arg!
				// 'cmd -f -l len -r reps -d delay' is wrong!
		fprintf(stderr, "##Bad option: %s\n", *argv);
		usage( *argv );
	}
	else {
		parse_cmd_line(argv);
	}
	return 0;
}
