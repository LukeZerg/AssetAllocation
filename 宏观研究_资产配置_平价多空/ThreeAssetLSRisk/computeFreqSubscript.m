function transvector = computeFreqSubscript(tradingdays, cycle)
%从日期序列中按照换仓频率提取下标
%tradingdays交易日序列
%cycle换仓周期
nt = size(tradingdays,1);
%如果换仓的周期为月
if strcmp(cycle,'m')
    transvector = 1;%第一天开始交易
    premonth = 0;
    for i = 1:(nt-1)
        vec = datevec(tradingdays{i});
        month = vec(2);
        if month ~= premonth
            transvector = [transvector;i];
        end ;%记录更改月份后第一个交易日
        premonth = month;
    end
elseif strcmp(cycle,'w')
    weeks = zeros(nt,1);
    weekflag = zeros(nt,1);%标识每周的第一个交易日
    weekend = zeros(nt,1);%标识每周的最后一个交易日
    weekflag(1) = 1;%第一个交易日必定是策略里第一周的第一个交易日
    for i = 1:nt
        vec = datevec(tradingdays{i});
        year = vec(1);
        month = vec(2);
        day = vec(3);
        weeks(i) = returenWeekDay(year,month,day);%蔡勒公式从日期计算星期几 
        if i > 1
           daydelta = datenum(tradingdays{i}) - datenum(tradingdays{i-1});%跟上一个交易日的自然日距离
           weekdaydelta = weeks(i) - weeks(i-1);%跟上一个交易日星期数字比较
           %如果
           if daydelta >= 7 || weekdaydelta <= 0 
               weekflag(i)=1; %是新的一周的第一个交易日
               weekend(i-1)=1; %前一天一定是上一周的最后一个交易日
           end
        end
    end
    transvector = find(weekend);%因为weekend最多赋值到第nt-1个，所以不用删除最后一个
    if transvector(1) ~= 1
        transvector = [1;transvector];
    end
else
    error('没有此日期周期');
end

end