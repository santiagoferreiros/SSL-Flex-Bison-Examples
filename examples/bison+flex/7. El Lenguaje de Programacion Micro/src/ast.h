#include "general.h"

struct Expresion_Nodo_AST;
struct Primaria_Nodo_AST;

struct Expresion_Nodo_AST {
        enum {
                EXPRESION_PRIMARIA,
                EXPRESION_SUMA,
                EXPRESION_RESTA
        } produccion;
        struct {
                struct Expresion_Nodo_AST *expresion;
                struct Primaria_Nodo_AST *primaria;
        } valor_semantico;
} expresion_nodo_ast;

struct Primaria_Nodo_AST {
        enum {
                PRIMARIA_IDENTIFICADOR,
                PRIMARIA_CONSTANTE,
                PRIMARIA_EXPRESION
        } produccion;
        union {
                char identificador[MAX_ID_LENGTH + 1];
                int constante;
                struct Expresion_Nodo_AST expresion;
        } valor_semantico;
} primaria_nodo_ast;