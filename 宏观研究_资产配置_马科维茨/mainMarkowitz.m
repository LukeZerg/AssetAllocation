%Wind����
%ԭʼ����ʱ��
startday_dt = '2010-11-02';
endday_dt = '2017-02-03';
Data = getindexdata(startday_dt, endday_dt, [{'000001.SH'},{'NH0100.NHF'},{'0372.CS'}]);
%����ʱ��
startday = '2011-02-01';
endday = '2017-02-03';
names = {{'��֤��ָ'},{'�ϻ���Ʒָ��'},{'��ծ�ܾ���ָ��'}};

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
%% ����
[pnldata, Assetall, Cumsums, weights ] = ...
    strategMarkowitzAndComputeAsset(startday, endday, 60, 30000*10000, Data, names, marketData);
[ output ] = Performance( Assetall );

%Plot_Animation_Net(output);