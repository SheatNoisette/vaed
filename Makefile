all: prod

prod:
	v -prod -skip-unused -gc none -o vaed.c .
	gcc -Os -o vaed vaed.c
	strip vaed

debug:
	v -skip-unused -gc none -o vaed.c .
	gcc -g3 -O0  -fsanitize=address -o vaed vaed.c

clean:
	rm -f vaed
