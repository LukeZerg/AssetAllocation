function [Position] = GetPos(Close,Information)
%利用初步数据整理生成Position和CloseData的标准格式
    n = size(Close,2);%资产数量
    Position = cell(1,n);%初始化仓位标准数据
    rowdt = size(Close{1,1},1);
    variety = Information(2:end,1);
    for i = 1:n
        onedata = Close{1,i};
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