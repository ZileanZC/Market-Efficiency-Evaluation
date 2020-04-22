function [stock_data_history]=tencent_history(stock_code,year_num)

% stock_code='600000';year_num=2017;

if str2num(stock_code)>=6e5
    stock_tencent=['sh',stock_code];
else
    stock_tencent=['sz',stock_code];
end

% Data Acquirement
year_str=num2str(year_num);

% urlRead1=['http://quotes.money.163.com/service/chddata.html?code=0000300&start=20151219&end=20171108&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;VOTURNOVER'];
urlRead=['http://data.gtimg.cn/flashdata/hushen/daily/',year_str(end-1:end),'/',stock_tencent,'.js'];

[s,status]=urlread(urlRead);

if status~=0
    cell1=strread(s,'%s','delimiter','\n');
    
            % Data Extracts
        if length(cell1)>0
            l1=length(cell1);
            stock_data_history=zeros(l1-2,6);

            for i=2:l1-1
                cell2=strread(cell1{i},'%s','delimiter','');
                a=char(cell2{1});
                m=find(a==' ');
                a1=str2num(a(1:m(1)-1));
                stock_data_history(i-1,1)=str2num(a(1:m(1)-1));
                stock_data_history(i-1,2)=str2num(a(m(1)+1:m(2)-1));
                stock_data_history(i-1,3)=str2num(a(m(2)+1:m(3)-1));
                stock_data_history(i-1,4)=str2num(a(m(3)+1:m(4)-1));
                stock_data_history(i-1,5)=str2num(a(m(4)+1:m(5)-1));
                stock_data_history(i-1,6)=str2num(a(m(5)+1:end-3));
            end
        else
                disp('acquirement failure, please recheck')
                stock_data_history=0;
        end
    
else
    disp('acquirement failure, please recheck')
    stock_data_history=0;
end

end
    