% Editor : Sayed Abulhasan Quadri ,Research Associate 
% CEDEC , USM , Malaysia
% Linear prediction
% SOLVELIN - Solves for a linear layer.
% SIMULIN - Simulates a linear layer.
% Using the above functions a linear neuron is designed to predict the next value in a signal, given the
% last five values of the signal.
% DEFINING A WAVE FORM
% TIME defines the time steps of this simulation.
% time = 0:0.025:5; from 0 to 6 seconds
% T defines the signal in time to be predicted:
% T = sin(time*4*pi);
% The input P to the network is the last five values of the signal T:
% P = delaysig(T,1,5);
% DELAYSIG Create delayed signal matrix from signal matrix.
% DELAYSIG(X,D)
% X - SxT matrix with S-element column vectors for T timesteps.
% D - Maximum delay.
% Returns signal X delayed by 0, 1, ..., and D2 timesteps.
% DELAYSIG(X,D1,D2)
% X - SxT matrix with S-element column vectors for T timesteps.
% D1 - Minimum delay.
% D2 - Maximum delay.
% Returns signal X delayed by D1, D1+1, ..., and D2 timesteps.
% The signal X can be a row vector of values, or a matrix
% of (column) vectors.
% PLOTTING THE SIGNALS
% Here is a plot of the signal to be predicted:
% plot(time,T)
% alabel('Time','Target Signal','Signal to be Predicted')
% SOLVELIN solves for weights and biases which will let the linear neuron model the system.
% [w,b] = solvelin(P,T)
% TESTING THE PREDICTOR
% SIMULIN simulates the linear neuron, which attempts to predict the next value in the signal at each
% timestep.
% a = simulin(P,w,b);
% The output signal is plotted with the targets.
% plot(time,a,time,T,'+')
% alabel('Time','Output _ Target +','Output and Target Signals')
% The linear neuron does a good job, doesn’t it?
% Error is the difference between output and target signals.
% e = T-a;
% This error can be plotted.
% plot(time,e)
% hold on
% plot([min(time) max(time)],[0 0],':r')
% hold off
% alabel('Time','Error','Error Signal')
% program starts here 
% Notice how small the error is!
time = 0:0.025:5; 
T = sin(time*4*pi);
P = delaysig(T,1,5);
figure;
plot(time,T)
alabel('Time','Target Signal','Signal to be Predicted')
[w,b] = solvelin(P,T)
a = simulin(P,w,b);
figure;
plot(time,a,time,T,'+')
alabel('Time','Output _ Target +','Output and Target Signals')
e = T-a;
figure;
plot(time,e)
hold on
plot([min(time) max(time)],[0 0],':r')
hold off
alabel('Time','Error','Error Signal')