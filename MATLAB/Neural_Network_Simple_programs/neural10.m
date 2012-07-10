% Editor : Sayed Abulhasan Quadri ,Research Associate 
% CEDEC , USM , Malaysia
% Adaptive linear prediction
% INITLIN - Initializes a linear layer.
% ADAPTWH - Trains a linear layer with Widrow-Hoff rule.
% Using the above functions a linear neuron is adaptively trained to predict the next value in a signal,
% given the last five values of the signal.
% The linear neuron is able to adapt to changes in the signal it is trying to predict.
% DEFINING A WAVE FORM
% TIME1 and TIME2 define two segments of time.
% time1 = 0:0.05:4; from 0 to 4 seconds
% time2 = 4.05:0.024:6; from 4 to 6 seconds
% TIME defines all the time steps of this simulation.
% time = [time1 time2]; from 0 to 6 seconds
% T defines a signal which changes frequency once:
% T = [sin(time1*4*pi) sin(time2*8*pi)];
% The input P to the network is the last five values of the target signal:
% P = delaysig(T,1,5);
% PLOTTING THE SIGNALS
% Here is a plot of the signal to be predicted:
% plot(time,T)
% alabel('Time','Target Signal','Signal to be Predicted')
% DEFINE THE NETWORK
% INITLIN generates initial weights and biases for our neuron:
% [w,b] = initlin(P,T)
% ADAPTING THE LINEAR NEURON
% ADAPTWH simulates adaptive linear neurons. It takes initial weights and biases, an input signal,
% and a target signal, and filters the signal adaptively. The output signal and the error signal are
% returned, along with new weights and biases.
% We will user a learning rate of 0.1.
% lr = 0.1;
% [a,e,w,b] = adaptwh(w,b,P,T,lr);
% ADAPTWH Adapt linear layer with Widrow-Hoff rule.
% [A,E,W,B] = ADAPTWH(W,B,P,T,lr)
% W - SxR weight matrix.
% B - Sx1 bias vector.
% P - RxQ matrix of input vectors.
% T - SxQ matrix of target vectors.
% lr - Learning rate (optional, default = 0.1).
% Returns:
% A - output of adaptive linear filter.
% E - error of adaptive linear filter.
% W - new weight matrix
% B - new weights & biases.
% PLOTTING THE OUTPUT SIGNAL
% Here the output signal of the linear neuron is plotted with the target signal.
% plot(time,a,time,T,'--')
% alabel('Time','Output ___ Target _ _','Output and Target Signals')
% It does not take the adaptive neuron long to figure out how to generate the target signal.
% A plot of the difference between the neurons output signal and the target signal shows how well the
% adaptive neuron works.
% plot(time,e,[min(time) max(time)],[0 0],':r')
% alabel('Time','Error','Error Signal')
% Program starts here 

time1 = 0:0.05:4; 
time2 = 4.05:0.024:6; 
time = [time1 time2]; 

T = [sin(time1*4*pi) sin(time2*8*pi)];

P = delaysig(T,1,5);

plot(time,T)
alabel('Time','Target Signal','Signal to be Predicted')
[w,b] = initlin(P,T)
lr = 0.1;
[a,e,w,b] = adaptwh(w,b,P,T,lr);
figure;
plot(time,a,time,T,'--')
alabel('Time','Output ___ Target _ _','Output and Target Signals')
figure;
plot(time,e,[min(time) max(time)],[0 0],':r')
alabel('Time','Error','Error Signal')