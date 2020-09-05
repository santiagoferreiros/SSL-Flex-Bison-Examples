%{

#include <stdio.h>
#include <stdlib.h> // para el itoa y el malloc
#include "funcionesDeLista.h"

Lista listaIdentificador = NULL,lista = NULL;

int flag_error = 0, flag_SentDeclaraciones = 0, flag_SentCompuesta = 0, flag_SentIteracion = 0, flag_SentExpresion = 0, flag_SentControl = 0, flag_funciones = 0;
int cantidad = 0, posicion = 0, band1 = 0, band2 = 0;
int band3 = 0;
char buffer[20];

extern FILE *yyin;

%}

%union {
char cadena[30];
char caracter;
int entero;
}

%token <entero> NUM
%token <cadena> TIPODATO
%token <cadena> IDENTIFICADOR
%token <cadena> SENTENCIADECONTROL
%token <cadena> SENTENCIADEITERACION
%token <cadena> RETURN
%token <caracter> CCARACTER
%token <cadena> LITERALESCADENA

%type <cadena> identificadoryAsignacion

%%




input:    /* vac�o */
        | input line
;
line:     '\n'                                    { printf ("\n"); }
        | expresion '\n'                          { printf ("\n----------------------------------------------------------------------------------\n"); }
        | sentencia '\n'                          { printf ("\n----------------------------------------------------------------------------------\n"); }
        | declaracionyDefinicionDeFunciones '\n'  { printf ("\n----------------------------------------------------------------------------------\n"); }
;




//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   EXPRESIONES  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


expresion :   expUnaria operador expresion
            | expUnaria
            | error                            { printf("Error el declarar la expresion\n"); }
;
operador :    '=' | '+' '=' | '-' '=' | '*' '=' | '/' '=' | '%' '='  // operadores asignacion
            | '|' '|' | '&' '&' | '=' '=' | '!' '='                  // operadores logicos
            | '<' | '>' | '<' '=' | '>' '='                          // operadores relacionales
            | '+' | '-'                                              // operadores aditivos
            | '*' | '/' | '%'                                        // operadores multiplicativos
;
expUnaria :   expPostfijo
            | operUnario expUnaria
            | incremento expUnaria
            | expUnaria incremento
;
incremento :  '+' '+' | '-' '-';                  // operadores de incremento y decremento
operUnario :  '&' | '*' | '!' ;                   // operadores unarios

expPostfijo :     expPrimaria
                | expPostfijo '[' expresion ']'
                | expPostfijo '(' listaDeArgumentos ')'
;
listaDeArgumentos :   expresion
                    | listaDeArgumentos ',' expresion
                    | /* vac�o */
;
expPrimaria :     IDENTIFICADOR
                | NUM                                   // { printf("numero %d \n",$1)}
                | '(' expresion ')'
                | CCARACTER                             // { printf("caracter %c \n",$1)}
                | LITERALESCADENA                          { /*printf("palabra %s \n",$1);*/ band2=1; insertarNodoALista(&lista,$1);}
              //| otros tipos de datos
;




//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   SENTENCIAS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


sentencia:    sentCompuesta         { if(flag_SentCompuesta==0){     printf("Se declaro una sentencia compuesta correctamente.\n\n");      }     flag_SentCompuesta=0; } // multiles expresiones
            | sentExpresion         { if(flag_SentExpresion==0){     printf("Se declaro una sentencia de expresion correctamente.\n\n");   }     flag_SentExpresion=0; }// a = c + b;
            | sentSeleccion         { if(flag_SentControl==0){       printf("Se declaro una sentencia condicional correctamente.\n\n");    }     if(flag_SentControl==1){printf("Error al declarar la sentencia de control\n");} flag_SentControl = 0; }// condiciones
            | sentIteracion         { if(flag_SentIteracion==0){     printf("Se declaro una sentencia repetitiva correctamente.\n\n");     }     flag_SentIteracion=0; }// bucles
            | sentenciaDeclaracion  { if(flag_SentDeclaraciones==0){ printf("Se declaro una sentencia de declaracion correctamente.\n\n"); }     flag_SentDeclaraciones=0; }
            | RETURN expOP ';'      { if(flag_error==0){             printf("Se declaro una sentencia de salto.\n\n");                     }     flag_error=0; }
;


         

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   SENTENCIAS COMPUESTAS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


sentCompuesta : '{' listaSentencias '}'         { if(flag_SentCompuesta == 0){printf("Se detecto una sentencia compuesta\n");} if(flag_SentCompuesta == 1){printf("No se puedo definir una sentencia compuesta correctamente\n");} }
;
listaSentencias :     listaSentencias sentencia
                    | sentencia             
                    | /* vac�o */
                    | error                     { printf("Error al definir una sentencia\n"); flag_SentCompuesta = 1; }
;




//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   SENTENCIAS COMPUESTAS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


sentExpresion :   expresion ';' // a=6+7;
                | error ';'             { printf("Error al definir una sentencia de expresion\n"); flag_SentExpresion = 1; }
;




//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  SENTENCIA CONTROL IF ELSE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


sentSeleccion :   SENTENCIADECONTROL '(' expresion ')' sentCompuesta then1      { if(flag_SentControl == 1){printf("Error al declarar la sentencia de control\n");} }// if(expresion) {sentencia}  // switch(expresion){sentencia}
                | SENTENCIADECONTROL '(' error ')' sentCompuesta then1          { printf("Declaracion incorrecta del condicional de la sentencia \"%s\"\n", $1);                        flag_SentControl = 1; }
                | SENTENCIADECONTROL '(' expresion ')' '{' error '}' then1      { printf("No se definio correctamente las acciones para la sentencia \"%s\"\n", $1);                    flag_SentControl = 1; }
                | SENTENCIADECONTROL '(' ')' sentCompuesta then1                { printf("No se definio correctamente una expresion condicional para la sentencia \"%s\"\n", $1);       flag_SentControl = 1; }
;
then1 :   SENTENCIADECONTROL sentCompuesta   //  else {sentencia}
        | sentSeleccion                      // if(expresion){sentencia}
        | error sentCompuesta                                                   { flag_SentControl=1; }
        | SENTENCIADECONTROL '{' error '}'                                      { printf("No se definio correctamente las acciones para la sentencia \"%s\"\n", $1); flag_SentControl=1; }
        | /* vac�o */
;




//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  SENTENCIA BUCLES  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


sentIteracion : SENTENCIADEITERACION then2
;
then2 :   '(' expresion ')' sentCompuesta                               { if(flag_SentIteracion == 0){printf("Se declaro correctamente una sentencia \"while\"\n");} }//while(expresion) {sentencia}
        | sentCompuesta SENTENCIADEITERACION '(' expresion ')' ';'      { if(flag_SentIteracion == 0){printf("Se declaro correctamente una sentencia \"do while\"\n");} }//do {sentencia} while(expresion);
        | '(' expOrDeclaracion ';' expOP ';' expOP ')' sentCompuesta    { if(flag_SentIteracion == 0){printf("Se declaro correctamente una sentencia \"for\"\n");} }//for(expOP; expOP; expOP){sentencia}
        | error                                                         { printf("Error al declarar la sentencia repetitiva\n"); flag_SentIteracion = 1; }
;
expOrDeclaracion:     TIPODATO IDENTIFICADOR '=' expresion              { if(flag_SentIteracion == 0) { ingresarSinRepetir(&listaIdentificador, $2, 1); } }
                    | expOP
                    | error  IDENTIFICADOR '=' expresion                { printf("No se reconocio el \"tipo de dato\" para el \"identificador\" \"%s\"\n", $2); flag_SentIteracion = 1; }
                    | TIPODATO error '=' expresion                      { printf("No se reconocio el \"identificador\" para el \"tipo de dato\" \"%s\"\n", $1); flag_SentIteracion = 1; }
               //     | error                                           { printf("Error al declarar un parametro \n");  flag_SentIteracion=1;}
;
expOP :   expresion
        | /* vac�o */
;




//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   SENTENCIA DECLARACION DE DATOS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


sentenciaDeclaracion :        TIPODATO listaDeIdentificadores finalizador           { if(flag_SentDeclaraciones == 0){ printf("Declaracion(es) del tipo \"%s\"\n",$1); } flag_SentDeclaraciones=0; totalDeIdentificadores(&listaIdentificador); band1=0;band2=0; }
                            | error listaDeIdentificadores  ';'                     { printf("Falta tipo de dato\n"); flag_SentDeclaraciones = 1; }
;
listaDeIdentificadores :  identificadoryAsignacion
                        | listaDeIdentificadores ',' identificadoryAsignacion
;
identificadoryAsignacion:     IDENTIFICADOR opcional                                { if(flag_SentDeclaraciones == 0) { ingresarSinRepetir(&listaIdentificador, $1, 1); } } //{ if( flag_SentDeclaraciones==0 ){ printf("\tSe ha ha declaro la variable \"%s\" \n", $1); } }
                            | IDENTIFICADOR opcional '=' valor                      { if(flag_SentDeclaraciones == 0) { ingresarSinRepetir(&listaIdentificador, $1, 1); } } //{ if( flag_SentDeclaraciones==0 ){ printf("inicializado a la variable \"%s\" \n", $1); } }
                            | error '=' valor                                       { printf("No se declaro correctamente el identificador\n"); flag_SentDeclaraciones = 1; }
                            | IDENTIFICADOR error valor                             { printf("falta signo de asignacion\n"); flag_SentDeclaraciones=1; }
;
opcional :    '[' ']'
            | '[' NUM ']'                                                           { if(flag_SentDeclaraciones == 0) { band1 =1; itoa($2,buffer,10); insertarNodoALista(&lista,buffer); } }
            | '[' error ']'                                                         { printf("Dentro de los corchetes solo se permiten numeros enteros\n"); flag_SentDeclaraciones = 1; }
            | /* VACIO */
;
valor:    expresion
       // | error                                                                   { printf("Valor/expresion no reconocida\n"); flag_SentDeclaraciones=1;}
;
finalizador: ';'                                                                    { if(flag_SentDeclaraciones == 0) if(band1 && band2) verificarSiPuede(&lista); }
            | error                                                                 { printf("Falta punto y coma de cierre\n"); flag_SentDeclaraciones = 1; }
;




//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  DECLARACION Y DEFINICION DE FUNCIONES  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


declaracionyDefinicionDeFunciones :   TIPODATO IDENTIFICADOR parametros cuerpo  { if(flag_funciones == 0 && band3 == 1){printf("Se declaro la funcion \"%s\".\n", $2); band3 = 0;}  
                                                                                  if(flag_funciones == 0 && band3 == 2){printf("Se definio la funcion \"%s\".\n", $2); band3 = 0;} 
                                                                                  if(flag_funciones == 1){printf("No se puedo definir/declarar la funcion\n");}   flag_funciones = 0; }
                                    | error IDENTIFICADOR parametros cuerpo     { printf("Error, no se definio correctamente el tipo de dato de la funcion\n");  }
                                    | TIPODATO error parametros cuerpo          { printf("Error, no se definio correctamente el identificador de la funcion\n"); }
;
parametros : '(' listaDeParametros ')'
            | '(' ')'
;
listaDeParametros :   parametro
                    | listaDeParametros ',' parametro
;
parametro :   TIPODATO                  { printf("Se detecto un parametro de tipo \"%s\"\n", $1); }
            | TIPODATO IDENTIFICADOR    { printf("Se detecto el parametro \"%s\" de tipo \"%s\"\n", $2, $1); }
            | error  IDENTIFICADOR      { if(flag_funciones == 0){printf("No se reconocio el Tipo de dato para el identificador \"%s\"\n", $2);} flag_funciones = 1; }
            | TIPODATO error            { if(flag_funciones == 0){printf("No se reconocio el identificador del parametro para el tipo de dato \"%s\"\n", $1);} flag_funciones = 1; }
;
cuerpo :  ';'                           { band3=1; }
        | sentCompuesta                 { if(flag_SentCompuesta == 1){ flag_funciones = 1; } band3 = 2; }
        | '{' error '}'                 { printf("Error al declarar la sentencia compuesta\n"); flag_funciones = 1; }
        | error                         { printf("No se pudo definir/declarar la funcion\n"); flag_funciones = 1; }
;


%%

int main(){
    yyin = fopen("archivo.txt", "r");
    yyparse();
}
