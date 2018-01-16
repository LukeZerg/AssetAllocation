clc
clear
%% 参数设置
%将currentFolder目录及其子文件夹添加到路径
%feature('DefaultCharacterSet', 'GBK');%使得matlab能够识别utf8
% currentFolder = 'D:\001Work';
% rmpath(genpath(currentFolder))
currentFolder = 'D:\001Work\宏观研究_资产配置_平价多空\FourAssetLastPxCYield';
addpath(genpath(currentFolder))

%原始数据时间
% startday_dt = '2012-07-01';
% endday_dt = '2017-03-14';
startday_dt = '2015-03-22';
endday_dt = '2017-07-18';
%输入策略时间
%startdayInput = '2017-06-01';
startdayInput = '2016-07-01';
enddayInput = '2017-07-18';   

backtime = 225;%风险平价模型回溯窗口
%capital = 550 * 10000;%20170622仓位
global s
s.capital = 800 * 10000;%20170626仓位
%总资产
%capital = 1000*10000;
%BL策略参数
d = 39; %LLT参数(MA均线计算天数d)
alpha = 2 / (d + 1); %LLT公式中的常量，0与1之间
longcol = [1,3]; %只在发出做多信号时入场的资产下标
backtimeD = 43; %斜率计算天数
backtimeDMA = 3;%DMAChg趋势判断天数


%% 取出并整理平价多空策略需要的数据
%不包括逆回购的三个资产

[startday, endday, data, names] = ...
    getData_riskparityAndLS_LatestPx(startday_dt,endday_dt,startdayInput,...
    enddayInput,backtime,backtimeD);

%% 取得Imformation，计算position 和 closeData

infoFile = '合约信息.txt';
Information = GetAssetInformation(infoFile);
[Position0, CloseData0] = GetPosAndCls(data,Information);

%% 取得C值排名和C值表日期

% [~,~,cdata] = xlsread('D:/001Work/宏观研究_资产配置_平价多空/FourAssetLastPxCYield/程序化排名.csv');
%save('D:/001Work/宏观研究_资产配置_平价多空/FourAssetLastPxCYield/cdata.mat','cdata');
load('D:/001Work/宏观研究_资产配置_平价多空/FourAssetLastPxCYield/cdata.mat');

% [~,~,comInfo] = xlsread('D:/001Work/宏观研究_资产配置_平价多空/FourAssetLastPxCYield/商品信息.xlsx');
% save('D:/001Work/宏观研究_资产配置_平价多空/FourAssetLastPxCYield/comInfo.mat','comInfo');
load('D:/001Work/宏观研究_资产配置_平价多空/FourAssetLastPxCYield/comInfo.mat');

%% ----------------------Riskparity多空策略------------------------
%LLT择时

[Position, CloseData, theWeights, theDirection ] = ...
    strategyRiskpParityLLTAsset(startday, endday, backtime, Position0,...
    CloseData0, names, longcol,alpha, backtimeD, cdata);

%% 计算除了商品外三种资产的position和Close
comcol = 2;%商品是第二个资产
[threePos,threeCls,threeInfo] = getThreePosCls(Position, CloseData, theDirection, theWeights, Information );
 
%% 取得商品cls，计算商品pos
Position_COM = Position{1,2};

% CloseData_COM = getcls_COM(Position_COM,comInfo); %获取商品价格
% save('D:/001Work/宏观研究_资产配置_平价多空/FourAssetLastPxCYield/CloseData_COM.mat','CloseData_COM');
load('D:/001Work/宏观研究_资产配置_平价多空/FourAssetLastPxCYield/CloseData_COM.mat');

[Weights_COM, Direction_COM] = getWD_COM(theWeights,theDirection,comcol); %获取商品总体的权重与方向

nls = 6; %多空个数，多nls个，空nls个
Pos_COM = getpos_COM(Position_COM, CloseData_COM, Weights_COM, Direction_COM, cdata ,comInfo ,nls ); %结合C值排序确定商品仓位

%% ----------------------合并仓位 价格 Imfo--------------
CloseData2 = [threeCls,CloseData_COM];
Position2 = [threePos,Pos_COM];
%info
temp = comInfo;
cominfo1 = temp(2:end,2:5);
Information2 = [threeInfo;cominfo1];
%% ----------------------第四部分 从仓位和价格获得交易记录-----------
TradeRecord = computetraderecord(Position2, CloseData2);

%% ---------------------------第五部分 计算pnl和asset --------------
[AssetData,AssetAll] = computeAsset(Position2,TradeRecord, CloseData2,...
    Information2);

%商品盈亏汇总
nA = size(AssetData,2);
nt = size(AssetData{1,i},1);
AssetCom = cell(nt,length(4:nA)+1);
AssetCom(:,1) =  AssetData{1,i}(:,1);
variety = comInfo(2:end,2)';
AssetCom(1,2:end) = variety;
for i = 4:nA
    temp = AssetData{1,i}(2:end,3:4);
    temp1 = cumsum(cell2mat(temp));
    temp2 = sum(temp1,2);
    AssetCom(2:end,i-2) = num2cell(temp2);
end


%将期货合并
collist = 4:36;
AssetDataMerge = mergeCOMAssetData(AssetData,collist);
%% ----------------------------Performance-----------------------
[ output ] = Performance( AssetAll );
open output
myplot_FourAsset(AssetAll,AssetDataMerge,theWeights)

%% ---------------d---- 参数测试 ---------------------
% Dlsit = [40:1:60,160:1:170];
% lend = length(Dlsit);
% 
% blist = [25:10:55,165:10:315];
% lenb = length(blist);
% 
% alpha = 2 / (39 + 1);
% 
% Msharpratio = zeros(lend,lenb);
% myoutputs = cell(8,1+lend*lenb);
% k = 1;
% for i = 1:lend
%     for j = 1:lenb
%         disp(i);
%         backtimeD = Dlsit(i);
%         backtime = blist(j);
%         [Position, CloseData, theWeights ] = ...
%         strategyRiskpParityLLT(startday, endday, backtime, capital, Position0,...
%         CloseData0, Information, names, cashcol,alpha, backtimeD,cycle);
% 
%         TradeRecord = computetraderecord(Position, CloseData);
% 
%         [AssetData,AssetAll] = computeAsset(Position,TradeRecord, CloseData,...
%             Information, capital);
% 
%         [ output ] = Performance( AssetAll );
%         
%         Msharpratio(i,j) = output{8,4};%记录夏普率矩阵
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
%     end
% end
% 
% surf(blist,Dlsit,Msharpratio); %画出三维图
% 
% surf(blist((end-15):end),Dlsit(1:21),Msharpratio(1:21,5:20)); %画出三维图
% 
% save canshuTest myoutputs Msharpratio Dlsit blist
% load('canshuTest.mat')