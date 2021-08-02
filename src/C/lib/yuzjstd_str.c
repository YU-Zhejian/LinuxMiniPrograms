#include <yuzjstd.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#ifdef OS_WIN
#else
#include <execinfo.h>
#endif
#include <time.h>
#include <stdarg.h>
#include <stdnoreturn.h>

/**
 * Create an INFO: message.
 * @param msg Message
 */
void infoh(char *msg)
{
    fprintf(stderr, "%s%s%s%s\n", ANSI_YELLOW, "INFO: ", msg, ANSI_CLEAR);
    fflush(stderr);
}


/**
 * Internal log formatter
 * @param tag DEBUG, INFO, WARNING, ERROR
 * @param message Message you wish to show in printf
 */
void log_format(const char* tag, const char* message, va_list args) {
    time_t now;
    time(&now);
    char * date =ctime(&now);
    date[strlen(date) - 1] = '\0';
    fprintf(stderr,"%s [%s] ", date, tag);
    vfprintf(stderr,message, args);
    fprintf(stderr,"\n");
    fflush(stderr);
}

#ifdef IS_DEBUG
void debugh(const char* message, ...) {
    va_list args;
    va_start(args, message);
    log_format("DEBUG", message, args);
    va_end(args);
}
#else
void debugh(const char* message, ...){}
#endif

#ifdef OS_WIN
// TODO: stack trace
/**
 * Create an ERROR: message and exit.
 * @param msg Message
 * @param exit_value Exit value
 */
noreturn void errh(char *msg, int exit_value)
{
    fprintf(stderr, "%s%s%s%s\n", ANSI_RED, "ERROR: ", msg, ANSI_CLEAR);
    printf("%s Stack trace:%s\n",ANSI_RED,ANSI_CLEAR);
    fflush(stderr);
    safe_free(msg);
    exit(exit_value);
}
#else
/**
 * Create an ERROR: message and exit.
 * @param msg Message
 * @param exit_value Exit value
 */
noreturn void errh(char *msg, int exit_value)
{
    fprintf(stderr, "%s%s%s%s\n", ANSI_RED, "ERROR: ", msg, ANSI_CLEAR);
    printf("%s Stack trace:%s\n",ANSI_RED,ANSI_CLEAR);
    fflush(stderr);
    void* callstack[128];
    int i, frames = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frames);
    for (i = 0; i < frames; ++i) {
        fprintf(stderr,"%s\n", strs[i]);
    }
    safe_free(strs);
    safe_free(msg);
    exit(exit_value);
}
#endif

/**
 * Create a WARNING: message and exit.
 * @param msg Message
 */
void warnh(char *msg)
{
    fprintf(stderr, "%s%s%s%s\n", ANSI_RED, "WARNING: ", msg, ANSI_CLEAR);
    fflush(stderr);
}

/**
 * A Perl-like replacement for `errh`. See `errh` for more details.
 */
noreturn void die(char *msg, int exit_value)
{ errh(msg, exit_value); }

/**
 * Get the substring of input and store it inside a buffer.
 * @param string The input string
 * @param targetstr The target buffer
 * @param position From position
 * @param length Target length
 * @return 0 if succeed, -1 if error
 */
int substring(char *string, char *targetstr, int position, int length)
{
    int c;
    char *instr= (char*) safe_malloc((int) strlen(string));
    sprintf(instr, "%s", string);
    char *tmpstr = safe_malloc(length + 1);
    for (c = 0; c < length; c++) {
        *(tmpstr + c) = *(instr +c + position);
    }
    *(tmpstr + c) = '\0';
    sprintf(targetstr, "%s", tmpstr);
    safe_free(tmpstr);
    // safe_free(instr);
    return 0;
}

void safe_regcomp(regex_t* regex, const char* pattern,int cflags){
    if (pcre2_regcomp(regex, pattern, cflags) != 0){
        char *ERRSTR = (char *)safe_malloc(500);
        if (errno == REG_ESPACE){
            sprintf(ERRSTR,
                    "Out of memory");
        } else {
            sprintf(ERRSTR, "%s: Format error NO %i", pattern, errno);
            perror("Description: ");
        }
        errh(ERRSTR, 1);
    }
}

/**
 * Check whether an argument is an option
 * @param argv String
 * @return 0 if yes, 1 if no
 */
int isopt(const char *argv)
{
    regex_t opt_regex ;
    safe_regcomp(&opt_regex,"^-[^-/s]$|^--[^-/s]+$|^-[^-/s]:[^-/s]+$",0);
    if (pcre2_regexec(&opt_regex, argv, 0, NULL, 0) == 0){
        pcre2_regfree(&opt_regex);
        return 0;
    }
    pcre2_regfree(&opt_regex);
    return 1;
}
