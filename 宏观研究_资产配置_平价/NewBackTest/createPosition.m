function Position = createPosition( Position_abs, Direction )
%将没有方向的仓位Position_abs与方向Direction合并起来,得到Position返回
n1 = size(Position_abs,2); %除了列名外的日期数
n2 = size(Direction,2)-1;
if n1 ~= n2
    error('没有方向的仓位Position_abs与方向Direction的资产数不同');
end
Position = cell(1,n1);
nt = size(Direction,1)-1;
for iAsset = 1:n1
    onePosition = Position_abs{1,iAsset} ;
    for j = 1:nt
        onePosition(j+1,4) = Direction(j+1,iAsset+1); %方向赋值
    end
    Position{1,iAsset} = onePosition;
end
end