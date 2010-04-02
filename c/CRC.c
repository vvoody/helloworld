#include <stdio.h>
#include <stdlib.h>
#include <string.h>

long int dec2bin(long int);
long int xor_div(long int, long int, unsigned, unsigned);
long int getFCS(long int, long int, unsigned, unsigned);

int main(void)
{
    printf("Do you want to send or check? ");
    char choice;
    scanf("%c", &choice);

    printf("M is what you want to send or you received. n is the length of FCS. P is the divisor.\n");
    printf("e.g. They are 1011011 and 3 and 1101 respectively.\n");

    char M[100];
    unsigned n=0;
    char P[100];

    printf("M is? ");
    scanf("%s", M);
    printf("n is? ");
    scanf("%d", &n);
    printf("P is? ");
    scanf("%s", P);

    unsigned len_M = strlen(M);
    unsigned len_P = strlen(P);

    if(len_P != n+1) {
        printf("\nError! P and n are not matched.\n");
        exit(1);
    }

    long int i_M = strtol(M, (char **) NULL, 2); // convert string M to a integer
    long int i_P = strtol(P, (char **) NULL, 2); // man atoi, man strtol

    printf("\n");

    if(choice == 's') {
        long int FCS = getFCS(i_M << n, i_P, len_M + n, n);
        printf("FCS is ");
        dec2bin(FCS);
        printf(", the data to be sent is ");
        dec2bin((i_M << n) | FCS);
        printf("\n");
    }
    else if(choice == 'c') {
        if(0 == getFCS(i_M, i_P, len_M, n))
            printf("The data you received is correct.\n");
        else
            printf("The data you received is incorrect.\n");
    }
  
    return 0;
}

long int dec2bin(long int dec)
{
    return (dec != 1) && !dec2bin( dec / 2 ) || printf("%d", dec & 1);
}

long int xor_div(long int dividend, long int divisor, unsigned len_dividend, unsigned n)
{
    long int M = dividend;
    long int P = divisor;
    unsigned step = len_dividend - n - 1;
    long int left = M >> step;
    long int right = P;
    long int R = left ^ right;
    step -= 1;

    while(step != -1) {
        long int flag = (M>>step) & 1;
        left = (R<<1) | flag;

        if(left >> n)
            right = P;
        else
            right = 0;

        R = left ^ right;
        step -= 1;
    }

    return R;
}

long int getFCS(long int M, long int P, unsigned len_M, unsigned n)
{
    return xor_div(M, P, len_M, n);
}
