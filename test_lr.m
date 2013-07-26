function y=test_lr(x,w)

[M,N]=size(x);

for i=1:M
    if w*[1;x(i,:)']>0
        y(i)=0;
    else
        y(i)=1;
    end
end

y=y';

return
