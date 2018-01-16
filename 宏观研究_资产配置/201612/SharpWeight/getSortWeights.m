function weights = getSortWeights(m)
%从1：m的序列按照proportion的三部分权重，计算1：m每个位置上的权重
if m == 3
    weights = [1-1/2-1/3;1/3;1/2];
elseif m == 4
    weights = [1/6;1/6;1/6;1/2];
    %weights = [1/10;2/10;3/10;4/10];
else
    error('getSortWeights没有考虑这样的资产数量');
end
end