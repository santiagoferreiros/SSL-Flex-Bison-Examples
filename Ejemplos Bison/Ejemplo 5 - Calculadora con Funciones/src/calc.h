#ifndef CALC_H
#define CALC_H

#define TYP_VAR 0
#define TYP_ARIT_FNCT 1
#define TYP_FNCT 3

typedef double (*func_t) (double);

/*
typedef struct function {
  struct symrec **params;
  struct symrec **body;
};*/

typedef struct symrec
{
  char *name;
  int type;   
  union
  {
    double var;    
    func_t fnctptr;
    //struct function *funcs;
  } value;
  struct symrec *next;
} symrec;

extern symrec *sym_table;

symrec *putsym (char const *, int);
symrec *getsym (char const *);

#endif
