// mst.cpp : Defines the entry point for the console application.
//

//#include "stdafx.h"
#include "stdio.h"
#include "stdlib.h"
#include <math.h>
#include "common.h"
#include "time.h"

unsigned long int H, W;
label_nodes *xx,*xxlast;


int main(int argc, char* argv[])
{
	clock_t start, finish;
	FILE *fp;
	
	label_nodes *pp, *idx1, *idx2;
	unsigned long int i,j, tmp, count, num_broken, n1, n2;
	
	
	// Read mask_gx	
	fp = fopen("mask_gx.txt","r");
	if(fp==NULL)
	{
		printf("Cannot open file\n");
		exit(0);
	}
	fscanf(fp,"%d\n",&W);
	fscanf(fp,"%d\n",&H);
	
	printf("H = %d, W = %d\n",H,W);
	
	
	double *mask_gx = new double [H*W];
	double *mask_gy = new double [H*W];
	
	unsigned int tt;


	for(i=0;i<W*H;i++)
	{
			fscanf(fp,"%d\n",&tt);
			mask_gx[i] = double(tt);
	}
	fclose(fp);
	
	
	fp = fopen("mask_gy.txt","r");
	if(fp==NULL)
	{
		printf("Cannot open file\n");
		exit(0);
	}

	fscanf(fp,"%d\n",&tmp);
	if(tmp!=W)
	{
		printf("Image dimensions not correct\n");
		exit(0);
	}
	fscanf(fp,"%d\n",&tmp);
	if(tmp!=H)
	{
		printf("Image dimensions not correct\n");
		exit(0);
	}
	
	for(i=0;i<W*H;i++)
	{
			fscanf(fp,"%d\n",&tt);
			mask_gy[i] = double(tt);
	}
	fclose(fp);
	
	
	// set mask_gx at right most boundary to zero and similary for mask_gy
	for(j=0;j<H;j++)
	{
		count = j + H*(W-1);
		mask_gx[count] = 0;
	}
	
	for(j=0;j<W;j++)
	{
		count = H-1 + H*j;
		mask_gy[count] = 0;
	}
	
	
	/*
	printmatrix_double(mask_gx,H,W);
	printmatrix_double(mask_gy,H,W);
	*/
	
	
	float tt1;
	double *WM1 = new double [H*W];
	fp = fopen("WM_1.txt","rt");
	if(fp==NULL)
	{
		printf("Can't open file\n");
		exit(0);
	}
	fscanf(fp,"%d\n",&tmp);
	if(tmp!=W)
	{
		printf("Image dimensions not correct\n");
		exit(0);
	}
	fscanf(fp,"%d\n",&tmp);
	if(tmp!=H)
	{
		printf("Image dimensions not correct\n");
		exit(0);
	}


	for(i=0;i<W*H;i++)
	{
			fscanf(fp,"%g\n",&tt1);
			WM1[i] = (double) tt1;

	}
	fclose(fp);



	double *WM2 = new double [H*W];
	fp = fopen("WM_2.txt","rt");
	if(fp==NULL)
	{
		printf("Can't open file\n");
		exit(0);
	}
	fscanf(fp,"%d\n",&tmp);
	if(tmp!=W)
	{
		printf("Image dimensions not correct\n");
		exit(0);
	}
	fscanf(fp,"%d\n",&tmp);
	if(tmp!=H)
	{
		printf("Image dimensions not correct\n");
		exit(0);
	}


	for(i=0;i<W*H;i++)
	{
			fscanf(fp,"%f\n",&tt1);
			WM2[i] = (double) tt1;
		
	}
	fclose(fp);

	/*
	printmatrix_double(WM1,H,W);
	printmatrix_double(WM2,H,W);
	*/





	start = clock();


	// find connected components in the initial setting
	unsigned long int *label =  new unsigned long int [H*W];
	printf("Running DFS...\n");
	// run DFS
	unsigned long int numlabels = dfs(label,mask_gx,mask_gy);
	//printmatrix_int(label, H, W);

	if(numlabels==1)
	{
		printf("Graph is already connected\n");
		return 0;
	}


	
	/*
	pp = xx;
	while(pp!=NULL)
	{
	printf("label = %d\tnum = %d\n",pp->label,pp->num);
	pp = pp->next;
	}
	*/

	
	
	//find number of edges which are broken
	num_broken = 0;
	for(i=0;i<H*W;i++)
	{
		num_broken = num_broken + (unsigned long) (mask_gx[i] + mask_gy[i]);
	}
	printf("No. of broken edges = %d\n",num_broken);
	
	
	
	// assign memory
	edge *broken_edge;
	
	broken_edge = (edge *) malloc(num_broken*sizeof(edge));
	
	
	// put broken edge info 
	// first x edges then y edges
	tmp = 0;
	for(i=0;i<H*W;i++)
	{
		if(mask_gx[i]==1)
		{
			
			broken_edge[tmp].horw = 1;
			broken_edge[tmp].w = WM1[i];
			broken_edge[tmp].n1 = i;
			broken_edge[tmp].n2 = i+H;
			tmp++;
		}
		
	}
	
	for(i=0;i<H*W;i++)
	{
		if(mask_gy[i]==1)
		{
			
			broken_edge[tmp].horw = 0;
			broken_edge[tmp].w = WM2[i];
			broken_edge[tmp].n1 = i;
			broken_edge[tmp].n2 = i+1;
			tmp++;
		}
		
	}
	
	
	if(tmp!=num_broken)
	{
		printf("No. of broken edges did not match\n");
		exit(0);
		
	}
	delete WM1;
	delete WM2;

	
	
	
	
	
	
	
	
	
	
	// now sort edges
	// get weights for borken edges
	

	double *WM = new double [num_broken];
	
	for(i=0;i<num_broken;i++)
	{
		WM[i] = broken_edge[i].w;
		
	}
	
	unsigned long int *index = new unsigned long int [num_broken];
	
//	printarray_float(WM1,num_broken);
//	printf("\n\n\n\n");
	hpsort(num_broken, WM,index);
	//printarray_float(WM1,num_broken);
	//return 0;

	delete WM;
	
	
	
	//add edges to the graph
	printf("Connecting Edges...\n");
	printf("\tNo. of clusters = %d\n",numlabels);
	
	for(i=0;i<num_broken;i++)
	{
		
		if(numlabels==1)
		{
			break;
		}
		
		
		unsigned long int idx = index[i];
		
		n1 =  broken_edge[idx].n1;
		n2 =  broken_edge[idx].n2;
		
		if(label[n1]!=label[n2])
		{
			// put this edge in mask
			if(broken_edge[idx].horw==1)
			{
				mask_gx[n1] = 0;
			}
			else
			{
				mask_gy[n1] = 0;
			}
			
			// merge labels
			pp = xx;
			for(j=0;j<numlabels;j++)
			{
				if(pp->label==label[n1])
					break;
				pp = pp->next;
			}
			idx1 = pp;
			
			
			pp =  xx;
			for(j=0;j<numlabels;j++)
			{
				if(pp->label==label[n2])
					break;
				pp = pp->next;
			}
			idx2 = pp;
			
			
			
			if(idx1->num < idx2->num)
				//copy idx1, delete idx1
			{
				pp = idx1;
				idx1 = idx2;
				idx2 = pp;
			}
			
			
			//now copy idx2, delete idx2
			idx1->node = (unsigned long int *) realloc(idx1->node, (idx1->num + idx2->num)*sizeof(unsigned long int));
			for(j=0;j<idx2->num;j++)
			{
				idx1->node[j+idx1->num] = idx2->node[j];
				label[idx2->node[j]] = idx1->label;
			}
			idx1->num = idx1->num + idx2->num;
			
			
			
			
			/*
			// copy all those nodes into label[n1] nodes
			// also set label in global array
			unsigned long int *tmp = new unsigned long int [idx1->num + idx2->num];
			for(j=0;j<idx1->num;j++)
			tmp[j] = idx1->node[j];
			
			  for(j=0;j<idx2->num;j++)
			  {
			  tmp[j+idx1->num] = idx2->node[j];
			  label[idx2->node[j]] = idx1->label;
			  }
			  
				idx1->node = tmp;
				idx1->num = idx1->num + idx2->num;
			*/
			
			
			
			//delete idx2
			if(idx2==xx)
			{
				xx = xx->next;
			}
			else if(idx2==xxlast)
			{
				pp = xx;
				while(pp->next!=xxlast)
					pp = pp->next;
				xxlast = pp;
				xxlast->next = NULL;
			}
			else
			{
				pp = xx;
				while(pp->next!=idx2)
					pp = pp->next;
				pp->next = idx2->next;
				
			}
			
			
			/*
			pp = xx;
			count = 0;
			while(pp!=NULL)
			{
				count++;
				pp = pp->next;
			}
			printf("no of clusters = %d\tnumlabel=%d\n",count,numlabels);
			*/
			
			numlabels--;
			
			
			/*
			printf("numlabels = %d\n",numlabels);
			printmatrix_int(label, H, W);
			*/
			
			
		}
	}
	
	//printmatrix_int(label, H, W);
	if(xx->next!=NULL)
	{
		printf("Error: Only one cluster should be left\n");
		exit(0);
	}
	else
	{
		printf("\tDone...\n\tSingle cluster left\n");
		printf("\tNodes in final cluster = %d\t, Total nodes = %d\n",xx->num,H*W);
		
	}
	
	finish = clock();
	double duration = (double)(finish - start) / CLOCKS_PER_SEC;
	
	printf("Time taken for MST = %2.1f seconds\n", duration );
	
	
	
	/*	
	pp = xx;
	while(pp!=NULL)
	{
	printf("label = %d\tnum = %d\n",pp->label,pp->num);
	pp = pp->next;
	}
	*/
	
	
	
	// write mask_gx and mask_gy
	//printmatrix_char(mask_gx,H,W);
	//printmatrix_char(mask_gy,H,W);
	
	fp = fopen("mask_gx_res.txt","w");
	count = 0;
	fprintf(fp,"%d\n%d\n",W,H);
	for(i=0;i<W;i++)
	{
		for(j=0;j<H;j++)
		{
			fprintf(fp,"%d\n",(char) mask_gx[count]);
			count++;
		}
		
	}
	fclose(fp);
	
	fp = fopen("mask_gy_res.txt","w");
	count = 0;
	fprintf(fp,"%d\n%d\n",W,H);
	for(i=0;i<W;i++)
	{
		for(j=0;j<H;j++)
		{
			fprintf(fp,"%d\n",(char) mask_gy[count]);
			count++;
		}
		
	}
	fclose(fp);
	
	
	
	
	return 0;
}
