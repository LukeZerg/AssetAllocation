clc;
clear;
load('D:/001Work/宏观研究_资产配置_平价/杠杆/data_RiskParity.mat');

currentFolder = 'D:\001Work\宏观研究_资产配置_平价\NewBackTest';%通用包
addpath(genpath(currentFolder))
currentFolder = 'D:\001Work\宏观研究_资产配置_平价\杠杆';%本策略特有文件
addpath(genpath(currentFolder))


Tradingdays = Data{1,1}(2:end,1);

global strategy
strategy.endday = Tradingdays{end};
strategy.startday = Tradingdays{225+2};
strategy.capital = 3000 * 10000;%20170626仓位
strategy.backtime = 225;%风险平价模型回溯窗口
strategy.cycle = 'w'; %m w
strategy.lever = [1,1,1,2];
%---------------------初始化----------------------
%有误，用具体合约后，合约乘数等信息应该从wind提取
Position0 = GetPos(Close,Information);
%-----------------------配置比例---------------------------------
[Position_abs, theWeights_abs, Close_strategy ] = ...
    WeightRiskpParity(Position0, Data, Close, Information);
%----------------------用大类资产价格判断方向------------------------------------------
Direction = DirectionAllocation(Data,Position0);
%----------------------合并配置比例和方向成为仓位-----------------------
Position = createPosition( Position_abs, Direction );
Weight = createWeight(theWeights_abs, Direction );
% --------------------从仓位和价格获得交易记录-----------
TradeRecord = computetraderecord(Position, Close_strategy);
%----------------------计算pnl和asset -------------------
[AssetData,AssetAll] = computeAsset(Position,TradeRecord, Close_strategy,...
    Information);
%-----------------------Performance-----------------------
[ output ] = Performance( AssetAll );
open output
myplot_FourAsset(AssetAll,AssetData,Weight);