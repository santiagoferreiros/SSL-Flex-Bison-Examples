

%{
#include "Ejemplo_DeclaracionVariables.tab.h"
#include <stdio.h>
#include <string.h>
%}


%%

[0-9]+	{yylval.entero=atoi(yytext); return NUM;}
int|char|float|double {strcpy(yylval.cadena,yytext); return TIPO_DATO;}
[A-Za-z_][A-Za-z_0-9]* {strcpy(yylval.cadena,yytext); return IDENTIFICADOR;}
","     {return ',';}
"="     {return '=';}
";"     {return ';';}
\n	{return '\n';}
[\t ]
.

%%

