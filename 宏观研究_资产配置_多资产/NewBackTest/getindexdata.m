function data = getindexdata(startday, endday, contract)
%获取从startday到endday的指定代码的价格
%startday = '2011-02-01';
%endday = '2017-01-11';
%contract = [{'000300.SH'},{'T.CFE'},{'NH0100.NHF'}];
w = windmatlab();
data = cell(1,size(contract,2));
for i = 1:size(contract,2)
    %disp(i);
    data{1,i} = {{'TradingDay'},{'Contract'},{'Close'}};
    %wind提取数据,按照Fill=Previous的规则
    [w_wsd_data,~,~,w_wsd_times,~,~]=w.wsd(contract{i},'close',startday,endday,'Fill=Previous');
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
        data{1,i}{j+1,2} = contract{i};%赋值合约
        data{1,i}{j+1,3} = w_wsd_data{j};
    end
end

end