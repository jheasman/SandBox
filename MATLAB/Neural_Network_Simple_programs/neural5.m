% Editor : Sayed Abulhasan Quadri ,Research Associate 
% CEDEC , USM , Malaysia 
% Classification with a 2-layer perceptron
% Using the above functions a two-layer perceptron can often classify non-linearly separable input
% vectors.
% The first layer acts as a non-linear preprocessor for the second layer. The second layer is trained as
% usual.
% DEFINING A CLASSIFICATION PROBLEM
% A matrix P defines ten 2-element input (column) vectors:
% P = [-0.5 -0.5 +0.3 -0.1 -0.8;
% -0.5 +0.5 -0.5 +1.0 +0.0];
% A matrix T defines the categories with target (column) vectors.
% T = [1 1 0 0 0];
% PLOTTING THE VECTORS TO CLASSIFY
% plotpv(P,T);
% The perceptron must properly classify the input 5 vectors in P into the 2 categories defined by T.
% Because the vectors are not linearly separable (you cannot draw a line between x's and o's) a single
% layer perceptron cannot classify them properly. We will try using a two-layer perceptron to classify
% them.
% DEFINE THE PERCEPTRON
% To maximize the chance that the preprocessing layer finds a linearly separable representation for the
% input vectors, it needs a lot of neurons. We will try 20.
% S1 = 20;
% INITP generates initial weights and biases for our network:
% [W1,b1] = initp(P,S1); Preprocessing layer
% [W2,b2] = initp(S1,T); Learning layer
% TRAINING THE PERCEPTRON
% TRAINP trains perceptrons to classify input vectors.
% The first layer is used to preprocess the input vectors:
% A1 = simup(P,W1,b1);
% TRAINP is the used to train the second layer to classify the preprocessed input vectors A1.
% [W2,b2,epochs,errors] = trainp(W2,b2,A1,T,-1);
% PLOTTING THE ERROR CURVE
% Here the errors are plotted with respect to training epochs:
% ploterr(errors);
% If the hidden (first) layer preprocessed the original non-linearly separable input vectors into new
% linearly separable vectors, then the perceptron will have 0 error. If the error never reached 0, it
% means a new preprocessing layer should be created (perhaps with more neurons). I.e. try running
% this script again.
% USING THE CLASSIFIER
% IF the classifier WORKED we can now classify any vector we like using SIMUP. Lets try an input
% vector of [0.7; 1.2]:
% p = [0.7; 1.2];
% a1 = simup(p,W1,b1); Preprocess the vector
% a2 = simup(a1,W2,b2) Classify the vector
% The program starts here 
P = [-0.5 -0.5 +0.3 -0.1 -0.8;
-0.5 +0.5 -0.5 +1.0 +0.0];
T = [1 1 0 0 0];
figure
plotpv(P,T);
S1 = 20;
[W1,b1] = initp(P,S1); 
[W2,b2] = initp(S1,T); 
A1 = simup(P,W1,b1);
[W2,b2,epochs,errors] = trainp(W2,b2,A1,T,-1);
figure 
ploterr(errors);
display(' see format for input below ')
display (' p = [0.7; 1.2]');
display ('a1 = simup(p,W1,b1); ')
display('a2 = simup(a1,W2,b2) ');