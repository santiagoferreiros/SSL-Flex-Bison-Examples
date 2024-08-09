/* Reconocedor de Tokens */

/* Inicio de la sección de definiciones. Aquí: */
    /* 1. Cualquier texto sangrado o encerrado entre '%{' y '%}' (estos últimos dos sin sangrar en líneas ocupadas únicamente por ellos) se copia íntegramente al archivo de salida del analizador léxico (scanner) generado (*.lex.yy.c) */
        /* De esas formas podemos poner declaraciones y definiciones de C y directivas del preprocesador */
    /* 2. Los comentarios (sólo hay de múltiples líneas) sin sangría también se copian tal cual al archivo de salida del analizador léxico (scanner) generado (*.lex.yy.c) */

%{

#include <stdio.h>
#include <stdlib.h>

#define archivo_yyin "entrada.txt"

enum yytokentype
{
	NUMBER = 258
};

int yylval;

#define INICIO_CONTEO_LINEA 1
#define INICIO_CONTEO_COLUMNA 1

int linea_actual = INICIO_CONTEO_LINEA, columna_actual = INICIO_CONTEO_COLUMNA;

%}

    /* La siguiente línea define explícitamente a yytext como un puntero a un caracter ( char* yytext; ). Ésta es la opción por defecto si no se pone nada. */
%pointer
    /* Con la siguiente opción la función de análisis int yylex(void); se comporta como si en la sección de usuario existiera la función int yywrap(void) return 1; la cual devuelve verdadero (no-cero), haciendo que una vez que la función de análisis int yylex(void) reciba una indicación de EOF desde YY_INPUT, asuma que no hay nada más para analizar de yyin y finalice (haciendo un return 0;) */
%option noyywrap

    /* Condiciones de arranque inclusivas */
/* %s */
    /* Condiciones de arranque exclusivas */
%x tokenNoReconocido

    /* Declaraciones con cada nombre y su definición; se utilizan para simplificar las reglas */
digito [0-9]

/* Fin de la sección de definiciones */

/* Inicio de la sección de reglas. Aquí: */
    /* 1. Cualquier texto sangrado o encerrado entre '%{' y '%}' (estos últimos dos sin sangrar en líneas ocupadas únicamente por ellos) se copia íntegramente al archivo de salida del analizador léxico (scanner) generado (*.lex.yy.c) */
        /* Esto podría utilizarse para declarar variables que son locales a la rutina de análisis léxico y (después de las declaraciones) al código que debe ejecutarse siempre que se entra a la rutina de análisis léxico */
    /* 2. NO pueden hacerse comentarios sin sangría, ya que estos no se copian literalmente al archivo de salida del analizador léxico (scanner) generado (*.lex.yy.c) */
%%

{digito}+ { 
		printf("%s:%d:%d: Reconocido: numero: %s \n", archivo_yyin, linea_actual, columna_actual, yytext); 
		columna_actual += yyleng;
		yylval = (int) strtoul(yytext, NULL, 0);
		return NUMBER;
	}

"+"	{ printf("%s:%d:%d: Reconocido: caracter de puntuacion/operador de C: %s \n", archivo_yyin, linea_actual, columna_actual, yytext); columna_actual += yyleng; return '+'; }

"-" { printf("%s:%d:%d: Reconocido: caracter de puntuacion/operador de C: %s \n", archivo_yyin, linea_actual, columna_actual, yytext); columna_actual += yyleng; return '-'; }

"*" { printf("%s:%d:%d: Reconocido: caracter de puntuacion/operador de C: %s \n", archivo_yyin, linea_actual, columna_actual, yytext); columna_actual += yyleng; return '*'; }

"/" { printf("%s:%d:%d: Reconocido: caracter de puntuacion/operador de C: %s \n", archivo_yyin, linea_actual, columna_actual, yytext); columna_actual += yyleng; return '/'; }

[ \t]+ { columna_actual += yyleng; }

\n+ { linea_actual += yyleng; columna_actual = INICIO_CONTEO_COLUMNA; }

[^ \t\n] { fprintf(stderr, "%s:%d:%d: Error lexico: token no reconocido: %s", archivo_yyin, linea_actual, columna_actual, yytext); columna_actual += yyleng; BEGIN(tokenNoReconocido); }
<tokenNoReconocido>{
    <<EOF>> {
        fprintf(stderr, "\n");
        BEGIN(INITIAL);
    }
    " "|\t|\n {
        yyless(0);
        fprintf(stderr, "\n");
        BEGIN(INITIAL);
    }
    [^ \t\n]+ {
        columna_actual += yyleng;
        fprintf(stderr, "%s\n", yytext);
        BEGIN(INITIAL);
    }
}

<<EOF>> { printf("%s:%d:%d: EOF alcanzado \n", archivo_yyin, linea_actual, columna_actual); yyterminate(); }

    /* Reglas por defecto de Flex: */
        /* <*>.|\n { ECHO; } */
            /* (ECHO; escribe yytext en la salida del escáner: FILE* yyout (variable global a la cual por defecto se le asigna stdout)) */
        /* <<EOF>> { yyterminate(); } */
            /* (yyterminate(); hace que la función yylex finalice retornando un 0, indicando un fin-de-entrada (EOF)) */

%%
/* Fin de la sección de reglas */ 

/* Inicio de la sección de código de usuario, la cual: */
	/* 1. Se utiliza para rutinas de complemento que llaman al analizador léxico o son llamadas por este; la presencia de esta sección es opcional */
    /* 2. Toda esta sección simplemente se copia íntegramente al archivo de salida del analizador léxico (scanner) generado (*.lex.yy.c) */

int main(void)
{
    int yychar;

    yyin = fopen(archivo_yyin, "r");

    while(yychar = yylex())
	{
		printf(" El valor del tipo de token es: %d\n", yychar);
		if(yychar == NUMBER)
		{
			printf(" Al tratarse de un numero su valor asociado es: %d\n", yylval);
		}
	}

	printf("Presione ENTER para continuar...\n");
	getchar();

	return 0;
}

/* Fin de la sección de código de usuario */