function f = argminf(x)
%œ»∏≥÷µ
sigma = [20;30;40];
cov = [1,1,1;1,1,1;1,1,1];
length = 3;
sumTRC = 0;
sum1 = x(1)^2*sigma(1)^2 + x(2)^2*sigma(2)^2 + x(3)^2*sigma(3)^2;
sum2 = x(2)*cov(1,2) + x(3)*cov(1,3) + x(1)*cov(2,1) + x(3)*cov(2,3) + x(1)*cov(3,1) + x(2)*cov(3,2);
sigmaPortfolio = sqrt(sum1 + sum2);
MRC = zeros(length,1);
MRC(1) = (x(1)*sigma(1)^2 + x(2)*cov(1,2) + x(3)*cov(1,3))/sigmaPortfolio;
MRC(2) = (x(2)*sigma(2)^2 + x(1)*cov(2,1) + x(3)*cov(2,3))/sigmaPortfolio;
MRC(3) = (x(3)*sigma(3)^2 + x(1)*cov(3,1) + x(2)*cov(3,2))/sigmaPortfolio;

f = sumTRC;