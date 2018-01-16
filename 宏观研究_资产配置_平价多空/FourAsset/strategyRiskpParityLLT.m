function [ Position,CloseData, theWeights ] = strategyRiskpParityLLT( ...
startday,endday, backtime, capital, Position0, CloseData0,Information, ...
    names, longcol, alpha, backtimeD, cycle)
%风险平价策略
% startday = '2013-02-04';
% endday = '2017-02-03';
% backtime = 60;
% capital = 30000*10000;
% data = Data;

Position = Position0;
CloseData = CloseData0;

onePosition = Position{1,1};
n = size(onePosition,1)-1; %除了列名外的日期数
m = size(Position,2);%资产数量

w=windmatlab();
if w.tdayscount(onePosition{2,1},startday) < backtime
    error('策略起始日期与原始数据起始日期距离小于回溯时间backtime');
end
if w.tdayscount(onePosition{2,1},startday) < backtime
    error('策略起始日期与原始数据起始日期距离小于回溯时间backtime');
end
if datenum(endday) > datenum(onePosition{n+1,1})
    error('策略结束日期在原始数据结束日期之后');
end
nstart = find(strcmp(onePosition(:,1),startday));%在第一列中找到开始日期下标
nend = find(strcmp(onePosition(:,1),endday));%在第一列中找到开始日期下标
tradingdays = onePosition(nstart:nend,1); %策略持续时间
lasttradingday = w.tdaysoffset(1,tradingdays{end});%为了应付回测当天是一周最后一天的情况，在最后一个交易日之后加入未来一天交易日
lasttradingday = datestr(lasttradingday,29);
tradingdays1 = [tradingdays;lasttradingday];%tradingdays1多一天
%从日期序列中按照换仓频率提取下标
transvector = computeFreqSubscript(tradingdays1, cycle);%找调仓下标
% 
% load('D:/001Work/宏观研究_资产配置_平价多空/FourAsset/cdata.mat');
% %改格式.ma
% ncdata = size(cdata,1);
% for i = 1:ncdata
%     cdata{i,1} = datestr(cdata{i,1},29);
% end
% ctday = cdata(:,1); 
% transvector = cyeildFreqSubscript(tradingdays1,ctday);%找调仓下标
%% ret LLT 赋值
%初始化
ret = zeros(n, m); %收益率矩阵
LLTs = zeros(n, m);%LLT指标矩阵

for iPosition = 1:size(Position,2)
    
    oneCloseData = CloseData{1,iPosition};
    prices = cell2mat(oneCloseData(2:end,3));%价格
    %ret = log(close(2:end)./close(1:(end-1))); %对数收益率
    oneret = diff(prices(:))./prices(1:(end-1));%收益率
    oneret = [0;oneret];
    %收益率矩阵赋值
    ret(:,iPosition) = oneret;
    %LLTs矩阵赋值
    LLTs(:,iPosition) = priceToLLT(prices,alpha);

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
        weights = RiskParity(sub);%计算权重
        subLLT = LLTs((j-2-backtimeD):(j-1-1),:);
        %择时数据跟权重数据计算独立开来
        direction = getDirectionLLTsomelong(subLLT,longcol); %利用LLT择时判断
        %direction = [1,1,1,1];
        for iPosition = 1:m
            Position{1,iPosition}{j+1,4} = direction(iPosition); %direction
            oneCapital = capital * weights(iPosition); %分配资金
            oneClose = CloseData{1,iPosition}{j+1,3};%对应价格
            if direction(iPosition) ~= 0
                Position{1,iPosition}{j+1,3} = ...
                    oneCapital/(Multiplier(iPosition)*oneClose);%计算手数
            else
                Position{1,iPosition}{j+1,3} = 0;%方向为0代表空仓不进场
            end
            %记录权重和方向的乘积,第一列是日期
            theWeights{j+1, iPosition+1} = direction(iPosition)*weights(iPosition);
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
 
 %% 截取需要的Position和CloseData时间段
startnull = 2:(nstart-1);%start之前的为空
endnull = (nend+1):(n+1);%end之后的为空
for idata = 1:m
    Position{1,idata}([startnull,endnull],:) = [];
    CloseData{1,idata}([startnull,endnull],:) = []; 
end
theWeights([startnull,endnull],:) = [];
end
