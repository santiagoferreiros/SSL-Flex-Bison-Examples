# Detecta el SO
UNAME:=$(shell uname)
ifeq ($(UNAME),Linux)
# Para Linux, genera un ejecutable *.out
FILE_EXT:=out
else
# Asume que el makefile se corre en Windows, por lo que genera un ejecutable *.exe
FILE_EXT:=exe
# Para Windows, las bibliotecas compatibles están en ./lib
LIBS+=-L lib
endif

# Ubicación de los *.l y *.c (excepto lex.yy.c)
SRCDIR:=src
# Ubicación de los *.h
IDIR:=src
# Ubicación de los objetos generados por Flex
ODIR:=obj

# Agregar bibliotecas necesarias acá (por ejemplo, -lm para incluir <math.h>)
# '+=' concatena con las "LIBS" anteriores (por ejemplo, se agrega el "-L lib" para Windows)
LIBS+=-lfl

# Compilador a usar
CC:=gcc
# Agrega la ruta donde se encuentran los includes
CFLAGS:=-I$(IDIR)
# Agrega los flags que se le pasan a Flex
FFLAGS+=

# wildcard me busca todos los archivos que cumplan con la condición y los concatena
SRC:= $(wildcard $(SRCDIR)/*.l)
# Ej: src/Ejemplo1.l src/Ejemplo2.l ... src/Ejemplo7.l
DEPS:= $(wildcard $(IDIR)/*.h) $(wildcard $(SRCDIR)/*.c)
# Ej: src/misfunciones.h

# $(patsubst param1, param2, param3) agarra param3 y le reemplaza una parte del string (param1) por otra (param2)
TARGETS:=$(patsubst $(SRCDIR)/%.l,%.$(FILE_EXT),$(SRC))
# Ej: src/Ejemplo1.l --> Ejemplo1.exe

# Para generar todos los objetos necesarios, se usa la sig estructura:

# 	objeto_a_generar: dependencia1 dependencia2 ... dependenciaM
# 	<tab> comando_a_ejecutar1
# 	<tab> comando_a_ejecutar2
# 	...
# 	<tab> comando_a_ejecutarN

%.$(FILE_EXT): $(SRCDIR)/%.l $(DEPS)
	@echo "=================[ Build | $@ ]================="
	@echo "<<< Generando lex.yy.c >>>"
	mkdir -p $(ODIR) && cd $(ODIR) && flex $(FFLAGS) ../$< && cd ..
	@echo "<<< lex.yy.c creado. >>>"
	@echo ""
	@echo "<<< Compilando y enlazando con libfl.a >>>"
	$(CC) $(CFLAGS) $(ODIR)/lex.yy.c $(LIBS) -o $@
	@echo "<<< $@ creado. >>>"
	@echo ""

# Para compilar todos los *.l que fueron modificados con 'make'
all: $(TARGETS)

# Para crear reglas que no generen objetos de ese mismo nombre
.PHONY: clean debug

# Para "limpiar" (eliminar) todos los objetos generados
clean:
	rm -f $(ODIR)/*
	rm -f *.$(FILE_EXT)

# Para agregar el flag de debug a Flex
debug: FFLAGS += -d
debug: $(TARGETS)