function [ pnldata, Assetall,temp ] = equalweightandcomputeasset( startday, ...
                            endday, backtime, capital, data)
%等权重策略
% startday = '2014-05-01';
% endday = '2017-01-11';
% backtime = 60;
% capital = 30000*10000;
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

%初始化onepnldada
pnldata = cell(1,size(data,2));
close = zeros(n, m); %价格矩阵
ret = zeros(n, m); %收益率矩阵
for idata = 1:size(data,2)
    onedata = data{1,idata};
    onepnldada = {{'TradingDay'},{'Close'},{'Ret'},{'Asset'},{'Weight'},...
        {'pnl_h'},{'pnl_t'},{'isChg'}};
    for j = 1:n
        close(j,idata) = onedata{j+1,3};     %赋值价格
    end
    ret(2:end,idata) = diff(close(:,idata))./close(1:(end-1),idata);%收益率
    %赋值
    for j = 1:n
        onepnldada{j+1,1} = onedata{j+1,1};%tradingday
        onepnldada{j+1,2} = onedata{j+1,3};%close
        onepnldada{j+1,3} = ret(j,idata);%ret
        
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

%计算权重，分配资金
onepnldada = pnldata{1,1};
%资产种类
ndata = size(data,2);
for j = 1:n
    if onepnldada{j+1,8} %如果是调仓日
        weights = ones(1,ndata)*(1/ndata);%计算权重
        for idata = 1:size(data,2)
            pnldata{1,idata}{j+1,5} = weights(idata); %Weight
            pnldata{1,idata}{j+1,4} = capital * weights(idata); %Asset
        end
    end
end

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

temp = [cumsum(cell2mat(pnldata{1,1}(2:end, 6))),cumsum(cell2mat(pnldata{1,2}(2:end, 6))),cumsum(cell2mat(pnldata{1,3}(2:end, 6)))];

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
end