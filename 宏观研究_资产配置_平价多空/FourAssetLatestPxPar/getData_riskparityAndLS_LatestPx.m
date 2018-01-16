function [startday, endday, Data, names] = ...
    getData_riskparityAndLS_LatestPx...
    (...
    startday_dt,endday_dt,startdayInput,enddayInput,backtime,backtimeD...
    )
%获取并整理平价多空策略数据，剔除逆回购部分

% %原始数据时间
% startday_dt = '2012-11-01';
% endday_dt = '2017-03-02';
% %输入策略时间
% startdayInput = '2013-02-04';
% enddayInput = '2017-03-02';   
% backtime = 60;

w=windmatlab();

names = {{'沪深300'},{'南华商品指数'},{'恒生ETF'}};

%Wind数据
Data = getindexdata(startday_dt, endday_dt, [{'000300.SH'},{'NH0100.NHF'},{'159920.SZ'}]);

%将Data最后一行置换为即时价格
%  [w_data,w_codes,w_fields,w_times,w_errorid,w_reqid]=w.wsq('000300.SH,NH0100.NHF,159920.SZ','rt_last');
%  Data{1,1}{end,3} = w_data(1);
%  Data{1,2}{end,3} = w_data(2);
%  Data{1,3}{end,3} = w_data(3);

%% 参数修正

%用交易日修正策略时间
[w_tdays_data,~,~,~,~,~]=w.tdays(startdayInput, enddayInput);
if(isempty(w_tdays_data))
    error('wind数据为空');
end
startday = datestr(w_tdays_data{1},29);
endday = datestr(w_tdays_data{end},29);

if backtimeD > backtime
    wrong('斜率计算天数超过回溯计算天数');
end

%% 10年期国债收益率 计算国债现券价格

[ret10,~,~,wtimes] = w.edb('M0325687', startday_dt, endday_dt,'Fill=Previous');

treasurycls = 100./((ret10/100+1).^10); %计算国债现券价格
treasurycls = num2cell(treasurycls);
temp = num2cell(wtimes); %转为cell
tradingdays = cell(length(temp),1);
for i = 1:length(temp)
    tradingdays{i} = datestr(temp{i},29);
end
%%
%10年期国债和Data数据的日期不一致，相互都有不一致的日期
%寻找不同日期并在10年期国债数据里删除
ddt = Data{1,1};
tdays = ddt(2:end,1);
daydiff = setdiff(tradingdays, tdays); %找到Data中没有的日期
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
    %ret = log(close(2:end)./close(1:(end-1))); %对数收益率
    ret = diff(close(:))./close(1:(end-1));%收益率
    Ret = [{'Ret'};0;num2cell(ret)];
    Data{1,iData} = [Data{1,iData},Ret];
end

end