%{
#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
%}

%union
{
 float real;
 char cadena[50];
}

%token <real> NUM
%token <cadena> IGUAL_IGUAL
%token <cadena> DISTINTO
%token <cadena> MAYOR_IGUAL
%token <cadena> MENOR_IGUAL
%token <cadena> MAYOR
%token <cadena> MENOR
%token <cadena> IF
%token <cadena> ELSE
%token <cadena> SWITCH
%token <cadena> TIPO_DATO
%token <cadena> DOBLE_PIPE 
%token <cadena> MAS_IGUAL
%token <cadena> MENOS_IGUAL
%token <cadena> POR_IGUAL
%token <cadena> DOBLE_AMPERSAND
%token <cadena> MAS_MAS
%token <cadena> SIZEOF
%token <cadena> LITERAL_CADENA
%token <cadena> IDENTIFICADOR

%left '+' '-' '*' ',' DOBLE_PIPE DOBLE_AMPERSAND IGUAL_IGUAL DISTINTO MAYOR_IGUAL MENOR_IGUAL MAYOR MENOR
%right '=' ':' '&' '!' '(' ')' '[' ']' MAS_IGUAL MENOS_IGUAL POR_IGUAL MAS_MAS SIZEOF


%% /* A continuación las reglas gramaticales y las acciones */

input:    /* vacío */
        | input line
;

line:     '\n'
        | expresion '\n' 
;
expresion: expAsignacion
;

expAsignacion: expCondicional
              |expUnaria operAsignacion expAsignacion
;

operAsignacion:'=' 
               |MAS_IGUAL
               |MENOS_IGUAL
               |POR_IGUAL
;
expCondicional: expOr
               |expOr expresion ':' expCondicional
;
expOr: expAnd
      |expOr DOBLE_PIPE expAnd
;

expAnd: expIgualdad
       |expAnd DOBLE_AMPERSAND expIgualdad
;

expIgualdad: expRelacional
            |expIgualdad igualdad expRelacional
;

igualdad: IGUAL_IGUAL
         |DISTINTO
;

expRelacional: expAditiva
              |expRelacional operadorRelacional expAditiva
;

operadorRelacional: MAYOR_IGUAL
                   |MENOR_IGUAL
                   |MAYOR
                   |MENOR
;

expAditiva: expMultiplicativa
           |expAditiva operadorAditivo expMultiplicativa
;

operadorAditivo: '+'
                |'-'
;

expMultiplicativa: expUnaria
                  |expMultiplicativa operadorMultiplicativo expUnaria

operadorMultiplicativo: '*'
                       |'/'
;
expUnaria:expPostFijo
          | MAS_MAS expUnaria
          |operUnario expUnaria
          |SIZEOF '(' TIPO_DATO ')'
;

operUnario: '&'  
           |'!'
;
expPostFijo : expPrimaria
             |expPostFijo '[' expresion ']'
	     |expPostFijo '(' listaArgumentos ')'
;

listaArgumentos: expresion
		| listaArgumentos ',' expresion
;

expPrimaria: IDENTIFICADOR         {printf("se encontro el identificador \n");}
             |NUM                  {printf("se encontro un numero \n");}
             |'('expresion')'
;

%%

main ()
{
  yyparse ();
}
