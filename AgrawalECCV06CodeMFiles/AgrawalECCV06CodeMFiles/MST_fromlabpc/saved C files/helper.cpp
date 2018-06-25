#include "stdafx.h"
#include <math.h>
#include "common.h"
#include "time.h"



extern unsigned long int H, W;


void printmatrix_char(char *data, int H, int W)
{
	int i,j, count;
	printf("\n");
	for(i=0;i<H;i++)
	{
		for(j=0;j<W;j++)
		{
			count = j*H + i;
			printf("%d\t",data[count]);
		}
		printf("\n");
	}
	printf("\n");
}



void printmatrix_int(unsigned long int *data, int H, int W)
{
	int i,j, count;
	printf("\n");
	for(i=0;i<H;i++)
	{
		for(j=0;j<W;j++)
		{
			count = j*H + i;
			printf("%d\t",data[count]);
		}
		printf("\n");
	}
	printf("\n");
}



void printmatrix_float(float *data, int H, int W)
{
	int i,j, count;
	
	
	printf("\n");
	for(i=0;i<H;i++)
	{
		for(j=0;j<W;j++)
		{
			count = j*H + i;
			printf("%6.4f\t",(float) data[count]);
		}
		printf("\n");
	}
	printf("\n");
}

void printmatrix_double(double *data, int H, int W)
{
	int i,j, count;

	printf("\n");



	
	for(i=0;i<H;i++)
	{
		for(j=0;j<W;j++)
		{
			count = j*H + i;
			printf("%6.2g\t", (float) data[count]);
		}
		printf("\n");
	}
	printf("\n");
	
}



void printarray_float(float *data, unsigned long int n)
{
	
	for(unsigned long int i=0;i<n;i++)
	{
		printf("%6.4f\n",(float) data[i]);
	}

}




