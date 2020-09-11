%{
  #include <stdio.h>
  #include <math.h>  
  #include "calc.h"

void yyerror(char const *s){fprintf (stderr, "%s\n> ", s);}

int yylex();

int yywrap(){
return(1);
}

%}

%union {
  double dval;
  struct symrec *sval;
}

%token <dval>  NUM      
%token <sval> VAR FNCT
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
| exp '\n'   	{ printf ("%.10g\n> ", $1);	}
| error '\n' 	{ yyerrok;              	}
;

exp:
  NUM                { $$ = $1;                         	}
| VAR                { $$ = $1->value.var;              	}
| VAR '=' exp        { $$ = $3; $1->value.var = $3;     	}
| FNCT '(' exp ')'   { $$ = (*($1->value.fnctptr))($3);	  }
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