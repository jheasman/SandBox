clear all

disp(str2mat('', ...
'----------------------------------------------------------------------------' , ...
'STAT ANALYSIS OF US MACROECONOMIC DATA' , ...
'Author: Taras Chaban, 14-May-02' , ...
'Copyright (c) 2002 The MathWorks, Inc. All Rights Reserved.' , ...
'----------------------------------------------------------------------------' , ...
'' , ...
'Load 25 yrs of quarterly economic data: money supply, inflation, unemployment, etc.', ...
'Visualise raw data, visualise correlation matrix', ...
'Run PCA to reduce dimensionality of the data', ...
'Run regression on the reduced data set',''));

pause

load tvpmoney
data = tvpmoney;

close all

if 1
    % plotting
    for i = 2:2 %size(data,2)
        figure;
        plot(data(:,i));
        grid on;
        title(upper(vnames{i}));
        figure;
        hist(data(:,i), 50);
        title(upper(vnames{i}));
        for j = i+1:2 %size(data,2)
            figure;
            plot(data(:,i), data(:,j), 'ro');
            grid on;
            title([upper(vnames{i}) ' v ' upper(vnames{j})]);
        end
    end
end

if 1
    figure;
    imagesc(corrcoef(data)); colorbar
    title(upper('Correlation matrix'));
    if 0
        figure;
        imagesc(cov(data)); colorbar
        title(upper('Covariance matrix'));
    end
end

y = data(:,1);
x = [ones(length(y),1), data(:,2:end), data(:,2:end).^2, data(:,2:end).^3];

if 1
[loads, newData, vars] = princomp(x(:,2:end));
% in loads columns are components

perExp = 100*vars/sum(vars);

figure;
plot(cumsum(perExp),'o-')
grid on;
title('PERCENTAGE EXPLAINED');
xlabel('Principal Components')
ylabel('Percentage');

for i=1:1 %5
figure;
bar(loads(:,i))
grid on;
title(['Loadings in PC ',num2str(i)])
xlabel('Original variable index')
ylabel('Weight')
end

x = [ones(length(y),1), newData(:,1:10)];
end

if 1
    % simplest regression
    % b= x\y
    % b = (x'*x)^-1*x'*y
    if 0
        [b,bint,r,rint,stats] = regress(y,x,0.1);
        
        ypred = x*b;
        
        figure;
        plot(y)
        hold on; plot(ypred,'r')
        title('GROWTH RATE PREDICTION');
        legend('Original data','Predicted values');
        grid on;
        
        figure;
        plot(r)
        title('RESIDUALS');
        xlabel('Observations');
        ylabel('Residuals')
        grid on;
        
        sqrt(sum(r.^2))
            
    elseif 0
        
        totInd = 1:length(y);
        tstInd = [25:27 31:33 39 41:49 57 60 65 73 89 97 100 104:106];
        modInd = setdiff(totInd,tstInd);
        
        
        [b,bint,r,rint,stats] = regress(y(modInd),x(modInd,:),0.1);
        
        ytrain = x(modInd,:)*b;
        
        figure;
        plot(y(modInd))
        hold on; plot(ytrain,'r')
        title('GROWTH RATE MODEL');
        legend('Original data','Estimated values');
        grid on;
        
        figure;
        plot(y(modInd) - ytrain)
        title('RESIDUALS');
        xlabel('Observations');
        ylabel('Residuals')
        grid on;
        
        ypred = x(tstInd,:)*b;
        
        figure;
        plot(y(tstInd))
        hold on; plot(ypred,'r')
        title('GROWTH RATE PREDICTION');
        legend('Original data','Predicted values');
        grid on;
        
        figure;
        plot(y(tstInd) - ypred)
        title('RESIDUALS');
        xlabel('Observations');
        ylabel('Residuals')
        grid on;
       
        sum((y(tstInd) - ypred).^2)./length(ypred)
        
    else
        
        for i=length(y)-60:length(y)-1
            [b,bint,r,rint,stats] = regress(y(1:i),x(1:i,:),0.1);
            ypred(-length(y)+i+61) = x(i+1,:)*b;
            yreal(-length(y)+i+61) = y(i+1);            
        end
        
        figure;
        plot(yreal)
        hold on; plot(ypred,'r')
        title('GROWTH RATE PREDICTION');
        legend('Original data','Predicted values');
        grid on;
        
        if 0
            figure;
            plot(yreal - ypred)
            title('RESIDUALS');
            xlabel('Observations');
            ylabel('Residuals')
            grid on;
        end
    end
    
end

if 0
    % R^2,  F, p
    stats
    
    rcoplot(r,rint)
    
    % create artificial data to calculate PEV
    npnts = 10;
    v1 = 2;
    v2 = 3;
    v1 = linspace(round(min(x(:,v1))),round(max(x(:,v1))),npnts);
    v2 = linspace(round(min(x(:,v2))),round(max(x(:,v2))),npnts);
    [foo1, foo2] = ndgrid(v1,v2);
    
    mxv = round(mean(x(:,4:end)));
    
    x = [ones(length(foo1(:)),1), foo1(:), foo2(:), mxv(ones(length(foo1(:)),1),:)];
    % y = x*b;
    
    mxv = mean(x);
    
    sxx = sum(x.^2);
    
    rss = sum(r).^2;
    df = size(x,1)-2;
    
    sigsq = rss/df;
    
    pev = sigsq * (1 + 1./size(x,1) + (x - mxv(ones(size(x,1),1),:))./sxx(ones(size(x,1),1),:));
    
    % sigsq = y'*(1 - x*(x'*x)^-1*x')*y;
    % pev = x*(x'*x)^-1*x'*sigsq;
end
