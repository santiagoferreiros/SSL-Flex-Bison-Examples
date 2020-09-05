/* Tipo de datos para enlaces en la cadena de símbolos.      */

struct symrec
{
  char* name;  /* nombre del símbolo                 */
  int type;    /* tipo del símbolo: bien VAR o FNCT  */
  union {
    double var;           /* valor de una VAR        */
    double (*fnctptr)();  /* valor de una FNCT       */
  } value;
  struct symrec* next;    /* campo de enlace         */
};

typedef struct symrec symrec;

/* La tabla de símbolos: una cadena de `struct symrec'.     */

extern symrec *sym_table;

symrec *putsym ();
symrec *getsym ();

struct init
{
  char *fname;
  double (*fnct)();
};

struct init arith_fncts[]
  = {
      "sin", sin,
      "cos", cos,
      "atan", atan,
      "ln", log,
      "exp", exp,
      "sqrt", sqrt,
      0, 0
    };

/* La tabla de símbolos: una cadena de `struct symrec'.  */

symrec *sym_table = (symrec *)0;

init_table ()  /* pone las funciones aritméticas en una tabla. */
{
  int i;
  symrec *ptr;
  for (i = 0; arith_fncts[i].fname != 0; i++)
    {
      ptr = putsym (arith_fncts[i].fname, FNCT);
      ptr->value.fnctptr = arith_fncts[i].fnct;
    }
}

symrec* putsym (char* sym_name,int sym_type){

  symrec* ptr = (symrec *)malloc(sizeof (symrec));
  ptr->name = (char *) malloc(strlen(sym_name)+1);
  strcpy(ptr->name,sym_name);
  ptr->type = sym_type;
  ptr->value.var = 0; /* pone valor a 0 incluso si es fctn.  */
  ptr->next = (struct symrec *)sym_table;
  sym_table = ptr;
  return ptr;
}

symrec* getsym (char* sym_name){
    
  symrec *ptr;
  for (ptr = sym_table; ptr != (symrec *) 0;ptr = (symrec *)ptr->next)
        if(strcmp(ptr->name,sym_name) == 0)
        return ptr;
  return 0;
}