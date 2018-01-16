function weights = SharpWeightsLong(sub)
%利用夏普率计算权重
%输入：ub是N行M列的数据，N个日期，M个资产的收益
%输出：M个资产的权重
m = size(sub,2);%sub列数
sharp = zeros(m,1);
weights = zeros(m,1);
for iSharp = 1:m
    retlist = sub(:,iSharp); %第iSharp个资产的收益率
    sharp(iSharp) = mean(retlist)/std(retlist)*250;
end
% 1-4等差序列,间隔3/(m-1)
sharpsort = [(1:4)',sharp];
sharpsort = sortrows(sharpsort,2);%将带下标的夏普率从小到大排序
for iSharp = 1:m
   subscript = sharpsort(iSharp,1);%从小到大取出下标
   weights(subscript) = 1+3/(m-1)*(iSharp-1); %从1开始加上间隔
end
weights = weights/sum(weights);%使权重之和为零
end
