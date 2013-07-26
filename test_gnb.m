function y=test_gnb(x,prior,cmean,cvar)
[M,N]=size(x);

for i=1:M
    lhy1=prior(1);
    lhy0=prior(2);
    for j=1:N
        lhy1=lhy1/sqrt(cvar(1,j))*exp(-(x(i,j)-cmean(1,j))*(x(i,j)-cmean(1,j))/2/cvar(1,j));
        lhy0=lhy0/sqrt(cvar(2,j))*exp(-(x(i,j)-cmean(2,j))*(x(i,j)-cmean(2,j))/2/cvar(2,j));
    end
    if lhy1>lhy0
        y(i)=1;
    else
        y(i)=0;
    end
end

y=y';

return
