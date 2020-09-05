/* Reconocedor de Tokens */

%{

#include <stdio.h>
#include <stdlib.h>

enum yytokentype {

NUMBER = 258,
ADD = 259,
SUB = 260,
MUL = 261,
DIV = 262,
ABS = 263,
EOL = 264

};

int yylval;

%}

%%

"+"	{ return ADD; }
"-" 	{ return SUB; }
"*" 	{ return MUL; }
"/" 	{ return DIV; }
"|" 	{ return ABS; }
[0-9]+	{ yylval = atoi(yytext); return NUMBER; }
\n 	{ return EOL; }
[ \t]+ 	{}
.+ 	{printf("Cadena desconocida: %s \n",yytext);}

%%

int main(){

    int tok;

    yyin = fopen("entrada.txt","r");

    while(tok = yylex()) {

        printf("El numero de token es: %d \n", tok);
        if(tok == NUMBER){
        printf("Al tratarse de un numero su valor entero asociado es: %d \n",yylval);
        }

   }

   return 0;

 }
