%{
	#include <stdlib.h>  
	#include "calc.h"
	#include "mfcalc.tab.h"
    #define TYPE_VAR 1
    #define TYPE_FNCT 2
%}

NUM [0-9]
ID [a-z][a-z0-9]*
OP [+-/*]

%%

{NUM}+"."*{NUM}*	{yylval.val = atof(yytext); return NUM;}

{ID}		{ yylval.tptr = getsym(yytext);
			  if(yylval.tptr==0){yylval.tptr = putsym(strdup(yytext),TYPE_VAR); return VAR; 		}
			  if(yylval.tptr->type == TYPE_VAR) {return VAR;}
			  if(yylval.tptr->type == TYPE_FNCT){return FNCT;}
			}

[ \t]+

"exit"  	{printf("Adios!\n"); exit(0);}

"\n"		{return '\n';}
"="			{return '=';}
"+"   		{return '+';}
"-"    		{return '-';}
"*"    		{return '*';}
"/"     	{return '/';}
"^"     	{return '^';}
")"			{return ')';}
"("			{return '(';}

%%