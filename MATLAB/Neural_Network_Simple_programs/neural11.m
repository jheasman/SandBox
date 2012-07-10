% Editor : Sayed Abulhasan Quadri ,Research Associate 
% CEDEC , USM , Malaysia 
% Backpropagation networks
% Pattern association with a linear neuron
% INITFF - Initializes a feed-forware network.
% TRAINBP - Trains a feed-forward network with backpropagation.
% SIMUFF - Simulates a feed-forward network.
% Using the above functions a neuron is trained to respond to specific inputs with target outputs.
% DEFINING A VECTOR ASSOCATION PROBLEM
% P defines two 1-element input vectors (column vectors):
% P = [-3.0 +2.0];
% T defines the associated 1-element targets (column vectors):
% T = [+0.4 +0.8];
% PLOTTING THE ERROR SURFACE AND CONTOUR
% ERRSURF calculates errors for a neuron with a range of possible weight and bias values. PLOTES
% plots this error surface with a contour plot underneath.
% wv = -4:0.4:4;
% bv = -4:0.4:4;
% es = errsurf(P,T,wv,bv,'logsig');
% plotes(wv,bv,es,[60 30]);
% The best weight and bias values are those that result in the lowest point on the error surface.
% DESIGN THE NETWORK
% INITFF is used to initialize the weights and biases for the LOGSIG neuron.
% [w,b] = initff(P,T,'logsig')
% TRAINING THE NETWORK
% TBP1 uses backpropagation to train 1-layer networks.
% df = 5; Frequency of progress displays (in epochs).
% me = 100; Maximum number of epochs to train.
% eg = 0.01; Sum-squared error goal.
% lr = 2; Learning rate.
% [w,b,ep,tr] = tbp1(w,b,'logsig',P,T,[df me eg lr],wv,bv,es,[60 30]);
% TRAINBP has returned new weight and bias values, the number of epochs trained EP, and a record of
% training errors TR.
% PLOTTING THE ERROR CURVE
% Here the errors are plotted with respect to training epochs:
% ploterr(tr,eg);
% INITFF Inititialize feed-forward network up to 3 layers.
% [W1,B1,...] = INITFF(P,S1,'F1',...,Sn,'Fn')
% P - Rx2 matrix of input vectors.
% Si - Size of ith layer.
% Fi - Transfer function of the ith layer (string).
% Returns:
% Wi - Weight matrix of the ith layer.
% Bi - Bias (column) vector of the ith layer.
% TBP1 Train 1-layer feed-forward network w/backpropagation.
% [W,B,TE,TR] = TBP1(W,B,F,P,T,TP)
% W - SxR weight matrix.
% B - Sx1 bias vector.
% F - Transfer function (string).
% P - RxQ matrix of input vectors.
% T - SxQ matrix of target vectors.
% TP - Training parameters (optional).
% Returns:
% W - new weights.
% B - new biases.
% TE - the actual number of epochs trained.
% TR - training record: [row of errors]
% Training parameters are:
% TP(1) - Epochs between updating display, default = 25.
% TP(2) - Maximum number of epochs to train, default = 1000.
% TP(3) - Sum-squared error goal, default = 0.02.
% TP(4) - Learning rate, 0.01.
% Missing parameters and NaN's are replaced with defaults.
% USING THE PATTERN ASSOCIATOR
% We can now test the associator with one of the original inputs, -3, and see if it returns the target, 0.4.
% p = -1.2;
% a = simuff(p,w,b,'logsig')
% Training to a lower error goal would reduce this error.
% Use SIMUP to check the neuron for an input of 2.0. The target response is 0.8
% Program starts here

P = [-3.0 +2.0];
T = [+0.4 +0.8];
wv = -4:0.4:4;
bv = -4:0.4:4;
es = errsurf(P,T,wv,bv,'logsig');
plotes(wv,bv,es,[60 30]);
[w,b] = initff(P,T,'logsig')
df = 5; 
me = 100; 
eg = 0.01; 
lr = 2; 
[w,b,ep,tr] = tbp1(w,b,'logsig',P,T,[df me eg lr],wv,bv,es,[60 30]);
figure;
ploterr(tr,eg);
