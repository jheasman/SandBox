% Editor : Sayed Abulhasan Quadri ,Research Associate 
% CEDEC , USM , Malaysia 
% Classification with a 3-input perceptron
% Using the above functions a 3-input hard limit neuron is trained to classify 8 input vectors into two
% categories.
% DEFINING A CLASSIFICATION PROBLEM
% A matrix P defines eight 3-element input (column) vectors:
% P = [-1 +1 -1 +1 -1 +1 -1 +1;
% -1 -1 +1 +1 -1 -1 +1 +1;
% -1 -1 -1 -1 +1 +1 +1 +1];
% A row vector T defines the vector's target categories.
% T = [0 1 0 0 1 1 0 1];
% PLOTTING THE VECTORS TO CLASSIFY
% We can plot these vectors with PLOTPV:
% plotpv(P,T);
% The perceptron must properly classify the 4 input vectors in P into the two categories defined by T.
% DEFINE THE PERCEPTRON
% [W,b] = initp(P,T)
% INITIAL PERCEPTRON CLASSIFICATION
% The input vectors can be replotted...
% plotpv(P,T)
% ...with the neuron's initial attempt at classification.
% plotpc(W,b)
% The neuron probably does not yet make a good classification! Fear not...we are going to train it.
% TRAINING THE PERCEPTRON
% SIMUP Simulate perceptron layer.
% SIMUP(P,W,B)
% P - RxQ matrix of input (column) vectors.
% W - SxR weight matrix.
% B - Sx1 bias (column) vector.
% Returns outputs of the perceptron layer.
% [W,b,epochs,errors] = trainp(W,b,P,T,-1);
% PLOTTING THE ERROR CURVE
% Here the errors are plotted with respect to training epochs:
% ploterr(errors);
% USING THE CLASSIFIER
% We can now classify any vector using SIMUP. Lets try an input vector of [0.7; 1.2; -0.2]:
% p = [0.7; 1.2; -0.2];
% a = simup(p,W,b)
% Now, use SIMUP to see if [-1; +1; -1] is properly classified as a 0.
%  Now starts the program 

P = [-1 +1 -1 +1 -1 +1 -1 +1; -1 -1 +1 +1 -1 -1 +1 +1; -1 -1 -1 -1 +1 +1 +1 +1];
T = [0 1 0 0 1 1 0 1];
[W,b] = initp(P,T)
plotpv(P,T)
figure
plotpc(W,b)
[W,b,epochs,errors] = trainp(W,b,P,T,-1);
figure 
ploterr(errors);
display('check the network by giving the input seeing format below ')
display(' p = [0.7; 1.2; -0.2]');
display('a = simup(p,W,b)')