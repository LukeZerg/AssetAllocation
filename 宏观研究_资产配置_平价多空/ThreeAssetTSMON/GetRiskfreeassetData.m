function riskFreeAsset = GetRiskfreeassetData(startday,endday)
%��ȡ�޷����ʲ����ݣ���������ع�
onecontract = '204001.SH';%��ع�����
onedata = {{'TradingDay'},{'Contract'},{'Close'},{'Ret'}};
%wind��ȡ����,����Fill=Previous�Ĺ���
w = windmatlab();
[w_wsd_data,~,~,w_wsd_times,~,~]=w.wsd(onecontract,'close',startday,endday,'Fill=Previous');
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
%ģ����ع��۸�ʹ֮��Ӧ��ع�������
onedata{1+1,3} = 1;%��ʼ����һ��۸�
for j = 2:nt
    %���ռ۸�=���ռ۸�*���������ʣ�w_wsd_dataû���������Լ�1
    onedata{j+1,3} = onedata{j,3}*(1+w_wsd_data{j-1}); 
end
riskFreeAsset = onedata;
end