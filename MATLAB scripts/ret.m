function r=ret(Array)
[R,~]=size(Array);
r=zeros(R-1,1);
for i=1:R-1
    r(i,1)=(Array(i+1,1)-Array(i,1))/Array(i,1);
end
    

