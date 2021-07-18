#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <isopt.h>

int main(int argc, char *argv[]) {
	int i;
	int DECODE = 0;
	for (i = 0; i < argc; i++) {
		if (!isopt(argv[i])) {
			if (strcmp(argv[i], "-h") == 0 | strcmp(argv[i], "--help") == 0) {
				system("yldoc b16c");
				return 0;
			} else if (strcmp(argv[i], "-v") == 0 | strcmp(argv[i], "--version") == 0) {
				printf("Version 1 Patch 1 in C\n");
				return 0;
			} else if (strcmp(argv[i], "-d") == 0 | strcmp(argv[i], "--decode") == 0) {
				DECODE = 1;
			}
		}
	}
	int a;
	if (DECODE) {
        int b;
		while ((a = getchar()) != EOF & (b = getchar()) != EOF) {
			putchar((a - 65) * 16 + b - 65);
		}
	} else {
        while ((a = getchar()) != EOF ) {
			putchar(a / 16 + 65);
			putchar(a % 16 + 65);
			//printf("%d %d %d\n",a,a / 16, a%16);
		}
	}
	return 0;
}
