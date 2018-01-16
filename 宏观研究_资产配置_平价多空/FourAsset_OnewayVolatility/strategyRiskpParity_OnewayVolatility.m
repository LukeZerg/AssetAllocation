function [ Position,CloseData, theWeights ] = strategyRiskpParity_OnewayVolatility( ...
startday,endday, backtime, Position0, CloseData0,Information, ...
    names)
%����ƽ�۲���
% startday = '2013-02-04';
% endday = '2017-02-03';
% backtime = 60;
% capital = 30000*10000;
% data = Data;
global strategy
capital = strategy.capital;
MA_LEN = strategy.MA_LEN; %���������ʼ�������ƽ������
VOL_LEN = strategy.VOL_LEN; %�����ʼ��㴰��
THRESHOLD = strategy.THRESHOLD; %�򵥴��̷���жϻ�׼

Position = Position0;
CloseData = CloseData0;

onePosition = Position{1,1};
n = size(onePosition,1)-1; %�����������������
m = size(Position,2);%�ʲ�����

w=windmatlab();
if w.tdayscount(onePosition{2,1},startday) < backtime
    error('������ʼ������ԭʼ������ʼ���ھ���С�ڻ���ʱ��backtime');
end
if w.tdayscount(onePosition{2,1},startday) < backtime
    error('������ʼ������ԭʼ������ʼ���ھ���С�ڻ���ʱ��backtime');
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
transvector = computeFreqSubscript(tradingdays1, strategy.cycle);%�ҵ����±�
%% ret vol������  ��ֵ
%��ʼ��
ret = zeros(n, m); %�����ʾ���
vol = zeros(n, m); %�����ʾ���
cumret_len = zeros(n, m); %һ�����ȵ��ۼ�������
vol_diff_mean = zeros(n, m); %���ڲ����ʾ���




for iPosition = 1:size(Position,2)
    
    oneCloseData = CloseData{1,iPosition};
    prices = cell2mat(oneCloseData(2:end,3));%�۸�
    %ret = log(close(2:end)./close(1:(end-1))); %����������
    oneret = diff(prices(:))./prices(1:(end-1));%������
    oneret = [0;oneret];
    %�����ʾ���ֵ
    ret(:,iPosition) = oneret;
    
    %���ڲ����ʸ�ֵ
    for j =  (VOL_LEN+1):n
        ret_VOL_LEN = oneret((j-VOL_LEN):(j-1));%ȡ��ȥVOL_LEN�������ʣ�������ڲ�����
        vol(j,iPosition) = std(ret_VOL_LEN);
    end
    
    %MA_LEN���ۼ�������
    for j = (MA_LEN+1):n
        prices_LEN = prices((j-MA_LEN):(j-1));%ȡ��ȥMA_LEN��۸񣬼�����ڲ�����
        if prices_LEN(1) == 0
            cumret_len(j,iPosition) = 0;
        else
            cumret_len(j,iPosition) = prices_LEN(end)/prices_LEN(1) - 1;
        end
    end
    
    %���㲨����-��ֵ����
    for j = (MA_LEN+1):n
        if oneret(j-1) > 0
            continue;
        elseif oneret(j-1) < 0
            vol(j,iPosition) = -vol(j,iPosition);
        else
            vol(j,iPosition) = 0;
        end
    end
    
    %ƽ�����򲨶���-��ֵ,MA_LEN���ֵ
    for j = (MA_LEN*2+1):n
         temp_mean = vol((j-MA_LEN):(j-1),iPosition);
         vol_diff_mean(j,iPosition) = sum(temp_mean)/MA_LEN;
    end
    
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
        
        sub_cumret_len = cumret_len(j,:);
        sub_vol_diff_mean = vol_diff_mean(j,:);
        
        %��ʱ���ݸ�Ȩ�����ݼ����������
        direction = getDirection_OnewayVolatility(sub_cumret_len,sub_vol_diff_mean,THRESHOLD); %���õ�����ʲ�ֵ��ʱ
        %direction = [1,1,1,1];
        for iPosition = 1:m
            Position{1,iPosition}{j+1,4} = direction(iPosition); %direction
            oneCapital = capital * weights(iPosition); %�����ʽ�
            oneClose = CloseData{1,iPosition}{j+1,3};%��Ӧ�۸�
            if direction(iPosition) ~= 0
                Position{1,iPosition}{j+1,3} = ...
                    oneCapital/(Multiplier(iPosition)*oneClose);%��������
            else
                Position{1,iPosition}{j+1,3} = 0;%����Ϊ0����ղֲ�����
            end
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
