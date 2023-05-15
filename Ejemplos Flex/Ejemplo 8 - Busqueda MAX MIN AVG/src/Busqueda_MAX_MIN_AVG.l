%{
    #include <stdio.h>
    #include <math.h>
    #include <stdlib.h>

    float numero = 0, suma = 0, maximo = 0, minimo = 900000000;
    int cant = 0;
%}

%%

[1-9]+"."[0-9]*	{ 	numero = atof(yytext); 
					cant = cant + 1; 
					suma = suma + numero;
					if(numero > maximo) maximo = numero;
					if (numero < minimo) minimo = numero;
                }

[0-9]+ 	{	numero = atoi(yytext);
			cant = cant + 1;
			suma = suma + numero;
			if(numero > maximo) maximo = numero;
			if (numero < minimo) minimo = numero;
		}

.	{}

%%


int main(){
	float promedio;
	
	yyin = fopen("entrada.txt","r");
	
	yylex();

	if(cant != 0){
		promedio = suma/cant;
		printf("La suma total es: %f \n", suma);
		printf("El maximo es: %f \n", maximo);
		printf("El minimo es: %f \n", minimo);
		printf("El promedio es: %f \n", promedio);
	}

	else { printf("No hay numeros en el archivo de entrada\n");}

	printf("Presione ENTER para continuar...\n");
	getchar();
	
	return 0;
}
