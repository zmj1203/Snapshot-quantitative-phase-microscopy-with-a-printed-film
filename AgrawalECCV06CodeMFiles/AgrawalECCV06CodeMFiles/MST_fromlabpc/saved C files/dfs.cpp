#include "stdafx.h"
#include "stdio.h"
#include "stdlib.h"
#include <math.h>
#include "common.h"

extern unsigned long int H, W;
extern  label_nodes *xx,*xxlast;


// Find no. of connected components in the graph by taking into account 
// which edges are broken (mask_gx=1, mask_gy=1 at broken edges).

unsigned long int dfs(unsigned long int *label, double *mask_gx, double *mask_gy)
{
	
	long int total_nodes = H*W;
	unsigned long int current_label, i, curr_nodes, jj;
	
	dfs_list *x, *y;
	dfs_list *xend, *yend;
	
	
	current_label = 0;
	for(i=0;i<H*W;i++)
	{
		label[i] = -1;
	}
	
	
	
	while(total_nodes>0)
	{
		
		current_label++;
		
		
		// find first node which has -1 in label
		for(i=0;i<H*W;i++)
		{
			if(label[i]==-1)
				break;
		}
		label[i] = current_label;
		total_nodes--;
		curr_nodes = 1;
		
		
		if(current_label==1)
		{
			xx = (label_nodes *) malloc(sizeof(label_nodes));
			xx->next = NULL;
			xx->num = 0;
			xx->label = 1;
			xxlast = xx;
		}
		else
		{
			xxlast->next = (label_nodes *) malloc(sizeof(label_nodes));
			xxlast = xxlast->next;
			xxlast->next = NULL;
			xxlast->num = 0;
			xxlast->label = current_label;
		}
		
		
		
		
		x = (dfs_list *) malloc(sizeof(dfs_list));
		x->next = NULL;
		x->node = i;
		xend = x;
		
		y = (dfs_list *) malloc(sizeof(dfs_list));
		y->next = NULL;
		y->node = i;
		yend = y;
		
		
		
		while(x!=NULL)
		{
			
			// get node from front of list
			unsigned long int n = x->node;
			
			//find neighbors and add them to list
			unsigned int col_no = (unsigned int) floor(double(n)/double(H));
			unsigned int row_no = (unsigned int) n - H*col_no;
			
			//printf("n=%d\trow=%d\tcol=%d\n",n,row_no,col_no);
			
			unsigned long int nn;
			
			
			// down
			if(row_no < H-1)
			{
				nn = H*col_no + row_no + 1;
				if(label[nn] == -1 && mask_gy[n]==0)
				{
					//printf("down nn=%d\n",nn);
					label[nn] = current_label;
					total_nodes--;
					curr_nodes++;
					xend->next = (dfs_list *) malloc(sizeof(dfs_list));
					xend = xend->next;
					xend->node = nn;
					xend->next = NULL;
					
					yend->next = (dfs_list *) malloc(sizeof(dfs_list));
					yend = yend->next;
					yend->node = nn;
					yend->next = NULL;
				}
			}
			
			
			//up
			if(row_no > 0)
			{
				nn = H*col_no + row_no - 1;
				if(label[nn] == -1 && mask_gy[nn]==0)
				{
					//printf("up nn=%d\n",nn);
					label[nn] = current_label;
					total_nodes--;
					curr_nodes++;
					xend->next = (dfs_list *) malloc(sizeof(dfs_list));
					xend = xend->next;
					xend->node = nn;
					xend->next = NULL;
					
					yend->next = (dfs_list *) malloc(sizeof(dfs_list));
					yend = yend->next;
					yend->node = nn;
					yend->next = NULL;
					
				}
			}
			
			
			//left
			if(col_no > 0)
			{
				nn = H*(col_no-1) + row_no;
				if(label[nn] == -1 && mask_gx[nn]==0)
				{
					//printf("left nn=%d\n",nn);
					label[nn] = current_label;
					total_nodes--;
					curr_nodes++;
					xend->next = (dfs_list *) malloc(sizeof(dfs_list));
					xend = xend->next;
					xend->node = nn;
					xend->next = NULL;
					
					yend->next = (dfs_list *) malloc(sizeof(dfs_list));
					yend = yend->next;
					yend->node = nn;
					yend->next = NULL;
					
				}
			}
			
			
			//right 
			if(col_no < W-1)
			{
				nn = H*(col_no+1) + row_no;
				if(label[nn] == -1 && mask_gx[n]==0)
				{
					//printf("right nn=%d\n",nn);
					label[nn] = current_label;
					total_nodes--;
					curr_nodes++;
					xend->next = (dfs_list *) malloc(sizeof(dfs_list));
					xend = xend->next;
					xend->node = nn;
					xend->next = NULL;
					
					yend->next = (dfs_list *) malloc(sizeof(dfs_list));
					yend = yend->next;
					yend->node = nn;
					yend->next = NULL;
					
				}
			}
			
			if(x==xend)
				break;
			
			x = x->next;
			
		}
		
		// Now y has all the nodes for this label
		xxlast->num = curr_nodes;
		xxlast->node = (unsigned long int *) malloc(curr_nodes*sizeof(unsigned long int));
		yend = y;
		for(jj=0;jj<curr_nodes;jj++)
		{
			xxlast->node[jj] = yend->node;
			yend = yend->next;
			
		}
		
		//		printf("current_label = %d\tTotal Nodes Remaining = %d\n",current_label,total_nodes);
		//		printf("current nodes = %d\n",curr_nodes);
	}
	
	
	
	
	delete y;
	return(current_label);
	
}