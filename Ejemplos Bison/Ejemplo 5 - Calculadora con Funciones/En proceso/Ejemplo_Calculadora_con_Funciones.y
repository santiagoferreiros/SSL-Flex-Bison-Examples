
%{
#include <math.h>  /* Para funciones matemáticas, cos(), sin(), etc. */
#include "calc.h"  /* Contiene definición de `symrec'                */
%}

%union {

double     val;  /* Para devolver números                            */
symrec*    tptr;   /* Para devolver punteros a la tabla de símbolos    */

}

%token <val>  NUM        /* Número simple en doble precisión         */
%token <tptr> VAR FNCT   /* Variable y Función                       */
%type  <val>  exp

%right '='
%left '-' '+'
%left '*' '/'
%left NEG     /* Negación--menos unario */
%right '^'    /* Exponenciación        */

/* A continuación la gramática */

%%

input:   /* vacío */
        | input line
;

line:
          '\n'
        | exp '\n'   { printf ("\t%.10g\n", $1); }
        | error '\n' { yyerrok;                  }
;

exp:      NUM                { $$ = $1;                         }
        | VAR                { $$ = $1->value.var;              }
        | VAR '=' exp        { $$ = $3; $1->value.var = $3;     }
        | FNCT '(' exp ')'   { $$ = (*($1->value.fnctptr))($3); }
        | exp '+' exp        { $$ = $1 + $3;                    }
        | exp '-' exp        { $$ = $1 - $3;                    }
        | exp '*' exp        { $$ = $1 * $3;                    }
        | exp '/' exp        { $$ = $1 / $3;                    }
        | '-' exp  %prec NEG { $$ = -$2;                        }
        | exp '^' exp        { $$ = pow ($1, $3);               }
        | '(' exp ')'        { $$ = $2;                         }
;

/* Fin de la gramática */

%%

int main ()
{
	init_table ();
	yyparse ();
}

yyerror (s) /* Llamada por yyparse ante un error */
char *s;
{
printf ("%s\n", s);
}



