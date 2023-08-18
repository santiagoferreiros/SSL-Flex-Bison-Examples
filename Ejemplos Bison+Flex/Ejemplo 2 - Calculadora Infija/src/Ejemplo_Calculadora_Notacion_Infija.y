/* Calculadora de notación infija */

/* Inicio de la seccion de prólogo (declaraciones y definiciones de C y directivas del preprocesador) */
%{
#include <stdio.h>
#include <math.h>

#include "general.h"

	/* Declaración de la funcion yylex del analizador léxico, necesaria para que la funcion yyparse del analizador sintáctico pueda invocarla cada vez que solicite un nuevo token */
extern int yylex(void);
	/* Declaracion de la función yyerror para reportar errores, necesaria para que la función yyparse del analizador sintáctico pueda invocarla para reportar un error */
void yyerror(const char*);

void menu(void);
%}
/* Fin de la sección de prólogo (declaraciones y definiciones de C y directivas del preprocesador) */

/* Inicio de la sección de declaraciones de bison */

	/* Para requerir una versión mínima de Bison para procesar la gramática */
/* %require "2.4.1" */

	/* Para requirle a Bison que describa más detalladamente los mensajes de error al invocar a yyerror */
%error-verbose
	/* Nota: esta directiva (escrita de esta manera) quedó obsoleta a partir de Bison v3.0, siendo reemplazada por la directiva: %define parse.error verbose */

	/* Para activar el seguimiento de las ubicaciones de los tokens (número de linea, número de columna) */
%locations

	/* Para especificar la colección completa de posibles tipos de datos para los valores semánticos */
%union {
	int int_type;
        double double_type;
}

        /* */
%token <double_type> NUM
%token <int_type> ENTERO

        /* */
%type <double_type> exp

        /* */
%left '+' '-'
%left '*' '/'
%left '^'
%left '(' ')'

	/* Para especificar el no-terminal de inicio de la gramática (el axioma). Si esto se omitiera, se asumiría que es el no-terminal de la primera regla */
%start input

/* Fin de la sección de declaraciones de bison */

/* Inicio de la sección de reglas gramaticales */
%%
input
        : /* intencionalmente se deja el resto de esta línea vacía: es la producción nula */
        | input line
        ;

line
        : '\n'
        | exp '\n'  { printf("El resultado de la expresion es: %g \n\n", $<double_type>1); menu(); }
        | error '\n' { printf("\n"); menu(); yyerrok; }
        ;

exp
        : NUM             { $<double_type>$ = $<double_type>1; }
	| ENTERO	  { $<double_type>$ = $<int_type>1; }
        | exp '+' exp     { $<double_type>$ = $<double_type>1 + $<double_type>3; }
        | exp '-' exp     { $<double_type>$ = $<double_type>1 - $<double_type>3; }
        | exp '*' exp     { $<double_type>$ = $<double_type>1 * $<double_type>3; }
        | exp '/' exp     {
                        if($<double_type>3 == 0)
                        {
                                fprintf(stderr, "Bison: %d:%d: Error semantico: No se puede dividir por 0\n", @1.first_line, @1.first_column);
                                YYERROR;
                        }
                        else $<double_type>$ = $<double_type>1 / $<double_type>3;
                }
        | exp '^' exp   {
                        if(($<double_type>1 == 0) &&($<double_type>3 == 0))
                        {
                                fprintf(stderr, "Bison: %d:%d: Error semantico: No se puede realizar 0^0\n", @1.first_line, @1.first_column);
                                YYERROR;
                        }
                        else $<double_type>$ = pow ($<double_type>1, $<double_type>3);
                }
	| '-' exp	  { $<double_type>$ = -$<double_type>2; }
	| '(' exp ')'     { $<double_type>$ = $<double_type>2; }
        ;

%%
/* Fin de la sección de reglas gramaticales */

/* Inicio de la sección de epílogo (código de usuario) */

int main(void)
{
        inicializarUbicacion();

        #if YYDEBUG
                yydebug = 1;
        #endif

        menu();
        yyparse();

        pausa();
        return 0;
}

        /* Definición de la funcion yyerror para reportar errores, necesaria para que la funcion yyparse del analizador sintáctico pueda invocarla para reportar un error */
void yyerror(const char* literalCadena)
{
        fprintf(stderr, "Bison: %d:%d: %s\n", yylloc.first_line, yylloc.first_column, literalCadena);
}

void menu(void)
{
        printf("Ingrese una expresion aritmetica para resolver (constantes reales, octales o hexadecimales):\n");
}

/* Fin de la sección de epílogo (código de usuario) */