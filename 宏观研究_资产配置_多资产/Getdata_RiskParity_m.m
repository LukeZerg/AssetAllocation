clc;
clear;
%获取大资产价格数据Data，与具体合约数据Close，大类资产每个cell和具体合约数据每个cell一一对应
startday_dt = '2015-04-20';
endday_dt = '2017-12-01';
currentFolder = 'D:\001Work\宏观研究_资产配置_多资产';
addpath(genpath(currentFolder))

%% 大类资产价格Data
w=windmatlab();
%A股、商品、港股、国债
names = {'上证50','中证500','中债固定利率债券全价','上清所银行间信用债综合指数','WIND商品指数','WIND黄金指数','恒生指数'};
contract = {'000016.SH','000905.SH','0451.CS','SCH012.SCH','CCFI.WI','NH0008.NHF','HSI.HI'};
Data = getindexdata(startday_dt, endday_dt, contract);
Data = [Data;names];
%将Data最后一行置换为即时价格
% [w_data,w_codes,w_fields,w_times,w_errorid,w_reqid]=w.wsq('000300.SH,NH0100.NHF,159920.SZ','rt_last');
% Data{1,1}{end,3} = w_data(1);
% Data{1,2}{end,3} = w_data(2);
% Data{1,3}{end,3} = w_data(3);

%% 具体合约数据CLose
%A股、商品、港股、国债
Close = getETFdata(startday_dt, endday_dt, contract);
Close = [Close;names];

%% Information
Information = cell(length(contract)+1,4);
Information(1,:) = {'variety','Multiplier','SlipPrice','fee'};
Information(2:end,1) = contract';
Information(2:end,2) = {1};%乘数
Information(2:end,3) = {0.01};%滑点
Information(2:end,4) = {0.0005};%万五手续费

save('D:/001Work/宏观研究_资产配置_多资产/data_RiskParity.mat','Data','Close','Information');