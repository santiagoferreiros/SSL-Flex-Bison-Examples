
/* Inicio de la sección de definiciones. Aquí: */
    /* 1. Cualquier texto sangrado o encerrado entre '%{' y '%}' (estos últimos dos sin sangrar en líneas ocupadas únicamente por ellos) se copia íntegramente al archivo de salida del analizador léxico (scanner) generado (*.lex.yy.c) */
        /* De esas formas podemos poner declaraciones y definiciones de C y directivas del preprocesador */
    /* 2. Los comentarios (sólo hay de múltiples líneas) sin sangría también se copian tal cual al archivo de salida del analizador léxico (scanner) generado (*.lex.yy.c) */

%{

#include "bibliotecas.h"
#include "ast.h"

/* Es indispensable que incluyamos el archivo de cabecera con las definiciones de YACC (*.tab.h) que se genera a partir del archivo fuente de YACC (*.y) */
#include "Ejemplo_LP_Micro.tab.h"

extern int depurar_reconocidos_flex;
int cantidadErroresLexicos = 0;
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
letra [a-zA-Z]
digito [0-9]

/* Fin de la sección de definiciones */

/* Inicio de la sección de reglas. Aquí: */
    /* 1. Cualquier texto sangrado o encerrado entre '%{' y '%}' (estos últimos dos sin sangrar en líneas ocupadas únicamente por ellos) se copia íntegramente al archivo de salida del analizador léxico (scanner) generado (*.lex.yy.c) */
        /* Esto podría utilizarse para declarar variables que son locales a la rutina de análisis léxico y (después de las declaraciones) al código que debe ejecutarse siempre que se entra a la rutina de análisis léxico */
    /* 2. NO pueden hacerse comentarios sin sangría, ya que estos no se copian literalmente al archivo de salida del analizador léxico (scanner) generado (*.lex.yy.c) */
%%
    reinicializarUbicacion();

    /* Constantes */
{digito}{digito}* {
    yylloc.last_column += yyleng;
    if(depurar_reconocidos_flex) printf("Flex: %s:%d:%d: Reconocida: constante: %s \n", archivo_yyin, yylloc.first_line, yylloc.first_column, yytext);
    yylval.int_type = (int) strtoul(yytext, NULL, 0);
    return CONSTANTE;
}

    /* Palabras reservadas */
inicio   { yylloc.last_column += yyleng; if(depurar_reconocidos_flex) printf("Flex: %s:%d:%d: Reconocida: palabra reservada: %s \n", archivo_yyin, yylloc.first_line, yylloc.first_column, yytext); return INICIO_TOKEN; }
fin      { yylloc.last_column += yyleng; if(depurar_reconocidos_flex) printf("Flex: %s:%d:%d: Reconocida: palabra reservada: %s \n", archivo_yyin, yylloc.first_line, yylloc.first_column, yytext); return FIN_TOKEN; }
leer     { yylloc.last_column += yyleng; if(depurar_reconocidos_flex) printf("Flex: %s:%d:%d: Reconocida: palabra reservada: %s \n", archivo_yyin, yylloc.first_line, yylloc.first_column, yytext); return LEER_TOKEN; }
escribir { yylloc.last_column += yyleng; if(depurar_reconocidos_flex) printf("Flex: %s:%d:%d: Reconocida: palabra reservada: %s \n", archivo_yyin, yylloc.first_line, yylloc.first_column, yytext); return ESCRIBIR_TOKEN; }

    /* Identificadores */
{letra}({letra}|{digito})* {
    yylloc.last_column += yyleng;
    if(yyleng > MAX_ID_LENGTH)
    {
        fprintf(stderr, "Flex: %d:%d: Error lexico: identificador que supera la longitud maxima de %d caracteres: %s", yylloc.first_line, yylloc.first_column, MAX_ID_LENGTH, yytext);
        cantidadErroresLexicos++;
    }
    else
    {
        if(depurar_reconocidos_flex) printf("Flex: %s:%d:%d: Reconocido: identificador: %s \n", archivo_yyin, yylloc.first_line, yylloc.first_column, yytext);
        strncpy(yylval.char_array_type, yytext, MAX_ID_LENGTH);
        return IDENTIFICADOR;
    }
}

    /* Caracteres de puntuación/operadores */
":=" { yylloc.last_column += yyleng; if(depurar_reconocidos_flex) printf("Flex: %s:%d:%d: Reconocido: asignacion: %s \n", archivo_yyin, yylloc.first_line, yylloc.first_column, yytext); return ASIGNACION_TOKEN; }

"+"  { yylloc.last_column += yyleng; if(depurar_reconocidos_flex) printf("Flex: %s:%d:%d: Reconocido: operador aditivo: %s \n", archivo_yyin, yylloc.first_line, yylloc.first_column, yytext); return '+'; }
"-"  { yylloc.last_column += yyleng; if(depurar_reconocidos_flex) printf("Flex: %s:%d:%d: Reconocido: operador aditivo: %s \n", archivo_yyin, yylloc.first_line, yylloc.first_column, yytext); return '-'; }

"("  { yylloc.last_column += yyleng; if(depurar_reconocidos_flex) printf("Flex: %s:%d:%d: Reconocido: caracter de puntuacion: %s \n", archivo_yyin, yylloc.first_line, yylloc.first_column, yytext); return '('; }
")"  { yylloc.last_column += yyleng; if(depurar_reconocidos_flex) printf("Flex: %s:%d:%d: Reconocido: caracter de puntuacion: %s \n", archivo_yyin, yylloc.first_line, yylloc.first_column, yytext); return ')'; }
,    { yylloc.last_column += yyleng; if(depurar_reconocidos_flex) printf("Flex: %s:%d:%d: Reconocido: caracter de puntuacion: %s \n", archivo_yyin, yylloc.first_line, yylloc.first_column, yytext); return ','; }
;    { yylloc.last_column += yyleng; if(depurar_reconocidos_flex) printf("Flex: %s:%d:%d: Reconocido: caracter de puntuacion: %s \n", archivo_yyin, yylloc.first_line, yylloc.first_column, yytext); return ';'; }

    /* Espacios y tabulaciones */
[ \t]+ { yylloc.first_column = yylloc.last_column += yyleng; }

    /* Saltos de línea */
\n {
        yylloc.first_line = yylloc.last_line += yyleng;
        yylloc.first_column = yylloc.last_column = INICIO_CONTEO_COLUMNA;
        if(recuperandose_de_error_sintactico) return '\n';
}

    /* Tokens no reconocidos */
[^ \t\n] { yylloc.last_column += yyleng; fprintf(stderr, "Flex: %s:%d:%d: Error lexico: token no reconocido: %s", archivo_yyin, yylloc.first_line, yylloc.first_column, yytext); BEGIN(tokenNoReconocido); cantidadErroresLexicos++; }
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
        yylloc.last_column += yyleng;
        fprintf(stderr, "%s\n", yytext);
        BEGIN(INITIAL);
    }
}

    /* EOF */
<<EOF>> { if(depurar_reconocidos_flex) printf("Flex: %s:%d:%d: EOF alcanzado \n", archivo_yyin, yylloc.first_line, yylloc.first_column); yyterminate(); }

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

/* Fin de la sección de código de usuario */