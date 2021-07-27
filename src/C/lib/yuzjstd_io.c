#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <yuzjstd.h>
#include <sys/stat.h>
#include <libgen.h>

void core_mkdir_p(char *abspath);
FILE *core_fopen(char *abspath,const char* mode);

/**
 * Get the normalized absolute path of an existing or non-existing path.
 * Algorithm:
 *
 * <p> If path is started by /, it is considered to be an absolute path. </p>
 *
 * <p> If path is started by ~, ~ will be replaced by ${HOME} environment variable. </p>
 *
 * <p> If path is started by other characters, it will be appended by PWD. </p>
 *
 * <p> Path are split by PATH_SEPARATOR and packed into an array. </p>
 *
 * <p> Items consisting ".."" are removed. </p>
 *
 * <p> Items consisting ".." are removed with its previous item. If no previous item found, will raise an error. </p>
 *
 * @param path An input path, can be absolute or relative.
 * e. g.
 * ~/bin
 * ~/bin/
 * lib
 * ./lib
 * /home
 * @param outpath The absolute path of the input path.
 * @return 0 if success, -1 if error
 *
 */
int get_abspath(char *path, char *outpath)
{
    char *tmppath = (char*) safe_malloc(PATH_MAX); // The input of each step
    sprintf(tmppath, "%s", path);
    // Resolve ~
    if (strncmp(tmppath, "~", 1) == 0) {
        char *home_dir = getenv("HOME");
        if (home_dir == NULL) {// Failed to get HOME environment variable
            outpath = NULL;
            free(tmppath);
            return -1;
        }
        char *path_without_header = safe_malloc(PATH_MAX);
        substring(tmppath, path_without_header, 1, (int)strlen(tmppath) - 1);
        sprintf(outpath, "%s%c%s", home_dir, PATH_SEPARATOR, path_without_header);
        sprintf(tmppath, "%s", outpath);
        free(path_without_header);
    }
    // Resolve ${PWD}
    if (strncmp(tmppath, "/", 1) != 0) {
        char *pwd = getenv("PWD");
        if (pwd == NULL) {// Failed to get PWD environment variable
            outpath = NULL;
            free(tmppath);
            return -1;
        }
        sprintf(outpath, "%s%c%s", pwd, PATH_SEPARATOR, path);
        sprintf(tmppath, "%s", outpath);
    }
    // Resolve . and ..
    sprintf(outpath, "");
    char* save_ptr = safe_malloc((int) strlen(tmppath));
    char *token = strtok_r(tmppath, PATH_SEPARATOR_STR,&save_ptr);
    while (token != NULL) {
        if (strcmp(token, "..") == 0) { // Removge the previous one if meeting '..'
            int last_sep = (int)(strrchr(outpath, PATH_SEPARATOR) - outpath + 1);
            char *outpath_prev = (char *)safe_malloc((int) strlen(tmppath));
            substring(outpath, outpath_prev, 0, last_sep);
            sprintf(outpath, "%s", outpath_prev);
            free(outpath_prev);
        }
        else if (strcmp(token, ".") != 0) {
            sprintf(outpath, "%s%c%s", outpath, PATH_SEPARATOR, token);
        }
        token = strtok_r(NULL, PATH_SEPARATOR_STR,&save_ptr);
    }
    free(token);
    sprintf(tmppath, "%s", outpath);
    // Resolve //
    sprintf(outpath, "");
    if (strlen(tmppath) >= 1){
        char curchar;
        char prevchar;
        int j=0;
        for (int i = 1;i<strlen(tmppath);i++){
            curchar=tmppath[i];
            prevchar=tmppath[i-1];
            if (curchar != PATH_SEPARATOR || prevchar !=  PATH_SEPARATOR){
                outpath[j]=prevchar;
                j++;
            }
        }
    }
    free(tmppath);
    return 0;
}

/**
 * Private function, core wrapper of creating a directory
 * @param abspath The absolute path
 */
void core_mkdir_p(char *abspath)
{
    if (mkdir(abspath, S_IRWXU) == -1) {
        char *ERRSTR = (char *)safe_malloc(500);
        if (errno == EEXIST) { // SKIP
            free(ERRSTR);
            return;
        }
        else if (errno == ENOTDIR) {
            sprintf(ERRSTR, "%s is a file rather than a directory.", abspath);
        }
        else if (errno == ENFILE || errno == EMFILE) {
            sprintf(ERRSTR, "Limit on the total number of open files has been reached.");
        }
        else if (errno == EACCES) {
            sprintf(ERRSTR, "%s: Permission denied", abspath);
        }
        else if (errno == ELOOP || errno == EMLINK) {
            sprintf(ERRSTR,
                    "%s: too many symbolic links were encountered in resolving pathname",
                    abspath);
        }
        else if (errno == EDQUOT || errno == ENOSPC) {
            sprintf(ERRSTR,
                    "The user's quota of disk blocks or inodes on the filesystem has been exhausted.");
        }
        else if (errno == ENAMETOOLONG) {
            sprintf(ERRSTR, "%s: pathname was too long.", abspath);
        }
        else if (errno == EROFS) {
            sprintf(ERRSTR, "%s: pathname refers to a file on a read-only filesystem.", abspath);
        }
        else if (errno == EPERM) {
            sprintf(ERRSTR,
                    "%s: The filesystem containing pathname does not support the creation  of directories.",
                    abspath);
        }
        else if (errno == ENOMEM) {
            sprintf(ERRSTR,
                    "Out of memory");
        }
        else {
            sprintf(ERRSTR, "%s: Unknown error NO %i", abspath, errno);
            perror("Description: ");
        }
        errh(ERRSTR, 1);
    }
}

/**
 * Create a directory from absolute path if not exist. Just like mkdir -p.
 * @param abspath Absolute path
 * @return 0 if success, -1 if error
 */
int mkdir_p(const char *abspath)
{
    char *abspath_created = (char *)safe_malloc((int) strlen(abspath));
    memset(abspath_created,0,(int) strlen(abspath));
    char* save_ptr = safe_malloc((int) strlen(abspath));
    char *token = strtok_r((char*) abspath, PATH_SEPARATOR_STR,&save_ptr);
    while (token != NULL) {
        sprintf(abspath_created, "%s%c%s", abspath_created, PATH_SEPARATOR, token);

        DIR *dir = opendir(abspath_created);
        if (dir == NULL) {
            char *ERRSTR = (char *)safe_malloc(500);
            if (errno == ENOTDIR) {
                sprintf(ERRSTR, "%s is a file rather than a directory.", abspath_created);
            }
            else if (errno == ENFILE || errno == EMFILE) {
                sprintf(ERRSTR, "Limit on the total number of open files has been reached.");
            }
            else if (errno == EACCES) {
                sprintf(ERRSTR, "%s: Permission denied", abspath_created);
            }
            else if (errno == ENOMEM) {
                sprintf(ERRSTR,
                        "Out of memory");
            }
            else if (errno == ENOENT) { // Directory not exist. Try to create it.
                core_mkdir_p(abspath_created);
                token = strtok_r(NULL, PATH_SEPARATOR_STR,&save_ptr);
                free(ERRSTR);
                continue;
            }
            errh(ERRSTR, 1);
        }
        else {
            closedir(dir);
        }
        token = strtok_r(NULL, PATH_SEPARATOR_STR,&save_ptr);
    }
    free(abspath_created);
    return 0;
}

/**
 * Internal function, create an non-exist file
 * @param abspath Absolute path
 */
void create_no_exist(char *abspath)
{
    if (creat(abspath, S_IRUSR | S_IWUSR) == -1) {
        char *ERRSTR = (char *)safe_malloc(500);
        if (errno == EEXIST) { // SKIP
            free(ERRSTR);
            return;
        }
        else if (errno == ENOENT) { // SKIP
            sprintf(ERRSTR, "%s ENOENT", abspath);
        }
        else if (errno == ENFILE || errno == EMFILE) {
            sprintf(ERRSTR, "Limit on the total number of open files has been reached.");
        }
        else if (errno == EBUSY) {
            sprintf(ERRSTR, "%s: resource busy", abspath);
        }
        else if (errno == EACCES) {
            sprintf(ERRSTR, "%s: Permission denied", abspath);
        }
        else if (errno == ELOOP || errno == EMLINK) {
            sprintf(ERRSTR,
                    "%s: too many symbolic links were encountered in resolving pathname",
                    abspath);
        }
        else if (errno == EDQUOT || errno == ENOSPC) {
            sprintf(ERRSTR,
                    "The user's quota of disk blocks or inodes on the filesystem has been exhausted.");
        }
        else if (errno == ENAMETOOLONG) {
            sprintf(ERRSTR, "%s: pathname was too long.", abspath);
        }
        else if (errno == EROFS) {
            sprintf(ERRSTR, "%s: pathname refers to a file on a read-only filesystem.", abspath);
        }
        else if (errno == EPERM) {
            sprintf(ERRSTR,
                    "%s: The filesystem containing pathname does not support the creation of directories.",
                    abspath);
        }
        else if (errno == ENOMEM) {
            sprintf(ERRSTR,
                    "Out of memory");
        }
        else {
            sprintf(ERRSTR, "%s: Unknown error NO %i", abspath, errno);
            perror("Description: ");
        }
        errh(ERRSTR, 1);
    }
}

/**
 * Private core fopen wrapper
 *
 * @param abspath Absolute path
 * @param mode Mode
 * @return FD if normal; NULL if error
 */
FILE* core_fopen(char *abspath, const char *mode)
{
    FILE *fd = fopen(abspath, mode);
    if (fd == NULL) {
        char *ERRSTR = (char *)safe_malloc(500);
        if (errno == ENFILE || errno == EMFILE) {
            sprintf(ERRSTR, "Limit on the total number of open files has been reached.");
        }
        else if (errno == EBUSY) {
            sprintf(ERRSTR, "%s: resource busy", abspath);
        }
        else if (errno == EACCES) {
            sprintf(ERRSTR, "%s: Permission denied", abspath);
        }
        else if (errno == ELOOP || errno == EMLINK) {
            sprintf(ERRSTR,
                    "%s: too many symbolic links were encountered in resolving pathname",
                    abspath);
        }
        else if (errno == EDQUOT || errno == ENOSPC) {
            sprintf(ERRSTR,
                    "The user's quota of disk blocks or inodes on the filesystem has been exhausted.");
        }
        else if (errno == ENAMETOOLONG) {
            sprintf(ERRSTR, "%s: pathname was too long.", abspath);
        }
        else if (errno == EROFS) {
            sprintf(ERRSTR, "%s: pathname refers to a file on a read-only filesystem.", abspath);
        }
        else if (errno == EPERM) {
            sprintf(ERRSTR,
                    "%s: The filesystem containing pathname does not support the creation of directories.",
                    abspath);
        }
        else if (errno == ENOMEM) {
            sprintf(ERRSTR,
                    "Out of memory");
        }
        else {
            sprintf(ERRSTR, "%s: Unknown error NO %i", abspath, errno);
            perror("Description: ");
        }
        errh(ERRSTR, 1);
    }
    return fd;
}
/**
 * GNU/Linux `touch` command, create a file if not exists.
 * @param abspath Absolute path
 * @return  0 if success, -1 if error
 */
int touch(char *abspath)
{
    char *tabp = (char *)safe_malloc(PATH_MAX);
    if (strncmp(abspath, "/", 1) != 0) {
        get_abspath(abspath, tabp);
    }
    else {
        sprintf(tabp, "%s", abspath);
    }
    char *tmppath = safe_malloc((int) strlen(tabp));
    sprintf(tmppath, "%s", tabp);
    mkdir_p(dirname(tmppath));
    FILE* tmpfd=fopen(tabp, "r");
    if (tmpfd == NULL) {
        if (errno == ENOENT) {// Create one
            create_no_exist(abspath);
        }
        else {// Other errors, let it show!
            FILE* tmp = core_fopen(tabp, "r");
            if (tmp != NULL) {
                fclose(tmp);
            }
        }
    } else {
        fclose(tmpfd);
    }
    free(tmppath);
    free(tabp);
    return 0;
}

/**
 * Safer fopen
 * @param abspath Absolute path
 * @return FD if normal; NULL if error
 */
FILE *safe_fopen(char *abspath, const char *mode)
{
    char *tabp = (char *)safe_malloc(PATH_MAX);
    if (strncmp(abspath, "/", 1) != 0) {
        get_abspath(abspath, tabp);
    }
    else {
        sprintf(tabp, "%s", abspath);
    }
    FILE *fd = fopen(tabp, "r");
    if (fd == NULL && errno == ENOENT) {
        touch(tabp);
    } else if ( fd != NULL) {
        fclose(fd);
    }
    fd = core_fopen(tabp, mode);
    free(tabp);
    return fd;
}

int safe_fgetc(FILE *fd)
{
    int i = fgetc(fd);
    if (i == EOF && errno != 0) {
            char *ERRSTR = (char *)safe_malloc(500);
            sprintf(ERRSTR, "Unknown error NO %i", errno);
            errh(ERRSTR, 1);
    }
    return i;
}

/**
 * To check whether a file is empty
 * @param abspath Absolute path
 * @return 0 if empty, 1 otherwise
 */
int is_empty(char *abspath)
{
    FILE *fd = safe_fopen(abspath, "rb");
    if (fd==NULL){ // Which is unlikely to happen
        return -1;
    }
    int i = (fgetc(fd) == EOF);
    fclose(fd);
    return i;
}
