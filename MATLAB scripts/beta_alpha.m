clear;
clc;

%%  读取sse50成分股证券编号，存储为fileNamesNum

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

%%  读取sse50列表 转化为收益率序列

load sse50
Rate=price2ret(sse50);

%%  计算beta以及alpha矩阵

Beta=zeros(r,2);
Alpha=zeros(r,3);

for i=1:r
    %获取上证50指数各成分股信息，按证券编号从小到大排列
    
    A=fileNamesNum(i,1);
    %文件信息
    B=char(fileNames(i,1));
    tmp='xls\';
    B=[tmp,B];
    [status,sheets,format]=xlsfinfo(B);
    %读取数据
    [num,txt,raw]=xlsread(B);
    [Rs,Cs]=size(num);
    
    Date=zeros(Rs,1);

            % 字符转换数字
            for tmp=1:Rs
                c=char(txt(tmp+1,2));
                Date_tmp=c(isstrprop(c,'digit'));
                DateNum=str2double(Date_tmp);
                Date(tmp,1)=DateNum;
            end
            
            a=20170101;b=20171231;
            %if Date(1,1)<=a 
                
            %end
            

%% 若符合条件 执行以下计算    
    
    %Trddt代表日期，Clsprc代表收盘价，以收盘价来计算收益率序列
    a=char(txt(2,2));
    b=char(txt(end,2));
    StartDate=a(isstrprop(a,'digit'));EndDate=b(isstrprop(b,'digit'));
    StartDateNum=str2double(StartDate);EndDateNum=str2double(EndDate);
    
    
    %以sse50 从开始到截止日期的数据为总量上限
    for t=1:length(sse50)
        if StartDateNum==sse50(t,1)
            mark=t;
            len=length(sse50)-t+1;
        end
    end
    
    MarketDate=zeros(len,1);
    for t=1:len
        MarketDate(t,1)=sse50(t+mark-1,1);
    end
    
    %成分股有效天数
    deltaDays=length(txt)-1;
    
    %formatIn = 'yyyy-mmm-dd';
    %StartDay=datenum(txt(2,2),formatIn);EndDay=datenum(txt(end,2),formatIn);

    if deltaDays<=len

            Date=zeros(deltaDays,1);

            % 字符转换数字
            for tmp=1:deltaDays
                c=char(txt(tmp+1,2));
                Date_tmp=c(isstrprop(c,'digit'));
                DateNum=str2double(Date_tmp);
                Date(tmp,1)=DateNum;
            end

           StockClosingPrice=[Date num(:,4)];
           Rate_Stock=price2ret(StockClosingPrice(:,2)); 
           % TEST=[StockClosingPrice [Rate_Stock;NaN]];

           %取出sse50矩阵中与之匹配的部分计算Beta
           
            sse50_tmp=zeros(deltaDays-1,2);
            for j=1:length(sse50)
                if StartDateNum==sse50(j,1) 
                    tmp=j;
                end
            end

            for j=1:deltaDays
                    sse50_tmp(j,1)=Date(j,1);
                    sse50_tmp(j,2)=sse50(j+tmp-1,2);
            end

            Rate_tmp=price2ret(sse50_tmp(:,2));
            
            %归一化  
            %subplot(2,2,1)
            %plot(StockClosingPrice(:,2)/StockClosingPrice(1,2))
           %收益率序列
            %subplot(2,2,3)
            %plot(Rate_Stock)

           %归一化  
            %subplot(2,2,2)
            %plot(sse50_tmp(:,2)/sse50_tmp(1,2))
           %收益率序列
            %subplot(2,2,4)
            %plot(Rate_tmp)
            
        else
           Date=MarketDate;
           StockClosingPrice=zeros(len,2); %#ok<PREALL>
           StockDate=zeros(deltaDays,1);% 日期格式转换

            %取 sse50 矩阵
            sse50_tmp1=zeros(len,1);
            for k=1:len;
            sse50_tmp1(k,1)=sse50(k+mark-1,2);
            end
            sse50_tmp=[Date sse50_tmp1];
           
           %取 成分股 数据
           for j=1:deltaDays
            A=char(txt(j+1,2));
            D=A(isstrprop(A,'digit'));
            D=str2double(D);
            StockDate(j,1)=D;
           end

           for j=1:deltaDays
               m=0;n=0;
               k= StockDate(j,1);
               [m,n]=find(Date==k);
               if m~=0
                   StockClosingPrice(m,1)=k;
                   StockClosingPrice(m,2)=num(j,4);
               end

           end
           %plot(StockClosingPrice(:,2))
           
           % 额外补充
           mark_1=0;
           for k=1:length(StockClosingPrice)
            if StockClosingPrice(k,1)==0
               mark_1=mark_1+1;
               mark_2=k;
            end
           end
           for k=1:mark_1
               StockClosingPrice(mark_2-mark_1+1,:)=[];
               sse50_tmp(mark_2-mark_1+1,:)=[];
           end
           
           Rate_Stock=price2ret(StockClosingPrice(:,2));
           Rate_tmp=price2ret(sse50_tmp(:,2));
           % TEST=[StockClosingPrice [Rate_Stock;NaN]];

           %归一化  
            %subplot(2,2,1)
            %plot(StockClosingPrice(:,2)/StockClosingPrice(1,2))
           %收益率序列
            %subplot(2,2,3)
            %plot(Rate_Stock)
            
           %归一化  
            %subplot(2,2,2)
            %plot(sse50_tmp(:,2)/sse50_tmp(1,2))
           %收益率序列
            %subplot(2,2,4)
            %plot(Rate_tmp)
            
    end
%% 计算成分股的beta
    beta_tmp=portbeta(Rate_tmp,Rate_Stock);
    Beta(i,1)=fileNamesNum(i,1);
    Beta(i,2)=beta_tmp;
    
%% 计算alpha和经过风险调整的收益
    %默认无风险利率置零
    Cash=zeros(length(Rate_tmp),1);
    %计算没有经过风险调整回报的alpha
    [alpha,RAReturn]=portalpha(Rate_Stock,Rate_tmp,Cash,'xs');
    %计算经过风险调整回报的alpha
    [alpha_tmp,RAReturn_tmp]=portalpha(Rate_Stock,Rate_tmp,Cash,'capm');
    Alpha(i,1)=fileNamesNum(i,1);
    Alpha(i,2)=alpha;
    Alpha(i,3)=alpha_tmp;
end

save Beta Beta
save Alpha Alpha
