load sse50
load fileNamesNum
load Beta

fileFolder=fullfile('G:\MS\Beta&Alpha\xls');
dirOutput=dir(fullfile(fileFolder,'*.xls'));%������ڲ�ͬ���͵��ļ����á�*����ȡ���У������ȡ�ض������ļ���'.'�����ļ����ͣ������á�.jpg��
fileNames={dirOutput.name}';

Beta_seq=sortrows(Beta,2);
fileNames_seq=zeros(length(Beta_seq),1);

fileNames_seq(:,1)=Beta_seq(:,1);
fileNames_seq1=[];
% beta=[Beta Beta_seq];
for i=1:length(fileNames_seq)
    A=num2str(fileNames_seq(i,1));
    B='.xls';
    A=strcat(A,B);
    fileNames_seq1=[fileNames_seq1;A];
end


for i=1:10
    for j=1:5
        toread=(i-1)*5+j;
        A=Beta_seq(toread,1);
        %�ļ���Ϣ
        B=char(fileNames_seq1(toread,:));
        tmp='xls\';
        B=[tmp,B];
        [status,sheets,format]=xlsfinfo(B);
        %��ȡ����
        [num,txt,raw]=xlsread(B);
        [Rs,Cs]=size(num);
        Rate_Stock=ret(num(:,4));
        Rate_average=mean(Rate_Stock);
        Rate_1(j,1)=Rate_average;
        Beta_1(j,1)=Beta_seq(toread,2);
    end
    Rate_Array(i,1)=mean(Rate_1);
    Beta_Array(i,1)=mean(Beta_1);
end
subplot(2,1,1)
bar(Rate_Array)
subplot(2,1,2)
bar(Beta_Array)