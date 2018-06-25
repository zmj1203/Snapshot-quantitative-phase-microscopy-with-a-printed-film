
#include <stdio.h>
#include <stdlib.h>


unsigned long int dfs(unsigned long *label, double *mask_gx, double *mask_gy);


typedef struct label_nodes{

	unsigned long num;
	unsigned long *node;
	struct label_nodes *next;
	unsigned long label;
} label_nodes;

typedef struct dfs_list{
	struct dfs_list *next;
	unsigned long node;
} dfs_list;


void printmatrix_char(char *data, int H, int W);
void printmatrix_float(float *data, int H, int W);
void printmatrix_double(double *data, int H, int W);

typedef struct edge{
	unsigned long n1;
	unsigned long n2;
	double w;
	char horw;
} edge;




void hpsort(unsigned long, double *,unsigned long *);