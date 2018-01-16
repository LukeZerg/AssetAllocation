function [ Position,CloseData, theWeights ] = strategyRiskpParityTSMON( ...
startday,endday, backtime, capital, Position0, CloseData0,Information, ...
    names, cashcol, cycle, riskFreeAsset, backtimeTSMON)
%����ƽ�۲���
% startday = '2013-02-04';
% endday = '2017-02-03';
% backtime = 60;
% capital = 30000*10000;
% data = Data;

Position = Position0;
CloseData = CloseData0;

onePosition = Position{1,1};
n = size(onePosition,1)-1; %�����������������
m = size(Position,2);%�ʲ�����

w=windmatlab();
%������ʼ������ԭʼ������ʼ���ھ���
dayscount = w.tdayscount(onePosition{2,1},startday);
if dayscount < backtime
    error('������ʼ������ԭʼ������ʼ���ھ���С�ڻ���ʱ��backtime');
end
if dayscount < backtimeTSMON
    error('������ʼ������ԭʼ������ʼ���ھ���С��TSMON���Ի���ʱ��backtimeTSMON');
end
if datenum(endday) > datenum(onePosition{n+1,1})
    error('���Խ���������ԭʼ���ݽ�������֮��');
end
nstart = find(strcmp(onePosition(:,1),startday));%�ڵ�һ�����ҵ���ʼ�����±�
nend = find(strcmp(onePosition(:,1),endday));%�ڵ�һ�����ҵ���ʼ�����±�
tradingdays = onePosition(nstart:nend,1); %���Գ���ʱ��
lasttradingday = w.tdaysoffset(1,tradingdays{end});%Ϊ��Ӧ���ز⵱����һ�����һ�������������һ��������֮�����δ��һ�콻����
lasttradingday = datestr(lasttradingday,29);
tradingdays1 = [tradingdays;lasttradingday];%tradingdays1��һ��
%�����������а��ջ���Ƶ����ȡ�±�
transvector = computeFreqSubscript(tradingdays1, cycle);%�ҵ����±�
%% ����ret���ڷ���ƽ�ۼ��㣬����exRet����������󣬱�ǵ����� 
%��ʼ��
ret = zeros(n, m); %�����ʾ���
exRet = zeros(n, m); %�����������
nav_riskfree = cell2mat(riskFreeAsset(2:end,3)); %��ع����ʻ���ľ�ֵ
if size(nav_riskfree,1) ~= n
    error('�����ʲ�����ع������ݳ��Ȳ�һ��');
end

for iPosition = 1:size(Position,2)
    
    oneCloseData = CloseData{1,iPosition};
    prices = cell2mat(oneCloseData(2:end,3));%�۸�
    %ret = log(close(2:end)./close(1:(end-1))); %����������
    oneret = diff(prices(:))./prices(1:(end-1));%������
    oneret = [0;oneret];
    %�����ʾ���ֵ
    ret(:,iPosition) = oneret;
    %backtimeTSMONʱ����������
    oneExRet = prices((backtimeTSMON+1):end)./...
        prices(1:(end-backtimeTSMON))-1;
    ret_riskfree = ...
        nav_riskfree((backtimeTSMON+1):end)./...
        nav_riskfree(1:(end-backtimeTSMON))-1;
    
     
    temp = oneExRet - ret_riskfree;%��������
    lentemp = size(temp,1);
    %------------------------------------
    colExRet = [zeros(n - lentemp,1);temp]; %�ڼ�����ĳ���������ǰ����0
    exRet(:,iPosition) = colExRet; %�Գ�����������һ�и�ֵ
    %------------------------------------
    
    %��ǵ�����
    ntv = size(transvector,1);
    for i = 1:ntv
        itv = transvector(i) + nstart - 1;%onepnldada�е������±�
        Position{1,iPosition}{itv,6} = 1;%%isChg,������
    end
end

%% ���㲢��¼Ȩ�أ������ʽ�, ��дPosition�������ͷ���
theWeights = cell(n+1,m+1);    %weights�洢Ȩ��
theWeights(1,:) = [{'TradingDay'},names];
theWeights(2:end,1) = onePosition(2:end,1);

Multiplier = cell2mat(Information(2:end,2));
onePosition = Position{1,1};
for j = 1:n
    if onePosition{j+1,6} %����ǵ�����
        sub = ret((j-1-backtime):(j-1-1),:);%j-2��onepnldada�е�j-1
        weights = RiskParity(sub);%����Ȩ��
        onedayexRet = exRet(j,:);
        %��ʱ���ݸ�Ȩ�����ݼ����������
        direction = getDirectionTSMON(onedayexRet,cashcol); %����TSMON��ʱ�ж�
        for iPosition = 1:m
            Position{1,iPosition}{j+1,4} = direction(iPosition); %direction
            oneCapital = capital * weights(iPosition); %�����ʽ�
            oneClose = CloseData{1,iPosition}{j+1,3};%��Ӧ�۸�
            Position{1,iPosition}{j+1,3} = ...
                oneCapital/(Multiplier(iPosition)*oneClose);%��������
            %��¼Ȩ�غͷ���ĳ˻�,��һ��������
            theWeights{j+1, iPosition+1} = direction(iPosition)*weights(iPosition);
        end
    end
end

%���position��curren 3�к�direction 4��
 for k = 1:m %ѭ�����Ʒ��
     [nP,~] = size(Position{1,k});%��Ʒ�����ݴ�С
     currenbox = 0;%��¼��
     directionbox=0;
     for i = 2:nP
         if Position{1,k}{i,6} == 1 %�����һ��ֱֲ仯��isChg
             %��¼��curren��direction
             currenbox = Position{1,k}{i,3};
             directionbox = Position{1,k}{i,4};
         end
         Position{1,k}{i,3} = currenbox;
         Position{1,k}{i,4} = directionbox;
     end
 end
 
 %���theWeights
 for k = 1:m %ѭ�����Ʒ��
     nP = size(theWeights,1);%��Ʒ�����ݴ�С
     oneWeight = 0;
     for i = 2:nP
         if Position{1,k}{i,6} == 1 %�����һ��ֱֲ仯��isChg
             %��¼��curren��direction
             oneWeight = theWeights{i,k+1};
         end
         theWeights{i,k+1} = oneWeight;
     end
 end
 
 %% ��ȡ��Ҫ��Position��CloseDataʱ���
startnull = 2:(nstart-1);%start֮ǰ��Ϊ��
endnull = (nend+1):(n+1);%end֮���Ϊ��
for idata = 1:m
    Position{1,idata}([startnull,endnull],:) = [];
    CloseData{1,idata}([startnull,endnull],:) = []; 
end
theWeights([startnull,endnull],:) = [];
end
