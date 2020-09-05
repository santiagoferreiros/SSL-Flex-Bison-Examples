%option noyywrap

%{
#include <stdio.h>
%}

DIGITO_DECIMAL [0-9] 
DIGITO_OCTAL [0-7] 
DIGITO_HEXADECIMAL [a-fA-F0-9] 
LETRA [a-zA-Z] 

%%

[1-9]{DIGITO_DECIMAL}* {printf("Encontre la constante entera decimal: %s de longitud %d \n",yytext,yyleng);}
0{DIGITO_OCTAL}* {printf("Encontre la constante entera octal: %s de longitud %d \n",yytext,yyleng);}
0[xX]{DIGITO_HEXADECIMAL}+ {printf("Encontre la constante entera hexadecimal: %s de longitud %d \n",yytext,yyleng);}
({LETRA}|"_")({LETRA}|{DIGITO_DECIMAL}|"_")* {printf("Encontre el identificador: %s de longitud %d \n",yytext,yyleng);}

%%


