#include <yuzjstd.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

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
 * Create an ERROR: message and exit.
 * @param msg Message
 * @param exit_value Exit value
 */
_Noreturn void errh(char *msg, int exit_value)
{
    fprintf(stderr, "%s%s%s%s\n", ANSI_RED, "ERROR: ", msg, ANSI_CLEAR);
    fflush(stderr);
    free(msg);
    exit(exit_value);
}
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
_Noreturn void die(char *msg, int exit_value)
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
    char *instr= malloc(strlen(string));
    if (instr == NULL) {
        targetstr = NULL;
        return -1;
    }
    sprintf(instr, "%s", string);
    char *tmpstr = safe_malloc(length + 1);
    if (tmpstr == NULL) {
        targetstr = NULL;
        free(instr);
        return -1;
    }
    for (c = 0; c < length; c++) {
        *(tmpstr + c) = *(instr +c + position);
    }
    *(tmpstr + c) = '\0';
    sprintf(targetstr, "%s", tmpstr);
    free(tmpstr);
    free(instr);
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
