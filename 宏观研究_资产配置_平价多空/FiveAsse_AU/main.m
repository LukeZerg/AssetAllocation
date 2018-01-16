clc
clear
% 取出并整理平价多空策略需要的数据
load('D:/001Work/宏观研究_资产配置_平价多空/FiveAsse_NASDAQ/data.mat'); 
%% 参数设置
%将currentFolder目录及其子文件夹添加到路径
%feature('DefaultCharacterSet', 'GBK');%使得matlab能够识别utf8
% currentFolder = 'D:\001Work';
% rmpath(genpath(currentFolder))
currentFolder = 'D:\001Work\宏观研究_资产配置_平价多空\FiveAsse_AU';
addpath(genpath(currentFolder))

%输入策略时间
%startdayInput = '2017-06-01';
startdayInput = '2014-06-01';
enddayInput = '2017-08-04';   

backtime = 225;%风险平价模型回溯窗口
 %斜率计算天数
backtimeD = [80,43,20,200,50];%参数换为（1，资产个数）的矩阵，每一个参数是这个资产斜率计算天数
if max(backtimeD) > backtime
    wrong('斜率计算天数超过回溯计算天数');
end

%总资产
capital = 3000 * 10000;%20170626仓位

%BL策略参数
d = 39; %LLT参数(MA均线计算天数d)
alpha = 2 / (d + 1); %LLT公式中的常量，0与1之间
longcol = [1,3,4]; %只在发出做多信号时入场的资产下标

%用交易日修正策略时间
w = windmatlab();
[w_tdays_data,~,~,~,~,~]=w.tdays(startdayInput, enddayInput);
if(isempty(w_tdays_data))
    error('wind数据为空');
end
startday = datestr(w_tdays_data{1},29);
endday = datestr(w_tdays_data{end},29);

%% 取得Imformation，计算position 和 closeData

infoFile = '合约信息.txt';
Information = GetAssetInformation(infoFile); %与资产顺序保持一致

[Position0, CloseData0] = GetPosAndCls(Data,Information);

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
% backtimeD = [80,43,40,43,50]; %斜率计算天数   
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
%             myoutputs{1,k+1} = parlist(i);
%             myoutputs{2,k+1} = backtime;
%             myoutputs(3:10,k+1) = output(1:8,4);%data
%         else
%             myoutputs{1,k+1} = parlist(i);
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