function GAf()
P=[1 2 3 4 5 6 7];  %初始群体
for i=1:500    %迭代次数
    y=funy(P);
    [B,index]=sort(y);
    P(index(1:4))=mutation(P(index(1:4)));
    [P(index(5)),P(index(6))]=crossover(P(index(5)),P(index(6)));
end
disp('the maximum of the curve:');disp(B(7));
disp('the value of x:');disp(P(index(7)));
return

function y=funy(x)
v=[0.5 0.25 1 0.25];
c=[1/8 3/8 5/8 7/8];
maxx=1073741823;
y=0*x;
for i=1:4
    y=y+v(i)*exp(-(x/maxx-c(i).*ones(size(x))).^2/0.006);
end
return

function [u,v]=crossover(s,r)
a=dec2bin(s,30);
b=dec2bin(r,30);
in=randperm(30);
for i=in(1):30
    temp=b(i);
    b(i)=a(i);
    a(i)=temp;
end
u=bin2dec(a);
v=bin2dec(b);
return

function y=mutation(x)
a=dec2bin(x,30);
in=randperm(30);
a(in(1))=num2str(1-str2num(a(in(1))));
y=bin2dec(a);
return




