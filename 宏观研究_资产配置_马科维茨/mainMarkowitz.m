%Wind数据
%原始数据时间
startday_dt = '2010-11-02';
endday_dt = '2017-02-03';
Data = getindexdata(startday_dt, endday_dt, [{'000001.SH'},{'NH0100.NHF'},{'0372.CS'}]);
%策略时间
startday = '2011-02-01';
endday = '2017-02-03';
names = {{'上证综指'},{'南华商品指数'},{'中债总净价指数'}};

%% 加入收益率
for iData = 1:size(Data,2)
    close = cell2mat(Data{1,iData}(2:end,3));
    ret = log(close(2:end)./close(1:(end-1))); %对数收益率
    %ret = diff(close(:))./close(1:(end-1));%收益率
    Ret = [{'Ret'};0;num2cell(ret)];
    Data{1,iData} = [Data{1,iData},Ret];
end

%% 读取Wind逆回购收益数据
onecontract = '204001.SH';%逆回购代码
w=windmatlab();
onedata = {{'TradingDay'},{'Contract'},{'Close'},{'Ret'}};
%wind提取数据,按照Fill=Previous的规则
[w_wsd_data,~,~,w_wsd_times,~,~]=w.wsd(onecontract,'close',startday_dt,endday_dt,'Fill=Previous');
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
Data = [Data,{onedata}];
names = [names,{'逆回购'}];

%% 市场组合和市场收益率
marketData = getindexdata(startday_dt, endday_dt, [{'000300.SH'}]);
marketData = marketData{1,1};
% 收益率
close = cell2mat(marketData(2:end,3));
ret = log(close(2:end)./close(1:(end-1))); %对数收益率
%ret = diff(close(:))./close(1:(end-1));%收益率
Ret = [{'Ret'};0;num2cell(ret)];
marketData = [marketData,Ret];
%% 策略
[pnldata, Assetall, Cumsums, weights ] = ...
    strategMarkowitzAndComputeAsset(startday, endday, 60, 30000*10000, Data, names, marketData);
[ output ] = Performance( Assetall );

%Plot_Animation_Net(output);