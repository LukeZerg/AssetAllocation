%% 参数设置
%将currentFolder目录及其子文件夹添加到路径
currentFolder = 'D:\001Work\宏观研究_资产配置_BL多空';
addpath(genpath(currentFolder))

%原始数据时间
startday_dt = '2010-01-01';
endday_dt = '2017-03-22';
%输入策略时间
startdayInput = '2013-02-04';
enddayInput = '2017-03-22';   
backtime = 60;

%总资产
capital = 30000*10000;
%BL策略参数
d = 39; %MA均线计算天数d
alpha = 2 / (d + 1); %LLT公式中的常量，0与1之间
cashcol = 4; %LLT相关计算和判断需要避开的列
backtimeD = 39; %斜率计算天数

%% 取出并整理平价多空策略需要的数据
[startday, endday, data, names] = ...
    getData_riskparityAndLS(startday_dt,endday_dt,startdayInput,...
    enddayInput,backtime,backtimeD);

%% 取得Imformation，计算position 和 closeData
infoFile = '合约信息.txt';
Information = GetInformation(infoFile);
[Position0, CloseData0] = GetPosAndCls(data,Information);

%% ----------------------BL多空策略------------------------
%w0 = [2;1;3;4];%初始权重
w0 = [4;1;1;1];%初始权重
tau=0.025;%tau越接近0，权重越接近初始权重，数据越接近正无穷，越接近投资者观点。

[Position, CloseData, theWeights ] = ...
    strategyBLLS(startday, endday, backtime, capital, Position0,...
    CloseData0, Information, names, cashcol,alpha, backtimeD, w0, tau);

%% ----------------------第四部分 从仓位和价格获得交易记录-----------
TradeRecord = computetraderecord(Position, CloseData);

%% ---------------------------第五部分 计算pnl和asset --------------
[AssetData,AssetAll] = computeAsset(Position,TradeRecord, CloseData,...
    Information, capital);

%% ----------------------------Performance-----------------------
[ output ] = Performance( AssetAll );
open output
myplot(AssetAll,AssetData,theWeights)

%% 参数测试
% backtimelist = 20:5:250;
% k=1;
% myoutputs = cell(8,length(backtimelist));
% for i = 1:length(backtimelist)
%     disp(i);
%     backtime = backtimelist(i);
%     
%     [Position, CloseData, theWeights ] = ...
%         strategyBLLS(startday, endday, backtime, capital, Position0,...
%         CloseData0, Information, names, cashcol,alpha, backtimeD, w0, tau);
% 
%     TradeRecord = computetraderecord(Position, CloseData);
% 
%     [AssetData,AssetAll] = computeAsset(Position,TradeRecord, CloseData,...
%         Information, capital);
% 
%     [ output ] = Performance( AssetAll );
%     
%     if k == 1
%         myoutputs{1,1} = {'d'};
%         myoutputs{2,1} = {'backtime'};
%         myoutputs(3:10,1) = output(1:8,3);%name
%         myoutputs{1,k+1} = d;
%         myoutputs{2,k+1} = backtime;
%         myoutputs(3:10,k+1) = output(1:8,4);%data
%     else
%         myoutputs{1,k+1} = d;
%         myoutputs{2,k+1} = backtime;
%         myoutputs(3:10,k+1) = output(1:8,4);
%     end
%     k = k + 1;
% end
