function [ Position,CloseData, theWeights ] = strategyBLLS( ...
startday,endday, backtime, capital, Position0, CloseData0,Information, ...
    names, cashcol, alpha, backtimeD, w0, tau)
%BL��ղ���
%startday,endday ��ʼ��������
%ָ�����

% startday = '2013-02-04';
% endday = '2017-02-03';
% backtime = 60;
% capital = 30000*10000;
% data = Data;

Position = Position0;
CloseData = CloseData0;
%��ȡͶ���߹۵�
Perspective = GetPerspective();

onePosition = Position{1,1};
n = size(onePosition,1)-1; %�����������������
m = size(Position,2);%�ʲ�����

w=windmatlab();
if w.tdayscount(onePosition{2,1},startday) < backtime
    error('������ʼ������ԭʼ������ʼ���ھ���С�ڻ���ʱ��backtime');
end
if datenum(endday) > datenum(onePosition{n+1,1})
    error('���Խ���������ԭʼ���ݽ�������֮��');
end
nstart = find(strcmp(onePosition(:,1),startday));%�ڵ�һ�����ҵ���ʼ�����±�
nend = find(strcmp(onePosition(:,1),endday));%�ڵ�һ�����ҵ���ʼ�����±�
tradingdays = onePosition(nstart:nend,1); %���Գ���ʱ��
%�����������а��ջ���Ƶ����ȡ�±�
transvector = computetransferpositionsubscript(tradingdays, 'm');%��

%% ret LLT ��ֵ
%��ʼ��
ret = zeros(n, m); %�����ʾ���
LLTs = zeros(n, m);%LLTָ�����

for iPosition = 1:size(Position,2)
    
    oneCloseData = CloseData{1,iPosition};
    prices = cell2mat(oneCloseData(2:end,3));%�۸�
    %ret = log(close(2:end)./close(1:(end-1))); %����������
    oneret = diff(prices(:))./prices(1:(end-1));%������
    oneret = [0;oneret];
    %�����ʾ���ֵ
    ret(:,iPosition) = oneret;
    %LLTs����ֵ
    if iPosition ~= cashcol
        LLTs(:,iPosition) = priceToLLT(prices,alpha);
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

Persday = Perspective(:,1);
numPersday = datenum(Persday);%תΪ��������

Multiplier = cell2mat(Information(2:end,2));
onePosition = Position{1,1};
for j = 1:n
    if onePosition{j+1,6} %����ǵ�����
        
        theday = onePosition{j+1,1};%ȡ������
        %�ҵ����¹۵������
        temp = (datenum(theday)>numPersday);
        ktemp = -1;
        for k = 1:length(temp)
            %�ҵ���һ��0��ǰһ���������¹۵�����
            if temp(k) == 0
                ktemp = k - 1;
                break
            end
        end
        %�����ǰ����thedayС�ڹ۵��һ�����ڣ���ôktempΪ0
        if ktemp == 0
            wrong('��ǰ��������С�ڹ۵��һ�����ڣ��������Ӧ�۵�');
        elseif ktemp == -1
        %�������£���ǰ����theday�������й۵����ڣ����Բ�ȡ���һ���۵�
            ktemp = length(temp);
        end
        P = Perspective{ktemp,2};%ȡ���۵����
        v = Perspective{ktemp,3};%ȡ���۵����
        conf = Perspective{ktemp,4};%ȡ������ˮƽ
        %��������ȡ�����¹۵�
        
        sub = ret((j-1-backtime):(j-1-1),:);%j-2��onepnldada�е�j-1
        weights = BL(sub,w0,P,v,conf,tau);%����Ȩ��
        subLLT = LLTs((j-2-backtimeD):(j-1-1),:);
        direction = getDirectionLLT(subLLT,cashcol,backtimeD); %����LLT��ʱ�ж�
        %direction = [1;1;1;1];
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
