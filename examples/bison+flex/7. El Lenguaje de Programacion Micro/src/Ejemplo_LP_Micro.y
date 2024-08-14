/* Lenguaje de Programación Micro */

/* Inicio de la seccion de prólogo (declaraciones y definiciones de C y directivas del preprocesador) */
%{

#include "bibliotecas.h"
#include "ast.h"

	/* Declaración de la funcion yylex del analizador léxico, necesaria para que la funcion yyparse del analizador sintáctico pueda invocarla cada vez que solicite un nuevo token */
extern YY_DECL;
	/* Declaracion de la función yyerror para reportar errores, necesaria para que la función yyparse del analizador sintáctico pueda invocarla para reportar un error */
void yyerror(const char*);

        /* Define la macro _YYRECOVERING (para un uso interno que está más adelante), la cual simplemente devuelve el resultado de evaluar la expresión YYRECOVERING() */
#define _YYRECOVERING YYRECOVERING()
        /* La función YYRECOVERING() retorna 1 cuando la función yyparse del analizador sintáctico se está recuperando de un error sintáctico, y 0 en caso contrario */

extern FILE* yyin;
extern int depurar_reducciones_bison;
extern int cantidadErroresLexicos;
int cantidadErroresSemanticos = 0;
%}
/* Fin de la sección de prólogo (declaraciones y definiciones de C y directivas del preprocesador) */

/* Inicio de la sección de declaraciones de Bison */

	/* Para requerir una versión mínima de Bison para procesar la gramática */
/* %require "2.4.1" */

	/* Para requirle a Bison que describa más detalladamente los mensajes de error al invocar a yyerror */
%error-verbose
	/* Nota: esta directiva (escrita de esta manera) quedó obsoleta a partir de Bison v3.0, siendo reemplazada por la directiva `%define parse.error verbose`. Si hay un warning que molesta se puede hacer dicho cambio, sólo hay que tener en cuenta que dicha nueva directiva no funciona en versiones anteriores de Bison */
                /* Si hay un warning que molesta, se puede hacer dicho cambio, sólo hay que tener en cuenta que dicha nueva directiva no funciona en versiones anteriores de Bison */

        /* Para especificar de a uno en uno los argumentos adicionales que deben ser pasados como parámetros hacia la función yylex del analizador léxico cuando es invocada por la función yyparse del analizador sintáctico */
                /* Esta directiva tiene una restricción sintáctica: "El último identificador en cada declaración del argumento debe ser el nombre de dicho argumento". Es por eso que tuvimos que definir la macro _YYRECOVERING en primer lugar al no poder poner la expresión directamente aquí */
                        /* Otro modo de hacer todo esto era definir la lista de argumentos utilizando la directiva de preprocesador `#define YYLEX_PARAM <argument_list>` en la sección de prólogo (declaraciones y definiciones de C y directivas del preprocesador), pero quedó en desuso a partir de Bison v3.0 */
%lex-param {int _YYRECOVERING}

	/* Para activar el seguimiento de las ubicaciones de los tokens (número de linea, número de columna) */
%locations

	/* Para especificar la colección completa de posibles tipos de datos para los valores semánticos */
%union {
	int int_type;
        char char_array_type[MAX_ID_LENGTH + 1];

        struct Expresion_Nodo_AST expresion_nodo_ast;
        struct Primaria_Nodo_AST primaria_nodo_ast;
}

	/* */
		/* Constantes */
%token <int_type> CONSTANTE
		/* Palabras reservadas */
%token INICIO_TOKEN "inicio" FIN_TOKEN "fin"
%token LEER_TOKEN "leer" ESCRIBIR_TOKEN "escribir"
		/* Identificadores */
%token <char_array_type> IDENTIFICADOR
		/* Caracteres de puntuación/operadores de más de un caracter de longitud */
%token ASIGNACION_TOKEN ":="

        /* */
%type <int_type> programa
%type <int_type> listaSentencias
%type <int_type> sentencia
%type <int_type> listaIdentificadores
%type <int_type> listaExpresiones
%type <expresion_nodo_ast> expresion
%type <primaria_nodo_ast> primaria

%left '+' '-'

	/* Para especificar el no-terminal de inicio de la gramática (el axioma). Si esto se omitiera, se asumiría que es el no-terminal de la primera regla */
%start programa

/* Fin de la sección de declaraciones de Bison */

/* Inicio de la sección de reglas gramaticales */
%%

programa
        : "inicio" listaSentencias "fin"
                {
                        if(depurar_reducciones_bison) printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: programa -> \"inicio\" listaSentencias \"fin\" \n", @1.first_line, @1.first_column, @3.last_line, @3.last_column);
                }
        ;

listaSentencias
        : sentencia
                {
                        if(depurar_reducciones_bison) printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: listaSentencias -> sentencia \n", @1.first_line, @1.first_column, @1.last_line, @1.last_column);
                }
        | listaSentencias sentencia
                {
                        if(depurar_reducciones_bison) printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: listaSentencias -> listaSentencias sentencia \n", @1.first_line, @1.first_column, @2.last_line, @2.last_column);
                }
        ;

sentencia
        : IDENTIFICADOR ":=" expresion ';'
                {
                        if(depurar_reducciones_bison) printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: sentencia -> IDENTIFICADOR \":=\" expresion ';' \n", @1.first_line, @1.first_column, @4.last_line, @4.last_column);
                }
        | "leer" '(' listaIdentificadores ')' ';'
                {
                        if(depurar_reducciones_bison) printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: sentencia -> \"leer\" '(' listaIdentificadores ')' ';' \n", @1.first_line, @1.first_column, @5.last_line, @5.last_column);
                }
        | "escribir" '(' listaExpresiones ')' ';'
                {
                        if(depurar_reducciones_bison) printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: sentencia -> \"escribir\" '(' listaExpresiones ')' ';' \n", @1.first_line, @1.first_column, @5.last_line, @5.last_column);
                }
        ;

listaIdentificadores
        : IDENTIFICADOR
                {
                        if(depurar_reducciones_bison) printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: listaIdentificadores -> IDENTIFICADOR \n", @1.first_line, @1.first_column, @1.last_line, @1.last_column);
                }
        | listaIdentificadores ',' IDENTIFICADOR
                {
                        if(depurar_reducciones_bison) printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: listaIdentificadores -> listaIdentificadores ',' IDENTIFICADOR \n", @1.first_line, @1.first_column, @3.last_line, @3.last_column);
                }
        ;

listaExpresiones
        : expresion
                {
                        if(depurar_reducciones_bison) printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: listaExpresiones -> expresion \n", @1.first_line, @1.first_column, @1.last_line, @1.last_column);
                }
        | listaExpresiones ',' expresion
                {
                        if(depurar_reducciones_bison) printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: listaExpresiones -> listaExpresiones ',' expresion \n", @1.first_line, @1.first_column, @3.last_line, @3.last_column);
                }
        ;

expresion
        : primaria
                {
                        if(depurar_reducciones_bison) printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: expresion -> primaria \n", @1.first_line, @1.first_column, @1.last_line, @1.last_column);
                        switch($1.produccion)
                        {
                                case PRIMARIA_IDENTIFICADOR:
                                        printf("produccion: PRIMARIA_IDENTIFICADOR | Identificador: %s\n", $1.valor_semantico.identificador);
                                break;
                                case PRIMARIA_CONSTANTE:
                                        printf("produccion: PRIMARIA_CONSTANTE | Constante: %d\n", $1.valor_semantico.constante);
                                break;
                                case PRIMARIA_EXPRESION:
                                        printf("produccion: PRIMARIA_EXPRESION | Expresion: \n");
                                break;
                                default:
                                        printf("produccion incorrecto\n");
                                break;
                        }
                }
        | expresion '+' primaria
                {
                        if(depurar_reducciones_bison) printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: expresion -> expresion '+' primaria \n", @1.first_line, @1.first_column, @3.last_line, @3.last_column);
                        switch($3.produccion)
                        {
                                case PRIMARIA_IDENTIFICADOR:
                                        printf("produccion: PRIMARIA_IDENTIFICADOR | Identificador: %s\n", $3.valor_semantico.identificador);
                                break;
                                case PRIMARIA_CONSTANTE:
                                        printf("produccion: PRIMARIA_CONSTANTE | Constante: %d\n", $3.valor_semantico.constante);
                                break;
                                case PRIMARIA_EXPRESION:
                                        printf("produccion: PRIMARIA_EXPRESION | Expresion: \n");
                                break;
                                default:
                                        printf("produccion incorrecto\n");
                                break;
                        }
                }
        | expresion '-' primaria
                {
                        if(depurar_reducciones_bison) printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: expresion -> expresion '-' primaria \n", @1.first_line, @1.first_column, @3.last_line, @3.last_column);
                        switch($3.produccion)
                        {
                                case PRIMARIA_IDENTIFICADOR:
                                        printf("produccion: PRIMARIA_IDENTIFICADOR | Identificador: %s\n", $3.valor_semantico.identificador);
                                break;
                                case PRIMARIA_CONSTANTE:
                                        printf("produccion: PRIMARIA_CONSTANTE | Constante: %d\n", $3.valor_semantico.constante);
                                break;
                                case PRIMARIA_EXPRESION:
                                        printf("produccion: PRIMARIA_EXPRESION | Expresion: \n");
                                break;
                                default:
                                        printf("produccion incorrecto\n");
                                break;
                        }
                }
        ;

primaria
        : IDENTIFICADOR
                {
                        if(depurar_reducciones_bison) printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: primaria -> IDENTIFICADOR \n", @1.first_line, @1.first_column, @1.last_line, @1.last_column);
                        yylval.primaria_nodo_ast.produccion = PRIMARIA_IDENTIFICADOR;
                        strncpy(yylval.primaria_nodo_ast.valor_semantico.identificador, $1, MAX_ID_LENGTH);
                        //yylval.primaria_nodo_ast.valor_semantico.identificador = $1;
                        $$ = yylval.primaria_nodo_ast;
                }
        | CONSTANTE
                {
                        if(depurar_reducciones_bison) printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: primaria -> CONSTANTE \n", @1.first_line, @1.first_column, @1.last_line, @1.last_column);
                        yylval.primaria_nodo_ast.produccion = PRIMARIA_CONSTANTE;
                        yylval.primaria_nodo_ast.valor_semantico.constante = $1;
                        $$ = yylval.primaria_nodo_ast;
                }
        | '(' expresion ')'
                {
                        if(depurar_reducciones_bison) printf("Bison: %d:%d-%d:%d: Reduciendo por la regla: primaria -> '(' expresion ')' \n", @1.first_line, @1.first_column, @3.last_line, @3.last_column);
                        yylval.primaria_nodo_ast.produccion = PRIMARIA_EXPRESION;
                        $$ = yylval.primaria_nodo_ast;
                }
        ;

%%
/* Fin de la sección de reglas gramaticales */

/* Inicio de la sección de epílogo (código de usuario) */

int main(void)
{
        // inicializar_tabla_de_simbolos();

        yyin = fopen(archivo_yyin, "r"); if(yyin == NULL) { fprintf(stderr, "Error al intentar abrir el archivo de entrada"); exit(1); }

        inicializarUbicacion();

        #if YYDEBUG
                yydebug = 1;
        #endif

        switch(yyparse())
	{
		case 0: case 1:
			if(!cantidadErroresLexicos)
			{
                                printf("\nEl texto del archivo \"%s\" SI es lexicamente correcto \n", archivo_yyin);
				if(!yynerrs)
				{
					printf("\nEl texto del archivo \"%s\" SI es sintacticamente correcto \n", archivo_yyin);
					if(! cantidadErroresSemanticos)
					{
						printf("\nEl texto del archivo \"%s\" SI es semanticamente correcto \n", archivo_yyin);
					}
					else
					{
						printf("\nEl texto del archivo \"%s\" NO es semanticamente correcto: se han detectado %d error(es) semantico(s) \n", archivo_yyin, cantidadErroresSemanticos);
					}
				}
				else
				{
					printf("\nEl texto del archivo \"%s\" NO es sintacticamente correcto: se han detectado %d error(es) sintactico(s) \n", archivo_yyin, yynerrs);
				}
			}
			else
			{
				printf("\nEl texto del archivo \"%s\" NO es lexicamente correcto: se han detectado %d error(es) lexicos(s) \n", archivo_yyin, cantidadErroresLexicos);
			}
		break;
		case 2:
			printf("\nError de programa: Hubo un fallo en el analisis sintactico ocasionado por el agotamiento de la memoria dinamica \n");
		break;
	}

        fclose(yyin);

        pausa();
        return 0;
}

        /* Definición de la funcion yyerror para reportar errores, necesaria para que la funcion yyparse del analizador sintáctico pueda invocarla para reportar un error */
void yyerror(const char* literalCadena)
{
        fprintf(stderr, "Bison: %d:%d: %s\n", yylloc.first_line, yylloc.first_column, literalCadena);
}

/* Fin de la sección de epílogo (código de usuario) */