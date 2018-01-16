function Direction = DirectionAllocation(Data,Position0)
%��ȡÿ���ʲ��ķ���
global strategy
endday = strategy.endday;
startday = strategy.startday;
cycle = strategy.cycle;

CloseData = Data;
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
% ret LLT ��ֵ
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


    ntv = size(transvector,1);
    for i = 1:ntv
        itv = transvector(i) + nstart - 1;%onepnldada�е������±�
        Position{1,iPosition}{itv,6} = 1;%%isChg,������
    end
end

%% ���㲢��¼Ȩ�أ������ʽ�, ��дPosition�������ͷ���
Direction = cell(n+1,m+1);    %weights�洢Ȩ��
Direction(1,:) = [{'TradingDay'},names];
Direction(2:end,1) = onePosition(2:end,1);

onePosition = Position{1,1};
for j = 1:n
    if onePosition{j+1,6} %����ǵ�����        
        direction = zeros(1,m);
        for iPosition = 1:m
            %��ʱ���ݸ�Ȩ�����ݼ����������
            direction(iPosition) = 1; %����һֱ����
        end
        Direction(j+1, 2:end) = num2cell(direction);
    end
end
 
 %���theWeights
 for k = 1:m %ѭ�����Ʒ��
     nP = size(Direction,1);%��Ʒ�����ݴ�С
     oneDirection = 0;
     for i = 2:nP
         if Position{1,k}{i,6} == 1 %�����һ��ֱֲ仯��isChg
             %��¼��curren��direction
             oneDirection = Direction{i,k+1};
         end
         Direction{i,k+1} = oneDirection;
     end
 end
 
 %% ��ȡ��Ҫ��Directionʱ���
startnull = 2:(nstart-1);%start֮ǰ��Ϊ��
endnull = (nend+1):(n+1);%end֮���Ϊ��

Direction([startnull,endnull],:) = [];

end