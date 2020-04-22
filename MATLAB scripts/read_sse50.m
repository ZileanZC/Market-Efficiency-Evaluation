
%文件信息
[status,sheets,format]=xlsfinfo('N00016.xls');
%读取数据
[num,txt,raw]=xlsread('N00016.xls');
sse50=flipud(num);
[r,c]=size(num);
Date=datenum(sse50(1:end,1));

save sse50 sse50

load sse50
figure
hold on
a=sse50(r,2);
subplot(2,1,1)
%归一化
plot(sse50(:,2)/sse50(1,2))
title('归一化净收益指数收盘价 Normalization Net Return Index')
xlabel('Days')
ylabel('Normalization Index')
subplot(2,1,2)
%收益率序列
% Rate=price2ret(sse50(:,2));
Rate=ret(sse50(:,2));
plot(Rate)
title('收益率序列 Return Series')
xlabel('Days')
ylabel('Return Rate')