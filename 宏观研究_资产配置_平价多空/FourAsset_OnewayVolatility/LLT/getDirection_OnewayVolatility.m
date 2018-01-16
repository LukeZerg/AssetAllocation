function direction = getDirection_OnewayVolatility(sub_cumret_len, sub_vol_diff_mean, THRESHOLD )
%利用单项波动率差值择时
%sub_cumret_len:  当天每个资产的len长度累计收益率
%sub_vol_diff_mean:  当天短期波动率均值

direction = zeros(size(sub_cumret_len,2),1);
for i = 1:size(sub_cumret_len,2)
    disp(THRESHOLD(i));
    if sub_cumret_len(i) <= -THRESHOLD(i) %反转，单向波动率差为负时满仓
        if sub_vol_diff_mean(i) < 0
            direction(i) = 1; 
        else
            direction(i) = 0; 
        end
    elseif sub_cumret_len(i) >= THRESHOLD(i) %趋势，单向波动率差为正时满仓
        if sub_vol_diff_mean(i) > 0
            direction(i) = 1; 
        else
            direction(i) = 0; 
        end
    else
        direction(i) = 1; %震荡时简单的持有
    end
end

end