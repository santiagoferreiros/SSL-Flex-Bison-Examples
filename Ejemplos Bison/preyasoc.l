
%{
#include "preyasoc.tab.h"
#include <stdlib.h>
#include <ctype.h>
#include <stdio.h>
%}


%%

[0-9]+ {yylval.s.valor = atoi(yytext); yylval.s.tipo = 2; strcpy(yylval.s.cadena,yytext); return NUM;}
[0-9]+("."[0-9]+)? {yylval.s.valor = atof(yytext); yylval.s.tipo = 1; strcpy(yylval.s.cadena,yytext); return NUM;}
"+"     {return '+';}
"-"     {return '-';}
"*"     {return '*';}
"/"     {return '/';}
"^"     {return '^';}
"("     {return '(';}
")"     {return ')';}
"\n"    {return '\n';}

%%
