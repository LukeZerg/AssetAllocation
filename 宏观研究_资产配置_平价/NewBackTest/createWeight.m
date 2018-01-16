function Weight = createWeight(theWeights_abs, Direction )
%将没有方向的仓位theWeights_abs与方向Direction合并起来,得到Weight返回
n1 = size(theWeights_abs,2)-1; %除了列名外的日期数
n2 = size(Direction,2)-1;
if n1 ~= n2
    error('没有方向的仓位theWeights_abs与方向Direction的资产数不同');
end
nt = size(Direction,1)-1;
Weight = theWeights_abs ;
for iAsset = 1:n1
    for j = 1:nt
        Weight{j+1,iAsset+1} = Direction{j+1,iAsset+1}*Weight{j+1,iAsset+1}; %方向赋值
    end
end
end