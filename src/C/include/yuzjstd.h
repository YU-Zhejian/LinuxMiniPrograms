#include <stdio.h>
#include <dirent.h>
#include <pcre2posix.h>
#ifndef YUZJSTD_H
#define YUZJSTD_H
#define ANSI_BLACK "\033[0;30m"
#define ANSI_RED "\033[0;31m"
#define ANSI_GREEN "\033[0;32m"
#define ANSI_YELLOW "\033[0;33m"
#define ANSI_BLUE "\033[0;34m"
#define ANSI_PURPLE "\033[0;35m"
#define ANSI_CYAN "\033[0;36m"
#define ANSI_WHITE "\033[0;37m"
#define ANSI_CLEAR "\033[0;00m"

#if defined(_WIN32) || defined(WIN32) || defined(__CYGWIN__) || defined(__MINGW32__) || defined(__BORLANDC__) || defined(_MSC_VER)
#define OS_WIN
#endif

#ifdef OS_WIN
#define PATH_SEPARATOR '\\'
#define PATH_SEPARATOR_STR "\\"
#else
#define PATH_SEPARATOR   '/'
#define PATH_SEPARATOR_STR  "/"
#endif

#ifndef PATH_MAX // Compatibility settings for musl c
#define PATH_MAX 256
#endif

void infoh(char *msg);
void warnh(char *msg);
void errh(char *msg, int exit_value);
void die(char *msg, int exit_value);
int get_abspath(char *path, char *outpath);
int mkdir_p(const char *abspath);
int touch(char *abspath);
FILE *safe_fopen(char *abspath, const char * mode);
void* safe_malloc(int size);
void safe_free(void* ptr);
int substring(char *string, char *targetstr, int position, int length);
int safe_fgetc(FILE *fd);
int is_empty(char *abspath);
int isopt(const char *argv);
void safe_regcomp(regex_t* regex, const char* pattern,int cflags);
void safe_fclose(FILE* fd);
DIR* safe_opendir(char* abspath);
void debugh(const char* message, ...);

#endif //YUZJSTD_H
