#
# Makefile
# 

AS= 		as
CC= 		gcc
LD= 		ld
SFLAGS= 	-statistics -fatal-warnings -size-check=error
CFLAGS=		-Wall -Werror
SEXE=		./srun
CEXE=		./crun
LFLAGS=		-L. -lS
LIBSRC= 	./libS.S  
LIBOBJS= 	./libS.o
LIB=		./libS.so
LIBFLAGS=$(SFLAGS) 

all:
	make clean
	make lib
	make asmapi

lib:
	$(AS) $(LIBSRC) $(LIBFLAGS) -o $(LIBOBJS)
	$(LD) $(LIBOBJS) -r -o $(LIB) 

asmapi: 
	$(AS) ./main.S $(SFLAGS) -o main.o
	$(LD) main.o $(LFLAGS) -o $(SEXE)
	$(CC) ./main.c $(CFLAGS) $(LFLAGS) -o $(CEXE)

clean:
	rm -rf *.o *.so $(SEXE) $(CEXE)
	@echo "Clean."
