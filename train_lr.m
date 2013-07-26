function w=train_lr(Xtrain,ytrain)

[M,N]=size(Xtrain);
w=zeros(1,N+1);
wold=ones(1,N+1);
eta=1e-3;

lambda=[0.1:0.3:0.7];
score=zeros(5,length(lambda));

for k=0:4
    %indvali=find(mod([1:M],5)==k);
    %indtrain=find(mod([1:M],5)~=k);
    for indlam=1:length(lambda)
        lam=lambda(indlam)
        ep=1;
        while(ep>1e-1)
            for i=1:N+1
                tau=0;
                for j=1:M
                    X=[1 Xtrain(j,:)];
                    if mod(j,5)~=k
                        u=exp(X*w');
                        tau=tau+X(i)*(ytrain(j)-u/(1+u));
%                         if ytrain(j)==1
%                             tau=tau+Xtrain(j,i)*(ytrain(j)-u/(1+u));
%                         else
%                             tau=tau+Xtrain(j,i)*(ytrain(j)-1/(1+u));
%                         end
                    end
                end
                w(i)=w(i)+eta*tau-eta*lam*w(i);
            end
            ep=norm(w-wold);
            disp(ep);
            wold=w;
        end
        %%validation
        for j=1:M
            if mod(j,5)==k
                u=exp([1 Xtrain(j,:)]*w');
                if u>1  %y=1
                    if ytrain(j)==1
                        score(k+1,indlam)=score(k+1,indlam)+1;
                    end
                else
                    if ytrain(j)==0
                        score(k+1,indlam)=score(k+1,indlam)+1;
                    end
                end
            end
        end
    end
end
        
disp(score);

%best lambda%
[Y,I]=max(score,[],2);
mostlam=zeros(5,1);
for k=1:5
    if I(k)==k
        mostlam(k)=mostlam(k)+1;
    end
end

[Y,I]=max(mostlam);
lam=lambda(I);

% %output w%
ep=1;
while(ep>1e-1)
    for i=1:N+1
        tau=0;
        for j=1:M
            X=[1 Xtrain(j,:)];
            if mod(j,5)~=k
                u=exp(X*w');
                tau=tau+X(i)*(ytrain(j)-u/(1+u));
            end
        end
        w(i)=w(i)+eta*tau-eta*lam*w(i);
    end
    ep=norm(w-wold);
    wold=w;
end

return






