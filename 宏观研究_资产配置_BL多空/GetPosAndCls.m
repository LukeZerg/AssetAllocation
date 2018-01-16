function [Position, CloseData] = GetPosAndCls(data,Information)
%利用初步数据整理生成Position和CloseData的标准格式
    n = size(data,2);%资产数量
    CloseData = cell(1,n);%初始化价格标准数据
    Position = cell(1,n);%初始化仓位标准数据
    rowdt = size(data{1,1},1);
    variety = Information(2:end,1);
    for i = 1:n
        onedata = data{1,i};
        CloseData{1,i} = {'TradingDay','Contract','Close','PreContract',...
            'PreClose','Variety','Deposit'};
        CloseData{1,i}(2:rowdt,1) = onedata(2:rowdt,1); %日期
        CloseData{1,i}(2:rowdt,2) = onedata(2:rowdt,2); %合约
        CloseData{1,i}(2:rowdt,3) = onedata(2:rowdt,3); %价格
        %前一天合约
        CloseData{1,i}(2:rowdt,4) = onedata(2:rowdt,2); %合约
        %前一天价格,因为一直是一个代码，所以如此处理
        CloseData{1,i}(2:rowdt,5) = onedata(2:rowdt,3); %前一天合约今日价格
        CloseData{1,i}(2:rowdt,6) = {variety{i}}; %资产种类
        %-----------------------------------------------------------------
        CloseData{1,i}(2:rowdt,7) = {1};%保证金率，这里特殊处理，预计没有影响
        %-----------------------------------------------------------------
        Position{1,i} = {'TradingDay','Contract','Curren','Direciton',...
            'Variety','isChg'};
        Position{1,i}(2:rowdt,1) = onedata(2:rowdt,1); %日期
        Position{1,i}(2:rowdt,2) = onedata(2:rowdt,2); %合约
        Position{1,i}(2:rowdt,3) = {0}; %curren
        Position{1,i}(2:rowdt,4) = {0}; %direction
        Position{1,i}(2:rowdt,5) = {variety{i}}; %资产种类
        Position{1,i}(2:rowdt,6) = {0}; %ischg
    end
end