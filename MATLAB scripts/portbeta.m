function beta=portbeta(portfoliosReturn,marketReturn)
%Э����������
temp_cov=cov(portfoliosReturn,marketReturn);
%Ͷ��������г���Э����/�г��ķ���
beta=temp_cov(1,2)/temp_cov(2,2);
