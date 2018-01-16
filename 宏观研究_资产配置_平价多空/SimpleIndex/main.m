%% 参数设置
%将currentFolder目录及其子文件夹添加到路径
currentFolder = 'D:\001Work\宏观研究_资产配置_平价多空\SimpleIndex';
addpath(genpath(currentFolder))

%原始数据时间
startday_dt = '2012-11-01';
endday_dt = '2017-03-03';
%输入策略时间
startdayInput = '2013-02-04';
enddayInput = '2017-03-03';   
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
    getData_riskparityAndLS(startday_dt,endday_dt,startdayInput,enddayInput,backtime,backtimeD);

%% Riskparity策略
[pnldata, Assetall, Cumsums, weights ] = ...
    strategyriskprityandcomputeasset(startday, endday, backtime, capital, data, names, cashcol,alpha, backtimeD);
[ output ] = Performance( Assetall );
