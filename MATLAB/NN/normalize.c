/*

 Normalize data X inplace with various method
 
 Usage
 -----

 normalize(X , [method]);

 Inputs
 ------

 X             data   (d x N) in single/double format
 method        method of normalization: 
               method = 1 <=> X~[-1,1], method = 2 <=> X~N(0,1) (default method = 1)

 To compile
 ----------

mex -output normalize.dll normalize.c 
mex -f mexopts_intel10.bat -output normalize.dll normalize.c

Example 1
---------
d                    = 100;
N                    = 1000;
X                    = randn(d , N);
method               = 1;

normalize(X , method);
 

Author : Sébastien PARIS : sebastien.paris@lsis.org
------

*/

#include <math.h>
#include "mex.h"

#define BIG 1e250
#define SMALL -1e250

/*--------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------*/

void dnormalize(double * , int, int , int);
void snormalize(float * , int, int , int);

/*--------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------*/

void mexFunction( int nlhs, mxArray *plhs[] , int nrhs, const mxArray *prhs[] )
{	
	double  *dX;	
	float *sX;
    int method = 0;
	int d, N , issingle = 0;
	
	/*--------------------------------------------------------------------------------*/
	/*--------------------------------------------------------------------------------*/
	/* -------------------------- Parse INPUT  -------------------------------------- */
	/*--------------------------------------------------------------------------------*/	
	/*--------------------------------------------------------------------------------*/
		
	if (nrhs < 1) 
	{
		mexPrintf(
			"\n"
			"\n"
			"\n"
			"Normalize data X inplace with various method\n"
			"\n"
			"\n"
			"Usage\n"
			"-----\n"
			"\n"
			"\n"
			"normalize(X , [method]);\n"
			"\n"
			"\n"
			"Inputs\n"
			"------\n"
			"\n"
			"\n"
			"X             data   (d x N) in single/double format\n"
			"method        method of normalization: \n"
			"              method = 1 <=> X~[-1,1], method = 2 <=> X~N(0,1) (default method = 1)\n"
			"\n"
			"\n"
			);
			return;
	}

	/* ----- Input 1 ----- */

	if(mxIsSingle(prhs[0]))
	{
		sX       = (float *)mxGetData(prhs[0]);
		issingle = 1;
	}
	else
	{
		dX       = (double *)mxGetData(prhs[0]);
	}

	d            = mxGetM(prhs[0]);
	N            = mxGetN(prhs[0]);
	
	/* ----- Input 2 ----- */

	if ((nrhs > 1) && !mxIsEmpty(prhs[1]) )
	{
		method       = (int) mxGetScalar(prhs[1]);
		if(method < 0 || method > 4)
		{
			mexErrMsgTxt("method = {0,1,2,3,4}");		
		}
	}
	
	/*---------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------*/
	/* ----------------------- MAIN CALL  -------------------------------------------- */
	/*---------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------*/	
	/*---------------------------------------------------------------------------------*/
	
	if(issingle)
	{
		snormalize(sX , method , d ,  N);
	}
	else
	{
		dnormalize(dX , method , d ,  N);
	}
}
/*--------------------------------------------------------------------------------*/
void dnormalize(double *X , int method , int d , int N)
{
	int i,j,jd , N1 = N-1;
	double m, std, min, max, temp;
	double diff;

	if(method == 1)
	{
		for (i = 0 ; i < d ; i++)
		{
			min  = BIG;
			max  = SMALL;
			for(j = 0 ; j < N ; j++)
			{
				temp = X[i + j*d];
				if(temp < min)
				{
					min = temp;
				}
				if(temp > max)
				{
					max = temp;
				}
			}
			diff = max - min;
			if(diff == 0.0)
			{
				diff = 1.0;
			}
			else
			{
				diff = 1.0/diff;
			}
			for(j = 0 ; j < N ; j++)
			{
				jd         = j*d;
				X[i + jd]  = 2.0*(X[i + jd] - min)*diff - 1.0;
			}
		}
	}
	else if(method == 2)
	{
		for (i = 0 ; i < d ; i++)
		{
			m    = 0.0;
			for(j = 0 ; j < N ; j++)
			{
				m += X[i + j*d];
			}
			m   = m/N;
			std = 0.0;
			for(j = 0 ; j < N ; j++)
			{
				jd           = j*d;
				X[i + jd]   -= m;
				temp         = X[i + jd];
				std         += (temp*temp);
			}
			std = sqrt(std/N1);
			if(std == 0.0)
			{
				std = 1.0;
			}
			else
			{
				std = 1.0/std;
			}
			for(j = 0 ; j < N ; j++)
			{
				X[i + j*d] *= std;
			}
		}
	}
}
/*--------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------*/
void snormalize(float *X , int method , int d , int N)
{
	int i,j,jd , N1 = N-1;
	float m, std, min, max, temp;
	float diff;

	if(method == 1)
	{
		for (i = 0 ; i < d ; i++)
		{
			min  = BIG;
			max  = SMALL;
			for(j = 0 ; j < N ; j++)
			{
				temp = X[i + j*d];
				if(temp < min)
				{
					min = temp;
				}
				if(temp > max)
				{
					max = temp;
				}
			}
			diff = max - min;
			if(diff == 0.0f)
			{
				diff = 1.0f;
			}
			else
			{
				diff = 1.0f/diff;
			}
			for(j = 0 ; j < N ; j++)
			{
				jd         = j*d;
				X[i + jd]  = 2.0f*(X[i + jd] - min)*diff - 1.0;
			}
		}
	}
	else if(method == 2)
	{
		for (i = 0 ; i < d ; i++)
		{
			m    = 0.0f;
			for(j = 0 ; j < N ; j++)
			{
				m += X[i + j*d];
			}
			m   = m/N;
			std = 0.0f;
			for(j = 0 ; j < N ; j++)
			{
				jd           = j*d;
				X[i + jd]   -= m;
				temp         = X[i + jd];
				std         += (temp*temp);
			}
			std = (float)sqrt(std/N1);
			if(std == 0.0f)
			{
				std = 1.0f;
			}
			else
			{
				std = 1.0f/std;
			}
			for(j = 0 ; j < N ; j++)
			{
				X[i + j*d] *= std;
			}
		}
	}
}
/*--------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------*/
