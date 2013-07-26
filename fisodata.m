function fisodata()

x=[0 0;1 1;2 2;4 3;5 3;4 4;5 4;6 5];
[M,N]=size(x);
y=ones(M,1);  %%%记录各x所属的类别%%%
c=2;tn=2;ts=1;td=4;L=1;I=4;nc=1;Ip=1;
%%%center of cluster%%%
z=zeros(nc,2);z(1,:)=[0 0];

while(1)
    y=fstep2(x,M,z,nc);
    [y,nct,z]=fstep3(tn,x,M,z,nc,y);
    if nct~=nc
        nc=nct;
        continue;
    end
    [z,dm,dms]=fstep4(x,M,nc,y);
    if Ip==I
        td=0;
        [z,nct]=fstep910(td,L,z,y,nc,M);
        break;
    elseif nc<=c/2
        [nct,z]=fstep678(x,M,y,nc,c,z,ts,tn,dm,dms);
        if nct~=nc
            Ip=Ip+1;nc=nct;
            continue;
        else [z,nc]=fstep910(td,L,z,y,nc,M);
            Ip=Ip+1;
            continue;
        end
    elseif nc>=2*c
        [z,nc]=fstep910(td,L,z,y,nc,M);
        Ip=Ip+1;
        continue;
    elseif mod(Ip,2)==1
        [nct,z]=fstep678(x,M,y,nc,c,z,ts,tn,dm,dms);
        if nct~=nc
            Ip=Ip+1;nc=nct;
            continue;
        else [z,nc]=fstep910(td,L,z,y,nc,M);
            Ip=Ip+1;
            continue;
        end
    elseif mod(Ip,2)==0
        [z,nc]=fstep910(td,L,z,y,nc,M);
        Ip=Ip+1;
        continue;
    end    
end
%%%show the results%%%
y=fstep2(x,M,z,nc);
figure(1);
for i=1:M
    if y(i)==1
        scatter(x(i,1),x(i,2),'d','g');hold on;
    else scatter(x(i,1),x(i,2),'d','r');hold on;
    end
end
scatter(z(1,1),z(1,2),'*','g');hold on;
scatter(z(2,1),z(2,2),'*','r');
return

function y=fstep2(x,M,z,nc)
for i=1:M
    for j=1:nc
        d(i,j)=norm(x(i,:)-z(j,:));
    end
    [Y,y(i)]=min(d(i,:));
end
return

function [y,nc,z]=fstep3(tn,x,M,z,nc,y)
d=zeros(nc,1);
for i=1:M
    d(y(i))=d(y(i))+1;
end
nct=nc;
for i=1:nc
    if d(i)<tn
        z(i,:)=[-1 -1];
        nct=nct-1;
    end
end
if nct~=nc
    Z=zeros(nct,2);
    j=1;
    for i=1:nc
        if z(i,1)~=-1
            Z(j,:)=z(i,:);
            j=j+1;
        end
    end
    z=zeros(nct,2);z=Z;
    nc=nct;
end
return

function [z,dm,dms]=fstep4(x,M,nc,y)
s=zeros(nc,2);n=zeros(nc,1);
for i=1:M
    s(y(i),:)=s(y(i),:)+x(i,:);
    n(y(i))=n(y(i))+1;
end
for i=1:nc
    z(i,:)=s(i,:)/n(i);
end
s=zeros(nc,1);
for i=1:M
    s(y(i))=s(y(i))+norm(x(i,:)-z(y(i),:));
end
dms=0;
for i=1:nc
    dm(i)=s(i)/n(i);
    dms=dms+s(i);
end
dms=dms/M;
return

function [nc,z]=fstep678(x,M,y,nc,c,z,ts,tn,dm,dms)
sigma=zeros(nc,2);
s=zeros(nc,2);n=zeros(nc,1);
for i=1:M
    s(y(i),:)=s(y(i),:)+(x(i,:)-z(y(i),:)).^2;
    n(y(i))=n(y(i))+1;
end
for i=1:nc
    sigma(i,:)=sqrt(s(i,:)/n(i,:));
end
sigmax=zeros(nc,1);
[sigmax,I]=max(sigma,[],2);
nct=nc;
flag=zeros(nc,1);
for i=1:nc
    if sigmax(i)>ts
        if (nc<=c/2)||((dm(i)>dms)&&(n(i)>2*(tn+1)))
            nct=nct+1;
            flag(i)=1;
        end
    end
end
k=0.2;
if nct~=nc
    Z=zeros(nct,2);j=1;
    for i=1:nc
        if flag(i)==0
            Z(i,:)=z(i,:);
        else Z(i,:)=z(i,:)+k*sigmax(i);
            Z(nc+j,:)=z(i,:)-k*sigmax(i);j=j+1;
        end
    end
    z=zeros(nct,2);z=Z;
    nc=nct;
end
return

function [z,nc]=fstep910(td,L,z,y,nc,M)
if nc<2
else
D=zeros(nc-1,nc)*10e6;
for i=1:nc-1
    for j=i+1:nc
        D(i,j)=norm(z(i,:)-z(j,:));
    end
end
DL=zeros(L,3);
[Y,I]=sort(reshape(D,1,nc*(nc-1)));  %%升序排列%%
for i=1:L
    DL(i,1)=Y(i);
    DL(i,2)=ceil(I(i)/nc);
    DL(i,3)=mod(I(i),nc);
end
%%% L=1,将D最小的两类合并%%%
nct=nc;
n=zeros(nc,1);
for i=1:M
    n(y(i))=n(y(i))+1;
end
if DL(1,1)<td
    nct=nc-1;
    Z=zeros(nct,2);j=1;
    for i=1:nc
        if i==DL(1,3)
        elseif i==DL(1,2)
            Z(j,:)=(n(i)*z(i,:)+n(DL(1,3))*z(DL(1,3),:))/(n(i)+n(DL(1,3)));
            j=j+1;
        else Z(j,:)=z(i,:);j=j+1;
        end
    end
    Z=zeros(nct,2);z=Z;nc=nct;
end
%%%
end
return




















