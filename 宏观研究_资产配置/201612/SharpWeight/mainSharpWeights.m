%Wind数据
%原始数据时间
startday_dt = '2010-11-02';
endday_dt = '2017-01-11';
Data = getindexdata(startday_dt, endday_dt, [{'000001.SH'},{'NH0100.NHF'}]);
%策略时间
startday = '2011-07-01';
endday = '2017-01-11';
names = {{'上证综指'},{'南华商品指数'}};
%% 读取国债数据
feature('DefaultCharacterSet', 'UTF8');%使得matlab能够识别utf8
fid = fopen('D:/001Work/宏观研究_资产配置/201612/data/10年期国债收益率.txt','r');
info = textscan(fid, '%s%f','HeaderLines',0,'Delimiter',',');%textscan的Name-Value Pair Arguments方法，跳过开始的1行，以','为分隔符,info每个cell为1列
fclose(fid);
%读取国债数据，合成Data品种的一部分
tradingdays = info{1,1};
treasurycls = num2cell(info{1,2});

%onedata和wind接口取得数据的日期不一致，相互都有不一致的日期
%寻找不同日期并在onedata里删除
ddt = Data{1,1};
tdays = ddt(2:end,1);
daydiff = setdiff(tradingdays, tdays); %找到wind接口中没有的日期
% Lia = ismember(A,B) returns an array containing 1 (true) where the ...
% data in A is found in B. Elsewhere, it returns 0 (false).
vectorfind = find(ismember(tradingdays,daydiff)==1);
tradingdays(vectorfind) = [];
treasurycls(vectorfind) = [];%删除

%剔除后的tradingdays在tdays中的位置
vectorfind2 = find(ismember(tdays,tradingdays)==1);
tdays2 = tdays;
treasurycls2 = zeros(size(tdays2,1),size(tdays2,2));
treasurycls2(vectorfind2) = cell2mat(treasurycls);%在相应位置上赋值

%滚动填充0值
prebox = 0;
n = length(treasurycls2);
for i = 1:n
    if treasurycls2(i) == 0
        treasurycls2(i) = prebox;
    else
        prebox = treasurycls2(i);
    end
end

%合成Data的一部分
contract = cell(size(tdays2,1),1);
contract(:,1) = {'treasury'};
onedata = [tdays2, contract, num2cell(treasurycls2)];
onedata = [{'TradingDay'},{'Contract'},{'Close'};onedata];
%合并到Data中
Data = [Data,{onedata}];
names = [names,{'国债'}];

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
%% 策略
[pnldata, Assetall, Cumsums, weights ] = ...
    strategSharpAndReturnWeightsAndComputeAsset(startday, endday, 59, 30000*10000, Data, names);
[ output ] = Performance( Assetall );

%Plot_Animation_Net(output);
