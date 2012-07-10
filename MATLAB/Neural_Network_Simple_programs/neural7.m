% Editor : Sayed Abulhasan Quadri ,Research Associate 
% CEDEC , USM , Malaysia 
% Training a linear layer
% INITLIN - Initializes a linear layer.
% TRAINWH - Trains a linear layer with Widrow-Hoff rule.
% SIMULIN - Simulates a linear layer.
% Using the above functions a linear layer is trained to respond to specific inputs with target outputs.
% DEFINING A PATTERN ASSOCATION PROBLEM
% P defines four 3-element input patterns (column vectors):
% P = [+1.0 +1.5 +1.2 -0.3
% -1.0 +2.0 +3.0 -0.5
% +2.0 +1.0 -1.6 +0.9];
% T defines associated 4-element targets (column vectors):
% T = [+0.5 +3.0 -2.2 +1.4
% +1.1 -1.2 +1.7 -0.4
% +3.0 +0.2 -1.8 -0.4
% -1.0 +0.1 -1.0 +0.6];
% DEFINE THE NETWORK
% INITLIN generates initial weights and biases for our neuron:
% [W,b] = initlin(P,T);
% TRAINING THE NETWORK
% TRAINWH uses the Widrow-Hoff rule to train PURELIN networks.
% me = 400; Maximum number of epochs to train.
% eg = 0.001; Sum-squared error goal.
% [W,b,epochs,errors] = trainwh(W,b,P,T,[NaN me eg NaN]);
% The plot shows the final error met the error goal.
% PLOTTING INDIVIDUAL ERRORS
% BARERR creates a bar plot of errors associated with
% barerr(T-simulin(P,W,b))
% Note that while the sum of these squared errors is less than our error goal, the individual errors are
% not the same.
% USING THE PATTERN ASSOCIATOR
% We can now test the associator with one of the original input vectors [1; -1; 2], and see if it returns
% the appropriate target vector [0.5; 1.1; 3; -1].
% p = [1; -1; 2];
% a = simulin(p,W,b)
% Use SIMULIN to check that the neuron response to [1.5; 2; 1] is the target response [3; -1.2; 0.2;
% 0.1].
%  Program starts here 
P = [+1.0 +1.5 +1.2 -0.3 -1.0 +2.0 +3.0 -0.5 +2.0 +1.0 -1.6 +0.9];
 T = [+0.5 +3.0 -2.2 +1.4 +1.1 -1.2 +1.7 -0.4 +3.0 +0.2 -1.8 -0.4 ];
%T = [+0.5 +3.0 -2.2 +1.4 +1.1 -1.2 +1.7 -0.4 +3.0 +0.2 -1.8 -0.4 -1.0 +0.1 -1.0 +0.6];
[W,b] = initlin(P,T);
me = 400; 
eg = 0.001;
[W,b,epochs,errors] = trainwh(W,b,P,T,[NaN me eg NaN]);
barerr(T-simulin(P,W,b))
display(' see format for input below ')
display('p = [1; -1; 2];')
display('a = simulin(p,W,b)')