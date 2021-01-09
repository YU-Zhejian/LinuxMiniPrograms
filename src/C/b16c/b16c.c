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
				printf("Version 1 in C\n");
				return 0;
			} else if (strcmp(argv[i], "-d") == 0 | strcmp(argv[i], "--decode") == 0) {
				DECODE = 1;
			}
		}
	}
	char a;
	if (DECODE) {
		char b;
		while (EOF != (a = getchar())) {
			b = getchar();
			putchar((a - 65) * 16 + b - 65);
		}
	} else {
		while (EOF != (a = getchar())) {
			putchar(a / 16 + 65);
			putchar(a - a / 16 * 16 + 65);
		}
	}
	return 0;
}
