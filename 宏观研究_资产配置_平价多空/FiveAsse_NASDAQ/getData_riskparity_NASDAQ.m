clc;
clear;
%��ȡ������ƽ�۶�ղ������ݣ��޳���ع�����

%ԭʼ����ʱ��
% startday_dt = '2012-07-01';
% endday_dt = '2017-03-14';
startday_dt = '2013-05-16';
endday_dt = '2017-08-09';

w=windmatlab();

names = {{'����300'},{'�ϻ���Ʒָ��'},{'����ETF'},{'��ָETF'}};

%Wind����
Data = getindexdata(startday_dt, endday_dt, [{'000300.SH'},{'NH0100.NHF'},{'159920.SZ'},{'513100.SH'}]);

%��Data���һ���û�Ϊ��ʱ�۸�������ü�ʱ�µ�����ע�͵�
% [w_data,~,~,~,~,~]=w.wsq('000300.SH,NH0100.NHF,159920.SZ,513100.SH','rt_last');
% Data{1,1}{end,3} = w_data(1);
% Data{1,2}{end,3} = w_data(2);
% Data{1,3}{end,3} = w_data(3);
% Data{1,4}{end,3} = w_data(4);

%% 10���ڹ�ծ������ �����ծ��ȯ�۸�

[ret10,~,~,wtimes] = w.edb('M0325687', startday_dt, endday_dt,'Fill=Previous');

treasurycls = 100./((ret10/100+1).^10); %�����ծ��ȯ�۸�
treasurycls = num2cell(treasurycls);
temp = num2cell(wtimes); %תΪcell
tradingdays = cell(length(temp),1);
for i = 1:length(temp)
    tradingdays{i} = datestr(temp{i},29);
end
%%
%10���ڹ�ծ��Data���ݵ����ڲ�һ�£��໥���в�һ�µ�����
%Ѱ�Ҳ�ͬ���ڲ���10���ڹ�ծ������ɾ��
ddt = Data{1,1};
tdays = ddt(2:end,1);
daydiff = setdiff(tradingdays, tdays); %�ҵ�Data��û�е�����
% Lia = ismember(A,B) returns an array containing 1 (true) where the ...
% data in A is found in B. Elsewhere, it returns 0 (false).
vectorfind = find(ismember(tradingdays,daydiff)==1);
tradingdays(vectorfind) = [];
treasurycls(vectorfind) = [];%ɾ��

%�޳����tradingdays��tdays�е�λ��
vectorfind2 = find(ismember(tdays,tradingdays)==1);
tdays2 = tdays;
treasurycls2 = zeros(size(tdays2,1),size(tdays2,2));
treasurycls2(vectorfind2) = cell2mat(treasurycls);%����Ӧλ���ϸ�ֵ

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
contract = cell(size(tdays2,1),1);
contract(:,1) = {'treasury'};
onedata = [tdays2, contract, num2cell(treasurycls2)];
onedata = [{'TradingDay'},{'Contract'},{'Close'};onedata];
%�ϲ���Data��
Data = [Data,{onedata}];
names = [names,{'��ծ'}];

%% ����������
for iData = 1:size(Data,2)
    close = cell2mat(Data{1,iData}(2:end,3));
    %ret = log(close(2:end)./close(1:(end-1))); %����������
    ret = diff(close(:))./close(1:(end-1));%������
    Ret = [{'Ret'};0;num2cell(ret)];
    Data{1,iData} = [Data{1,iData},Ret];
end
save('D:/001Work/����о�_�ʲ�����_ƽ�۶��/FiveAsse_NASDAQ/data.mat','Data','names'); 