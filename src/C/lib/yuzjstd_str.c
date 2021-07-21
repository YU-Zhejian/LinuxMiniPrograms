#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <yuzjstd.h>
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
 * Create an ERROR: message and exit.
 * @param msg Message
 * @param exit_value Exit value
 */
noreturn void errh(char *msg, int exit_value)
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

/**
 * Check whether an argument is an option
 * @param argv String
 * @return 0 if yes, 1 if no
 */
int isopt(char *argv)
{
    // FIXME: TODO
    return 0;
}
