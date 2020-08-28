
%{

#include <stdlib.h>
#include "Ejemplo_Calculadora_Notacion_Infija.tab.h"

%}

option noyywrap

%%

0[0-7]* {yylval.ival = strtol(yytext, NULL, 0); return ENTERO;} //Entero base 8

[0-9]+(\.[0-9]+)?  {yylval.dval = atof(yytext); return NUM;} //Real base 10

0[xX][0-9a-fA-f]* {yylval.ival = strtol(yytext, NULL, 0); return ENTERO;} //Entero base 16

"+"     {return '+';}
"-"     {return '-';}
"*"     {return '*';}
"/"     {return '/';}
"^"     {return '^';}
"("	{return '(';}
")"	{return ')';}
"\n"    {return '\n';}

%%

