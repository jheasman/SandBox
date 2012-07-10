/*

  Generalized Learning Vector Quantization classification.

  Usage
  ------

  [yproto_est , Wproto_est , lambda_est , E_GLVQ] = grlvq_model(X , y , [options] , [yproto_ini] , [Wproto_ini] , [lambda_ini] );

  Inputs
  -------

  X                                     Train data (d x N)
  y                                     Train label vector (1 x N) with yi = {1,...m}, m different classes  
  options                               Options'structure
          epsilonk                      Update weight's for class label between prototype and train data (default epsilonk = 0.05).
          epsilonl                      Update weight's for class label between prototype and train data (default epsilonl = 0.01).
          epsilonlambda                 lambda's rate for updating. epsilonlambda must be << epsilonk (default epsilonlambda = 10e-6).
		  xi                            Parameter of the sigmoid function  (default xi = 1.0)
          nb_iterations                 Number of iterations (default nb_iterations = 1000).
          metric_method                 Euclidean 1 or Euclidean4l1 2 (default metric_method = 2).
		  shuffle                       Randomly permute order of train data between each iteration if shuffle=1 (default shuffle = 1).
		  updatelambda                  Update Lambda vector if = 1 (default updatelambda = 1).
          seed                          Seed number for internal random generator (default random seed according to time).

If compiled with the "OMP" compilation flag
          num_threads                   Number of threads. If num_threads = -1, num_threads = number of core  (default num_threads = -1).

  yproto_ini                            Intial prototypes label (1 x Nproto) where card(yproto_ini)=card(y)
  Wproto_ini                            Initial prototypes weights (d x Nproto) (default Wproto_ini (d x Nproto) where Nproto=round(sqrt(N)). 
                                        Wproto_ini ~ N(m_{y=i},sigma_{y=i}), where m_{y=i} = E[X|y=i], sigma_{y=i} = E[XX'|y=i]
  lambda_ini                            Initial weigths factor  (d x 1). Default lambda_ini = (1/d)*ones(d , 1);

  Outputs
  -------
  
  yproto_est                            Final prototypes labels  (1 x Nproto)
  Wproto_est                            Final prototypes weigths (d x Nproto)
  lambda_est                            Final Weigths factor    (d x 1)
  E_GLVQ                                Energy criteria versus iterations (1 x options.nb_iterations)

  To compile
  ----------

  mex -g grlvq_model.c

  mex  -output grlvq_model.dll grlvq_model.c

  mex  -f mexopts_intel10.bat -output grlvq_model.dll grlvq_model.c

  mex -v -DOMP -f mexopts_intel10.bat -output grlvq_model.dll grlvq_model.c "C:\Program Files\Intel\Compiler\11.1\065\mkl\ia32\lib\mkl_core.lib" "C:\Program Files\Intel\Compiler\11.1\065\mkl\ia32\lib\mkl_intel_c.lib" "C:\Program Files\Intel\Compiler\11.1\065\mkl\ia32\lib\mkl_intel_thread.lib" "C:\Program Files\Intel\Compiler\11.1\065\lib\ia32\libiomp5md.lib"


  Example 1
  ---------

  d                                     = 2;
  Ntrain                                = 100;
  m                                     = 2;
  M0                                    = [0 ; 0];
  R0                                    = [1 0 ; 0 1];
  M1                                    = [2 ; 3];
  R1                                    = [0.5 0.1 ; 0.2 1];
  vect_test                             = (-4:0.1:8);
  options.epsilonk                      = 0.005;
  options.epsilonl                      = 0.001;
  options.epsilonlambda                 = 10e-6;
  options.xi                            = 0.1;
  options.nb_iterations                 = 1000;
  options.metric_method                 = 1;
  options.shuffle                       = 1;
  options.updatelambda                  = 1;
  options.seed                          = 123456;


  Xtrain                                = [M0(: , ones(1 , Ntrain/2)) + chol(R0)'*randn(d , Ntrain/2) , M1(: , ones(1 , Ntrain/2)) + chol(R1)'*randn(d , Ntrain/2)]; 
  ytrain                                = [zeros(1 , Ntrain/2) , ones(1 , Ntrain/2)];
  [X , Y]                               = meshgrid(vect_test);
  Xtest                                 = [X(:)' ; Y(:)'];

  [yproto_est , Wproto_est  , lambda_est , E_GRLVQ]    = grlvq_model(Xtrain , ytrain , options);
  ytest_est                                            = NN_predict(Xtest , yproto_est , Wproto_est , lambda_est , options);

  indtrain0                                            = (ytrain == 0);
  indtrain1                                            = (ytrain == 1);

  indproto0                                            = (yproto_est == 0);
  indproto1                                            = (yproto_est == 1);

  figure(1)
  imagesc(vect_test , vect_test , reshape(ytest_est , length(vect_test) , length(vect_test)) )
  axis ij
  hold on
  plot(Xtrain(1 , indtrain0) , Xtrain(2 , indtrain0) , 'k+' , Xtrain(1 , indtrain1) , Xtrain(2 , indtrain1) , 'm+' , Wproto_est(1 , indproto0) ,  Wproto_est(2 , indproto0) , 'ko' , Wproto_est(1 , indproto1) ,  Wproto_est(2 , indproto1) , 'mo')
  h = voronoi(Wproto_est(1 , :) , Wproto_est(2 , :));
  set(h , 'color' , 'y' , 'linewidth' , 2)
  hold off
  title('E_{GRLVQ}(t)' , 'fontsize' , 12)
  colorbar

  figure(2)
  plot(E_GRLVQ);
  title('E_{GRLVQ}(t)' , 'fontsize' , 12)

  figure(3)
  stem(lambda_est);
  title('\lambda' , 'fontsize' , 12)

  Example 2
  ---------

  close all
  load ionosphere
  Nproto_pclass                      = 4*ones(1 , length(unique(y)));
  
  options.epsilonk                   = 0.005;
  options.epsilonl                   = 0.001;
  options.epsilonlambda              = 10e-6;
  options.xi                         = 1;
  options.nb_iterations              = 5000;
  options.metric_method              = 1;
  options.shuffle                    = 1;
  options.updatelambda               = 1;
  options.seed                       = 123456;

  [d , N]                            = size(X);
  ON                                 = ones(1 , N);
  mindata                            = min(X , [] , 2);
  maxdata                            = max(X , [] , 2);
  temp                               = maxdata - mindata;
  temp(temp==0)                      = 1;
  X                                  = 2*(X - mindata(: , ON))./(temp(: , ON)) - 1;
  n1                                 = round(0.7*N);
  n2                                 = N - n1;
  ind                                = randperm(length(y));
  ind1                               = ind(1:n1);
  ind2                               = ind(n1+1:N);
  Xtrain                             = X(: , ind1);
  ytrain                             = y(ind1);
  Xtest                              = X(: , ind2);
  ytest                              = y(ind2);
  
  [yproto_ini , Wproto_ini , lambda_ini]              = ini_proto(Xtrain , ytrain , Nproto_pclass);
  [yproto_est , Wproto_est  , lambda_est , E_GRLVQ]   = grlvq_model(Xtrain , ytrain , options , yproto_ini , Wproto_ini  , lambda_ini);
  ytest_est                                           = NN_predict(Xtest , yproto_est , Wproto_est , lambda_est , options);
  Perf                                                = sum(ytest == ytest_est)/n2;
  disp(Perf)
  plot(E_GRLVQ);
  title('E_{GRLVQ}(t)' , 'fontsize' , 12)
  figure(2)
  stem(lambda_est);
  title('\lambda' , 'fontsize' , 12)

  Example 3
  ---------

  load artificial
  
  Nproto_pclass                      = [15 , 12 , 3];
  options.epsilonk                   = 0.008;
  options.epsilonl                   = 0.001;
  options.epsilonlambda              = 10e-7;
  options.xi                         = 10;
  options.nb_iterations              = 5000;
  options.metric_method              = 1;
  options.shuffle                    = 1;
  options.updatelambda               = 1;
  options.seed                       = 123456;


  [d , N]                            = size(X);
  ON                                 = ones(1 , N);
  n1                                 = round(0.7*N);
  n2                                 = N - n1;
  ind                                = randperm(length(y));
  ind1                               = ind(1:n1);
  ind2                               = ind(n1+1:N);
  Xtrain                             = X(: , ind1);
  ytrain                             = y(ind1);
  Xtest                              = X(: , ind2);
  
  ytest                              = y(ind2);

  [yproto_ini , Wproto_ini , lambda_ini]              = ini_proto(Xtrain , ytrain , Nproto_pclass);

  [yproto_est , Wproto_est  , lambda_est , E_GRLVQ]   = grlvq_model(Xtrain , ytrain , options , yproto_ini , Wproto_ini , lambda_ini);
  ytest_est                                           = NN_predict(Xtest , yproto_est , Wproto_est , lambda_est , options);
  Perf                                                = sum(ytest == ytest_est)/n2;
  disp(Perf)

  figure(1)
  plot_label(X , y);
  hold on
  h = voronoi(Wproto_est(1 , :) , Wproto_est(2 , :));
  hold off

  figure(2)
  plot(E_GRLVQ);
  title('E_{GRLVQ}(t)' , 'fontsize' , 12)

  figure(3)
  stem(lambda_est);

  Example 4
  ---------

  load glass

  options.epsilonk                   = 0.005;
  options.epsilonl                   = 0.001;
  options.epsilonlambda              = 10e-6;
  options.xi                         = 0.1;
  options.nb_iterations              = 15000;
  options.metric_method              = 1;
  options.shuffle                    = 1;
  options.updatelambda               = 1;
  options.seed                       = 123456;


  [d , N]                            = size(X);
  ON                                 = ones(1 , N);
  mindata                            = min(X , [] , 2);
  maxdata                            = max(X , [] , 2);
  temp                               = maxdata - mindata;
  temp(temp==0)                      = 1;
  X                                  = 2*(X - mindata(: , ON))./(temp(: , ON)) - 1;
  n1                                 = round(0.7*N);
  n2                                 = N - n1;
  ind                                = randperm(length(y));
  ind1                               = ind(1:n1);
  ind2                               = ind(n1+1:N);
  Xtrain                             = X(: , ind1);
  ytrain                             = y(ind1);
  Xtest                              = X(: , ind2);
  ytest                              = y(ind2);
  Nproto_pclass                      = 4*ones(1 , length(unique(y)));

  
  [yproto_ini , Wproto_ini , lambda_ini ]             = ini_proto(Xtrain , ytrain , Nproto_pclass);
  [yproto_est , Wproto_est  , lambda_est , E_GRLVQ]   = grlvq_model(Xtrain , ytrain , options , yproto_ini , Wproto_ini , lambda_ini);
  ytest_est                                           = NN_predict(Xtest , yproto_est , Wproto_est , lambda_est , options);

  Perf                                                = sum(ytest == ytest_est)/n2;
  disp(Perf)
  plot(E_GRLVQ);
  title('E_{GRLVQ}(t)' , 'fontsize' , 12)

  figure(3)
  stem(lambda_est);


  Example 5
  ---------

  close all
  %load artificial
  load iris
  
  options.epsilonk                   = 0.005;
  options.epsilonl                   = 0.001;
  options.epsilonlambda              = 10e-7;
  options.xi                         = 1;
  options.nb_iterations              = 5000;
  options.metric_method              = 2;
  options.shuffle                    = 1;
  options.updatelambda               = 1;
  
  options.method                     = 6;
  options.cv.K                       = 10;
  options.holding.rho                = 0.7;
  options.holding.K                  = 20;
  options.bootstraping.rho           = 0.7;
  options.bootstraping.K             = 20;


  Nproto_pclass                      = 4*ones(1 , length(unique(y)));
  %Nproto_pclass                      = [15 , 12 , 3];

  [Itrain , Itest]                   = sampling(X , y , options);
  Perf                               = zeros(1 , size(Itrain , 1));

  for i = 1 : size(Itrain , 1)
    Xtrain                                    = X(: , Itrain(i , :));
    ytrain                                    = y(Itrain(i , :));

    Xtest                                     = X(: , Itest(i , :));
    ytest                                     = y(Itest(i , :));
  
    [yproto_ini , Wproto_ini , lambda_ini]    = ini_grlvq(Xtrain , ytrain , Nproto_pclass);
    [yproto_est , Wproto_est  , lambda_est]   = grlvq_model(Xtrain , ytrain , options , yproto_ini , Wproto_ini , lambda_ini );
    ytest_est                                 = glvq_predict(Xtest , yproto_est , Wproto_est , lambda_est , options);
    Perf(i)                                   = sum(ytest == ytest_est)/length(ytest);
  end
  disp(mean(Perf))


 Author : Sébastien PARIS : sebastien.paris@lsis.org
 -------  Date : 04/09/2006

 Reference ""

*/


#include <time.h>
#include <math.h>
#include <mex.h>
#ifdef OMP
#include <omp.h>
#endif

#ifndef MAX
#define MAX(A,B)   (((A) > (B)) ? (A) : (B) )
#define MIN(A,B)   (((A) < (B)) ? (A) : (B) ) 
#endif

#ifndef MAX_THREADS
#define MAX_THREADS 64
#endif

#define mix(a , b , c) \
{ \
	a -= b; a -= c; a ^= (c>>13); \
	b -= c; b -= a; b ^= (a<<8); \
	c -= a; c -= b; c ^= (b>>13); \
	a -= b; a -= c; a ^= (c>>12);  \
	b -= c; b -= a; b ^= (a<<16); \
	c -= a; c -= b; c ^= (b>>5); \
	a -= b; a -= c; a ^= (c>>3);  \
	b -= c; b -= a; b ^= (a<<10); \
	c -= a; c -= b; c ^= (b>>15); \
}

#define zigstep 128 /* Number of Ziggurat'Steps */
#define znew   (z = 36969*(z&65535) + (z>>16) )
#define wnew   (w = 18000*(w&65535) + (w>>16) )
#define MWC    ((znew<<16) + wnew )
#define SHR3   ( jsr ^= (jsr<<17), jsr ^= (jsr>>13), jsr ^= (jsr<<5) )
#define randint SHR3
#define rand() (0.5 + (signed)randint*2.328306e-10)

#ifdef __x86_64__
    typedef int UL;
#else
    typedef unsigned long UL;
#endif

static UL jsrseed = 31340134 , jsr;
static UL iz , kn[zigstep];		
static long hz;
static double wn[zigstep] , fn[zigstep];

typedef struct OPTIONS 
{
  double epsilonk;
  double epsilonl;
  double epsilonlambda;
  double xi;   
  int    nb_iterations;
  int    metric_method;
  int    shuffle;
  int    updatelambda;
  UL     seed;
#ifdef OMP 
  int    num_threads;
#endif
} OPTIONS; 

/*-------------------------------------------------------------------------------------------------------------- */
/* Function prototypes */

void randini(UL);  
void randnini(void);
double nfix(void);
double randn(void); 
void qs( double * , int , int  ); 
void qsindex( double * , int * , int , int  ); 
void grlvq_model(double * , double * , OPTIONS , int , int , int , int , double * , double * , double *, double *, double *);

/*-------------------------------------------------------------------------------------------------------------- */
void mexFunction( int nlhs, mxArray *plhs[] , int nrhs, const mxArray *prhs[] )
{
    double *X , *y  , *Wproto_ini , *yproto_ini;
#ifdef OMP 
	OPTIONS options = {0.005, 0.001 , 10e-6 , 1.0, 1000 , 1 , 1 , 1 , (UL)NULL , -1};
#else
	OPTIONS options = {0.005, 0.001 , 10e-6 , 1.0, 1000 , 1 , 1 , 1 , (UL)NULL};
#endif
	double *Wproto_est , *yproto_est , *E_GRLVQ , *lambda_est;
	int d , N  , Nproto  , m = 0;
	int i , j  , l , co , Nprotom  , ld , id , indice;
	double  currentlabel , ind , temp;
	double *tmp , *ysorted , *labels , *mtemp , *stdtemp , *lambda_ini;
	int *Nk ;
    mxArray *mxtemp;
	int tempint;
	UL templint;

	if (nrhs < 1) 
	{
		mexPrintf(
			"\n"
			"\n"
			"\n"
			"Generalized Learning Vector Quantization classification.\n"
			"\n"
			"\n"
			"Usage\n"
			"-----\n"
			"\n"
			"\n"
			"[Wproto_est , yproto_est , lambda_est , E_GLVQ] = grlvq_model(X , y , [options] , [yproto_ini] , [Wproto_ini] , [lambda_ini] );\n"
			"\n"
			"\n"
			"Inputs\n"
			"------\n"
			"\n"
			"\n"
			"X                                    Train data (d x N)\n"
			"y                                    Train label vector (1 x N) with yi = {1,...m}, m different classes\n"  
			"options                              Options'structure\n"
			"       epsilonk                      Update weight's for class label between prototype and train data (default epsilonk = 0.05).\n"
			"       epsilonl                      Update weight's for class label between prototype and train data (default epsilonl = 0.01).\n"
			"       epsilonlambda                 lambda's rate for updating. epsilonlambda must be << epsilonk (default epsilonlambda = 10e-6).\n" 
			"       xi                            Constant in the sigmoid function  (default xi = 1.0).\n"
			"       nb_iterations                 Number of iterations (default nb_iterations = 1000).\n"
			"       metric_method                 Euclidean 1 or Euclidean4l1 2 (default metric_method = 2).\n"
			"       shuffle                       Randomly permute order of train data between each iteration if shuffle=1 (default shuffle = 1).\n"
			"       updatelambda                  Update Lambda vector if = 1 (default updatelambda = 1).\n"
			"       seed                          Seed number for internal random generator (default random seed according to time).\n"
#ifdef OMP 
			"       num_threads                   Number of threads. If num_threads = -1, num_threads = number of core  (default num_threads = -1)\n"
#endif

			"yproto_ini                           Intial prototypes label (1 x Nproto) where card(yproto_ini)=card(y).\n"
			"Wproto_ini                           Initial prototypes weights (d x Nproto) (default Wproto_ini (d x Nproto) where Nproto=round(sqrt(N)).\n" 
			"                                     Wproto_ini ~ N(m_{y=i},sigma_{y=i}), where m_{y=i} = E[X|y=i], sigma_{y=i} = E[XX'|y=i].\n"
			"lambda_ini                           Initial weigths factor  (d x 1). Default lambda_ini = (1/d)*ones(d , 1);.\n"
			"\n"
			"\n"
			"Outputs\n"
			"-------\n"
			"\n"
			"\n"  
			"yproto_est                            Final prototypes labels  (1 x Nproto)\n"
			"Wproto_est                            Final prototypes weigths (d x Nproto)\n"
			"lambda_est                            Final Weigths factor  estimated (d x 1)\n"
			"E_GLVQ                                Energy criteria versus iteration (1 x options.nb_iterations)\n"
			"\n"
			"\n"
			);
		return;
	}

    /* Input 1  X */
	
	X         = mxGetPr(prhs[0]);		
	if( mxGetNumberOfDimensions(prhs[0]) != 2 )
	{
		mexErrMsgTxt("X must be (d x N)");
	}
	d         = mxGetM(prhs[0]);	 
	N         = mxGetN(prhs[0]);
	Nproto    = (int)floor(sqrt(N));
	
	/* Input 2  y */

	y         = mxGetPr(prhs[1]);
   	
	if((mxGetNumberOfDimensions(prhs[1]) != 2) || (mxGetN(prhs[1]) != N))
	{
		mexErrMsgTxt("y must be (1 x N)");
	}
	/* Determine unique Labels */
	ysorted  = malloc(N*sizeof(double));
	for ( i = 0 ; i < N; i++ ) 
	{
		ysorted[i] = y[i];
	}
	qs( ysorted , 0 , N - 1 );

	labels       = (double *) malloc(sizeof(double)); 
	labels[m]    = ysorted[0];
	currentlabel = labels[0];
	for (i = 0 ; i < N ; i++) 
	{ 
		if (currentlabel != ysorted[i]) 
		{ 
			labels       = (double *)realloc(labels , (m+2)*sizeof(double)); 
			labels[++m]  = ysorted[i]; 
			currentlabel = ysorted[i];
		} 
	} 
	m++; 

   /* Input 3   option */
	
	if ( (nrhs > 2) && !mxIsEmpty(prhs[2]) )
	{
		mxtemp                                   = mxGetField(prhs[2] , 0, "epsilonk");
		if(mxtemp != NULL)
		{
			tmp                                  = mxGetPr(mxtemp);	
			temp                                 = tmp[0];
			if((temp < 0.0))
			{
				mexPrintf("epsilonk >= 0.0, force to 0.005\n");	
				options.epsilonk                 = 0.005;
			}
			else
			{
				options.epsilonk                 = temp;
			}			
		}

		mxtemp                                   = mxGetField(prhs[2] , 0, "epsilonl");
		if(mxtemp != NULL)
		{				
			tmp                                  = mxGetPr(mxtemp);	
			temp                                 = tmp[0];
			if((temp < 0.0) || (temp > options.epsilonk))
			{
				mexPrintf("epsilonl >= 0.0 and epsilonl < epsilonk, force to 0.001\n");	
				options.epsilonl                 = 0.001;
			}
			else
			{
				options.epsilonl                 = temp;
			}						
		}
		
		mxtemp                                   = mxGetField(prhs[2] , 0, "epsilonlambda");		
		if(mxtemp != NULL)
		{	
			tmp                                  = mxGetPr(mxtemp);	
			temp                                 = tmp[0];
			if((temp < 0.0) || (temp > options.epsilonl/10))
			{
				mexPrintf("epsilonlambda >= 0.0 and epsilonlambda < epsilonl/10, force to 10e-6\n");	
				options.epsilonlambda            = 10e-6;
			}
			else
			{
				options.epsilonlambda                 = temp;
			}						
		}		

		mxtemp                                   = mxGetField(prhs[2] , 0, "xi");
		if(mxtemp != NULL)
		{
			tmp                                  = mxGetPr(mxtemp);	
			temp                                 = tmp[0];
			if((temp < 0.0))
			{
				mexPrintf("xi >= 0.0, force to 1\n");	
				options.xi                      = 1.0;
			}
			else
			{
				options.xi                      = temp;
			}			
		}
		
		mxtemp                                   = mxGetField(prhs[2] , 0, "nb_iterations");
		if(mxtemp != NULL)
		{
			tmp                                  = mxGetPr(mxtemp);
			tempint                              = (int) tmp[0];
			if( (tempint < 1) )
			{
				mexPrintf("nb_iterations > 1 , force to 1000\n");	
				options.nb_iterations            = 1000;
			}
			else
			{
				options.nb_iterations            = tempint;
			}
		}
		
		mxtemp                                   = mxGetField(prhs[2] , 0, "metric_method");
		if(mxtemp != NULL)
		{
			tmp                                  = mxGetPr(mxtemp);
			tempint                              = (int) tmp[0];
			if( (tempint < 1)|| (tempint > 2) )
			{
				mexPrintf("metric_method ={1,2} , force to 2\n");	
				options.metric_method            = 2;
			}
			else
			{
				options.metric_method            = tempint;
			}
		}
	
		mxtemp                                   = mxGetField(prhs[2] , 0, "shuffle");
		if(mxtemp != NULL)
		{		
			tmp                                  = mxGetPr(mxtemp);
			tempint                              = (int) tmp[0];
			if( (tempint < 0)|| (tempint > 2) )
			{
				mexPrintf("shuffle = {0,1} , force to 1\n");	
				options.shuffle                  = 1;
			}
			else
			{
				options.shuffle                  = tempint;
			}
		}

		mxtemp                                   = mxGetField(prhs[2] , 0, "updatelambda");
		if(mxtemp != NULL)
		{
			tmp                                  = mxGetPr(mxtemp);
			tempint                              = (int) tmp[0];
			if( (tempint < 0)|| (tempint > 2) )
			{
				mexPrintf("updatelambda = {0,1} , force to 1\n");	
				options.updatelambda             = 1;
			}
			else
			{
				options.updatelambda             = tempint;
			}
		}
		
		mxtemp                                   = mxGetField(prhs[2] , 0 , "seed");
		if(mxtemp != NULL)
		{
			tmp                                  = mxGetPr(mxtemp);
			templint                             = (UL) tmp[0];
			if( (templint < 1) )
			{
				mexPrintf("seed >= 1 , force to NULL (random seed)\n");	
				options.seed                     = (UL)NULL;
			}
			else
			{
				options.seed                     = templint;
			}
		}

#ifdef OMP
		mxtemp                            = mxGetField(prhs[2] , 0 , "num_threads");
		if(mxtemp != NULL)
		{
			tmp                           = mxGetPr(mxtemp);
			tempint                       = (int) tmp[0];

			if( (tempint < -1))
			{
				mexPrintf("num_threads must be >= -1, force to -1\n");	
				options.num_threads       = -1;
			}
			else
			{
				options.num_threads       = tempint;
			}
		}
#endif
	}

	/* Input 4   yproto_ini */

	if ((nrhs < 4) || mxIsEmpty(prhs[3]) )
	{
		plhs[0]               = mxCreateDoubleMatrix(1 , Nproto , mxREAL);
		yproto_est            = mxGetPr(plhs[0]);
		co                    = 0;
		Nprotom               = ceil((double)Nproto/(double)m);
		for(i = 0 ; i < m-1 ; i++)
		{
			ind               = labels[i];
			for(j = 0 ; j < Nprotom ; j++)
			{
				yproto_est[co]  = labels[i];
				co++;
			}
		}	
		ind                   = labels[m-1];
		for(j = (m-1)*Nprotom ; j < Nproto ; j++)
		{
			yproto_est[co]    = ind;
			co++;
		}
	}
	else
	{
		yproto_ini                = mxGetPr(prhs[3]);
		if(mxGetNumberOfDimensions(prhs[3]) != 2)
		{
			mexErrMsgTxt("yproto_ini must be (1 x Nproto)");
		}
		Nproto                = mxGetN(prhs[3]);
		plhs[0]               = mxCreateDoubleMatrix(1 , Nproto, mxREAL);
		yproto_est            = mxGetPr(plhs[0]);
		for( i = 0 ; i < Nproto ; i++)
		{
			yproto_est[i]     = yproto_ini[i];
		}
	}	

   /*Initialize Random generator */
	 
	 randini(options.seed);	
     randnini(); 

	/* Input 5   Wproto_ini */

	if ((nrhs < 5) || mxIsEmpty(prhs[4]) )
	{
		mtemp    = malloc(d*m*sizeof(double));
		stdtemp  = malloc(d*m*sizeof(double));
		Nk       = malloc(m*sizeof(int));

		for(i = 0 ; i < d*m ; i++)
		{
			mtemp[i]   = 0.0;
			stdtemp[i] = 0.0;
		}
		for (l = 0 ; l < m ; l++)	
		{
			ind   = labels[l];	
			ld    = l*d;
			Nk[l] = 0;
			for (i = 0 ; i < N ; i++)			
			{
				if(y[i] == ind)		
				{
					id  = i*d;
					for(j = 0 ; j < d ; j++)
					{
						mtemp[j + ld] += X[j + id];	
					}
					Nk[l]++;
				}
			}
		}
		for (l = 0 ; l < m ; l++)	
		{
			ld   = l*d;
			temp = 1.0/Nk[l];
			for(j = 0 ; j < d ; j++)
			{
				mtemp[j + ld] *= temp;
			}
		}
		for (l = 0 ; l < m ; l++)
		{
			ind = labels[l];
			ld  = l*d;
			for (i = 0 ; i < N ; i++)
			{
				if(y[i] == ind)
				{
					id  = i*d;
					for(j = 0 ; j < d ; j++)
					{
						temp             = (X[j + id] - mtemp[j + ld]);
						stdtemp[j + ld] += (temp*temp);
					}
				}
			}
		}
		for (l = 0 ; l < m ; l++)
		{
			ld   = l*d;
			temp = 1.0/(Nk[l] - 1);
			for(j = 0 ; j < d ; j++)
			{
				stdtemp[j + ld] = temp*sqrt(stdtemp[j + ld]);
			}
		}

		plhs[1]               = mxCreateDoubleMatrix(d , Nproto, mxREAL);
		Wproto_est            = mxGetPr(plhs[1]);

		for(l = 0 ; l < Nproto ; l++)
		{
			ld = l*d;		
			for(i = 0 ; i < m ; i++)
			{				
				if(labels[i] == yproto_est[l] )		
				{
					indice = i*m;	
				}
			}
			for(i = 0 ; i < d ; i++)
			{
				Wproto_est[i + ld]  = mtemp[i + indice] + stdtemp[i + indice]*randn();
			}
		}
	}	
	else
	{
		Wproto_ini            = mxGetPr(prhs[4]);
		if((mxGetNumberOfDimensions(prhs[4]) != 2) || (mxGetM(prhs[4]) != d) )
		{
			mexErrMsgTxt("Wproto_ini must be (d x Nproto)");
		}

		Nproto                = mxGetN(prhs[4]);
		plhs[1]               = mxCreateDoubleMatrix(d , Nproto, mxREAL);
		Wproto_est            = mxGetPr(plhs[1]);
	
		for( i = 0 ; i < d*Nproto ; i++)			
		{
			Wproto_est[i]     = Wproto_ini[i];
		}
	}
	
	/* Input 6   lambda_ini */

	plhs[2]                = mxCreateDoubleMatrix(d , 1 , mxREAL);
	lambda_est             = mxGetPr(plhs[2]);	
	if ((nrhs < 6) || mxIsEmpty(prhs[5]) )
	{
		lambda_ini = (double *)malloc(d*sizeof(double));
		for (i = 0 ; i < d ; i++)
		{
			lambda_ini[i]          = 1.0/d;
		}
		for (i = 0 ; i < d ; i++)
		{
			lambda_est[i]     = lambda_ini[i] ;
		}
	}
	else
	{
		lambda_ini             = mxGetPr(prhs[5]);
		for (i = 0 ; i < d ; i++)
		{
			lambda_est[i]      = lambda_ini[i] ;
		}	
	}
	
	/*---------- Outputs --------*/ 

    plhs[3]                = mxCreateDoubleMatrix(1 , options.nb_iterations , mxREAL);
	E_GRLVQ                = mxGetPr(plhs[3]);

	/*-------------- Main Call ----------- */

	grlvq_model(X , y , options , d , N , Nproto , m , Wproto_est , yproto_est , E_GRLVQ , lambda_ini , lambda_est);
		
   /*------------- Free memory -----------*/ 

	free(labels);
	free(ysorted);

	if((nrhs < 6) || mxIsEmpty(prhs[5]))
	{
		free(lambda_ini);
	}
	if( (nrhs < 5) || mxIsEmpty(prhs[4]))
	{
		free(mtemp);
		free(stdtemp);
		free(Nk);
	}
}
/*-------------------------------------------------------------------------------------------------------------- */
void grlvq_model(double *X , double *y , OPTIONS options , int d , int N , int Nproto , int m , double *Wproto_est , double *yproto_est , double *E_GRLVQ , double *lambda_ini , double *lambda_est)				 
{	
	int i , j , l , t , indice , ind , kmin , lmin , offkmin , offlmin , indtemp , indtemp1 , jd;
	int shuffle = options.shuffle , nb_iterations = options.nb_iterations , metric_method = options.metric_method , updatelambda = options.updatelambda;
	double yi , temp , dkmin , dlmin , double_max = 1.79769313486231*10e307;
	double nu , lnu , ctek , ctel  , ctelamb ,tmptmp, tmptmp2, tmptmp1, tmptmp3 , tmptmp4 , cte_tmp , cte_lambda , dist_proto;
	double epsilonk = options.epsilonk , epsilonl = options.epsilonl , epsilonlambda = options.epsilonlambda , xi = options.xi;
	double *vect_temp;
	int *index;

#ifdef OMP 
    int num_threads = options.num_threads;
    num_threads     = (num_threads == -1) ? MIN(MAX_THREADS,omp_get_num_procs()) : num_threads;
    omp_set_num_threads(num_threads);
#endif

    vect_temp        = (double *) malloc(N*sizeof(double));
    index            = (int *) malloc(N*sizeof(int));

	for(i = 0 ; i < N ; i++)
	{							
		index[i] = i;	
	}
	for (t = 0 ; t < nb_iterations ; t++)	
	{
		if(shuffle)		
		{
			for(i = 0 ; i < N ; i++)
			{		
				vect_temp[i]  = rand();	
				index[i]      = i;
			}
			qsindex(vect_temp , index , 0 , N - 1 ); 
		}

		E_GRLVQ[t]       = 0.0;
		for(i = 0 ; i < N ; i++) /* O(dNprotoN) */
		{
			indice       = index[i];	
			ind          = indice*d;
			yi           = y[indice];
			dkmin        = double_max;
			dlmin        = double_max;
			kmin         = 0;
			lmin         = 0;

			if (metric_method)
			{
#ifdef OMP
#pragma omp parallel for default(none) private(j,l,jd,temp) shared(X,yproto_est,Wproto_est,lambda_est,dist_proto,yi,d,Nproto,kmin,lmin,dkmin,dlmin,ind)
#endif
				for(j = 0 ; j < Nproto ; j++) 
				{
					dist_proto  = 0.0;	
					jd          = j*d;
					for(l = 0 ; l < d ; l++)
					{
						temp        = (X[l + ind] - Wproto_est[l + jd]);
						dist_proto += (lambda_est[l]*temp*temp);						
					}
					if(yproto_est[j] == yi)
					{	
						if(dist_proto < dkmin)		
						{
							dkmin = dist_proto;	
							kmin  = j;
						}
					}
					else
					{
						if(dist_proto < dlmin)		
						{
							dlmin = dist_proto;	
							lmin  = j;
						}
					}
				}
			}
			else
			{
#ifdef OMP
#pragma omp parallel for default(none) private(j,l,jd,temp) shared(X,yproto_est,Wproto_est,lambda_est,dist_proto,yi,d,Nproto,kmin,lmin,dkmin,dlmin,ind)
#endif
				for(j = 0 ; j < Nproto ; j++)
				{
					dist_proto  = 0.0;	
					jd          = j*d;
					for(l = 0 ; l < d ; l++)
					{		
						temp        = (X[l + ind] - Wproto_est[l + jd]);
						dist_proto += (lambda_est[l]*temp*temp*temp*temp);					
					}
					if(yproto_est[j] == yi)
					{	
						if(dist_proto < dkmin)		
						{
							dkmin = dist_proto;	
							kmin  = j;
						}
					}
					else
					{
						if(dist_proto < dlmin)		
						{
							dlmin = dist_proto;	
							lmin  = j;
						}
					}
				}
			}

			tmptmp     = 1.0/(dkmin + dlmin);
			nu         = (dkmin - dlmin)*tmptmp;
			lnu        = 1.0/(1.0 + exp(-xi*nu)); /* *(t+1); margin */
			E_GRLVQ[t]+= lnu;

			/*			cte_tmp    = xi*lnu*(1.0 - lnu)*tmptmp*tmptmp; */

			cte_tmp    = xi*lnu*(1.0 - lnu)*tmptmp;
			ctek       = cte_tmp*epsilonk*dlmin;
			ctel       = cte_tmp*epsilonl*dkmin;			
			ctelamb    = epsilonlambda*cte_tmp;
			offkmin    = kmin*d;			
			offlmin    = lmin*d;
			cte_lambda = 0.0;

			if (metric_method == 2)
			{
				for( l = 0 ; l < d ; l++)					
				{
					indtemp               = l + offkmin;
					tmptmp1               = X[l + ind] - Wproto_est[indtemp];					
					Wproto_est[indtemp] += (ctek*8.0*lambda_est[l]*tmptmp1*tmptmp1*tmptmp1); 
					indtemp1              = l + offlmin;
					tmptmp2               = X[l + ind] - Wproto_est[indtemp1];
					Wproto_est[indtemp1] -= (ctel*8.0*lambda_est[l]*tmptmp2*tmptmp2*tmptmp2); 
					if (updatelambda)
					{						
						tmptmp3               = tmptmp1*tmptmp1;	
						tmptmp4               = tmptmp2*tmptmp2;
						lambda_est[l]        -= (ctelamb*4.0*(dlmin*tmptmp3*tmptmp3 - dkmin *tmptmp4*tmptmp4));
						lambda_est[l]         = MAX(0 , lambda_est[l]);
						cte_lambda           += lambda_est[l];						
					}
				}				
			}
			else
			{	
				for( l = 0 ; l < d ; l++)		
				{
					indtemp               = l + offkmin;
					tmptmp1               = X[l + ind] - Wproto_est[indtemp];
					Wproto_est[indtemp]  += (4.0*ctek*lambda_est[l]*tmptmp1); 
					indtemp1              = l + offlmin;
					tmptmp2               = X[l + ind] - Wproto_est[indtemp1];
					Wproto_est[indtemp1] -= (4.0*ctel*lambda_est[l]*tmptmp2); 
					if (updatelambda)
					{
						lambda_est[l]        -= (ctelamb*2.0*(dlmin*tmptmp1*tmptmp1 - dkmin*tmptmp2*tmptmp2)); 
						lambda_est[l]         = MAX(0 , lambda_est[l]);
						cte_lambda           += lambda_est[l];						
					}
				}
			}
			if (updatelambda)
			{
				cte_lambda        = 1.0/cte_lambda;				
				for (l = 0 ; l < d ; l++)
				{
					lambda_est[l] *= cte_lambda;	
				}
			}	
		}
	}
	free(vect_temp);
	free(index);
}
/*----------------------------------------------------------------------------------------------------------------------------------------- */
void qs(double  *a , int lo, int hi)
{
/*  
lo is the lower index, hi is the upper index
   of the region of array a that is to be sorted
*/
    int i=lo, j=hi;
    double x=a[(lo+hi)/2] , h;

    /*  partition */
    do
    {    
        while (a[i]<x) i++; 
        while (a[j]>x) j--;
        if (i<=j)
        {
            h        = a[i]; 
			a[i]     = a[j]; 
			a[j]     = h;
            i++; 
			j--;
        }
    }
	while (i<=j);

    /*  recursion */
    if (lo<j) qs(a , lo , j);
    if (i<hi) qs(a , i , hi);
}
/*----------------------------------------------------------------------------------------------------------------------------------------- */
void qsindex (double  *a, int *index , int lo, int hi)
{
/*  
lo is the lower index, hi is the upper index
   of the region of array a that is to be sorted
*/
    int i=lo, j=hi , ind;
    double x=a[(lo+hi)/2] , h;

    /*  partition */
    do
    {    
        while (a[i]<x) i++; 
        while (a[j]>x) j--;
        if (i<=j)
        {
            h        = a[i]; 
			a[i]     = a[j]; 
			a[j]     = h;
			ind      = index[i];
			index[i] = index[j];
			index[j] = ind;
            i++; 
			j--;
        }
    }
	while (i<=j);

    /*  recursion */
    if (lo<j) qsindex(a , index , lo , j);
    if (i<hi) qsindex(a , index , i , hi);
}
/* --------------------------------------------------------------------------- */
void randini(UL seed)
 {
	 /* SHR3 Seed initialization */
	if(seed == (UL)NULL)
	{
		jsrseed  = (UL) time( NULL );
		jsr     ^= jsrseed;
	}
	else
	{
		jsr     = (UL)NULL;
		jsrseed = seed;
		jsr    ^= jsrseed;
	}
 }
/* --------------------------------------------------------------------------- */
void randnini(void) 
{	  
	register const double m1 = 2147483648.0 ;
	register double  invm1;
	register double dn = 3.442619855899 , tn = dn , vn = 9.91256303526217e-3 , q; 
	int i;

	/* Ziggurat tables for randn */	 
	
	invm1             = 1.0/m1;	
	q                 = vn/exp(-0.5*dn*dn);  
	kn[0]             = (dn/q)*m1;	  
	kn[1]             = 0;
	wn[0]             = q*invm1;	  
	wn[zigstep - 1 ]  = dn*invm1;
	fn[0]             = 1.0;	  
	fn[zigstep - 1]   = exp(-0.5*dn*dn);		
	
	for(i = (zigstep - 2) ; i >= 1 ; i--)      
	{   
		dn              = sqrt(-2.*log(vn/dn + exp(-0.5*dn*dn)));          
		kn[i+1]         = (dn/tn)*m1;		  
		tn              = dn;          
		fn[i]           = exp(-0.5*dn*dn);          
		wn[i]           = dn*invm1;      
	}
}
/* --------------------------------------------------------------------------- */
double nfix(void) 
{	
	const double r = 3.442620; 	/* The starting of the right tail */		
	static double x, y;
	
	for(;;)
	{
		x = hz*wn[iz];				
		if(iz == 0)
		{	/* iz==0, handle the base strip */
			do
			{	
				x = -log(rand())*0.2904764;  /* .2904764 is 1/r */  
				y = -log(rand());			
			} 
			while( (y + y) < (x*x));
			return (hz > 0) ? (r + x) : (-r - x);	
		}
		if( (fn[iz] + rand()*(fn[iz-1] - fn[iz])) < ( exp(-0.5*x*x) ) ) 
		{
			return x;
		}	
		hz = randint;		
		iz = (hz & (zigstep - 1));		
		if(abs(hz) < kn[iz]) 
		{
			return (hz*wn[iz]);	
		}
	}
}
/* --------------------------------------------------------------------------- */
double randn(void) 
{ 
		hz = randint;
		iz = (hz & (zigstep - 1));
		return (abs(hz) < kn[iz]) ? (hz*wn[iz]) : ( nfix() );
}
/* --------------------------------------------------------------------------- */



