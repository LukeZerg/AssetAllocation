function direction = getDirectionDMAChg(subMAfast, subMAslow , cashcol)
%利用MA距离变化值，判断多空方向
%subMAfast: MA快线矩阵，MA慢线矩阵
%cashcol 现金资产在Data中的列数，需要避开计算

%subMAChg第一行与对应最后一行同方向，比绝对值判断间距变化；不同方向，断定间距变大
subMAChg = subMAfast - subMAslow;
stdMAchg = std(subMAChg); %标准差
m = size(subMAfast,2);
direction = zeros(m,1);
for iK = 1:m
    now = subMAChg(end,iK);
    before = subMAChg(1,iK);
    if iK~=cashcol
        if now>=0       %若当前间距为正
            if before >= 0  %如果之前间距为正
                if abs(now) > abs(before) %如果间距扩大
                    direction(iK) = 1;
                elseif abs(now) < abs(before) %如果间距减小
                    direction(iK) = -1; 
                else
                    direction(iK) = 0; 
                end
            elseif before < 0 %方向相反,认定为间距为正且扩大
                direction(iK) = 1;
            end
        elseif now<0   %若当前间距为负数
            if before <= 0  %如果之前间距为负
                if abs(now) > abs(before) %如果间距扩大
                    direction(iK) = -1;
                elseif abs(now) < abs(before) %如果间距减小
                    direction(iK) = 1; 
                else
                    direction(iK) = 0; 
                end
            elseif before > 0 %方向相反,,认定为间距为负且扩大
                direction(iK) = -1;
            end
        end %now的几种情况
    else
        direction(iK) = 1;%cashcol列特殊处理，做多现金
    end %是否cashcol列
end %循环每个资产
end