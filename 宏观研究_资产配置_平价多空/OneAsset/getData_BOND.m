function [startday, endday, Data, names] = ...
    getData_BOND...
    (...
    startday_dt,endday_dt,startdayInput,enddayInput,backtime,backtimeD...
    )
%��ȡ������ƽ�۶�ղ������ݣ��޳���ع�����

% %ԭʼ����ʱ��
% startday_dt = '2012-11-01';
% endday_dt = '2017-03-02';
% %�������ʱ��
% startdayInput = '2013-02-04';
% enddayInput = '2017-03-02';   
% backtime = 60;

%Wind����
w=windmatlab();
tdays = w.tdays(startday_dt, endday_dt); %�ҵ�startday_dt��endday_dt֮��Ľ���������

%�ý�������������ʱ��
[w_tdays_data,~,~,~,~,~]=w.tdays(startdayInput, enddayInput);
if(isempty(w_tdays_data))
    error('wind����Ϊ��');
end
startday = datestr(w_tdays_data{1},29);
endday = datestr(w_tdays_data{end},29);
if backtimeD > backtime
    wrong('б�ʼ��������������ݼ�������');
end

% 10���ڹ�ծ������ �����ծ��ȯ�۸�
[ret10,~,~,wtimes] = w.edb('M0325687', startday_dt, endday_dt,'Fill=Previous');
treasurycls = 100./((ret10/100+1).^10); %�����ծ��ȯ�۸�
treasurycls = num2cell(treasurycls);
temp = num2cell(wtimes); %תΪcell
tradingdays = cell(length(temp),1);
for i = 1:length(temp)
    tradingdays{i} = datestr(temp{i},29);
end

%10���ڹ�ծ��Data���ݵ����ڲ�һ�£��໥���в�һ�µ�����
%����ͳһ�����������ڵĸ�ʽ
for i = 1:size(tdays,1)
    tdays{i,1} = datestr(tdays{i,1},29);
end
%�������潻���ն�Ӧ�۸������
treasurycls2 = zeros(size(tdays));
%���ս����ձ�������������ծ�����ݣ��㸳ֵ������������ļ۸���
for i = 1:size(tdays,1)
    subs = FindinCell(tradingdays, 1, tdays{i,1});
    treasurycls2(i) = treasurycls{subs};%���ڲ����ظ�
end

%�������0ֵ
prebox = 0;
n = length(treasurycls2);
for i = 1:n
    if treasurycls2(i) == 0
        treasurycls2(i) = prebox;
    else
        prebox = treasurycls2(i);
    end
end

%�ϳ�Data��һ����
contract = cell(size(tdays,1),1);
contract(:,1) = {'treasury'};
onedata = [tdays, contract, num2cell(treasurycls2)];
onedata = [{'TradingDay'},{'Contract'},{'Close'};onedata];
%�ϲ���Data��
Data = [{onedata}];
names = [{'��ծ'}];

%% ����������
for iData = 1:size(Data,2)
    close = cell2mat(Data{1,iData}(2:end,3));
    %ret = log(close(2:end)./close(1:(end-1))); %����������
    ret = diff(close(:))./close(1:(end-1));%������
    Ret = [{'Ret'};0;num2cell(ret)];
    Data{1,iData} = [Data{1,iData},Ret];
end

end