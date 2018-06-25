#include "stdafx.h"
#include "stdio.h"
#include "stdlib.h"
#include <math.h>
#include "common.h"




void hpsort(unsigned long n, double ra[], unsigned long int *index)
{
	unsigned long int i, ir, j, l, rra_index;
	double rra;
	
	
	// initialize index
	
	for(i=0;i<n;i++)
	{
		index[i] = i;
	}


	if(n < 1) 
		return;
	
	l = (n >> 1) + 1;
	ir = n-1;
	
	for(;;)
	{
		if( l > 0)
		{
			rra = ra[--l];
			rra_index = index[l];
		}
		else
		{
			rra = ra[ir];
			rra_index = index[ir];
			
			ra[ir] = ra[0];
			index[ir] = index[0];
			
			
			if(--ir == 0)
			{
				ra[0] = rra;
				index[0] = rra_index;
				break;
			}
		}
		i = l;
		j = l + 1;
		while(j <= ir)
		{
			if(j < ir && ra[j] < ra[j+1])
				j++;
			if(rra < ra[j])
			{
				ra[i] = ra[j];
				index[i] = index[j];
				i = j;
				j <<= 1;
			}
			else break;
		}
		ra[i] = rra;
		index[i] = rra_index;
		
	}
	
	
	return;
}

