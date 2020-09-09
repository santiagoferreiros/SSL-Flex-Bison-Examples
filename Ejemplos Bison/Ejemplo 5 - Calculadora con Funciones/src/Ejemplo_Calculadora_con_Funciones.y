
%{
#include <math.h>  /* Para funciones matemáticas, cos(), sin(), etc. */
#include "calc.h"  /* Contiene definición de `symrec'                */
%}

%union {

double     val;  /* Para devolver números                            */
symrec*    tptr;   /* Para devolver punteros a la tabla de símbolos  */

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

exp:      NUM                { $<val>$ = $<val>1;                               }
        | VAR                { $<val>$ = $<tptr>1->value.var;                    }
        | VAR '=' exp        { $<val>$ = $<val>3; $<tptr>1->value.var = $<val>3;     }
        | FNCT '(' exp ')'   { $<val>$ = (*($<tptr>1->value.fnctptr))($<val>3);            }
        | exp '+' exp        { $<val>$ = $<val>1 + $<val>3;                     }
        | exp '-' exp        { $<val>$ = $<val>1 - $<val>3;                     }
        | exp '*' exp        { $<val>$ = $<val>1 * $<val>3;                     }
        | exp '/' exp        { $<val>$ = $<val>1 / $<val>3;                     }
        | '-' exp  %prec NEG { $<val>$ = -$<val>2;                              }
        | exp '^' exp        { $<val>$ = pow ($<val>1, $<val>3);                }
        | '(' exp ')'        { $<val>$ = $<val>2;                               }
;

/* Fin de la gramática */

%%

int main (){

	init_table ();
	yyparse ();
}

/* Llamada por yyparse ante un error */

yyerror (char* s){

        printf ("%s\n", s);

}



