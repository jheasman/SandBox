% Editor : Sayed Abulhasan Quadri ,Research Associate 
% CEDEC , USM , Malaysia 
% Let us start with  Perceptron
%  Classification with a 2-input perceptron.
% SIMUP - Simulates a perceptron layer.
% TRAINP - Trains a perceptron layer with perceptron rule.
% Using the above functions a 2-input hard limit neuron is trained to classify 4 input vectors into two
% categories.
% DEFINING A CLASSIFICATION PROBLEM
% A row vector P defines four 2-element input vectors:
% P = [-0.5 -0.5 +0.3 +0.0;
% -0.5 +0.5 -0.5 +1.0];
% A row vector T defines the vector's target categories.
% T = [1 1 0 0];
% PLOTTING THE VECTORS TO CLASSIFY
% We can plot these vectors with PLOTPV:
% plotpv(P,T);
% The perceptron must properly classify the 4 input vectors in P into the two categories defined by T.
% DEFINE THE PERCEPTRON
% Perceptrons have HARDLIM neurons. These neurons are capable of separating an input pace with
% a straight line into two categories (0 and 1).
% INITP generates initial weights and biases for our neuron:
% [W,b] = initp(P,T)
% INITIAL PERCEPTRON CLASSIFICATION
% The input vectors can be replotted...
% plotpv(P,T)
% ...with the neuron's initial attempt at classification.
% INITP - Initializes a perceptron layer.
% [W,B] = INITP(P,T)
% P - RxQ matrix of input vectors.
% T - SxQ matrix of target outputs.
% Returns weights and biases.
% plotpc(W,b)
% The neuron probably does not yet make a good classification! Fear not...we are going to train it.
% TRAINING THE PERCEPTRON
% TRAINP trains perceptrons to classify input vectors.
% TRAINP returns new weights and biases that will form a better classifier. It also returns the number
% of epochs the perceptron was trained and the perceptron's errors throughout training.
% [W,b,epochs,errors] = trainp(W,b,P,T,-1);
% PLOTTING THE ERROR CURVE
% Here the errors are plotted with respect to training epochs:
% ploterr(errors);
% USING THE CLASSIFIER
% We can now classify any vector using SIMUP.
% Lets try an input vector of [-0.5; 0.5]:
% p = [-0.5; 0.5];
% a = simup(p,W,b)

% Program starts here 
P = [+0.1 +0.2 +0.3 +0.4 ; +0.5 +0.6 +0.3 +0.5 ];
T = [0.6 0.8 0.6 0.9 ];
 plot(P,T);
[W,b] = initp(P,T)
figure;
 plot(P,T);
 figure;
plotpc(W,b);
[W,b,epochs,errors] = trainp(W,b,P,T,1);
figure;
ploterr(errors)
display(' see below format to get output from trained network ')
display('p = [-0.5; 0.5];')
display ('a = simup(p,W,b)')