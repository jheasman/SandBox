% Editor : Sayed Abulhasan Quadri ,Research Associate 
% CEDEC , USM , Malaysia 
% Adaptive linear layer
% INITLIN - Initializes a linear layer.
% ADAPTWH - Trains a linear layer with Widrow-Hoff rule.
% Using the above functions a linear neuron is allowed to adapt so that, given one signal, it can predict
% a second signal.
% DEFINING A WAVE FORM
% TIME defines the time steps of this simulation.
% time = 1:0.0025:5;
% P defines a signal over these time steps:
% P = sin(sin(time).*time*10);
% T is a signal which is linearly related to P:
% T = P * 2 + 2;
% PLOTTING THE SIGNALS
% Here is how the two signals are plotted:
% plot(time,P,time,T,'--')
% title('Input and Target Signals')
% xlabel('Time')
% ylabel('Input ___ Target _ _')
% DEFINE THE NETWORK
% [w,b] = initlin(P,T)
% ADAPTING THE LINEAR NEURON
% ADAPTWH simulates adaptive linear neurons. It takes initial weights and biases, an input signal,
% and a target signal, and filters the signal adaptively. The output signal and the error signal are
% returned, along with new weights and biases.
% lr = 0.01; Learning rate.
% [a,e,w,b] = adaptwh(w,b,P,T,lr);
% PLOTTING THE OUTPUT SIGNAL
% Here the output signal of the linear neuron is plotted with the target signal.
% plot(time,a,time,T,'--')
% title('Output and Target Signals')
% xlabel('Time')
% ylabel('Output ___ Target _ _')
% It does not take the adaptive neuron long to figure out how to generate the target signal.
% PLOTTING THE ERROR SIGNAL
% A plot of the difference between the neurons output signal and the target shows how well the
% adaptive neurons works.
% plot(time,e)
% hold on
% plot([min(time) max(time)],[0 0],':r')
% hold off
% title('Error Signal')
% xlabel('Time')
% ylabel('Error')
% program starts here 

time = 1:0.0025:5;
P = sin(sin(time).*time*10);
T = P * 2 + 2;
figure
plot(time,P,time,T,'--')
title('Input and Target Signals')
xlabel('Time')
ylabel('Input ___ Target _ _')
[w,b] = initlin(P,T)
lr = 0.01; 
[a,e,w,b] = adaptwh(w,b,P,T,lr);
figure
plot(time,a,time,T,'--')
title('Output and Target Signals')
xlabel('Time')
ylabel('Output ___ Target _ _')
figure
plot(time,e)
hold on
plot([min(time) max(time)],[0 0],':r')
hold off
title('Error Signal')
xlabel('Time')
ylabel('Error')