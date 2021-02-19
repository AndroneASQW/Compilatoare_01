#include <stdio.h>

int circleArea100(int radius);
int mac(int a, int b, int c);
int f(int a, int b, int c);
int pnd(int n1, int n2, int p, int Multiplier);

int main(int argc, char ** argv)
{
	printf("circleArea100(3) : %d\n", circleArea100(3));
	printf("mac(-4,2,7) : %d\n", mac(-4,2,7));
	printf("f(-4,2,5) : %d\n", f(-4,2,5));
	printf("pnd(3,8,40,-3) : %d\n", pnd(3,8,40,-3));
	return 0;
}
