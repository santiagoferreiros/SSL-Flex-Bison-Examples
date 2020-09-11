%{
	#include <stdlib.h>  
	#include "calc.h"
	#include "mfcalc.tab.h"
	#include <string.h>
%}

NUM [0-9]
ID [A-Za-z_][A-Za-z0-9_]*

%%

{NUM}+"."*{NUM}*	{ yylval.dval = atof(yytext); return NUM;	}

"exit"				{ printf("Hasta la proxima. Se cierra la calculadora\n"); exit(0);           	}

{ID}		{ yylval.sval = getsym(yytext);
			  if(!yylval.sval) {yylval.sval = putsym(strdup(yytext), TYP_VAR); return VAR;}
			  if(yylval.sval->type == TYP_VAR)  { return VAR;	}
			  if(yylval.sval->type == TYP_FNCT)	{ return FNCT;	}
			}

[+-/*=:\n()^] 		return yytext[0];
     
[ \t]+

%%
