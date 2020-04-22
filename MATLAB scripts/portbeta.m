function beta=portbeta(portfoliosReturn,marketReturn)
%协方差矩阵计算
temp_cov=cov(portfoliosReturn,marketReturn);
%投资组合与市场的协方差/市场的方差
beta=temp_cov(1,2)/temp_cov(2,2);
