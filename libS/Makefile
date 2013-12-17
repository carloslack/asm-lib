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
LFLAGS=		-L. -lS -ltest
LIBSRC= 	./libS.S  
LIBTESTSRC= 	./libtest.S  
LIBOBJS= 	./libS.o
LIBTESTOBJS= 	./libtest.o
LIB=		./libS.so
LIBTEST=	./libtest.so
LIBFLAGS=$(SFLAGS) 

all:
	make clean
	make lib
	make libtest
	make asmapi

lib:
	$(AS) $(LIBSRC) $(LIBFLAGS) -o $(LIBOBJS)
	$(LD) $(LIBOBJS) -r -o $(LIB) 

libtest:
	$(AS) $(LIBTESTSRC) $(LIBFLAGS) -o $(LIBTESTOBJS)
	$(LD) $(LIBTESTOBJS) -r -o $(LIBTEST) 

asmapi: 
	@./prototypes.sh
	$(AS) ./main.S $(SFLAGS) -o main.o
	$(LD) main.o $(LFLAGS) -o $(SEXE)
	$(CC) ./main.c $(CFLAGS) $(LFLAGS) -o $(CEXE)

clean:
	rm -rf *.o *.so $(SEXE) $(CEXE)
	@echo "Clean."
