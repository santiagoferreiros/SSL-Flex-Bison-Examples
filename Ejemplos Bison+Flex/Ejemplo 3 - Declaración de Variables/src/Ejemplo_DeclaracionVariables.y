/* Ejemplo para detección de declaración de variables */

/* Inicio de la seccion de prólogo (declaraciones y definiciones de C y directivas del preprocesador) */
%{
#include <stdio.h>
#include <string.h>

#include "general.h"

	/* Declaración de la funcion yylex del analizador léxico, necesaria para que la funcion yyparse del analizador sintáctico pueda invocarla cada vez que solicite un nuevo token */
extern int yylex(void);
	/* Declaracion de la función yyerror para reportar errores, necesaria para que la función yyparse del analizador sintáctico pueda invocarla para reportar un error */
void yyerror(const char*);

int flag_error = 0;
int contador = 0;
char* tipo;

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
	char char_array_type[30];
	int int_type;
	float real;
}

	/* */
%token <int_type> NUM
%token <char_array_type> IDENTIFICADOR
%token CHAR_TOKEN "char" INT_TOKEN "int" FLOAT_TOKEN "float" DOUBLE_TOKEN "double"
/*%token <int_type> error*/

	/* */
%type <char_array_type> factorizacion_identificadorA
%type <int_type> expresion

	/* Para especificar el no-terminal de inicio de la gramática (el axioma). Si esto se omitiera, se asumiría que es el no-terminal de la primera regla */
%start input

/* Fin de la sección de declaraciones de bison */

/* Inicio de la sección de reglas gramaticales */
%%

input
	:    /* intencionalmente se deja el resto de esta línea vacía: es la producción nula */
	| input line
	;

line
	: '\n'
    | sentenciaDeclaracion '\n'
	;

sentenciaDeclaracion
	: especificador_de_tipo lista_identificadores ';' { if(flag_error==0){printf("Se han declarado %d variables de tipo %s \n",contador,$<char_array_type>1);contador=0;};flag_error=0;}
	| error caracterDeCorte {printf("Falta tipo de dato\n");}
	;

lista_identificadores
	: factorizacion_identificadorA
	| factorizacion_identificadorA ',' lista_identificadores
	;

factorizacion_identificadorA
	: IDENTIFICADOR {printf("Se declara el identificador %s de tipo %s \n",$<char_array_type>1,tipo);contador++;}
	| IDENTIFICADOR '=' expresion {if(flag_error==0){printf("Se declara el identificador %s de tipo %s y se le asigna el valor %d \n",$<char_array_type>1,tipo,$<int_type>3);};contador++;}
	| error {if(flag_error==0){printf("Falta identificador \n");flag_error=1;};}
	;

especificador_de_tipo
	: "char"
			{
				debug_reducciones_bison_printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: type_specifier -> \"char\" \n", @1.first_line, @1.first_column, @1.last_line, @1.last_column);
				bandera_podria_usarse_un_nombre_de_typedef = FALSE;
				$$ = crear_nodo_ast_enumeracion_type_specifier(TIPO_CHAR, @1, NULL, NULL);
			}
	| "int"
			{
				debug_reducciones_bison_printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: type_specifier -> \"int\" \n", @1.first_line, @1.first_column, @1.last_line, @1.last_column);
				bandera_podria_usarse_un_nombre_de_typedef = FALSE;
				$$ = crear_nodo_ast_enumeracion_type_specifier(TIPO_INT, @1, NULL, NULL);
			}
	| "float"
			{
				debug_reducciones_bison_printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: type_specifier -> \"float\" \n", @1.first_line, @1.first_column, @1.last_line, @1.last_column);
				bandera_podria_usarse_un_nombre_de_typedef = FALSE;
				$$ = crear_nodo_ast_enumeracion_type_specifier(TIPO_FLOAT, @1, NULL, NULL);
			}
	| "double"
			{
				debug_reducciones_bison_printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: type_specifier -> \"double\" \n", @1.first_line, @1.first_column, @1.last_line, @1.last_column);
				bandera_podria_usarse_un_nombre_de_typedef = FALSE;
				$$ = crear_nodo_ast_enumeracion_type_specifier(TIPO_DOUBLE, @1, NULL, NULL);
			}
	;

expresion
	: NUM {$<int_type>$=$<int_type>1;}
	| error {flag_error=1;printf("Valor no reconocido para asignar\n");}
	;

caracterDeCorte
	: ';'
	| '\n'
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
 
	yyparse();

	pausa();
	return 0;
}

        /* Definición de la funcion yyerror para reportar errores, necesaria para que la funcion yyparse del analizador sintáctico pueda invocarla para reportar un error */
void yyerror(const char* literalCadena)
{
        fprintf(stderr, "Bison: %d:%d: %s\n", yylloc.first_line, yylloc.first_column, literalCadena);
}

/* Fin de la sección de epílogo (código de usuario) */