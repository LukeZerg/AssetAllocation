function data = getFuturedata(startday, endday, contract)
%获取从startday到endday的指定代码的价格
%startday = '2011-02-01';
%endday = '2017-01-11';
%contract = [{'IF.CFE'},{'T.CFE'},{'159920.SZ'}];
w = windmatlab();
nContract = size(contract,2);
data = cell(1,nContract);
for i = 1:nContract
    %disp(i);
    data{1,i} = {{'TradingDay'},{'Contract'},{'Open'},{'High'},{'Low'},{'Close'},{'Volume'},{'Position'},{'PreContract'},{'PreContractPx'}};
    %wind提取数据,按照Fill=Previous的规则
    [w_wsd_data,~,~,w_wsd_times,~,~]=w.wsd(contract{i},'Trade_hiscode,open,high,low,close,volume,oi',startday,endday,'Fill=Previous');%,volume,position
    if(isempty(w_wsd_data))
        error('wind数据为空');
    end
    if iscell(w_wsd_data) == 0     %如果w_wsd_data不是cell,因为此时全为数值，将数据变为cell
        w_wsd_data = num2cell(w_wsd_data);
    end
    %TradingDay
    nt = size(w_wsd_times,1);
    for j = 1:nt
        data{1,i}{j+1,1} = datestr(w_wsd_times(j),29);
        data{1,i}{j+1,2} = w_wsd_data{j,1};%赋值主力合约
        data{1,i}{j+1,3} = w_wsd_data{j,2};%开盘价格
        data{1,i}{j+1,4} = w_wsd_data{j,3};%最高价
        data{1,i}{j+1,5} = w_wsd_data{j,4};%最低价
        data{1,i}{j+1,6} = w_wsd_data{j,5};%收盘价
        data{1,i}{j+1,7} = w_wsd_data{j,6};%成交量
        data{1,i}{j+1,8} = w_wsd_data{j,7};%持仓量,只有期货有这个属性
    end
    %给前一天合约和前一天合约今日价格赋值
    data{1,i}{2,9} = data{1,i}{2,2};
    data{1,i}{2,10} = data{1,i}{2,6};
    for j = 2:nt
        precontract = data{1,i}{j,2}; %前一天合约
        data{1,i}{j+1,9} = precontract;
        nowcontract = data{1,i}{j+1,2};
        %今日和昨日合约不同,取昨日合约今日价格;相同的话，就用今日合约的今日价格
        if ~strcmp(nowcontract,precontract)
            theday = data{1,i}{j+1,1};
            data{1,i}{j+1,10} = w.wsd(precontract,'close',theday,theday,'Fill=Previous'); %取出价格
        else
            data{1,i}{j+1,10} = data{1,i}{j+1,6};
        end
    end
end
w.menu
end