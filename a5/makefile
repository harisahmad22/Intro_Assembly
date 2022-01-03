myprog: a5Main.o a5.o
	gcc a5Main.o a5.o -o myprog

a5.o:	a5.s
	as a5.s -o a5.o

a5main.o:	a5Main.c
		gcc -c a5Main.c

a5.s:	a5.asm
	m4 a5.asm > a5.s
