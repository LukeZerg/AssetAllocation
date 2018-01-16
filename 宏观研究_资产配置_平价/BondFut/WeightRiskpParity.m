function [ Position_abs, theWeights_abs, Close_strategy] = ...
    WeightRiskpParity( Position0, Data, Close, Information)
%风险平价策略
%用大类资产价格确定权重，用具体合约价格计算手数

global strategy
endday = strategy.endday;
startday = strategy.startday;
backtime = strategy.backtime;
capital = strategy.capital;
cycle = strategy.cycle;

names = Data(2,:);
Position = Position0;

onePosition = Position{1,1};
n = size(onePosition,1)-1; %除了列名外的日期数
m = size(Position,2);%资产数量

w=windmatlab();

nstart = find(strcmp(onePosition(:,1),startday));%在第一列中找到开始日期下标
nend = find(strcmp(onePosition(:,1),endday));%在第一列中找到开始日期下标
tradingdays = onePosition(nstart:nend,1); %策略持续时间
lasttradingday = w.tdaysoffset(1,tradingdays{end});%为了应付回测当天是一周最后一天的情况，在最后一个交易日之后加入未来一天交易日
lasttradingday = datestr(lasttradingday,29);
tradingdays1 = [tradingdays;lasttradingday];%tradingdays1多一天
%从日期序列中按照换仓频率提取下标
transvector = computeFreqSubscript(tradingdays1, cycle);%找调仓下标
%% ret LLT 赋值
%初始化
ret = zeros(n, m); %收益率矩阵
for iPosition = 1:size(Position,2)
    
    oneData = Data{1,iPosition};
    prices = cell2mat(oneData(2:end,3));%大类资产收盘价格
    %ret = log(close(2:end)./close(1:(end-1))); %对数收益率
    oneret = diff(prices(:))./prices(1:(end-1));%收益率
    oneret = [0;oneret];
    %收益率矩阵赋值
    ret(:,iPosition) = oneret;

    ntv = size(transvector,1);
    for i = 1:ntv
        itv = transvector(i) + nstart - 1;%onepnldada中调仓日下标
        Position{1,iPosition}{itv,6} = 1;%%isChg,调仓日
    end
end

%% 计算并记录权重，分配资金, 填写Position的手数和方向
theWeights = cell(n+1,m+1);    %weights存储权重
theWeights(1,:) = [{'TradingDay'},names];
theWeights(2:end,1) = onePosition(2:end,1);

Multiplier = cell2mat(Information(2:end,2));
onePosition = Position{1,1};
for j = 1:n
    if onePosition{j+1,6} %如果是调仓日
        sub = ret((j-1-backtime):(j-1-1),:);%j-2即onepnldada中的j-1
        weights = RiskParity(sub);%用大类资产价格计算权重
                
        for iPosition = 1:m
            oneCapital = capital * weights(iPosition); %分配资金
            oneClose = Close{1,iPosition}{j+1,6};%具体合约收盘价格
            Position{1,iPosition}{j+1,3} = ...
                oneCapital/(Multiplier(iPosition)*oneClose);%计算手数
            %记录权重和方向的乘积,第一列是日期
            theWeights{j+1, iPosition+1} = weights(iPosition);
        end
    end
end

%填充position的curren 3列和direction 4列
 for k = 1:m %循环多空品种
     [nP,~] = size(Position{1,k});%此品种数据大小
     currenbox = 0;%记录器
     directionbox=0;
     for i = 2:nP
         if Position{1,k}{i,6} == 1 %如果这一天持仓变化了isChg
             %记录下curren和direction
             currenbox = Position{1,k}{i,3};
             directionbox = Position{1,k}{i,4};
         end
         Position{1,k}{i,3} = currenbox;
         Position{1,k}{i,4} = directionbox;
     end
 end
 
 %填充theWeights
 for k = 1:m %循环多空品种
     nP = size(theWeights,1);%此品种数据大小
     oneWeight = 0;
     for i = 2:nP
         if Position{1,k}{i,6} == 1 %如果这一天持仓变化了isChg
             %记录下curren和direction
             oneWeight = theWeights{i,k+1};
         end
         theWeights{i,k+1} = oneWeight;
     end
 end
 
 %% 截取需要的Position和Data时间段
startnull = 2:(nstart-1);%start之前的为空
endnull = (nend+1):(n+1);%end之后的为空
for idata = 1:m
    Position{1,idata}([startnull,endnull],:) = [];
    Close{1,idata}([startnull,endnull],:) = []; 
end
theWeights([startnull,endnull],:) = [];

theWeights_abs = theWeights;
Position_abs = Position;
Close_strategy = Close;
end
