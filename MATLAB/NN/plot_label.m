function plot_label(Xtrain , ytrain , markersize , Xtest , ytest)

if ((nargin < 3) ||isempty(markersize))

    markersize = 6;

end


if(nargin < 2)

    ytrain   = zeros(1 , size(Xtrain , 2));

end

label   = unique(ytrain);

n_class = length(label);

colors  = repmat('brkgymc' , 1 , 6*7);

markers  = reshape(repmat('.ox+*sd' , 6 , 1) , 1 , 6*7);



for i=1:n_class

    indtrain = (ytrain==label(i));
   
    plot(Xtrain(1,indtrain) , Xtrain(2,indtrain),[colors(i) markers(i)],'MarkerSize',markersize);
    
   hold on

end


if((nargin > 3) && (nargin < 6))

    label   = unique(ytest);

    n_class = length(label);

    markers = reshape(repmat('+x*sd.o' , 6 , 1) , 1 , 6*7);

    for i=1:n_class

        indtest = (ytest==label(i));

        plot(Xtest(1,indtest) , Xtest(2,indtest),[colors(i) markers(i)],'MarkerSize',markersize);

    end

end


hold off
