%{
#include <stdio.h>
#include <string.h>
#include <math.h>  
#include "calc.h"
int yylex ();
int yyerror (char*);
int yywrap(){
return(1);
}
%}

%union {
  double dval;
  struct symrec *sval;
}

%token <dval>  NUM      
%token <sval> VAR ARIT_FNCT NAT_FNCT FNCT
%token <char*> DEF;
%type  <dval>  exp

%right '='
%left '-' '+'
%left '*' '/'
%right NEG
%right '^'     
%%

input:   /* vacío */
        | input line
;

line:
  '\n'
| exp '\n'   	{ printf ("%.10g\n> ", $1);	}
| native '\n'	{				}
| error '\n' 	{ yyerrok;              	}
;

native:
  NAT_FNCT '(' exp ')' { if(!strcmp($1->name, "print"))
			   printf ("%.10g\n> ", $3); 
			 else
			   printf ("%s->Ainda não implementado :( \n> ",$1->name);
                       }
//  DEF
;

exp:
  NUM                { $$ = $1;                         	}
| VAR                { $$ = $1->value.var;              	}
| VAR '=' exp        { $$ = $3; $1->value.var = $3;     	}
| ARIT_FNCT '(' exp ')' { $$ = (*($1->value.fnctptr))($3);	}
| exp '+' exp        { $$ = $1 + $3;                    	}
| exp '-' exp        { $$ = $1 - $3;                    	}
| exp '*' exp        { $$ = $1 * $3;                    	}
| exp '/' exp        { $$ = $1 / $3;                    	}
| '-' exp  %prec NEG { $$ = -$2;                        	}
| exp '^' exp        { $$ = pow ($1, $3);               	}
| '(' exp ')'        { $$ = $2;                         	}
;

%%

symrec *sym_table;

struct init
{
  char const *fname;
  double (*fnct) (double);
};

struct u_func
{
  char const *fname;
  double (*fnct) (double);
};

struct init const int_fncts[] =
{
  { "print", 	0 },
  { "load",  	0 },
  { "if",    	0 },
  { "for",   	0 },
  { "while", 	0 },
  { "func",	0 },
  { "return",	0 },
  { 0,       	0 },
};

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

static void init_table(){
  int i;
  for (i = 0; arith_fncts[i].fname != 0; i++)
    {
      symrec *ptr = putsym (arith_fncts[i].fname, TYP_ARIT_FNCT);
      ptr->value.fnctptr = arith_fncts[i].fnct;
    }
  for (i = 0; int_fncts[i].fname != 0; i++)
    {
      symrec *ptr = putsym (int_fncts[i].fname, TYP_NAT_FNCT);
    }
}

int main (int argc, char const* argv[])
{
  printf("> ");
  init_table();
  return yyparse();
}

