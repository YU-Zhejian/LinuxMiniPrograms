#include <yuzjstd.h>
#include <string.h>
#include <dirent.h>
#include <libgen.h>

LOTS_OF_BUGS

int DECODE = 0;

int IS_B16C = 0;

float VERSION = 1.1f;

char *abspath;

typedef char gear[16];

void inc_gear(int *all_gear_s, int start_len);
int encode(int chr, gear *all_gear, int *all_gear_s, int start_len);
int decode(int chr, gear *all_gear, int *all_gear_s, int start_len);
void read_gear(char *fn, gear return_gear);
void gen_gear();

int main(int argc, char *argv[])
{
    int start_len = 0;
    int gear_len = 0;
    char *relpath = (char *) safe_malloc(256);
    sprintf(relpath, "%s/../../var/linuxminiprograms/enigma.d/", dirname(argv[0]));
    abspath = (char *) safe_malloc(256);
    get_abspath(relpath, abspath);
    safe_free(relpath);
    for (int i = 1; i < argc; i++) {
        if (!isopt(argv[i])) {
            if (strcmp(argv[i], "-h") == 0 | strcmp(argv[i], "--help") == 0) {
                system("man enigma");
                safe_free(abspath);
                return 0;
            }
            else if ((strcmp(argv[i], "-v") == 0) | (strcmp(argv[i], "--version") == 0)) {
                printf("Version %f in C\n", VERSION);
                safe_free(abspath);
                return 0;
            }
            else if ((strcmp(argv[i], "-g") == 0) | (strcmp(argv[i], "--gengear") == 0)) {
                gen_gear();
                return 0;
            }
            else if ((strcmp(argv[i], "-d") == 0) | (strcmp(argv[i], "--decode") == 0)) {
                DECODE = 1;
            }
            else if (strncmp(argv[i], "-c:", 3) == 0) { // Gear No.
                gear_len++;
            }
            else if (strncmp(argv[i], "-s:", 3) == 0) { // Start Pos.
                start_len = (int) strlen(argv[i]) - 3;
            }
        }
    }
    if (start_len != gear_len || start_len == 0) {
        warnh("b16c mode");
        // B16c Mode
        int a;
        if (DECODE) {
            int b;
            while (((a = getchar()) != EOF) & ((b = getchar()) != EOF)) {
                putchar((a - 65) * 16 + b - 65);
            }
            return 0;
        }
        else {
            warnh("b16c mode");
            while ((a = getchar()) != EOF) {
                putchar(a / 16 + 65);
                putchar(a % 16 + 65);
                //printf("%d %d %d\n",a,a / 16, a%16);
            }
            return 0;
        }
    }
    gear all_gear[start_len]; // All gears
    int all_gear_s[start_len]; // Starting position of all gears
        int curr_gear = 0;
        for (int i = 0; i < argc; i++) {
            if (!isopt(argv[i])) {
                if (strncmp(argv[i], "-c:", 3) == 0) {
                    char *tmpstr = (char *) safe_malloc(256);
                    substring(argv[i], tmpstr, 3, (int) strlen(argv[i]) - 3);
                    sprintf(tmpstr, "%s%s", abspath, tmpstr);
                    read_gear(tmpstr, all_gear[curr_gear]);
                    curr_gear++;
                    safe_free(tmpstr);
                }
                else if (strncmp(argv[i], "-s:", 3) == 0) { // Starting pos
                    char *tmpstr = (char *) safe_malloc(start_len);
                    substring(argv[i], tmpstr, 3, (int) strlen(argv[i]) - 3);
                    for (int j = 0; j < start_len; j++) {
                        all_gear_s[j] = (int) tmpstr[j];
                    }
                    safe_free(tmpstr);
                }
            }
        }
    safe_free(abspath);
    int a;
    if (DECODE) {
        int b;
        while (((a = getchar()) != EOF) & ((b = getchar()) != EOF)) {
            putchar(decode(a, all_gear, all_gear_s, start_len) * 16
                        + decode(b, all_gear, all_gear_s, start_len));

        }
    }
    else {

        while ((a = getchar()) != EOF) {
            putchar(encode(a / 16 + 65, all_gear, all_gear_s, start_len) * 16
                        + encode(a % 16 + 65, all_gear, all_gear_s, start_len));
        }

    }
}
void gen_gear()
{
    debugh("Entering gen_gear with abspath=%s", abspath);
    struct dirent *de;
    mkdir_p(abspath);
    DIR *dr = safe_opendir(abspath);
    int gear_cnt = 0;
    while (readdir(dr) != NULL) {
        gear_cnt += 1;
    }
    gear_cnt -= 2; // . and ..
    debugh("%i gears exists",gear_cnt);
    seekdir(dr,0L);
    gear this_all_gear[gear_cnt];
    int gear_i = 0;
    char *gear_path = (char *) safe_malloc(256);
    while ((de = readdir(dr)) != NULL) {
        debugh(de->d_name);
        if (strcmp(de->d_name, "..") || strcmp(de->d_name, ".")) {
            continue;
        }
        debugh("gear %i read",gear_i);
        debugh("Got dname=%s", de->d_name);
        sprintf(gear_path, "%s/%s", abspath, de->d_name);
        debugh("gen_gear with gear_path=%s", gear_path);
        read_gear(gear_path, this_all_gear[gear_i]);
        gear_i += 1;
    }
    debugh("%i gears exists",gear_cnt);
    safe_free(de);
    closedir(dr);
    gear new_gear;
    for (int i = 0; i < 16; i++) {
        new_gear[i] = (char) (i + 65);
    }
    int have_duplicate = 1;
    while (have_duplicate) {
        for (int i = 0; i < 16; i++) {
            char temp = new_gear[i];
            int randomIndex = rand() % 16;
            new_gear[i] = new_gear[randomIndex];
            new_gear[randomIndex] = temp;
        }
        have_duplicate=0;
        for (int i = 0; i < gear_cnt; i++) {
            if (strcmp(this_all_gear[i], new_gear)) {
                have_duplicate=1;
            }
        }
    }
    gear_cnt += 1;
    sprintf(gear_path, "%s/%i", abspath, gear_cnt);
    FILE *fgp = safe_fopen(gear_path, "w");
    fprintf(fgp, "%s", new_gear);
    printf("%i=%s", gear_cnt, new_gear);
    safe_free(gear_path);
    // safe_free(new_gear);
    safe_fclose(fgp);
    safe_free(abspath);
    debugh("Leaving gen_gear");
}

void read_gear(char *fn, gear return_gear)
{
    debugh("Entering read_gear with fn=%s", fn);
    char tmp_chr;
    FILE *gear_file = safe_fopen(fn, "r");
    for (int i = 0; i < 16; i++) {
        tmp_chr=(char) safe_fgetc(gear_file);
        if (tmp_chr == EOF){
            errh("File too short; should contain at least 16 characters. Please remove it ans use another gear.",1);
        }
        return_gear[i] = tmp_chr;
    }
    debugh("Leaving read_gear");
    safe_fclose(gear_file);
}

void inc_gear(int *all_gear_s, int start_len)
{
    all_gear_s[0] += 1;
    for (int i = 0; i < start_len - 1; i++) {
        if (all_gear_s[i] >= 16) {
            all_gear_s[i] %= 16;
            all_gear_s[i + 1] += 1;
        }
    }
    all_gear_s[start_len - 1] %= 16;
}

int encode(int chr, gear *all_gear, int *all_gear_s, int start_len)
{
    for (int i = 0; i < start_len; i++) {
        chr = (int) all_gear[i][chr - 65 + all_gear_s[i] % 16];
    }
    inc_gear(all_gear_s, start_len);
    return chr;
}

int decode(int chr, gear *all_gear, int *all_gear_s, int start_len)
{
    for (int i = start_len - 1; i >= 0; i--) {
        chr = (int) (strchr(all_gear[i], chr) - all_gear[i] + 1 - all_gear_s[i] + 16) % 16 + 65;
    }
    inc_gear(all_gear_s, start_len);
    return chr;
}

