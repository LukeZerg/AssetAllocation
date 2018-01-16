function [ pnldata, Assetall, Cumsums, weights ] = ...
    strategBLAndComputeAsset( ...
    startday, endday, backtime, capital, data, names,w0,Perspective,tau)
% startday = '2013-02-04';
% endday = '2017-02-03';
% backtime = 60;
% capital = 30000*10000;
% data = Data


% pnldata 各个品种的pnl， Assetall总资本和总pnl， Cumsums各品种累计pnl，
% weights 各个品种权重
onedata = data{1,1};
n = size(onedata,1)-1;
m = size(onedata,2);

w=windmatlab();
if w.tdayscount(onedata{2,1},startday) < backtime
    error('策略起始日期与原始数据起始日期距离小于回溯时间backtime');
end
if datenum(endday) > datenum(onedata{n+1,1})
    error('策略结束日期在原始数据结束日期之后');
end
nstart = find(strcmp(onedata(:,1),startday));%在第一列中找到开始日期下标
nend = find(strcmp(onedata(:,1),endday));%在第一列中找到开始日期下标
tradingdays = onedata(nstart:nend,1); %策略持续时间
%从日期序列中按照换仓频率提取下标
transvector = computetransferpositionsubscript(tradingdays, 'm');%月

%% 初始化onepnldada ， 计算收益 or 超额收益
pnldata = cell(1,size(data,2));
ret = zeros(n, m); %收益率矩阵
for idata = 1:size(data,2)
    onedata = data{1,idata};
    onepnldada = {{'TradingDay'},{'Close'},{'Ret'},{'Asset'},{'Weight'},...
        {'pnl_h'},{'pnl_t'},{'isChg'}};
    
    %收益率矩阵赋值
    oneRet = cell2mat(onedata(2:end,4));
    %取得市场收益率
    %marketRet = cell2mat(marketData(2:end,4));
    %回归取得该资产对市场的beta
    %beta = regress(oneRet, marketRet); 
    %超额收益
    %ret(:,idata) = oneRet - beta*marketRet;
    %计算该资产的超额收益
    ret(:,idata) = oneRet;
    %赋值
    for j = 1:n
        onepnldada{j+1,1} = onedata{j+1,1};%tradingday
        onepnldada{j+1,2} = onedata{j+1,3};%close
        onepnldada{j+1,3} = onedata{j+1,4};%ret
        
        onepnldada{j+1,4} = 0;  %Asset
        onepnldada{j+1,5} = 0;  %Weight
        onepnldada{j+1,6} = 0;  %pnl_h
        onepnldada{j+1,7} = 0;  %pnl_t
        onepnldada{j+1,8} = 0;  %isChg
    end
    ntv = size(transvector,1);
    for i = 1:ntv
        itv = transvector(i) + nstart - 1;%onepnldada中调仓日下标
        onepnldada{itv,8} = 1;%%isChg,调仓日
    end
    pnldata{1,idata} = onepnldada;
end
%% 取出最新投资者观点，计算权重
Persday = Perspective(:,1);
numPersday = datenum(Persday);%转为日期数字
onepnldada = pnldata{1,1};
for j = 1:n
    if onepnldada{j+1,8} %如果是调仓日
        theday = onepnldada{j+1,1};%取出日期
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
        sub = ret((j-backtime):(j-1),:);
        weights = BL(sub,w0,P,v,conf,tau);%计算权重
        for idata = 1:size(data,2)
            pnldata{1,idata}{j+1,5} = weights(idata); %Weight
            pnldata{1,idata}{j+1,4} = capital * weights(idata); %Asset
        end
    end
end

%% pnl

%滚动计算pnl
for idata = 1:size(data,2)
    for j = 2:n
        if ~pnldata{1,idata}{j+1,8} %不是调仓日
            pnldata{1,idata}{j+1,6} = ...
                    pnldata{1,idata}{j,4} * pnldata{1,idata}{j+1,3};
            %今日持仓盈亏=昨日资本*今日收益率
            pnldata{1,idata}{j+1,4} = pnldata{1,idata}{j,4} + ...
                    pnldata{1,idata}{j+1,6} + pnldata{1,idata}{j+1,7};
            %今日资本=昨日资本+今日持仓盈亏+今日交易盈亏    
        else %调仓日不用再算asset
            pnldata{1,idata}{j+1,6} = ...
                    pnldata{1,idata}{j,4} * pnldata{1,idata}{j+1,3};
            %今日持仓盈亏=昨日资本*今日收益率
            %调仓日算tradingpnl
            
        end
    end
end

%onepnldada 筛选策略时间段
startnull = 2:(nstart-1);%start之前的为空
endnull = (nend+1):(n+1);%end之后的为空
for idata = 1:size(data,2)
    pnldata{1,idata}([startnull,endnull],:) = [];
end

%汇总
tradingday = pnldata{1,1}(2:end,1);
Assetall = {{'TradingDay'},{'Asset'},{'pnl_h'},{'pnl_t'}};
len = nend - nstart + 1;
asset = ones(len,1)*capital;
pnl_h = zeros(len,1);
pnl_t = zeros(len,1);

%汇总pnl
for idata = 1:size(data,2)
    onepnldata = pnldata{1,idata};
    onepnl_h = cell2mat(onepnldata(2:end, 6)); 
    onepnl_t = cell2mat(onepnldata(2:end, 7));
    pnl_h = pnl_h + onepnl_h;
    pnl_t = pnl_t + onepnl_t;
end
Assetall(2:len+1,1) = tradingday;

Assetall(2:len+1,3) = num2cell(cumsum(pnl_h));
Assetall(2:len+1,4) = num2cell(cumsum(pnl_t));
Assetall(2:len+1,2) = num2cell(asset + cumsum(pnl_h) + cumsum(pnl_t));

%分品种名称

%分品种累计收益统计
cumsums = zeros(size(tradingday,1),size(pnldata,2));
for i=1:size(pnldata,2)
    cumsums(:,i) = cumsum(cell2mat(pnldata{1,i}(2:end, 6)));
end
cumsums = num2cell(cumsums);
Cumsums = [{'TradingDay'},names];
Cumsums(2:len+1,1) = tradingday;
Cumsums(2:len+1,2:end) = cumsums;


% 权重数据整理
onepnldata = pnldata{1,1};
n = size(onepnldata,1);
weights = cell(n,size(pnldata,2)+1);    %weights存储权重
weights(1,:) = [{'TradingDay'},names];
weights(2:end,1) = onepnldata(2:end,1);
for i = 1:size(pnldata,2)
    weights(2:end,i+1) = pnldata{1,i}(2:end,5);%赋值
end
is0 = zeros(n,1); %记录全部是0的部分
for i = 2:n
    temp = cell2mat(weights(i,2:end));%取出这一天所有权重
    if sum(temp) == 0 %如果权重都为0
        is0(i) = 1;
    end
end
weights(find(is0),:) = [];

end
