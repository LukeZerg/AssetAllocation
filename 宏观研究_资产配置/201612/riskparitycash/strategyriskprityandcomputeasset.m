function [ pnldata, Assetall, Cumsums, weights ] = strategyriskprityandcomputeasset( startday, ...
                            endday, backtime, capital, data, names)
%����ƽ�۲���
% startday = '2011-02-01';
% endday = '2017-01-11';
% backtime = 60;
% capital = 30000*10000;
% data = Data;

% pnldata ����Ʒ�ֵ�pnl�� Assetall���ʱ�����pnl�� Cumsums��Ʒ���ۼ�pnl��
% weights ����Ʒ��Ȩ��
onedata = data{1,1};
n = size(onedata,1)-1;
m = size(onedata,2);

w=windmatlab();
if w.tdayscount(onedata{2,1},startday) < backtime
    error('������ʼ������ԭʼ������ʼ���ھ���С�ڻ���ʱ��backtime');
end
if datenum(endday) > datenum(onedata{n+1,1})
    error('���Խ���������ԭʼ���ݽ�������֮��');
end
nstart = find(strcmp(onedata(:,1),startday));%�ڵ�һ�����ҵ���ʼ�����±�
nend = find(strcmp(onedata(:,1),endday));%�ڵ�һ�����ҵ���ʼ�����±�
tradingdays = onedata(nstart:nend,1); %���Գ���ʱ��
%�����������а��ջ���Ƶ����ȡ�±�
transvector = computetransferpositionsubscript(tradingdays, 'm');%��

%��ʼ��onepnldada
pnldata = cell(1,size(data,2));
ret = zeros(n, m); %�����ʾ���
for idata = 1:size(data,2)
    onedata = data{1,idata};
    onepnldada = {{'TradingDay'},{'Close'},{'Ret'},{'Asset'},{'Weight'},...
        {'pnl_h'},{'pnl_t'},{'isChg'}};
    %�����ʾ���ֵ
    ret(:,idata) = cell2mat(onedata(2:end,4));
    %��ֵ
    for j = 1:n
        onepnldada{j+1,1} = onedata{j+1,1};%tradingday
        onepnldada{j+1,2} = onedata{j+1,3};%close
        onepnldada{j+1,3} = onedata{j+1,4};%ret
        
        onepnldada{j+1,4} = 0;  %Asset
        onepnldada{j+1,5} = 0;  %Weight
        onepnldada{j+1,6} = 0;  %pnl_h
        onepnldada{j+1,7} = 0;  %pnl_t
        onepnldada{j+1,8} = 0;  %isChg
    end
    ntv = size(transvector,1);
    for i = 1:ntv
        itv = transvector(i) + nstart - 1;%onepnldada�е������±�
        onepnldada{itv,8} = 1;%%isChg,������
    end
    pnldata{1,idata} = onepnldada;
end

%����Ȩ�أ������ʽ�
onepnldada = pnldata{1,1};
for j = 1:n
    if onepnldada{j+1,8} %����ǵ�����
        weights = RiskParity(ret((j-backtime):(j-1),:));%����Ȩ��
        for idata = 1:size(data,2)
            pnldata{1,idata}{j+1,5} = weights(idata); %Weight
            pnldata{1,idata}{j+1,4} = capital * weights(idata); %Asset
        end
    end
end


%��������pnl
for idata = 1:size(data,2)
    for j = 2:n
        if ~pnldata{1,idata}{j+1,8} %���ǵ�����
            pnldata{1,idata}{j+1,6} = ...
                    pnldata{1,idata}{j,4} * pnldata{1,idata}{j+1,3};
            %���ճֲ�ӯ��=�����ʱ�*����������
            pnldata{1,idata}{j+1,4} = pnldata{1,idata}{j,4} + ...
                    pnldata{1,idata}{j+1,6} + pnldata{1,idata}{j+1,7};
            %�����ʱ�=�����ʱ�+���ճֲ�ӯ��+���ս���ӯ��    
        else %�����ղ�������asset
            pnldata{1,idata}{j+1,6} = ...
                    pnldata{1,idata}{j,4} * pnldata{1,idata}{j+1,3};
            %���ճֲ�ӯ��=�����ʱ�*����������
            %��������tradingpnl
            
        end
    end
end

%onepnldada ɸѡ����ʱ���
startnull = 2:(nstart-1);%start֮ǰ��Ϊ��
endnull = (nend+1):(n+1);%end֮���Ϊ��
for idata = 1:size(data,2)
    pnldata{1,idata}([startnull,endnull],:) = [];
end

%����
tradingday = pnldata{1,1}(2:end,1);
Assetall = {{'TradingDay'},{'Asset'},{'pnl_h'},{'pnl_t'}};
len = nend - nstart + 1;
asset = ones(len,1)*capital;
pnl_h = zeros(len,1);
pnl_t = zeros(len,1);

%����pnl
for idata = 1:size(data,2)
    onepnldata = pnldata{1,idata};
    onepnl_h = cell2mat(onepnldata(2:end, 6)); 
    onepnl_t = cell2mat(onepnldata(2:end, 7));
    pnl_h = pnl_h + onepnl_h;
    pnl_t = pnl_t + onepnl_t;
end
Assetall(2:len+1,1) = tradingday;

Assetall(2:len+1,3) = num2cell(cumsum(pnl_h));
Assetall(2:len+1,4) = num2cell(cumsum(pnl_t));
Assetall(2:len+1,2) = num2cell(asset + cumsum(pnl_h) + cumsum(pnl_t));

%��Ʒ������

%��Ʒ���ۼ�����ͳ��
cumsums = zeros(size(tradingday,1),size(pnldata,2));
for i=1:size(pnldata,2)
    cumsums(:,i) = cumsum(cell2mat(pnldata{1,i}(2:end, 6)));
end
cumsums = num2cell(cumsums);
Cumsums = [{'TradingDay'},names];
Cumsums(2:len+1,1) = tradingday;
Cumsums(2:len+1,2:end) = cumsums;


% Ȩ����������
onepnldata = pnldata{1,1};
n = size(onepnldata,1);
weights = cell(n,size(pnldata,2)+1);    %weights�洢Ȩ��
weights(1,:) = [{'TradingDay'},names];
weights(2:end,1) = onepnldata(2:end,1);
for i = 1:size(pnldata,2)
    weights(2:end,i+1) = pnldata{1,i}(2:end,5);%��ֵ
end
is0 = zeros(n,1); %��¼ȫ����0�Ĳ���
for i = 2:n
    temp = cell2mat(weights(i,2:end));%ȡ����һ������Ȩ��
    if sum(temp) == 0 %���Ȩ�ض�Ϊ0
        is0(i) = 1;
    end
end
weights(find(is0),:) = [];

end
