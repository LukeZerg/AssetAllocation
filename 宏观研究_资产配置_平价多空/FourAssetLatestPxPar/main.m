clc
clear
%% 参数设置
%将currentFolder目录及其子文件夹添加到路径
%feature('DefaultCharacterSet', 'GBK');%使得matlab能够识别utf8
% currentFolder = 'D:\001Work';
% rmpath(genpath(currentFolder))
currentFolder = 'D:\001Work\宏观研究_资产配置_平价多空\FourAssetLatestPxPar';
addpath(genpath(currentFolder))

%原始数据时间
% startday_dt = '2012-07-01';
% endday_dt = '2017-03-14';
startday_dt = '2012-10-22';
endday_dt = '2017-09-01';
%输入策略时间
%startdayInput = '2017-06-01';
startdayInput = '2014-06-01';
enddayInput = '2017-09-01';   

backtime = 225;%风险平价模型回溯窗口
%capital = 550 * 10000;%20170622仓位
capital = 2500 * 10000;%20170626仓位
%总资产
%capital = 1000*10000;
%BL策略参数
d = 39; %LLT参数(MA均线计算天数d)
alpha = 2 / (d + 1); %LLT公式中的常量，0与1之间
longcol = [1,3]; %只在发出做多信号时入场的资产下标

%参数换为（1，资产个数）的矩阵，每一个参数是这个资产斜率计算天数
backtimeD = [80,43,40,50]; %当前斜率计算天数
%backtimeD = [80,43,20,50]; %最优斜率计算天数

%% 取出并整理平价多空策略需要的数据
%不包括逆回购的三个资产

[startday, endday, data, names] = ...
    getData_riskparityAndLS_LatestPx(startday_dt,endday_dt,startdayInput,...
    enddayInput, backtime, max(backtimeD));

%% 取得Imformation，计算position 和 closeData

infoFile = '合约信息.txt';
Information = GetAssetInformation(infoFile);
[Position0, CloseData0] = GetPosAndCls(data,Information);


%% ----------------------Riskparity多空策略------------------------
%LLT择时
cycle = 'w';  %m w
[Position, CloseData, theWeights ] = ...
    strategyRiskpParityLLT(startday, endday, backtime, capital, Position0,...
    CloseData0, Information, names, longcol,alpha, backtimeD, cycle);
%DMAChg择时
% [Position, CloseData, theWeights ] = ...
%     strategyRiskpParityDMAChg(startday, endday, backtime, capital, Position0,...
%     CloseData0, Information, names, cashcol,backtimeDMA);

%% ----------------------第四部分 从仓位和价格获得交易记录-----------
TradeRecord = computetraderecord(Position, CloseData);

%% ---------------------------第五部分 计算pnl和asset --------------
[AssetData,AssetAll] = computeAsset(Position,TradeRecord, CloseData,...
    Information, capital);

%% ----------------------------Performance-----------------------
[ output ] = Performance( AssetAll );
open output
myplot_FourAsset(AssetAll,AssetData,theWeights)

%% ---------------d---- 参数测试 ---------------------
% 
% backtimeD = [80,180,20,50]; %斜率计算天数   
% parlist = 10:10:220;
% lenp = length(parlist);
% k = 1;
% for i = 1:lenp
%         disp(i);
%         backtimeD(4) = parlist(i); 
%         % ----------------------Riskparity多空策略------------------------
%         %LLT择时
%         cycle = 'w';  %m w
%         [Position, CloseData, theWeights ] = ...
%             strategyRiskpParityLLT(startday, endday, backtime, capital, Position0,...
%             CloseData0, Information, names, longcol,alpha, backtimeD, cycle);
%         %DMAChg择时
%         % [Position, CloseData, theWeights ] = ...
%         %     strategyRiskpParityDMAChg(startday, endday, backtime, capital, Position0,...
%         %     CloseData0, Information, names, cashcol,backtimeDMA);
% 
%         % ----------------------第四部分 从仓位和价格获得交易记录-----------
%         TradeRecord = computetraderecord(Position, CloseData);
% 
%         % ---------------------------第五部分 计算pnl和asset --------------
%         [AssetData,AssetAll] = computeAsset(Position,TradeRecord, CloseData,...
%             Information, capital);
% 
%         % ----------------------------Performance-----------------------
%         [ output ] = Performance( AssetAll );
% 
%         
% 
%         if k == 1
%             %复制名称
%             myoutputs{1,1} = {'Dbacktime'};
%             myoutputs{2,1} = {'backtime'};
%             myoutputs(3:10,1) = output(1:8,3);%name
%             myoutputs{1,k+1} = backtimeD;
%             myoutputs{2,k+1} = backtime;
%             myoutputs(3:10,k+1) = output(1:8,4);%data
%         else
%             myoutputs{1,k+1} = backtimeD;
%             myoutputs{2,k+1} = backtime;
%             myoutputs(3:10,k+1) = output(1:8,4);
%         end
%         k = k + 1;
% end
% surf(blist,Dlsit,Msharpratio); %画出三维图
% 
% surf(blist((end-15):end),Dlsit(1:21),Msharpratio(1:21,5:20)); %画出三维图
% 
% save canshuTest myoutputs Msharpratio Dlsit blist
% load('canshuTest.mat')