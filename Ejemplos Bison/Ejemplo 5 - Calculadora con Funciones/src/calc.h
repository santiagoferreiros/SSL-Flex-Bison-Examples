#include  <math.h>
#include <stdio.h>
#include <stdlib.h>
#define TYPE_VAR 1
#define TYPE_FNCT 2

/* Tipo de datos para enlaces en la cadena de símbolos.      */

struct symrec
{
  char* name;  /* nombre del símbolo                 */
  int type;    /* tipo del símbolo: VAR o FNCT       */
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

/* Se declara una estructura llamada init compuesta por dos campos
fname que guardara el nombre de la función y fnct que es un puntero a una función */

struct init
{
  char *fname;
  double (*fnct)(double); /*Se está definiendo un campo llamado fnct que es un puntero a una función que recibe y retorna un valor de tipo double */
};

/* Se inicializa un vector de tipo init para almacenar los nombres de las
funciones clásicas de una calculadora */

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

/* El último elmento 0,0 se pone para saber cuando se llega al final del vector 
Se utilizará posteriormente al cargar todos estos nombres en la tabla de símbolos */

/* La tabla de símbolos: una cadena de `struct symrec'.  */

symrec *sym_table = (symrec *)0;

/* Se define ua funcion init_table para poner todas las funciones
aritméticas definidas previamente en la table de símbolos sym_table */

init_table () 
{
  int i;
  symrec *ptr;
  for (i = 0; arith_fncts[i].fname != 0; i++)
    {
      ptr = putsym(arith_fncts[i].fname, TYPE_FNCT);
      ptr->value.fnctptr = arith_fncts[i].fnct;
    }
}

/* La función getsym recibe un nombre de un símbolo "sym_name" y su tipo "sym_type"
y se encarga de agergar el mismo a la tabla de símbolos "sym_table" 

sym_type puede ser TYPE_VAR o TYPE_FNCT con valores enteros 1 y 2 respectivamente
En caso de no encontrarlo devuelve 0 */

symrec* putsym (char* sym_name,int sym_type){

  symrec* ptr = (symrec *) malloc(sizeof(symrec)); /* Pide memoria para el nodo */
  ptr->name = (char *) malloc(strlen(sym_name)+1); /* Pide memoria para el nombre del símbolo */
  strcpy(ptr->name,sym_name); /* Copia el nombre del símbo en el nodo */
  ptr->type = sym_type; /* Asigna el tipo al símbolo */
  ptr->value.var = 0; /* pone valor a 0 incluso si es fctn.  */
  ptr->next = (struct symrec *)sym_table; /*El nuevo nodo creado apunta al nodo donde apunta actualmente la tabla de símbolos */
  sym_table = ptr; /* La tabla de símbolos apunta al nodo creado */
  return ptr;
}

/* La función getsym recibe un nombre de un símbolo "sym_name" se se encarga de
buscar el mismo en la tabal de símbolos "sym_table" 

Puede buscar nombres de variables o de funciones, está todo en la misma tabla 
Retorna un puntero al nodo que contenga la información del símbolo
En caso de no encontrarlo devuelve 0 */

symrec* getsym (char* sym_name){
    
  symrec *ptr;
  for (ptr = sym_table; ptr != (symrec *) 0;ptr = (symrec *)ptr->next)
        if(strcmp(ptr->name,sym_name) == 0)
        return ptr;
  return 0;
}