%{
#include "Validacion_Tipos.tab.h"
#include <stdio.h>
#include <string.h>

%}

%%

[0-9]+	{yylval.mystruct.valor_entero=atoi(yytext); yylval.mystruct.tipo=1; return NUMERO_ENTERO;}
[0-9]+\.[0-9]+ {yylval.mystruct.valor_real=atof(yytext); yylval.mystruct.tipo=2; return NUMERO_REAL;}
"+"     {return '+';}
"-"     {return '-';}
"*"     {return '*';}
\n	    {return '\n';}
[\t ]
.

%%