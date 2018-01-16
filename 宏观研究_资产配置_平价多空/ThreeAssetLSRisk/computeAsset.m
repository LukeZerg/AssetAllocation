function [AssetData, AssetAll] = computeAsset(position,TradeRecord, CloseData, Information, iniCapital)
%从交易记录和价格数据里获取资产信息
%AssetData各品种pnl，AssetAll总的pnl

% position = Position
% iniCapital = capital


%品种信息初始化
%name = Information(2:end,1); %名称
multiplier = Information(2:end,2);   %乘数
slipPrice = Information(2:end,3); %滑点
fee = Information(2:end,4); %手续费

Multiplier = multiplier;
SlipPrice = slipPrice;
Fee = fee;

%资产矩阵初始化
nPosition = size(position,2);
AssetData = cell(1,nPosition);%包括所有品种，每种品种分为多空两列
for i = 1:nPosition %循环品种多空
    AssetData{1,i} = {'TradingDay','Contract','pnl_h','pnl_t','Asset_deposit','Asset_all','Asset_cash','deposit'};
    pos = position{1,i}; %获取仓位
    nt = size(pos,1)-1;%日期序列
    TradingDays = pos(2:end,1);
    oneCloseData = CloseData{1,i}; %该品种CloseData数据
    oneContract = pos(:,2);%取出合约列
    for j = 1:nt
       %赋值日期
       AssetData{1,i}(j+1,1) = TradingDays(j);
       AssetData{1,i}(j+1,2) = oneContract(j+1);%合约
       AssetData{1,i}{j+1,3} = 0;
       AssetData{1,i}{j+1,4} = 0;
       AssetData{1,i}{j+1,5} = 0;
       AssetData{1,i}{j+1,6} = 0;
       AssetData{1,i}{j+1,7} = 0;
       AssetData{1,i}(j+1,8) = oneCloseData(j+1,7);%保证金率 deposit 
    end
end

%资产矩阵计算
for i = 1:nPosition
    pos = position{1,i};
    trecord = TradeRecord{1,i};
    cdata = CloseData{1,i};
    nt = size(pos,1)-1;
    %nt
    for t = 2:nt  %循环日期,从第二天开始算
        tradeDay = AssetData{1,i}{t+1,1};
        %trading pnl
        AssetData{1,i}{t+1,4} = 0;%tradepnl初始化为0
        %查找今日是否有交易
        vector = FindinCell(trecord ,1 ,tradeDay);
        if ~isempty(vector) %若有交易
            tradeprice = trecord{vector,3}; %成交价
            curren = trecord{vector,4};     %手数
            %手续费=-1*乘数*成交价*手数*手续费率
            feeCost = double(-1 * Multiplier{i} * tradeprice...
                * curren * Fee{i});
            %滑价损失=-1*滑价*乘数*手数  
            slipCost = double( -1 * SlipPrice{i} * Multiplier{i} * curren);
            %加上double是为了统一数据类型
            AssetData{1,i}{t+1,4} = feeCost + slipCost;
        end
        % Hoding Pnl      
        AssetData{1,i}{t+1,3} = ...     
        double( cdata{t+1,5} - cdata{t,3} )...%昨日合约今日价格-昨日合约昨日价格
        * double(pos{t,3} * pos{t,4} * Multiplier{i});  %昨日仓位，昨日方向              
        %deposit
        %今日仓位=乘数*当日合约当日价格*当日仓位
        todayposition = double(Multiplier{i} * cdata{t+1,3} * pos{t+1,3});
        ratedeposit = double(AssetData{1,i}{t+1,8}/100);%今日保证金率
        AssetData{1,i}{t+1,5} = todayposition * ratedeposit;%保证金
    end
end

%汇总
AssetAll = {'TradingDay','pnl_h','pnl_t','Asset_deposit','Asset_all','Asset_cash'};
ad = AssetData{1,1};
pos = position{1,1};
TradingDays = pos(2:end,1);
nt = size(TradingDays,1);
AssetAll(2:nt+1,1) = TradingDays;
%汇总
hodingpnlAll = zeros(size(ad,1)-1,1);
tradepnlAll = zeros(size(ad,1)-1,1);
assetdepositAll = zeros(size(ad,1)-1,1);
for i = 1:nPosition
    ad = AssetData{1,i};
    %每一个品种的pnl
    hodingpnl = cell2mat(ad(2:end,3));
    tradepnl = cell2mat(ad(2:end,4));
    assetdeposit = cell2mat(ad(2:end,5));
    %对应每一天求和
    hodingpnlAll = hodingpnlAll + hodingpnl;
    tradepnlAll = tradepnlAll + tradepnl;
    assetdepositAll = assetdepositAll + assetdeposit;
end
%累计pnl
temp = cumsum(hodingpnlAll);
temp2 = cumsum(tradepnlAll);
temp3 = [temp,temp2];
cumpnl = cumsum(hodingpnlAll) + cumsum(tradepnlAll);
%总权益
assettotal = iniCapital + cumpnl;
%可用
assetcash = assettotal - assetdepositAll;

AssetAll(2:nt+1,2) = num2cell(hodingpnlAll);
AssetAll(2:nt+1,3) = num2cell(tradepnlAll);
AssetAll(2:nt+1,4) = num2cell(assetdepositAll);
AssetAll(2:nt+1,5) = num2cell(assettotal);
AssetAll(2:nt+1,6) = num2cell(assetcash);


end