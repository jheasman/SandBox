% Editor : Sayed Abulhasan Quadri ,Research Associate 
% CEDEC , USM , Malaysia 
% Linear networks
% Pattern association with a linear neuron
% Using the above functions a linear neuron is designed to respond to specific inputs with target
% outputs.
% DEFINING A PATTERN ASSOCATION PROBLEM
% P defines two 1-element input patterns (column vectors):
% P = [1.0 -1.2];
% T defines the associated 1-element targets (column vectors):
% T = [0.5 1.0];
% PLOTTING THE ERROR SURFACE AND CONTOUR
% ERRSURF calculates errors for a neuron with a range of possible weight and bias values. PLOTES
% plots this error surface with a contour plot underneath.
% w_range = -1:0.1:1;
% b_range = -1:0.1:1;
% ES = errsurf(P,T,w_range,b_range,'purelin');
% plotes(w_range,b_range,ES);
% The best weight and bias values are those that result in the lowest point on the error surface.
% DESIGN THE NETWORK
% The function SOLVELIN will find the weight and bias that result in the minimum error:
% ERRSURF(P,T,WV,BV,F)
% P - 1xQ matrix of input vectors.
% T - 1xQ matrix of target vectors.
% WV - Row vector of values of W.
% BV - Row vector of values of B.
% F - Transfer function (string).
% Returns a matrix of error values over WV and BV.
% PLOTES(WV,BV,ES,V)
% WV - 1xN row vector of values of W.
% BV - 1xM ow vector of values of B.
% ES - MxN matrix of error vectors.
% V - View, default = [-37.5, 30].
% Plots error surface with contour underneath.
% Calculate the error surface ES with ERRSURF.
% [w,b] = solvelin(P,T)
% CALCULATING THE NETWORK ERROR
% SIMULIN is used to simulate the neuron for inputs P.
% A = simulin(P,w,b);
% We can then calculate the neurons errors.
% E = T - A;
% SUMSQR adds up the squared errors.
% SSE = sumsqr(E)
% PLOT SOLUTION ON ERROR SURFACE
% PLOTES replots the error surface.
% plotes(w_range,b_range,ES);
% PLOTEP plots the "position" of the network using the weight and bias values returned by
% SOLVELIN.
% plotep(w,b,SSE)
% As can be seen from the plot, SOLVELIN found the minimum error solution.
% USING THE PATTERN ASSOCIATOR
% We can now test the associator with one of the original inputs, -1.2, and see if it returns the target,
% 1.0.
% p = -1.2;
% SOLVELIN Design linear network.
% [W,B] = SOLVELIN(P,T)
% P - RxQ matrix of Q input vectors.
% T - SxQ matrix of Q target vectors.
% Returns:
% W - SxR weight matrix.
% B - Sx1 bias vector.
% SIMULIN Simulate linear layer.
% SIMULIN(P,W,B)
% P - RxQ Matrix of input (column) vectors.
% W - SxR Weight matrix of the layer.
% B - Sx1 Bias (column) vector of the layer.
% Returns outputs of the perceptron layer.
% a = simulin(p,w,b)
% Use SIMLIN to check that the neurons response to 1.0 is 0.5.
%  program starts here 
P = [1.0 -1.2];
T = [0.5 1.0];
w_range = -1:0.1:1;
b_range = -1:0.1:1;
ES = errsurf(P,T,w_range,b_range,'purelin');
plotes(w_range,b_range,ES);
[w,b] = solvelin(P,T)
A = simulin(P,w,b);
E = T - A;
SSE = sumsqr(E)
figure
plotes(w_range,b_range,ES);
figure
plotep(w,b,SSE)
display(' see format for input below ')
display ('p = -1.2;')
display( 'a = simulin(p,w,b)')