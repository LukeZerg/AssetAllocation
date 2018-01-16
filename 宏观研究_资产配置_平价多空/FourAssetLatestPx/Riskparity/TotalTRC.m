function y = TotalTRC(Cov , x)
%input:x为各个资产初始化权重
%      Cov为协方差矩阵
%output:为计算后的各个资产权重
%该函数为TotalTRC的计算公式
TRC = Cov * x .* x ; %总体风险贡献
y = std(TRC);
% len = length(TRC);
% dataTRC = zeros(len,len); 
% for i = 1:len
%     for j = 1:len
%             dataTRC(i,j) = ( TRC(i)-TRC(j) )^2 ; %总体风险贡献之差的平方和
%     end
% end %for
% y = sum(sum(dataTRC));
end
