clc;
clear;
load('D:/001Work/����о�_�ʲ�����_ƽ��/�ܸ�/data_RiskParity.mat');

currentFolder = 'D:\001Work\����о�_�ʲ�����_ƽ��\NewBackTest';%ͨ�ð�
addpath(genpath(currentFolder))
currentFolder = 'D:\001Work\����о�_�ʲ�����_ƽ��\�ܸ�';%�����������ļ�
addpath(genpath(currentFolder))


Tradingdays = Data{1,1}(2:end,1);

global strategy
strategy.endday = Tradingdays{end};
strategy.startday = Tradingdays{225+2};
strategy.capital = 3000 * 10000;%20170626��λ
strategy.backtime = 225;%����ƽ��ģ�ͻ��ݴ���
strategy.cycle = 'w'; %m w
strategy.lever = [1,1,1,2];
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
myplot_FourAsset(AssetAll,AssetData,Weight);