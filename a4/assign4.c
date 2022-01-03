#include <stdio.h>
#include <stdlib.h>

#define FALSE 0

#define TRUE 1


struct coord {

int x, y;

};


struct size {

int width, length;

};


struct pyramid {

struct coord center;

struct size base;

int height;

int volume;

};



struct pyramid newPyramid(int width, int length, int height)

{

struct pyramid p;


p.center.x = 0;

p.center.y = 0;

p.base.width = width;

p.base.length = length;

p.height = height;

p.volume = (p.base.width * p.base.length * p.height) / 3;


return p;

}


void relocate(struct pyramid *p, int deltaX, int deltaY)

{

p->center.x += deltaX;

p->center.y += deltaY;

}


void expand(struct pyramid *p, int factor)

{

p->base.width *= factor;

p->base.length *= factor;

p->height *= factor;

p->volume = (p->base.width * p->base.length * p->height) / 3;

}


void printPyramid(char *name, struct pyramid *p)

{

printf("Pyramid %s\n", name);

printf("\tCenter = (%d, %d)\n", p->center.x, p->center.y);

printf("\tBase width = %d Base length = %d\n", p->base.width, p->base.length);

printf("\tHeight = %d\n", p->height);

printf("\tVolume = %d\n\n", p->volume);

}








int equalSize(struct pyramid *p1, struct pyramid *p2)

{

int result = FALSE;


if (p1->base.width == p2->base.width) {

if (p1->base.length == p2->base.length) {

if (p1->height == p2->height) {

result = TRUE;

}

}

}


return result;

}


int main()

{

struct pyramid khafre, cheops;

khafre = newPyramid(10, 10, 9);

cheops = newPyramid(15, 15, 18);


printf("Initial pyramid values:\n");

printPyramid("khafre", &khafre);

printPyramid("cheops", &cheops);


if (!equalSize(&khafre, &cheops)) {

expand(&cheops, 9);

relocate(&cheops, 27, -10);

relocate(&khafre, -23, 17);

}


printf("\nNew pyramid values:\n");

printPyramid("khafre", &khafre);

printPyramid("cheops", &cheops);

}
