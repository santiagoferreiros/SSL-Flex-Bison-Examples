#define YYLTYPE Ubicacion

typedef struct Ubicacion
{
  unsigned int first_line;
  unsigned int first_column;
  unsigned int last_line;
  unsigned int last_column;
} Ubicacion;

#define INICIO_CONTEO_LINEA 1
#define INICIO_CONTEO_COLUMNA 1

void pausa(void);
void inicializarUbicacion(void);
void reinicializarUbicacion(void);