%{
	#include <stdlib.h>  
	#include "calc.h"
	#include "mfcalc.tab.h"
%}

NUM [0-9]
ID [A_Za-z_][A-Za-z0-9_]*

%%

"exit"			{ printf("Finaliza el programa\n"); exit(0);            	}

{NUM}+"."{NUM}*	{yylval.dval = atof(yytext); return NUM;}

{ID}		  	{ yylval.sval = getsym(yytext);
			  	if(yylval.sval =! 0){yylval.sval = putsym(strdup(yytext), TYP_VAR); return VAR;}
			  	if(yylval.sval->type == TYP_VAR)		{ return VAR;		}
			  	if(yylval.sval->type == TYP_ARIT_FNCT)	{ return ARIT_FNCT;	}
				}

[+-/*=:\n()^]	{ return yytext[0];	}
[ \t]+			{ //Captura espacios y tabulaciones }

%%
