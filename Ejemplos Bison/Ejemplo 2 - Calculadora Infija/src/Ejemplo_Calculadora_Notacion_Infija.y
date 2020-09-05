/*Calculadora NOTACION INFIJA*/

%{
#include <math.h>
#include <stdio.h>
#include <ctype.h>
int yylex ();
int yyerror (char*);
int yywrap(){
return(1);
}

%}

%token <dval> NUM
%token <ival> ENTERO

%type <dval> exp

%left '+' '-'
%left '*' '/'
%left '^'
%left '(' ')'

%union { /*Para poder manejar varios tipos de datos en el yyval, uno para enteros y otro para punto flotante)*/
  int ival;
  double dval;
}


%% /* Reglas y acciones */

input:    /* vacio */
        | input line
;

line:     '\n'
        | exp '\n'  { printf ("El resultado de la expresion es: %g \n", $<dval>1); }
;

exp:    NUM               { $<dval>$ = $<dval>1; }
	| ENTERO	  { $<dval>$ = $<ival>1; }
        | exp '+' exp     { $<dval>$ = $<dval>1 + $<dval>3; }
        | exp '-' exp     { $<dval>$ = $<dval>1 - $<dval>3; }
        | exp '*' exp     { $<dval>$ = $<dval>1 * $<dval>3; }
        | exp '/' exp     { if($<dval>3 == 0) {printf("No se puede dividir por 0"); return 1;} else $<dval>$ = $<dval>1 / $<dval>3;}
        | exp '^' exp     { if(($<dval>1 == 0)&&($<dval>3 == 0)){printf("No se puede realizar 0^0"); return 1;} else $<dval>$ = pow ($<dval>1, $<dval>3);}
	| '-' exp	  { $<dval>$ = -$<dval>2; }
	| '(' exp ')'     { $<dval>$ = $<dval>2; }
;

%%
int yyerror (char *mensaje)  /* Fucion de error */
{
  printf ("Error: %s\n", mensaje);
}

void main(){

   #ifdef BISON_DEBUG
        yydebug = 1;
#endif    
 
   printf("Ingrese una expresion aritmetica para resolver (decimal, octal o hexadecimal):\n");
   yyparse();
}
