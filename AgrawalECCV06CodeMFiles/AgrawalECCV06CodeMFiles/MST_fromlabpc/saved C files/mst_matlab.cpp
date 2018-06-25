// mst.cpp : Defines the entry point for the console application.
//

#include <math.h>
#include "common.h"
#include "time.h"
#include "mex.h"

#if defined(NAN_EQUALS_ZERO)
#define IsNonZero(d) ((d)!=0.0 || mxIsNaN(d))
#else
#define IsNonZero(d) ((d)!=0.0)
#endif


unsigned long int H, W;
label_nodes *xx,*xxlast;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs,  mxArray *prhs[])
{
    clock_t start, finish;
    FILE *fp;
    
    label_nodes *pp, *idx1, *idx2;
    unsigned long int i,j, tmp, count, num_broken, n1, n2;
    
    //Declarations
    //double *mask_gx, *mask_gy;
    double *mask_gx, *mask_gy;
    double *curl;
    
    printf("Going in C function\n");
    printf("nlhs = %d, nrhs = %d\n",nlhs,nrhs);
    
    H = (unsigned long int) mxGetScalar(prhs[0]);
    W = (unsigned long int) mxGetScalar(prhs[1]);
    
    printf("H = %d\tW = %d\n",H,W);
    
    
    // get data
    mask_gx = mxGetPr(prhs[2]);
    mask_gy = mxGetPr(prhs[3]);
    curl = mxGetPr(prhs[4]);
    
    /*
    printf("here 1\n");
    printmatrix_double(mask_gx,H,W);
    printf("here 2\n");
     */
    
    
    start = clock();
    
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
    

    unsigned long int *label =  new unsigned long int [H*W];
    printf("Running DFS...\n");
    // run DFS
    unsigned long int numlabels = dfs(label,mask_gx,mask_gy);
    
    if(numlabels==1)
    {
        printf("Graph is already connected\n");
        return;
    }
    
    
    
    num_broken = 0;
    for(i=0;i<H*W;i++)
    {
        num_broken = num_broken + (unsigned long) (mask_gx[i] + mask_gy[i]);
    }
    printf("No. of broken edges = %d\n",num_broken);
    
    // assign memory
    edge *broken_edge;
    
    broken_edge = (edge *) malloc(num_broken*sizeof(edge));
    
    
    tmp = 0;
    for(i=0;i<H*W;i++)
    {
        if(mask_gx[i]==1)
        {
            
            broken_edge[tmp].horw = 1;
            broken_edge[tmp].w = curl[i];
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
            broken_edge[tmp].w = curl[i];
            broken_edge[tmp].n1 = i;
            broken_edge[tmp].n2 = i+1;
            tmp++;
        }
        
    }
    if(tmp!=num_broken)
    {
        printf("Error: No. of broken edges did not match\n");
        exit(0);
    }
    
    
    
    
    
    
    
    delete curl;
    curl = new double [num_broken];
    for(i=0;i<num_broken;i++)
    {
        curl[i] = broken_edge[i].w;
    }
    

    unsigned long int *index = new unsigned long int [num_broken];
    hpsort(num_broken, curl,index);
    
    
    
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
            
            numlabels--;
            
        }
    }
    
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
    
}