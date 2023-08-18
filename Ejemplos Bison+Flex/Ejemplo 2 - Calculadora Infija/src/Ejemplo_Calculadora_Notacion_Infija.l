
/* Inicio de la sección de definiciones. Aquí: */
    /* 1. Cualquier texto sangrado o encerrado entre '%{' y '%}' (estos últimos dos sin sangrar en líneas ocupadas únicamente por ellos) se copia íntegramente al archivo de salida del analizador léxico (scanner) generado */
        /* De esas formas podemos poner declaraciones y definiciones de C y directivas del preprocesador */
    /* 2. Los comentarios (sólo hay de múltiples líneas) sin sangría también se copian tal cual a la salida */

%{

#include "general.h"

/* Es indispensable que incluyamos el archivo de cabecera con las definiciones de YACC (*.tab.h) que se genera a partir del archivo fuente de YACC (*.y) */
#include "Ejemplo_Calculadora_Notacion_Infija.tab.h"

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
digitoOctal [0-7]
digitoHexa [0-9a-fA-F]

/* Fin de la sección de definiciones */

/* Inicio de la sección de reglas. Aquí: */
    /* 1. Cualquier texto sangrado o encerrado entre '%{' y '%}' (estos últimos dos sin sangrar en líneas ocupadas únicamente por ellos) se copia íntegramente al archivo de salida del analizador léxico (scanner) generado */
        /* Esto podría utilizarse para declarar variables que son locales a la rutina de análisis léxico y (después de las declaraciones) al código que debe ejecutarse siempre que se entra a la rutina de análisis léxico */
    /* 2. NO pueden hacerse comentarios sin sangría, ya que estos no se copian literalmente a la salida */
%%

    /* Constantes reales sin parte exponente */
({digito}*"."{digito}+)|({digito}+".") {
    yylloc.last_column += yyleng;
    yylval.double_type = strtod(yytext, NULL); 
    return NUM;
    }

    /* Constantes enteras octales sin sufijo */
0{digitoOctal}* {
    yylloc.last_column += yyleng;
    yylval.int_type = (int) strtoul(yytext, NULL, 0);
    return ENTERO;
    }

    /* Constantes enteras hexadecimales sin sufijo */
0[xX]{digitoHexa}+ {
    yylloc.last_column += yyleng;
    yylval.int_type = (int) strtoul(yytext, NULL, 0);
    return ENTERO;
}

"+" { yylloc.last_column += yyleng; return '+'; }

"-" { yylloc.last_column += yyleng; return '-'; }

"*" { yylloc.last_column += yyleng; return '*'; }

"/" { yylloc.last_column += yyleng; return '/'; }

"^" { yylloc.last_column += yyleng; return '^'; }

"(" { yylloc.last_column += yyleng; return '('; }

")" { yylloc.last_column += yyleng; return ')'; }

[^ \t\n] { yylloc.last_column += yyleng; fprintf(stderr, "Flex: %d:%d: Error lexico: token no reconocido: %s", yylloc.first_line, yylloc.first_column, yytext); BEGIN(tokenNoReconocido); }
<tokenNoReconocido>{
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

[ \t]+ { yylloc.first_column = yylloc.last_column += yyleng; }

\n {
        yylloc.first_line = yylloc.last_line += yyleng;
        yylloc.first_column = yylloc.last_column = INICIO_CONTEO_COLUMNA;
        return '\n';
    }

%%
/* Fin de la sección de reglas */ 

/* Inicio de la sección de código de usuario, la cual: */
	/* 1. Se utiliza para rutinas de complemento que llaman al analizador léxico o son llamadas por este; la presencia de esta sección es opcional */
    /* 2. Toda esta sección simplemente se copia íntegramente al archivo de salida del analizador léxico (scanner) generado */

/* Fin de la sección de código de usuario */