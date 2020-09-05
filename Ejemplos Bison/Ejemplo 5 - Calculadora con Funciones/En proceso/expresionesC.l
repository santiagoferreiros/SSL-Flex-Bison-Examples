%{ 
	#include <stdio.h>
	#include <string.h>
	#include "bnf.tab.h"
%}

%option noyywrap

%%

"{"		{ return '{'; }
"}"		{ return '}'; }
"="		{ return '='; }
"<"		{ return '<'; }
">"		{ return '>'; }
"+"		{ return '+'; }
"-"		{ return '-'; }
"*"		{ return '*'; }
"/"		{ return '/'; }
"%"		{ return '%'; }
";"		{ return ';'; }
":"		{ return ':'; }
"("		{ return '('; }
")"		{ return ')'; }
","		{ return ','; }

"||"	{ yylval.s.esNum = 0; return OR; }
"&&"	{ yylval.s.esNum = 0; return AND; }
"=="	{ yylval.s.esNum = 0; return IGUALDAD; }
">="	{ yylval.s.esNum = 0; return MAYORIGUAL; }
"<="	{ yylval.s.esNum = 0; return MENORIGUAL; }
"!=" 	{ yylval.s.esNum = 0; return DESIGUALDAD; }

while 		{ return WHILE; }
if		{ return IF; }
else		{ return ELSE; }
do		{ return DO; }
switch		{ return SWITCH; }
for		{ return FOR; }
case		{ return CASE; }
break		{ return BREAK; }
default		{ return DEFAULT; }
char		{ return CHAR; }
double		{ return DOUBLE; }
float		{ return FLOAT; }
int		{ return INT; }
long		{ return LONG; }
short		{ return SHORT; }

[1-9][0-9]*       { yylval.s.esNum = 1; return CONSTANTEDECIMAL; }
0[0-7]*           { yylval.s.esNum = 1; return CONSTANTEOCTAL; }
0[xX][0-9a-fA-F]+ { yylval.s.esNum = 1; return CONSTANTEHEXADECIMAL; }
[0-9]*\.[0-9]+([eE][\+\-]?[0-9]+)?|[0-9]+\.([eE][\+\-]?[0-9]+)?|[0-9]([eE][\+\-]?[0-9]+)? { yylval.s.esNum = 1; return CONSTANTEREAL; } 
[0-9]+(\.[0-9]+)?	{ yylval.s.esNum = 1; return CONSTANTE; }
'[ -~]'|'\\[abefnrtv\\\'\"\?]' { yylval.s.esNum = 1; return CONSTANTECARACTER; }
auto|const|continue|enum|extern|goto|register|signed|sizeof|static|struct|typedef|union|unsigned|void|volatile { yylval.s.esNum = 0; return PALABRARESERVADA; } 
[_a-zA-Z][_a-zA-Z0-9]* { strcpy(yylval.s.valor, yytext); return IDENTIFICADOR; }
[,\.;:\?\(\)\[\]]  { yylval.s.esNum = 0; return CARACTERDEPUNTUACION; }
[!&\*\+\-/|%><\?]     { yylval.s.esNum = 0; return OPERADORDEC; }
\/\/(.)*|\/\*(.)*\*\/           { yylval.s.esNum = 0; return COMENTARIO; }

%%

int main() {
	yyin = fopen("entrada.txt", "r");
	yyparse();

	return 0;
}

yyerror() { }
