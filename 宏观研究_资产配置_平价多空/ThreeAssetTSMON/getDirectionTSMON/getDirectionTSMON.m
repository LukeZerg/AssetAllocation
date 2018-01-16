function direction = getDirectionTSMON(onedayexRet,cashcol)
%利用时间序列择时判断
%onedayexRet为某一个交易日的在过去一段时间的超额收益率
%cashcol为不参与计算，始终做多的品种列数
%direction，返回的各资产的择时方向
nExRet = length(onedayexRet);
direction = zeros(nExRet,1);
for iExRet = 1:nExRet
    if iExRet ~= cashcol
        if onedayexRet(iExRet) > 0
            direction(iExRet) = 1;
        elseif onedayexRet(iExRet) < 0
            direction(iExRet) = -1;
        else
            direction(iExRet) = 0;
        end
    else
        onedayexRet(iExRet) = 1; %如果是cashcol列，始终做多
    end
end
end