% Editor : Sayed Abulhasan Quadri ,Research Associate 
% CEDEC , USM , Malaysia 
P = [-0.5 -0.5 +0.3 +0.0; -0.5 +0.5 -0.5 +1.0];
T = [1 1 0 0];
plotpv(P,T);
[W,b] = initp(P,T)
figure;
plotpv(P,T);
figure;
plotpc(W,b);
[W,b,epochs,errors] = trainp(W,b,P,T,-1);
figure ;
ploterr(errors);