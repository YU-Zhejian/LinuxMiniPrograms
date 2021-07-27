#include <assert.h>
#include <libgen.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <yuzjstd.h>
#include <unistd.h>

int main(int argc, char *argv[]);
void mat_test();
void print_test();
void libself_test(char *argv0);

/**
 * The main function, entrypoint of the program
 * @param argc Argument count
 * @param argv Argument value
 * @return 0 if success, 1 if error
 */
int main(int argc, char *argv[])
{
    mat_test();
    print_test();
    libself_test(argv[0]);
    return 0;
}

/**
 * Test small matrix
 */
void mat_test()
{
    char(matrix[2])[3] = {{1, 2, 5}, {3, 4, 6}};
    char(*p)[3] = matrix;
    assert((int)p[0][1] == (int)matrix[0][1]);
}

/**
 * Test some printing functions and TTY support
 */
void print_test()
{
    infoh(isatty(fileno(stdin))
          ? "stdin is tty"
          : "stdin is not tty");
    infoh(isatty(fileno(stdout))
          ? "stdout is tty"
          : "stdout is not tty");
    infoh(isatty(fileno(stderr))
          ? "stderr is tty"
          : "stderr is not tty");
    infoh(
        "Chinese in UNICODE16: \u7b80\u4f53\u4e2d\u6587 \u7232\u653f\u82e5\u6c90\u4e5f\u3002\u96d6\u6709\u68c4\u767c\u4e4b\u8cbb\u800c\u6709\u9577\u767c\u4e4b\u5229\u4e5f\u3002");
    infoh("Chinese in UTF-8:     简体中文 爲政若沐也。雖有棄發之費而有長發之利也。");
}

void test_isopt(char* argv){
    char* INFOSTR = (char *)safe_malloc(200);
    if (isopt(argv) == 0){
        sprintf(INFOSTR,"%s is an option",argv);
    } else {
        sprintf(INFOSTR,"%s is not an option",argv);
    }
    infoh(INFOSTR);
    free(INFOSTR);
}

/**
 * Test libcapple and libyuzjstd
 * @param argv0 The argv[0] value
 */
void libself_test(char *argv0)
{
    // Try to create & read from a configuration file
    char *tabp = (char *)safe_malloc(PATH_MAX);
    get_abspath(argv0, tabp);
    char *INFOSTR = safe_malloc(PATH_MAX + 40);
    sprintf(INFOSTR, "The absolute path of the program is %s", tabp);
    infoh(INFOSTR);
    char *etc_path = safe_malloc(PATH_MAX);
    sprintf(etc_path,"%s/etc/test.conf",dirname(dirname(tabp)));
    free(tabp);
    if (is_empty(etc_path)) {
        sprintf(INFOSTR, "%s is blank; creating one", etc_path);
        infoh(INFOSTR);free(INFOSTR);
        FILE *fd = safe_fopen(etc_path, "w");
        fprintf(fd, "Initialized content\n");
        fclose(fd);
    }
    else {
        sprintf(INFOSTR, "Contents from %s:", etc_path);
        infoh(INFOSTR);
        free(INFOSTR);
        FILE *fd = safe_fopen(etc_path, "r");
        fseek(fd, 0L, 0);
        int ch = safe_fgetc(fd);
        while (ch != EOF) {
            printf("%c", ch);
            ch = fgetc(fd);
        }
        fclose(fd);
    }
    test_isopt("-a");
    test_isopt("--all");
    test_isopt("all");
    test_isopt("-all");
    test_isopt("-a:ll");
    test_isopt("--all:all");
}
