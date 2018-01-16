function [ Position,CloseData, theWeights ] = strategyBLLS( ...
startday,endday, backtime, capital, Position0, CloseData0,Information, ...
    names, cashcol, alpha, backtimeD, w0, tau)
%BL多空策略
%startday,endday 起始结束日期
%指标计算

% startday = '2013-02-04';
% endday = '2017-02-03';
% backtime = 60;
% capital = 30000*10000;
% data = Data;

Position = Position0;
CloseData = CloseData0;
%获取投资者观点
Perspective = GetPerspective();

onePosition = Position{1,1};
n = size(onePosition,1)-1; %除了列名外的日期数
m = size(Position,2);%资产数量

w=windmatlab();
if w.tdayscount(onePosition{2,1},startday) < backtime
    error('策略起始日期与原始数据起始日期距离小于回溯时间backtime');
end
if datenum(endday) > datenum(onePosition{n+1,1})
    error('策略结束日期在原始数据结束日期之后');
end
nstart = find(strcmp(onePosition(:,1),startday));%在第一列中找到开始日期下标
nend = find(strcmp(onePosition(:,1),endday));%在第一列中找到开始日期下标
tradingdays = onePosition(nstart:nend,1); %策略持续时间
%从日期序列中按照换仓频率提取下标
transvector = computetransferpositionsubscript(tradingdays, 'm');%月

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
    if iPosition ~= cashcol
        LLTs(:,iPosition) = priceToLLT(prices,alpha);
    end

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

Persday = Perspective(:,1);
numPersday = datenum(Persday);%转为日期数字

Multiplier = cell2mat(Information(2:end,2));
onePosition = Position{1,1};
for j = 1:n
    if onePosition{j+1,6} %如果是调仓日
        
        theday = onePosition{j+1,1};%取出日期
        %找到最新观点的日期
        temp = (datenum(theday)>numPersday);
        ktemp = -1;
        for k = 1:length(temp)
            %找到第一个0，前一个便是最新观点日期
            if temp(k) == 0
                ktemp = k - 1;
                break
            end
        end
        %如果当前日期theday小于观点第一个日期，那么ktemp为0
        if ktemp == 0
            wrong('当前计算日期小于观点第一个日期，请添加相应观点');
        elseif ktemp == -1
        %这个情况下，当前日期theday大于所有观点日期，所以采取最后一个观点
            ktemp = length(temp);
        end
        P = Perspective{ktemp,2};%取出观点矩阵
        v = Perspective{ktemp,3};%取出观点矩阵
        conf = Perspective{ktemp,4};%取出信心水平
        %利用日期取出最新观点
        
        sub = ret((j-1-backtime):(j-1-1),:);%j-2即onepnldada中的j-1
        weights = BL(sub,w0,P,v,conf,tau);%计算权重
        subLLT = LLTs((j-2-backtimeD):(j-1-1),:);
        direction = getDirectionLLT(subLLT,cashcol,backtimeD); %利用LLT择时判断
        %direction = [1;1;1;1];
        for iPosition = 1:m
            Position{1,iPosition}{j+1,4} = direction(iPosition); %direction
            oneCapital = capital * weights(iPosition); %分配资金
            oneClose = CloseData{1,iPosition}{j+1,3};%对应价格
            Position{1,iPosition}{j+1,3} = ...
                oneCapital/(Multiplier(iPosition)*oneClose);%计算手数
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
