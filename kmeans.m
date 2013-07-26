clear all;

x=[0 0;1 0;0 1;1 1;2 1;1 2;2 2;3 2;6 6;7 6;8 6;6 7;7 7;8 7;9 7;7 8;8 8;9 8;8 9;9 9];
[M,N]=size(x);
c=2;
z1=x(1,:);z2=x(2,:);
flag=1;t=0;
while(flag==1)
    t1=z1;t2=z2;s=zeros(1,2);a=zeros(2,2);
    for i=1:M
        d(1,i)=norm(x(i,:)-z1);d(2,i)=norm(x(i,:)-z2);
        if d(1,i)<d(2,i)
            a(1,:)=a(1,:)+x(i,:);
            s(1)=s(1)+1;
        else s(2)=s(2)+1;
            a(2,:)=a(2,:)+x(i,:);
        end
    end
    z1=a(1,:)/s(1);z2=a(2,:)/s(2);
    if(t1==z1&t2==z2)
        flag=0;
    end
    t=t+1;
end

disp(t);   %iteration times

x1=zeros(s(1),2);x2=zeros(s(2),2);
j=1;k=1;
for i=1:M
    d(1,i)=norm(x(i,:)-z1);d(2,i)=norm(x(i,:)-z2);
    if d(1,i)<d(2,i)
        x1(uint8(j),:)=x(i,:);j=j+1;
    else x2(uint8(k),:)=x(i,:);k=k+1;
    end
end
 figure(1);
 scatter(x1(:,1),x1(:,2),'d','g');hold on;
 scatter(x2(:,1),x2(:,2),'d','r');hold on;
 scatter(z1(1),z1(2),'*','g');hold on;
 scatter(z2(1),z2(2),'*','r');







