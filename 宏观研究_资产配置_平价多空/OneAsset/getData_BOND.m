function [startday, endday, Data, names] = ...
    getData_BOND...
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

%Wind数据
w=windmatlab();
tdays = w.tdays(startday_dt, endday_dt); %找到startday_dt到endday_dt之间的交易日序列

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

% 10年期国债收益率 计算国债现券价格
[ret10,~,~,wtimes] = w.edb('M0325687', startday_dt, endday_dt,'Fill=Previous');
treasurycls = 100./((ret10/100+1).^10); %计算国债现券价格
treasurycls = num2cell(treasurycls);
temp = num2cell(wtimes); %转为cell
tradingdays = cell(length(temp),1);
for i = 1:length(temp)
    tradingdays{i} = datestr(temp{i},29);
end

%10年期国债和Data数据的日期不一致，相互都有不一致的日期
%首先统一两个数据日期的格式
for i = 1:size(tdays,1)
    tdays{i,1} = datestr(tdays{i,1},29);
end
%用来保存交易日对应价格的序列
treasurycls2 = zeros(size(tdays));
%按照交易日遍历，如果这天国债有数据，便赋值到交易日这天的价格中
for i = 1:size(tdays,1)
    subs = FindinCell(tradingdays, 1, tdays{i,1});
    treasurycls2(i) = treasurycls{subs};%日期不会重复
end

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
contract = cell(size(tdays,1),1);
contract(:,1) = {'treasury'};
onedata = [tdays, contract, num2cell(treasurycls2)];
onedata = [{'TradingDay'},{'Contract'},{'Close'};onedata];
%合并到Data中
Data = [{onedata}];
names = [{'国债'}];

%% 加入收益率
for iData = 1:size(Data,2)
    close = cell2mat(Data{1,iData}(2:end,3));
    %ret = log(close(2:end)./close(1:(end-1))); %对数收益率
    ret = diff(close(:))./close(1:(end-1));%收益率
    Ret = [{'Ret'};0;num2cell(ret)];
    Data{1,iData} = [Data{1,iData},Ret];
end

end