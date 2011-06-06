TARGET	= libecma.a
OBJS	= ecmayacc.o ecmalex.o
TMPS	= ecmayacc.h

LFLAGS	=
YFLAGS	= -d
CFLAGS	=
ARFLAGS	= -rsv
LIBS	=

# ================================================================== #
.SUFFIXES: .o .cc .c .y .l

.y.c :
	$(YACC.y) $< -o $@
.l.c :
	$(LEX.l) $< > $@
.c.o :
	$(COMPILE.c) -c $< -o $@
.cc.o :
	$(COMPILE.cc) -c $< -o $@

$(TARGET) : $(OBJS)
	$(AR) $(ARFLAGS) $@ $^ $(LIBS)

clean :
	- $(RM) $(OBJS) $(TMPS)
