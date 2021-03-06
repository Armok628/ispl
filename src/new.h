// Functions for creating new LISP objects
#ifndef NEW_H
#define NEW_H
#include <stdlib.h>
#include "hash.h"
#include "object.h"
extern table_t *obtable;

obj_t *new_object(void);
obj_t *new_array(int);
obj_t *new_cell(obj_t *,obj_t *);
obj_t *new_double(double);
obj_t *new_filestream(FILE *);
obj_t *new_integer(long);
// new_function: See function.h
obj_t *new_namespace(table_t *);
obj_t *new_symbol(char *);
#endif
