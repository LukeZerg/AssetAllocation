function [Data] = ...
    getFutureData...
    (...
    startday_dt,endday_dt...
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
contract =  [{'AU.SHF'}];
w = windmatlab();

data = cell(1,size(contract,2));
for i = 1:size(contract,2)
    %disp(i);
    data{1,i} = {{'TradingDay'},{'Contract'},{'Close'}};
    %wind��ȡ����,����Fill=Previous�Ĺ���
    [w_wsd_data,~,~,w_wsd_times,~,~]=w.wsd(contract{i},'close,trade_hiscode',startday_dt,endday_dt,'Fill=Previous');
    if(isempty(w_wsd_data))
        error('wind����Ϊ��');
    end
    if iscell(w_wsd_data) == 0     %���w_wsd_data����cell,��Ϊ��ʱȫΪ��ֵ�������ݱ�Ϊcell
        w_wsd_data = num2cell(w_wsd_data);
    end
    %TradingDay
    nt = size(w_wsd_times,1);
    for j = 1:nt
        data{1,i}{j+1,1} = datestr(w_wsd_times(j),29);
        data{1,i}{j+1,2} = w_wsd_data{j,2};%��ֵ������Լ
        data{1,i}{j+1,3} = w_wsd_data{j,1};%price
    end
end
Data = data;

%% ����������
for iData = 1:size(Data,2)
    close = cell2mat(Data{1,iData}(2:end,3));
    %ret = log(close(2:end)./close(1:(end-1))); %����������
    ret = diff(close(:))./close(1:(end-1));%������
    Ret = [{'Ret'};0;num2cell(ret)];
    Data{1,iData} = [Data{1,iData},Ret];
end

end