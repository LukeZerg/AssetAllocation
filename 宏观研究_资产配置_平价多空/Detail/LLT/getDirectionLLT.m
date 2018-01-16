function direction = getDirectionLLT(subLLT, cashcol , backtimeD)
%利用LLT值计算斜率，判断多空方向
%subLLT: LLT子集
%cashcol 现金资产在Data中的列数，需要避开计算
%backtimeD 回溯时间段
len = size(subLLT,1);
if backtimeD > len
    wrong('回溯计算时间超出数据长度');
end
%计算斜率
ks = (subLLT(len,:) - subLLT(len-backtimeD,:))/backtimeD;
direction = zeros(size(subLLT,2),1);
for iK = 1:size(subLLT,2)
    if iK~=cashcol
        %利用斜率判断多空方向
        if ks(iK)>0
            direction(iK)=1;
        elseif ks(iK)<0
            direction(iK)=-1;
        else
            direction(iK) = 0;
        end
    else
        direction(iK) = 1;
    end
end

end