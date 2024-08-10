
/* Inicio de la sección de definiciones. Aquí: */
    /* 1. Cualquier texto sangrado o encerrado entre '%{' y '%}' (estos últimos dos sin sangrar en líneas ocupadas únicamente por ellos) se copia íntegramente al archivo de salida del analizador léxico (scanner) generado (*.lex.yy.c) */
        /* De esas formas podemos poner declaraciones y definiciones de C y directivas del preprocesador */
    /* 2. Los comentarios (sólo hay de múltiples líneas) sin sangría también se copian tal cual al archivo de salida del analizador léxico (scanner) generado (*.lex.yy.c) */

%{
    #include <stdio.h>
    #include <stdlib.h>
	#include <math.h>

    double numero = 0, suma = 0, maximo = 0, minimo = 900000000;
    unsigned int cantidad = 0;
%}

    /* La siguiente línea define explícitamente a yytext como un puntero a un caracter ( char* yytext; ). Ésta es la opción por defecto si no se pone nada. */
%pointer
    /* Con la siguiente opción la función de análisis int yylex(void); se comporta como si en la sección de usuario existiera la función int yywrap(void) return 1; la cual devuelve verdadero (no-cero), haciendo que una vez que la función de análisis int yylex(void) reciba una indicación de EOF desde YY_INPUT, asuma que no hay nada más para analizar de yyin y finalice (haciendo un return 0;) */
%option noyywrap

    /* Condiciones de arranque inclusivas */
/* %s */
    /* Condiciones de arranque exclusivas */
/* %x */

    /* Declaraciones con cada nombre y su definición; se utilizan para simplificar las reglas */
/* digito [0-9] */

/* Fin de la sección de definiciones */

/* Inicio de la sección de reglas. Aquí: */
    /* 1. Cualquier texto sangrado o encerrado entre '%{' y '%}' (estos últimos dos sin sangrar en líneas ocupadas únicamente por ellos) se copia íntegramente al archivo de salida del analizador léxico (scanner) generado (*.lex.yy.c) */
        /* Esto podría utilizarse para declarar variables que son locales a la rutina de análisis léxico y (después de las declaraciones) al código que debe ejecutarse siempre que se entra a la rutina de análisis léxico */
    /* 2. NO pueden hacerse comentarios sin sangría, ya que estos no se copian literalmente al archivo de salida del analizador léxico (scanner) generado (*.lex.yy.c) */
%%

[1-9]+"."[0-9]*	{
		numero = strtod(yytext, NULL); 
		cantidad = cantidad + 1; 
		suma = suma + numero;
		if(numero > maximo) maximo = numero;
		if (numero < minimo) minimo = numero;
    }

[0-9]+ {
		numero = (double) strtoul(yytext, NULL, 0);
		cantidad = cantidad + 1;
		suma = suma + numero;
		if(numero > maximo) maximo = numero;
		if (numero < minimo) minimo = numero;
	}

. { /* No se hace nada */ }

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
	double promedio;
	
	yyin = fopen("entrada.txt","r");
	
	yylex();

	if(cantidad != 0)
	{
		promedio = suma/cantidad;
		printf("La suma total es: %f \n", suma);
		printf("El maximo es: %f \n", maximo);
		printf("El minimo es: %f \n", minimo);
		printf("El promedio es: %f \n", promedio);
	}
	else { printf("No hay numeros en el archivo de entrada\n"); }

	printf("Presione ENTER para continuar...\n");
	getchar();

	return 0;
}

/* Fin de la sección de código de usuario */