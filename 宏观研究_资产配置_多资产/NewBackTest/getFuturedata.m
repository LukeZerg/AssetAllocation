function data = getFuturedata(startday, endday, contract)
%��ȡ��startday��endday��ָ������ļ۸�
%startday = '2011-02-01';
%endday = '2017-01-11';
%contract = [{'IF.CFE'},{'T.CFE'},{'159920.SZ'}];
w = windmatlab();
nContract = size(contract,2);
data = cell(1,nContract);
for i = 1:nContract
    %disp(i);
    data{1,i} = {{'TradingDay'},{'Contract'},{'Open'},{'High'},{'Low'},{'Close'},{'Volume'},{'Position'},{'PreContract'},{'PreContractPx'}};
    %wind��ȡ����,����Fill=Previous�Ĺ���
    [w_wsd_data,~,~,w_wsd_times,~,~]=w.wsd(contract{i},'Trade_hiscode,open,high,low,close,volume,oi',startday,endday,'Fill=Previous');%,volume,position
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
        data{1,i}{j+1,2} = w_wsd_data{j,1};%��ֵ������Լ
        data{1,i}{j+1,3} = w_wsd_data{j,2};%���̼۸�
        data{1,i}{j+1,4} = w_wsd_data{j,3};%��߼�
        data{1,i}{j+1,5} = w_wsd_data{j,4};%��ͼ�
        data{1,i}{j+1,6} = w_wsd_data{j,5};%���̼�
        data{1,i}{j+1,7} = w_wsd_data{j,6};%�ɽ���
        data{1,i}{j+1,8} = w_wsd_data{j,7};%�ֲ���,ֻ���ڻ����������
    end
    %��ǰһ���Լ��ǰһ���Լ���ռ۸�ֵ
    data{1,i}{2,9} = data{1,i}{2,2};
    data{1,i}{2,10} = data{1,i}{2,6};
    for j = 2:nt
        precontract = data{1,i}{j,2}; %ǰһ���Լ
        data{1,i}{j+1,9} = precontract;
        nowcontract = data{1,i}{j+1,2};
        %���պ����պ�Լ��ͬ,ȡ���պ�Լ���ռ۸�;��ͬ�Ļ������ý��պ�Լ�Ľ��ռ۸�
        if ~strcmp(nowcontract,precontract)
            theday = data{1,i}{j+1,1};
            data{1,i}{j+1,10} = w.wsd(precontract,'close',theday,theday,'Fill=Previous'); %ȡ���۸�
        else
            data{1,i}{j+1,10} = data{1,i}{j+1,6};
        end
    end
end
w.menu
end