function [prior,cmean,cvar]=train_gnb(x,y)
[M,N]=size(x);

indy0=find(y==0);
indy1=find(y==1);
lenindy0=length(indy0);
lenindy1=length(indy1);

prior(1)=lenindy1/length(y);   %y=1
prior(2)=lenindy0/length(y);
cmean=zeros(2,N);   %first row: y=1
cvar=zeros(2,N);    %first row: y=1

cmean(1,:)=sum(x(indy1,:))/lenindy1;
cmean(2,:)=sum(x(indy0,:))/lenindy0;

cvar(1,:)=sum((x(indy1,:)-repmat(cmean(1,:),lenindy1,1)).*(x(indy1,:)-repmat(cmean(1,:),lenindy1,1)))/lenindy1;
cvar(2,:)=sum((x(indy0,:)-repmat(cmean(2,:),lenindy0,1)).*(x(indy0,:)-repmat(cmean(2,:),lenindy0,1)))/lenindy0;


return
