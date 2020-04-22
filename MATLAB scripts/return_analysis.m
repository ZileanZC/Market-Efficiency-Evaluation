load sse50
load fileNamesNum
load Beta_1

% load data from 2014-2018
% 1. Calculate the Beta and Alpha in Year.N(2013-2017)
% form 10 quantile portfolios by sorting all Betas from the smallest to the largest
% 2. Suppose that Beta won't change in Year.N+1 and analyze the portfolio
% returns for each day of Year.N+1

q=10;   %10-quantiles
basic=2013;
Num=length(fileNamesNum)/q;
Beta_mean=zeros(q+1,Num+1); Return=zeros(q+1,Num+1);

for Year=2014:2018
    
    Beta_seq=sortrows(Beta,Year-basic+1);
    [m,n]=find(Beta_seq(:,1)==0);
    size_1=fix((m-1)/q); size_2=rem(m-1,q);
    portfoliosList=zeros(Num+1,q); 
    portfoliosList(1,:)=1:10; Beta_mean(:,1)=0:10; Return(:,1)=0:10;
    Beta_mean(1,Year-basic+1)=Year-1;Return(1,Year-basic+1)=Year;

    for i=1:size_2
        a=0;
        for j=1:Num
            portfoliosList(j+1,i)=Beta_seq((i-1)*Num+j,1);
            a=a+Beta_seq((i-1)*Num+j,Year-basic+1);
        end % end for j
        a=a/Num;
        Beta_mean(i+1,Year-basic+1)=a;
    end % end for i
    
    div=size_2*Num;
    
    for i=size_2+1:q
        a=0;
        for j=1:size_1
            portfoliosList(j+1,i)=Beta_seq(div+(Num-1)*(i-size_2-1)+j,1);
            a=a+Beta_seq(div+(Num-1)*(i-size_2-1)+j,Year-basic+1);
        end % end for j
        a=a/size_1;
        Beta_mean(i+1,Year-basic+1)=a;
    end % end for i
    
    % Calculate Return
    
    for x=1:q
        startDay=0; endDay=0;
        for y=2:Num+1
            if portfoliosList(y,x)>=6e5
                stock_code=mat2str(portfoliosList(y,x));
                temp=tencent_history(stock_code,Year);
                endDay=endDay+temp(end,3);startDay=startDay+temp(1,3);
            end % end if
        end % end for y=1:Num
        % Annual Return
        annualReturn=(endDay-startDay)/startDay;
        Return(x+1,Year-basic+1)=annualReturn;
    end % end for x=1:q
    
end % end Year

averageReturn=zeros(1,10);
for i=1:q
    R=Return(i+1,2:end);
    averageReturn(1,i)=mean(R);
end
bar(averageReturn)
title('Average Return in 2014-2018')
xlabel('Portfolios Num')
ylabel('Average Return')
