
%option noyywrap

%{

#include <stdio.h>

%}

%%

[1-9][0-9]* {printf("Encontre una constante entera decimal \n");}
0[0-7]* {printf("Encontre una constante entera octal \n");}
0[xX][0-9a-fA-F]+ {printf("Encontre una constante entera hexadecimal \n");}
[a-zA-Z_][a-zA-Z0-9_]* {printf("Encontre un identificador \n");}

%%

