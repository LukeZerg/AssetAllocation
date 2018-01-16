function [resultcell] = RiskEvaluationStrategy(data, w, code1, code2, code3, Today, capital_start, cycle )
%w = windmatlab;
% code1 = 'S0105896';                             %南华
% %code2 = 'M0066367';                            %活跃合约 沪深300
% code2 = 'M0020209';                             %沪深300 指数
% code3 = 'M0096849';                             %活跃合约 5年期国债期货
% Today = '2016/02/08';
% capital_start = 10000000;
% cycle = 22;                                     %周期
%data = importdata('data1.xlsx');  
StartDate = datestr(datenum(Today)-366, 29);    %取过去一年的时间来计算权重
EndDate = datestr(datenum(Today), 29);   
[data1,~,~,~,~]=w.edb(code1,StartDate,EndDate,'Fill=Previous'); 
[data2,~,~,~,~]=w.edb(code2,StartDate,EndDate,'Fill=Previous');
[data3,~,~,~,~]=w.edb(code3,StartDate,EndDate,'Fill=Previous');
weights = GetWeights(data1(1:(end-1)),data2(1:(end-1)),data3(1:(end-1)));    %获得风险平价最优解の权重,用今天以前的数据计算
if isempty(data) == 1
    capital = capital_start ;                          %资本初始化,交易第一天
    cap = capital * weights;                           %在三个资产上分配资金
    TradingDay = Today;
    count = 1;
    %写入
    firstcell = {'TradingDay','cap1','cap2','cap3','count'};
    secondcell = {  TradingDay, cap(1), cap(2), cap(3), count };
    mycell = 
    %xlswrite('data1.xlsx',mycell);
else
    onedata = data.data(end,:);
    cap_pre = onedata(1:3);
    count = onedata(4); 
    count = count + 1;                                  %交易周期计数
    ret = zeros(3,1);
    %算今日收益
    ret(1) = ( data1(end) - data1(end-1) ) / data1(end-1);
    ret(2) = ( data2(end) - data2(end-1) ) / data2(end-1);
    ret(3) = ( data3(end) - data3(end-1) ) / data3(end-1);
    cap = cap_pre'.*(ret+1);                             %计算今日新资本
    if count == cycle                                    %如果到周期了，按权重分配资金
        cap = sum(cap)*weights;
    end
    TradingDay = data.textdata(end,:);
    mycell = { TradingDay, cap(1), cap(2), cap(3), count };

end
%xlswrite('data1.xlsx',mycell);
%system('tskill excel');                                 %关掉EXCEL进程
resultcell = mycell;
end