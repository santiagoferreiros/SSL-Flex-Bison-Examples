%option noyywrap

%{
#include <stdio.h>
%}

DIGITO_DECIMAL [0-9] 
DIGITO_OCTAL [0-7] 
DIGITO_HEXADECIMAL [a-fA-F0-9] 
LETRA [a-zA-Z] 

%%

[1-9]{DIGITO_DECIMAL}* {printf("Encontre la constante entera decimal que tiene como primer caracter: %c \n",yytext[0]);}
0{DIGITO_OCTAL}* {printf("Encontre la constante entera octal que tiene como segundo caracter: %c \n",yytext[1]);}
0[xX]{DIGITO_HEXADECIMAL}+ {printf("Encontre la constante entera hexadecimal: %s \n",yytext);}
({LETRA}|"_")({LETRA}|{DIGITO_DECIMAL}|"_")* {printf("Encontre el identificador: %s \n",yytext);}

%%