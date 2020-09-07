%{
#include <stdio.h>
#include <ctype.h>
#include <string.h>

int yylex();
int yywrap(){
	return(1);
}

void yyerror (char const *s) {
   fprintf (stderr, "%s\n", s);
}



%}

%union {

 struct yylval_struct
  {
      int tipo;
      int valor_entero;
      float valor_real;
  } mystruct;

}

%token <mystruct> NUMERO_ENTERO
%token <mystruct> NUMERO_REAL
%token <mystruct> error

%type <mystruct> expresion

%% /* A continuacion las reglas gramaticales y las acciones */

input:  /* vacio */
        | input line
;

line:   '\n'
        | expresion '\n'  {if($<mystruct>1.tipo==1){printf ("El resultado de la expresion es: %d \n", $<mystruct>1.valor_entero);}else{printf("El resultado de la expresion es: %g \n", $<mystruct>1.valor_real);} };

expresion:  NUMERO_ENTERO {$<mystruct>$.tipo=$<mystruct>1.tipo;$<mystruct>$.valor_entero=$<mystruct>1.valor_entero;}
	  		| NUMERO_REAL {$<mystruct>$.tipo=$<mystruct>1.tipo;$<mystruct>$.valor_real=$<mystruct>1.valor_real;}	
	  		| expresion '+' expresion { if($<mystruct>1.tipo==$<mystruct>3.tipo)
    
    { 
        if($<mystruct>1.tipo==1)
    
        {
            $<mystruct>$.valor_entero=$<mystruct>1.valor_entero+$<mystruct>3.valor_entero;
        }
        
        else
        
        {
            $<mystruct>$.valor_real=$<mystruct>1.valor_real+$<mystruct>3.valor_real;
        }
    }
        
    else
    
    {
        printf("Los operandos son de distinto tipo \n");
    }
        
}
	  		| expresion '-' expresion { if($<mystruct>1.tipo==$<mystruct>3.tipo)
    
    { 
        if($<mystruct>1.tipo==1)
    
        {
            $<mystruct>$.valor_entero=$<mystruct>1.valor_entero+$<mystruct>3.valor_entero;
        }
        
        else
        
        {
            $<mystruct>$.valor_real=$<mystruct>1.valor_real+$<mystruct>3.valor_real;
        }
    }
        
    else
    
    {
        printf("Los operandos son de distinto tipo \n");
    }
        
}
	  		| expresion '*' expresion { if($<mystruct>1.tipo==$<mystruct>3.tipo)
    
    { 
        if($<mystruct>1.tipo==1)
    
        {
            $<mystruct>$.valor_entero=$<mystruct>1.valor_entero+$<mystruct>3.valor_entero;
        }
        
        else
        
        {
            $<mystruct>$.valor_real=$<mystruct>1.valor_real+$<mystruct>3.valor_real;
        }
    }
        
    else
    
    {
        printf("Los operandos son de distinto tipo \n");
    }
        
}
;

%%

int main ()
{
    #ifdef BISON_DEBUG
        yydebug = 1;
#endif
  yyparse ();
}
