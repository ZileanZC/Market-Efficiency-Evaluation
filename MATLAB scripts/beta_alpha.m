clear;
clc;

%%  ��ȡsse50�ɷֹ�֤ȯ��ţ��洢ΪfileNamesNum

fileFolder=fullfile('G:\MS\Beta&Alpha\xls');
dirOutput=dir(fullfile(fileFolder,'*.xls'));%������ڲ�ͬ���͵��ļ����á�*����ȡ���У������ȡ�ض������ļ���'.'�����ļ����ͣ������á�.jpg��
fileNames={dirOutput.name}';
[r,c]=size(fileNames);
fileNamesNum=zeros(r,c);
for i=1:r
    a=char(fileNames(i,1));
    A=a(isstrprop(a,'digit'));
    B=str2double(A);
    fileNamesNum(i,1)=B;
end

%%  ��ȡsse50�б� ת��Ϊ����������

load sse50
Rate=price2ret(sse50);

%%  ����beta�Լ�alpha����

Beta=zeros(r,2);
Alpha=zeros(r,3);

for i=1:r
    %��ȡ��֤50ָ�����ɷֹ���Ϣ����֤ȯ��Ŵ�С��������
    
    A=fileNamesNum(i,1);
    %�ļ���Ϣ
    B=char(fileNames(i,1));
    tmp='xls\';
    B=[tmp,B];
    [status,sheets,format]=xlsfinfo(B);
    %��ȡ����
    [num,txt,raw]=xlsread(B);
    [Rs,Cs]=size(num);
    
    Date=zeros(Rs,1);

            % �ַ�ת������
            for tmp=1:Rs
                c=char(txt(tmp+1,2));
                Date_tmp=c(isstrprop(c,'digit'));
                DateNum=str2double(Date_tmp);
                Date(tmp,1)=DateNum;
            end
            
            a=20170101;b=20171231;
            %if Date(1,1)<=a 
                
            %end
            

%% ���������� ִ�����¼���    
    
    %Trddt�������ڣ�Clsprc�������̼ۣ������̼�����������������
    a=char(txt(2,2));
    b=char(txt(end,2));
    StartDate=a(isstrprop(a,'digit'));EndDate=b(isstrprop(b,'digit'));
    StartDateNum=str2double(StartDate);EndDateNum=str2double(EndDate);
    
    
    %��sse50 �ӿ�ʼ����ֹ���ڵ�����Ϊ��������
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
    
    %�ɷֹ���Ч����
    deltaDays=length(txt)-1;
    
    %formatIn = 'yyyy-mmm-dd';
    %StartDay=datenum(txt(2,2),formatIn);EndDay=datenum(txt(end,2),formatIn);

    if deltaDays<=len

            Date=zeros(deltaDays,1);

            % �ַ�ת������
            for tmp=1:deltaDays
                c=char(txt(tmp+1,2));
                Date_tmp=c(isstrprop(c,'digit'));
                DateNum=str2double(Date_tmp);
                Date(tmp,1)=DateNum;
            end

           StockClosingPrice=[Date num(:,4)];
           Rate_Stock=price2ret(StockClosingPrice(:,2)); 
           % TEST=[StockClosingPrice [Rate_Stock;NaN]];

           %ȡ��sse50��������֮ƥ��Ĳ��ּ���Beta
           
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
            
            %��һ��  
            %subplot(2,2,1)
            %plot(StockClosingPrice(:,2)/StockClosingPrice(1,2))
           %����������
            %subplot(2,2,3)
            %plot(Rate_Stock)

           %��һ��  
            %subplot(2,2,2)
            %plot(sse50_tmp(:,2)/sse50_tmp(1,2))
           %����������
            %subplot(2,2,4)
            %plot(Rate_tmp)
            
        else
           Date=MarketDate;
           StockClosingPrice=zeros(len,2); %#ok<PREALL>
           StockDate=zeros(deltaDays,1);% ���ڸ�ʽת��

            %ȡ sse50 ����
            sse50_tmp1=zeros(len,1);
            for k=1:len;
            sse50_tmp1(k,1)=sse50(k+mark-1,2);
            end
            sse50_tmp=[Date sse50_tmp1];
           
           %ȡ �ɷֹ� ����
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
           
           % ���ⲹ��
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

           %��һ��  
            %subplot(2,2,1)
            %plot(StockClosingPrice(:,2)/StockClosingPrice(1,2))
           %����������
            %subplot(2,2,3)
            %plot(Rate_Stock)
            
           %��һ��  
            %subplot(2,2,2)
            %plot(sse50_tmp(:,2)/sse50_tmp(1,2))
           %����������
            %subplot(2,2,4)
            %plot(Rate_tmp)
            
    end
%% ����ɷֹɵ�beta
    beta_tmp=portbeta(Rate_tmp,Rate_Stock);
    Beta(i,1)=fileNamesNum(i,1);
    Beta(i,2)=beta_tmp;
    
%% ����alpha�;������յ���������
    %Ĭ���޷�����������
    Cash=zeros(length(Rate_tmp),1);
    %����û�о������յ����ر���alpha
    [alpha,RAReturn]=portalpha(Rate_Stock,Rate_tmp,Cash,'xs');
    %���㾭�����յ����ر���alpha
    [alpha_tmp,RAReturn_tmp]=portalpha(Rate_Stock,Rate_tmp,Cash,'capm');
    Alpha(i,1)=fileNamesNum(i,1);
    Alpha(i,2)=alpha;
    Alpha(i,3)=alpha_tmp;
end

save Beta Beta
save Alpha Alpha
