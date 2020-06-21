%option noyywrap

%{
#include <stdio.h>
%}

%%

[1-9][0-9]* {printf("Encontre la constante entera decimal: %s \n",yytext);}
0[0-7]* {printf("Encontre la constante entera octal: %s \n",yytext);}
0[xX][0-9a-fA-F]+ {printf("Encontre la constante entera hexadecimal: %s \n",yytext);}
[a-zA-Z_][a-zA-Z0-9_]* {printf("Encontre el identificador: %s \n",yytext);}

%%

int main() {
   
    yyin = fopen("entrada.txt", "r");
    yyout = fopen("salida.txt", "w");	
    yylex();
	
    return 0;
}
