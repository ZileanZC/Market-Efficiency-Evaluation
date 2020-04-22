clear;
clc;

%%  load sse50 stock numbers，save as fileNamesNum.mat

fileFolder=fullfile('G:\MS\Beta&Alpha\xls');
dirOutput=dir(fullfile(fileFolder,'*.xls'));%如果存在不同类型的文件，用‘*’读取所有，如果读取特定类型文件，'.'加上文件类型，例如用‘.jpg’
fileNames={dirOutput.name}';
[r,c]=size(fileNames);
fileNamesNum=zeros(r,c);
for i=1:r
    a=char(fileNames(i,1));
    A=a(isstrprop(a,'digit'));
    B=str2double(A);
    fileNamesNum(i,1)=B;
end
% a=2e7;

%%  Load sse50 && Calculate Continuous Growth Rate

load sse50
sse50_Date=rem(sse50(:,1),2e7);
Rate=price2ret(sse50);

%%  Calculate Beta and Alpha

    % Create Matrix for Beta & Alpha
    Beta=zeros(length(fileNamesNum)+1,6);
    Alpha=zeros(length(fileNamesNum)+1,6);

for Year=2013:2017
% Year=2017;
    
    Beta(1,Year-2012+1)=Year;
    Alpha(1,Year-2012+1)=Year;
    
    for i=1:length(fileNamesNum)
        
        stockName=fileNamesNum(i);
        Beta(i+1,1)=stockName;Alpha(i+1,1)=stockName;
        temp=mat2str(stockName);
        stockInfo=tencent_history(temp,Year);
        stock_Date=stockInfo(:,1);   %Stock Dates Array
        
        % x=rem(Year,2000);y=fix(stockInfo(1,1)/1e4);
        if stockInfo~=0
        
        finalTable=zeros(length(stock_Date),3);
        
            for j=1:length(stock_Date)
                a=stock_Date(j);

                if find(sse50_Date==a)
                    [m,n]=find(sse50_Date==a);
                    finalTable(j,1)=a;
                    finalTable(j,2)=sse50(m,2);
                    finalTable(j,3)=stockInfo(j,3);
                else
                    finalTable(j,:)=0;
                end

            end     % end for j
            
            % Delete 0
                [p,q]=find(~finalTable(:,1));
                if p
                         finalTable(p,:)=[];
                end
            
            % Calculate Rate of Return
            Rate_sse50=ret(finalTable(:,2));
            Rate_stock=ret(finalTable(:,3));
            
            % Calculate Beta & Alpha
            beta_tmp=portbeta(Rate_sse50,Rate_stock);
            Beta(i+1,Year-2012+1)=beta_tmp;
            
            % set risk-free rate 0
            Cash=zeros(length(Rate_sse50),1);
            % Calculate alpha without risk-adjusted return
            % [alpha,RAReturn]=portalpha(Rate_Stock,Rate_sse50,Cash,'xs');
            % Calculate alpha with risk-adjusted return
            [alpha_tmp,RAReturn_tmp]=portalpha(Rate_stock,Rate_sse50,Cash,'capm');

            Alpha(i+1,Year-2012+1)=alpha_tmp;

        else
            
            % data acquirement failed
            Beta(i+1,Year-2012+1)=NaN;Alpha(i+1,Year-2012+1)=NaN;
            
        end     % end if StockInfo~=0
    
    end         % end for i
end             % end for Year
save Beta_1 Beta
save Alpha_1 Alpha
filename = 'testdata.xlsx';
% [status,message]=xlswrite(filename,Alpha);




