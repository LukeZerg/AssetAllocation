function direction = getDirectionLLTsomelong(subLLT, cashlong )
%利用LLT值计算斜率，判断多空方向
%subLLT: LLT子集
%cashcol 现金资产在Data中的列数，需要避开计算
%backtimeD 回溯时间段
len = size(subLLT,1);
%计算斜率
ks = (subLLT(len,:) - subLLT(1,:))/(len-1);
direction = zeros(size(subLLT,2),1);
for iK = 1:size(subLLT,2)
    %如果ik在cashlong之中，那么公式sum(ismember(cashlong,iK))大于0
    %如果ik在cashlong之中，那么ik只做多，其余时间空仓，
    if sum(ismember(cashlong,iK))
        if ks(iK) > 0
            direction(iK) = 1;
        else
            direction(iK) = 0;
        end
    else
        %利用斜率判断多空方向
        if ks(iK)>0
            direction(iK) = 1;
        elseif ks(iK)<0
            direction(iK) = -1;
        else
            direction(iK) = 0;
        end
    end
end

end