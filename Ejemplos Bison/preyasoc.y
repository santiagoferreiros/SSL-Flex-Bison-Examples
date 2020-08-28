/* Calculadora de notación infija (usual) */

%{
#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
%}

%union { 
  struct {
     char cadena[50];
     float  valor;
     int  tipo;
  } s;
}

%token <s> NUM
%type <s> exp

%left '+' '-'
%right '*' '/'
%nonassoc '^'


%% /* A continuación las reglas gramaticales y las acciones */

input:    /* vacío */
        | input line
;

line:     '\n'
        | exp '\n'  { printf ("\t %f\n", $<s.valor>1); }
;

exp:    NUM               { $<s.valor>$ = $<s.valor>1; $<s.tipo>$ = $<s.tipo>1; }
        |'(' '-' NUM ')'  { $<s.valor>$ = - $<s.valor>3; $<s.tipo>$ = $<s.tipo>3; }
        | exp '+' exp     { if ($<s.tipo>1==$<s.tipo>3){$<s.valor>$ = $<s.valor>1 + $<s.valor>3; $<s.tipo>$ = $<s.tipo>1;}else{printf("No se corresponden los tipos de datos en la suma");}}
        | exp '-' exp     { if ($<s.tipo>1==$<s.tipo>3){$<s.valor>$ = $<s.valor>1 - $<s.valor>3; $<s.tipo>$ = $<s.tipo>1;}else{printf("No se corresponden los tipos de datos en la resta");}}
        | exp '*'  exp    { if ($<s.tipo>1==$<s.tipo>3){$<s.valor>$ = $<s.valor>1 * $<s.valor>3; $<s.tipo>$ = $<s.tipo>1;}else{printf("No se corresponden los tipos de datos en el producto");}}
        | exp '/' exp     { if ($<s.tipo>1==$<s.tipo>3){$<s.valor>$ = $<s.valor>1 / $<s.valor>3; $<s.tipo>$ = $<s.tipo>1;}else{printf("No se corresponden los tipos de datos en el cociente");}}
        | exp '^' exp     { if ($<s.tipo>1==$<s.tipo>3){$<s.valor>$ = pow($<s.valor>1,$<s.valor>3); $<s.tipo>$ = $<s.tipo>1;}else{printf("No se corresponden los tipos de datos en la potencia");}}
;
%%

yyerror (s)  /* Llamada por yyparse ante un error */
     char *s;
{
  printf ("%s\n", s);
}

main ()
{
  yyparse ();
}
