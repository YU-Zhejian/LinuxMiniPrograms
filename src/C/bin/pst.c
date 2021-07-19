#include <stdio.h>
#include <pthread.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include "yuzjstd.h"

_Noreturn void *print_l(void *args);

char *tohuman(long inl);

long l = 0;
long t = 0;
int ISMACHINE = 0;
char *dc, *lhm,*ldhm;


int main(int argc, char *argv[]) {
	int i;
	for (i = 0; i < argc; i++) {
		if (! isopt(argv[i])){
			if (strcmp(argv[i], "-h") == 0 | strcmp(argv[i], "--help") == 0) {
				system("yldoc pst");
				return 0;
			} else if (strcmp(argv[i], "-v") == 0 | strcmp(argv[i], "--version") == 0) {
                printf("Version 1 in C\n");
                return 0;
            } else if (strcmp(argv[i], "-m") == 0 | strcmp(argv[i], "--machine") == 0) {
                ISMACHINE = 1;
            }
        }
    }
    char a;
    pthread_t thrd1;
    pthread_create(&thrd1, NULL, print_l, NULL);
    while (EOF != (a = (char) getchar())) {
        putchar(a);
        l++;
    }
    return 0;
}

_Noreturn void *print_l(void *args)
{
    long tmpl;
    long _l = 0;
    if (ISMACHINE) {
        while (1) {
            tmpl = l;
            t++;
            fprintf(stderr, "%ld\t%ld\t%ld\n", l, t, tmpl - _l);
            _l = tmpl;
            sleep(1);
        }
	} else {
		while (1) {
			tmpl=l;
			t++;
			lhm = tohuman(tmpl);
			ldhm = tohuman(tmpl - _l);
			fprintf(stderr, "\n\033[1ACC=%s, TE=%ld, SPEED=%s/s", lhm, t, ldhm);
			//fprintf(stderr,"\n\033[1ACC=%ld, TE=%ld, SPEED=%ld/s",l,t,ldiff);
			_l = l;
			free(lhm);
			free(ldhm);
			sleep(1);
		}
	}
}

char * (tohuman)(long inl)
{
    char *str = (char *) malloc(50);
    double ddiff = (double) inl;
    dc = "b";
    if (ddiff >= 1024) {
        ddiff = ddiff / 1024;
        dc = "kb";
    }
    if (ddiff >= 1024) {
        ddiff = ddiff / 1024;
        dc = "mb";
    }
    if (ddiff >= 1024) {
		ddiff = ddiff / 1024;
		dc = "gb";
	}
	sprintf(str, "%f%s", ddiff, dc);
	return str;
}
