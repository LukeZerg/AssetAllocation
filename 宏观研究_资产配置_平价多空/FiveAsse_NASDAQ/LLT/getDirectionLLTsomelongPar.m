function direction = getDirectionLLTsomelongPar(subLLTcol, longcol ,iPosition)
%利用LLT值计算斜率，判断多空方向
%subLLT: LLT子集
%cashcol 现金资产在Data中的列数，需要避开计算
%iPosition 列数
len = size(subLLTcol,1);
%计算斜率
ks = (subLLTcol(len,:) - subLLTcol(1,:))/(len-1);

%如果ik在cashlong之中，那么公式sum(ismember(cashlong,iK))大于0
%如果ik在cashlong之中，那么ik只做多，其余时间空仓，
if sum(ismember(longcol,iPosition))
    if ks > 0
        direction = 1;
    else
        direction = 0;
    end
else
    %利用斜率判断多空方向
    if ks>0
        direction = 1;
    elseif ks<0
        direction = -1;
    else
        direction = 0;
    end
end


end