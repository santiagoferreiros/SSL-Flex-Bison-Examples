%option noyywrap

%{
#include <stdio.h>
%}

%%

"Hola \"Mundo\"" {printf("Se encontro el literal cadena \"Hola \"Mundo\"\n");}
C[^aeiou]R {printf("Se encontro una secuencia de caracteres que no posee vocales minusculas");}
[0-9]/[a-zA-Z] {printf("Se encontro un digito del 0 al 9 que esta seguido de una letra minuscula o mayuscula \n");}
[a-z] {printf("Se encontro una letra minuscula %c \n", yytext[0]);}
"jaja"$ {printf("Se encontro la secuencia \"jaja\" antes del fin de una linea \n");}


%%

