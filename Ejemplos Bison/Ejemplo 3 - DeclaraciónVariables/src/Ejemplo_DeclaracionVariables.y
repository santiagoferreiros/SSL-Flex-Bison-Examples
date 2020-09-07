/* Ejemplo para detección de declaración de variables */

%{
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#define YYDEBUG 1

int flag_error=0;
int contador=0;
char* tipo;

int yylex();
int yywrap(){
	return(1);
}

void yyerror (char const *s) {
   fprintf (stderr, "%s\n", s);
}

%}

%union {
char cadena[30];
int entero;
int tipo;
float real;
}

%token <entero> NUM
%token <cadena> IDENTIFICADOR
%token <cadena> TIPO_DATO
%token <entero> error

%type <cadena> identificadorA
%type <entero> expresion

%% /* A continuacion las reglas gramaticales y las acciones */

input:    /* vacio */
        | input line
;

line:     '\n'
        | sentenciaDeclaracion '\n'
;

sentenciaDeclaracion: 	TIPO_DATO {tipo=$<cadena>1;} listaIdentificadores ';' {if(flag_error==0){printf("Se han declarado %d variables de tipo %s \n",contador,$<cadena>1);contador=0;};flag_error=0;}
						| error caracterDeCorte {printf("Falta tipo de dato \n");}

listaIdentificadores: 	identificadorA
						| identificadorA ',' listaIdentificadores
;

identificadorA:		  	IDENTIFICADOR {printf("Se declara el identificador %s de tipo %s \n",$<cadena>1,tipo);contador++;}
						| IDENTIFICADOR '=' expresion {if(flag_error==0){printf("Se declara el identificador %s de tipo %s y se le asigna el valor %d \n",$<cadena>1,tipo,$<entero>3);};contador++;}
						| error {if(flag_error==0){printf("Falta identificador \n");flag_error=1;};}
;

expresion:				NUM {$<entero>$=$<entero>1}
						| error {flag_error=1;printf("Valor no reconocido para asignar \n");}
;

caracterDeCorte:	';' | '\n'

%%

int main ()
{
#ifdef BISON_DEBUG
        yydebug = 1;
#endif
  yyparse ();
}
