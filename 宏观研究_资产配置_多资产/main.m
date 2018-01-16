clc;
clear;
load('D:/001Work/����о�_�ʲ�����_���ʲ�/data_RiskParity.mat');

currentFolder = 'D:\001Work\����о�_�ʲ�����_���ʲ�';%ͨ�ð�
addpath(genpath(currentFolder))

Tradingdays = Data{1,1}(2:end,1);
names = Data(2,:);
global strategy
strategy.endday = Tradingdays{end};
strategy.startday = Tradingdays{225+2};
strategy.capital = 1000 * 10000;%20170626��λ
strategy.backtime = 20;%����ƽ��ģ�ͻ��ݴ���
strategy.cycle = 'w'; %m w
%---------------------��ʼ��----------------------
%�����þ����Լ�󣬺�Լ��������ϢӦ�ô�wind��ȡ
Position0 = GetPos(Close,Information);
%-----------------------���ñ���---------------------------------
[Position_abs, theWeights_abs, Close_strategy ] = ...
    WeightRiskpParity(Position0, Data, Close, Information);
%----------------------�ô����ʲ��۸��жϷ���------------------------------------------
Direction = DirectionAllocation(Data,Position0);
%----------------------�ϲ����ñ����ͷ����Ϊ��λ-----------------------
Position = createPosition( Position_abs, Direction );
Weight = createWeight(theWeights_abs, Direction );
% --------------------�Ӳ�λ�ͼ۸��ý��׼�¼-----------
TradeRecord = computetraderecord(Position, Close_strategy);
%----------------------����pnl��asset -------------------
[AssetData,AssetAll] = computeAsset(Position,TradeRecord, Close_strategy,...
    Information);
%-----------------------Performance-----------------------
[ output ] = Performance( AssetAll );
open output
open AssetData
myplot_mAsset(AssetAll,AssetData,Weight,names);

save('D:/001Work/����о�_�ʲ�����_ƽ��/BondFut/AssetAll.mat','AssetAll');