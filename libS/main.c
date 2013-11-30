#include <stdio.h>
#include <string.h>

size_t s_log(const char *str);
int s_mod(unsigned int x, unsigned int y);
ssize_t s_read(int fd, void *buf, size_t count);
void *s_memset(void *s, int c, size_t n);
int s_bitscandw(int direction, int dword);

int main(int argc, char **argv)
{
#if 0
    int ret = s_log(argv[1]);
    printf("ret: %d\n", ret);

    ret = s_mod(1234, 10);
    printf("ret: %d\n", ret);
#endif
    char buf[32];
    
    void *ret = s_memset((void*)&buf, 65, 32);
    //int ret = s_read(0, (void*)buf, 32);

    printf("ret: %p:%s\n", ret, buf);

    printf("# %d\n", sizeof(char));
    printf("# %d\n", sizeof(short));
    printf("# %d\n", sizeof(int));
    printf("# %d\n", sizeof(long));
    printf("# %d\n", sizeof(long long));

    printf("%d\n", s_bitscandw(1, 5));

    //printf("%04x\n", 0b10000000);
    return 0;
}
