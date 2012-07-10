% Editor : Sayed Abulhasan Quadri ,Research Associate 
% CEDEC , USM , Malaysia 
% Classification with a 2-neuron perceptron
% Using the above functions a layer of 2 hard limit neurons is trained to classify 10 input vectors into
% 4 categories.
% DEFINING A CLASSIFICATION PROBLEM
% A matrix P defines ten 2-element input (column) vectors:
% P = [+0.1 +0.7 +0.8 +0.8 +1.0 +0.3 +0.0 -0.3 -0.5 -1.5; ...
% +1.2 +1.8 +1.6 +0.6 +0.8 +0.5 +0.2 +0.8 -1.5 -1.3];
% A matrix T defines the categories with target (column) vectors.
% T = [1 1 1 0 0 1 1 1 0 0;
% 0 0 0 0 0 1 1 1 1 1];
% PLOTTING THE VECTORS TO CLASSIFY
% plotpv(P,T);
% The perceptron must properly classify the 4 input vectors in P into the two categories defined by T.
% DEFINE THE PERCEPTRON
% A perceptron layer with two neurons is able to separate the input space into 4 different categories.
% [W,b] = initp(P,T)
% INITIAL PERCEPTRON CLASSIFICATION
% The input vectors can be replotted...
% plotpv(P,T)
% ...with the neuron's initial attempt at classification.
% plotpc(W,b)
% The neuron probably does not yet make a good classification! Fear not...we are going to train it.
% TRAINING THE PERCEPTRON
% [W,b,epochs,errors] = trainp(W,b,P,T,-1);
% PLOTTING THE ERROR CURVE
% Here the errors are plotted with respect to training epochs:
% ploterr(errors);
% USING THE CLASSIFIER
% We can now classify any vector we like using SIMUP. Lets try an input vector of [0.7; 1.2]:
% p = [0.7; 1.2];
% a = simup(p,W,b)
% Now, use SIMUP to see if [0.1; 1.2] is properly classified as [1; 0].
P = [+0.1 +0.7 +0.8 +0.8 +1.0 +0.3 +0.0 -0.3 -0.5 -1.5; +1.2 +1.8 +1.6 +0.6 +0.8 +0.5 +0.2 +0.8 -1.5 -1.3];
T = [1 1 1 0 0 1 1 1 0 0; 0 0 0 0 0 1 1 1 1 1];
plotpv(P,T);
[W,b] = initp(P,T)
plotpv(P,T)
figure
plotpc(W,b)
[W,b,epochs,errors] = trainp(W,b,P,T,-1);
figure 
ploterr(errors);
display('check the network by giving the input seeing format below ')
display('p = [0.7; 1.2]');
display('a = simup(p,W,b)')
