function transvector = computetransferpositionsubscript(tradingdays, cycle)
%从日期序列中按照换仓频率提取下标
%tradingdays交易日序列
%cycle换仓周期
nt = size(tradingdays,1);
transvector = [];
subscript = 0;%下标
%如果换仓的周期为月
if strcmp(cycle,'m')
    premonth = 0;
    for i = 1:nt
        vec = datevec(tradingdays{i});
        month = vec(2);
        if month ~= premonth
            transvector = [transvector;i];
        end ;%记录更改月份后第一个交易日
        premonth = month;
    end
else
    error('没有此日期周期');
end

end