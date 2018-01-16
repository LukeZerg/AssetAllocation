function riskFreeAsset = GetRiskfreeassetData(startday,endday)
%获取无风险资产数据，这里是逆回购
onecontract = '204001.SH';%逆回购代码
onedata = {{'TradingDay'},{'Contract'},{'Close'},{'Ret'}};
%wind提取数据,按照Fill=Previous的规则
w = windmatlab();
[w_wsd_data,~,~,w_wsd_times,~,~]=w.wsd(onecontract,'close',startday,endday,'Fill=Previous');
if(isempty(w_wsd_data))
    error('wind数据为空');
end
if iscell(w_wsd_data) == 0     %如果w_wsd_data不是cell,因为此时全为数值，将数据变为cell
    w_wsd_data = num2cell(w_wsd_data/(100*365));%除以100为收益率，除以365为当天收益率
end
%TradingDay
nt = size(w_wsd_times,1);
for j = 1:nt
    onedata{j+1,1} = datestr(w_wsd_times(j),29);
    onedata{j+1,2} = onecontract;%赋值合约
    onedata{j+1,4} = w_wsd_data{j};%收益率赋值，close留空不赋值
end
%模拟逆回购价格，使之适应逆回购收益率
onedata{1+1,3} = 1;%初始化第一天价格
for j = 2:nt
    %今日价格=昨日价格*昨日收益率，w_wsd_data没有行名所以减1
    onedata{j+1,3} = onedata{j,3}*(1+w_wsd_data{j-1}); 
end
riskFreeAsset = onedata;
end