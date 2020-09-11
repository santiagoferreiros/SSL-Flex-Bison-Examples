%{
  #include <stdio.h>
  #include <math.h>  
  #include "calc.h"
  #include <string.h>

void yyerror(char const *s){fprintf (stderr, "%s\n> ", s);}

int yylex();

int yywrap(){
return(1);
}

symrec *aux;

%}

%union {
  double dval;
  char*  idval;
}

%token <dval>  NUM      
%token <idval> ID
%type  <dval>  exp

%right '='
%left '-' '+'
%left '*' '/'
%left NEG
%right '^'     
%%

input:
        | input line
;

line:
  '\n'
| exp '\n'   	{ printf ("El resultado de la operacion es: %.10g\n> ", $1);	}
| error '\n' 	{ yyerrok;              	}
;

exp:
  NUM                { $$ = $1;                          	}
| ID                 { aux=getsym($<idval>1); if (aux) { $$=(aux->value.var)    ;} else { printf("La variable %s no esta declarada, se considera que posee valor cero \n",$1); $$=0; } }
| ID '=' exp         { aux=getsym($<idval>1); if (aux) { $$=(aux->value.var)=$3 ;} else { printf("Se declara una nueva variable con nombre %s y se inicializa en %f \n",$1,$3); aux=putsym(strdup($1),TYP_VAR); $$=(aux->value.var)=$3 ;} }
| ID '(' exp ')'     { aux=getsym($<idval>1); if (aux) { $$ = (*(aux->value.fnctptr))($3); } else { printf("La funcion %s no esta definida, se considera que retorna valor cero por defecto \n",$1); $$=0; } }
| exp '+' exp        { $$ = $1 + $3;                    	}
| exp '-' exp        { $$ = $1 - $3;                    	}
| exp '*' exp        { $$ = $1 * $3;                    	}
| exp '/' exp        { $$ = $1 / $3;                    	}
| '-' exp  %prec NEG { $$ = -$2;                        	}
| exp '^' exp        { $$ = pow ($1, $3);               	}
| '(' exp ')'        { $$ = $2;                         	}
;

%%

// Define variable puntero que apunta a la tabla de símbolos (TS).

symrec *sym_table;

// Define una estructura para cargar en la TS las funciones aritméticas.

struct init
{
  char const *fname;
  double (*fnct) (double);
};

// Declaramos una vector de tipo init llamado arith_fncts para almacenar todas las funciones en la TS.

struct init const arith_fncts[] =
{
  { "atan", atan },
  { "cos",  cos  },
  { "exp",  exp  },
  { "ln",   log  },
  { "sin",  sin  },
  { "sqrt", sqrt },
  { 0, 0 },
};

//Definimos la función init_table para cargar el vector de funciones en la TS.

static void init_table(){
  int i;
  for (i = 0; arith_fncts[i].fname != 0; i++)
    {
      symrec *ptr = putsym (arith_fncts[i].fname, TYP_FNCT);
      ptr->value.fnctptr = arith_fncts[i].fnct;
    }

}

//Función principal, inicializa la TS e invoca al parser.

int main (int argc, char const* argv[])
{
  printf("> ");
  init_table();
  return yyparse();
}