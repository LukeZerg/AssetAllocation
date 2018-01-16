function [ Position_abs, theWeights_abs, Close_strategy] = ...
    WeightRiskpParity( Position0, Data, Close, Information)
%����ƽ�۲���
%�ô����ʲ��۸�ȷ��Ȩ�أ��þ����Լ�۸��������

global strategy
endday = strategy.endday;
startday = strategy.startday;
backtime = strategy.backtime;
capital = strategy.capital;
cycle = strategy.cycle;

names = Data(2,:);
Position = Position0;

onePosition = Position{1,1};
n = size(onePosition,1)-1; %�����������������
m = size(Position,2);%�ʲ�����

w=windmatlab();

nstart = find(strcmp(onePosition(:,1),startday));%�ڵ�һ�����ҵ���ʼ�����±�
nend = find(strcmp(onePosition(:,1),endday));%�ڵ�һ�����ҵ���ʼ�����±�
tradingdays = onePosition(nstart:nend,1); %���Գ���ʱ��
lasttradingday = w.tdaysoffset(1,tradingdays{end});%Ϊ��Ӧ���ز⵱����һ�����һ�������������һ��������֮�����δ��һ�콻����
lasttradingday = datestr(lasttradingday,29);
tradingdays1 = [tradingdays;lasttradingday];%tradingdays1��һ��
%�����������а��ջ���Ƶ����ȡ�±�
transvector = computeFreqSubscript(tradingdays1, cycle);%�ҵ����±�
%% ret LLT ��ֵ
%��ʼ��
ret = zeros(n, m); %�����ʾ���
for iPosition = 1:size(Position,2)
    
    oneData = Data{1,iPosition};
    prices = cell2mat(oneData(2:end,3));%�����ʲ����̼۸�
    %ret = log(close(2:end)./close(1:(end-1))); %����������
    oneret = diff(prices(:))./prices(1:(end-1));%������
    oneret = [0;oneret];
    %�����ʾ���ֵ
    ret(:,iPosition) = oneret;

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
        weights = RiskParity(sub);%�ô����ʲ��۸����Ȩ��
                
        for iPosition = 1:m
            oneCapital = capital * weights(iPosition); %�����ʽ�
            oneClose = Close{1,iPosition}{j+1,6};%�����Լ���̼۸�
            Position{1,iPosition}{j+1,3} = ...
                oneCapital/(Multiplier(iPosition)*oneClose);%��������
            %��¼Ȩ�غͷ���ĳ˻�,��һ��������
            theWeights{j+1, iPosition+1} = weights(iPosition);
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
 
 %% ��ȡ��Ҫ��Position��Dataʱ���
startnull = 2:(nstart-1);%start֮ǰ��Ϊ��
endnull = (nend+1):(n+1);%end֮���Ϊ��
for idata = 1:m
    Position{1,idata}([startnull,endnull],:) = [];
    Close{1,idata}([startnull,endnull],:) = []; 
end
theWeights([startnull,endnull],:) = [];

theWeights_abs = theWeights;
Position_abs = Position;
Close_strategy = Close;
end
