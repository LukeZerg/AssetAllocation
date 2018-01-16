function weights = SharpAndReturnWeightsLong(sub)
%利用夏普率和收益率计算评分，再计算权重
%输入：ub是N行M列的数据，N个日期，M个资产的收益
%输出：M个资产的权重
m = size(sub,2);%sub列数
%计算各资产收益率，累计收益率
sharp = zeros(m,1);
cumsumlist = zeros(m,1);
for iSharp = 1:m
    retlist = sub(:,iSharp); %第iSharp个资产的收益率
    sharp(iSharp) = mean(retlist)/std(retlist)*250; %可换为风险
    temp = cumsum(retlist);
    cumsumlist(iSharp) = temp(end);%第iSharp个资产的累计收益率
end

%保存排名和评分
score_sharp = zeros(m,1);
score_cumsum = zeros(m,1);

%排序后对应的之前的下标
[~,sharpPresub] = sort(sharp);%按照SharpRatio从小到大排序，sharpPresub是排序后的资产在排序之前的位置
[~,cumsumPresub] = sort(cumsumlist);%按照累计收益率排序获得名次cumsumPresub， cumsumPresub是排序后的资产在排序之前的位置

%记录排名数字，排名越前，分数越小
score_sharp(sharpPresub) = 1:m;
score_cumsum(cumsumPresub) = 1:m;
score_all = 1/2*score_sharp + 1/2*score_cumsum;
%用总评分排序得到排名
[~, scorePresub]=sort(score_all);

%按照个数分为三组,每组内等权重分配
sortweights = getSortWeights(m); %最终每个资产的权重
weights = zeros(m,1);

for iWeights = 1:m
    %取从小到大评分的顺序取出资产的下标
    subw = scorePresub(iWeights);
    weights(subw) = sortweights(iWeights);
end

end
