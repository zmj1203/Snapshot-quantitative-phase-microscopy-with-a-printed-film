#include "stdafx.h"
#include "stdio.h"
#include "stdlib.h"
#include <math.h>
#include "common.h"


extern unsigned long int H, W;

#define SWAP(a,b) temp=(a);(a)=(b);(b)=temp;

#define NSTACK 10000

float * sort(unsigned long int n, float arr[])
{
	unsigned long int i, ir =n, j,k, l =1;
	int jstack =0 ;
	float a,temp;
	
	unsigned long int *istack = new unsigned long int [NSTACK];
	
	for(;;)
	{
		if(ir-1<7)
		{
			for(j=l+1;j<=ir;j++)
			{
				a=arr[j];
				for(i=j-1;i>=l;i--)
				{
					if(arr[i]<=a)
						break;
					arr[i+1]=arr[i];
				}
				arr[i+1]=a;
			}
			if(jstack==0)
				break;
			ir = istack[jstack--];
			l = istack[jstack--];
		}
		else
		{
			k = (l+ir) >> 1;
			SWAP(arr[k],arr[l+1]);
			if(arr[l] > arr[ir])
			{
				SWAP(arr[l],arr[ir]);
			}
			if(arr[l+1] > arr[ir])
			{
				SWAP(arr[l+1],arr[ir]);
			}
			if(arr[l] > arr[l+1])
			{
				SWAP(arr[l],arr[l+1]);
			}
			i = l+1;
			j = ir;
			a = arr[l+1];
			for(;;)
			{
				do i++; while(arr[i]<a);
				do j--; while(arr[j]>a);
				if(j<i) break;
				SWAP(arr[i],arr[j]);
			}
			arr[l+1] = arr[j];
			arr[j] = a;
			jstack += 2;
			if(jstack > NSTACK) 
			{
				printf("NSTACK too small in sort");
				exit(0);
			}
			if(ir-i+1 >= j-1)
			{
				istack[jstack] = ir;
				istack[jstack-1] = i;
				ir = j-1;
				
			}
			else
			{
				istack[jstack] = j-1;
				istack[jstack-1] = l;
				l = i;
			}
			
			
			
		}
	}
	delete istack;
	return(arr);
	
}