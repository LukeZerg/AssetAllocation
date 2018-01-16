function f = fmin(x,cov)
%先赋值
%cov = [1,1,1;1,1,1;1,1,1];
length = max(size(x));
sumTRC = 0;
temp = zeros(3,1);
%分别计算
for i = 1:length
    for j = 1:length
        temp(i) = temp(i) + x(j)*cov(i,j);
    end
end
for i = 1:length
    for j = 1:length
        sumTRC = sumTRC + (x(i)*temp(i) - x(j)*temp(j))^2;
    end
end
f = sumTRC;
end