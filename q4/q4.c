#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <dlfcn.h>
#define ll long long
int main() {
    char opcode[20];
    int a, b;
    void* libpointer = NULL;
    char libraryname[20];
    int (*func)(int, int);

    while(scanf("%5s %d %d", opcode, &a, &b) == 3) {
        if(libpointer != NULL) dlclose(libpointer);
        sprintf(libraryname, "./lib%s.so", opcode);
        libpointer = dlopen(libraryname, 1);
        if(libpointer == NULL) continue;
        func = dlsym(libpointer, opcode);
        if(func == NULL) continue;
        int ans = func(a, b);
        printf("%d\n", ans);
    }
    if(libpointer != NULL) dlclose(libpointer);
}