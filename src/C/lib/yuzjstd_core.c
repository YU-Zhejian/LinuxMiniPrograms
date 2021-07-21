#include <string.h>
#include <malloc.h>
#include <yuzjstd.h>

void* safe_malloc(int size){
    void * tmptr=malloc(size);
    if (tmptr == NULL){
        errh("Not enough memory",1);
    }
    return tmptr;
}
