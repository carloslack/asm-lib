#include <stdio.h>
#include <stdlib.h>
#include "main.h"

int main(int argc, char **argv)
{
    /*
    unsigned short val1 = 2;
    unsigned int val2 = 2;
    unsigned char val3 = 2;
    printf("%d\n", s_bitscanw(1,val1));
    printf("%d\n", s_bitscandw(1,val2));
    printf("%d\n", s_bitscanb(1,val3));
*/
    int x = func2();
    printf("%d\n", x);
    //char *name = getenv("USER");
    //s_log(name);
    int y = rk_intercept((void *)c_orig, (void *)c_rk, 10,20);
    printf("result: %d\n", y);
    return 0;
}
