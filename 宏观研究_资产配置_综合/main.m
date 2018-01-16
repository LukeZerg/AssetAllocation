%% ��������
%��currentFolderĿ¼�������ļ�����ӵ�·��
currentFolder = 'D:\001Work\����о�_�ʲ�����_�ۺ�';
addpath(genpath(currentFolder))

%Wind����
%ԭʼ����ʱ��
startday_dt = '2012-11-01';
endday_dt = '2017-02-03';
Data = getindexdata(startday_dt, endday_dt, [{'000300.SH'},{'NH0100.NHF'}]);
w=windmatlab();
%tradingdays_dt = w.tdays(startday_dt, endday_dt);

%����ʱ��
startday = '2013-02-04';
endday = '2017-02-03';
names = {{'����300'},{'�ϻ���Ʒָ��'}};
backtime = 60;
capital = 30000*10000;

%% 10���ڹ�ծ������ �����ծ��ȯ�۸�

[ret10,~,~,wtimes] = w.edb('M0325687', startday_dt, endday_dt,'Fill=Previous');
w.close();
treasurycls = 100./((ret10/100+1).^10); %�����ծ��ȯ�۸�
treasurycls = num2cell(treasurycls);
temp = num2cell(wtimes); %תΪcell
tradingdays = cell(length(temp),1);
for i = 1:length(temp)
    tradingdays{i} = datestr(temp{i},29);
end
%%
%onedata��wind�ӿ�ȡ�����ݵ����ڲ�һ�£��໥���в�һ�µ�����
%Ѱ�Ҳ�ͬ���ڲ���onedata��ɾ��
ddt = Data{1,1};
tdays = ddt(2:end,1);
daydiff = setdiff(tradingdays, tdays); %�ҵ�wind�ӿ���û�е�����
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
    ret = log(close(2:end)./close(1:(end-1))); %����������
    %ret = diff(close(:))./close(1:(end-1));%������
    Ret = [{'Ret'};0;num2cell(ret)];
    Data{1,iData} = [Data{1,iData},Ret];
end

%% ��ȡWind��ع���������
onecontract = '204001.SH';%��ع�����
w=windmatlab();
onedata = {{'TradingDay'},{'Contract'},{'Close'},{'Ret'}};
%wind��ȡ����,����Fill=Previous�Ĺ���
[w_wsd_data,~,~,w_wsd_times,~,~]=w.wsd(onecontract,'close',startday_dt,endday_dt,'Fill=Previous');
if(isempty(w_wsd_data))
    error('wind����Ϊ��');
end
if iscell(w_wsd_data) == 0     %���w_wsd_data����cell,��Ϊ��ʱȫΪ��ֵ�������ݱ�Ϊcell
    w_wsd_data = num2cell(w_wsd_data/(100*365));%����100Ϊ�����ʣ�����365Ϊ����������
end
%TradingDay
nt = size(w_wsd_times,1);
for j = 1:nt
    onedata{j+1,1} = datestr(w_wsd_times(j),29);
    onedata{j+1,2} = onecontract;%��ֵ��Լ
    onedata{j+1,4} = w_wsd_data{j};%�����ʸ�ֵ��close���ղ���ֵ
end
Data = [Data,{onedata}];
names = [names,{'��ع�'}];

%% �г���Ϻ��г�������
marketData = getindexdata(startday_dt, endday_dt, [{'000300.SH'}]);
marketData = marketData{1,1};
% ������
close = cell2mat(marketData(2:end,3));
ret = log(close(2:end)./close(1:(end-1))); %����������
%ret = diff(close(:))./close(1:(end-1));%������
Ret = [{'Ret'};0;num2cell(ret)];
marketData = [marketData,Ret];

%% BL����

%��Ͷ���߹۵㸳ֵ
Perspective = GetPerspective();
w0 = [2;1;3;4];%��ʼȨ��
tau=0.025;%tauԽ�ӽ�0��Ȩ��Խ�ӽ���ʼȨ�أ�����Խ�ӽ������Խ�ӽ�Ͷ���߹۵㡣
[pnldata, Assetall, Cumsums, weights ] = ...
    strategBLAndComputeAsset(startday, endday, backtime, capital, Data, names, w0, Perspective,tau);
[ output ] = Performance( Assetall );

%% Markowitz����
[pnldata, Assetall, Cumsums, weights ] = ...
    strategMarkowitzAndComputeAsset(startday, endday, backtime, capital, Data, names, marketData);
[ output ] = Performance( Assetall );

%% Riskparity����
[pnldata, Assetall, Cumsums, weights ] = ...
    strategyriskprityandcomputeasset(startday, endday, backtime, capital, Data, names);
[ output ] = Performance( Assetall );

%% ��Ȩ�ز���
[pnldata, Assetall, Cumsums, weights ] = ...
    equalweightandcomputeasset(startday, endday, backtime, capital, Data, names);
[ output ] = Performance( Assetall );