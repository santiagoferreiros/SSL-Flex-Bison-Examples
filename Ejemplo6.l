%option noyywrap

%{

// Definimos las librerías que incluímos, entre ellas "misfunciones.h"

#include <stdio.h>
#include "misfunciones.h"

// Podemos definir variables globales para nuestro analizador léxico

int acum = 0;
%}

LETRA [a-zA-z]
DIGITO_HEXADECIMAL [0-9A-Fa-f]

%%

[1-9][0-9]* {acum=acum+yyleng;printf("El doble de la longitud de la cadena %s es %d \n",yytext,duplicar(yyleng));}
0[0-7]* {acum=acum+yyleng;}
0[xX]{DIGITO_HEXADECIMAL}+ {acum=acum+yyleng;}
({LETRA}|"_")({LETRA}|[0-9]|"_")* {acum=acum+yyleng;}

%%

int main() {
   
    /* Acciones previas a la invocación den analizador léxico */

    yyin = fopen("entrada.txt", "r");
    yyout = fopen("salida.txt", "w");	

    /* Invocación del analizador léxico */

    yylex();
	
    /* Acciónes posteriores a la ejecución del analizador léxico, 
    sirven por ejemplo, para hacer un informen de resumen.1 */

    printf ("La suma de las longitudes de todas las cadadenas reconocidas es %d",acum);

    return 0;
}

