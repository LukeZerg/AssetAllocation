function Direction = DirectionAllocation(Data,Position0)
%获取每项资产的方向
global strategy
endday = strategy.endday;
startday = strategy.startday;
cycle = strategy.cycle;

CloseData = Data;
names = Data(2,:);

Position = Position0;

onePosition = Position{1,1};
n = size(onePosition,1)-1; %除了列名外的日期数
m = size(Position,2);%资产数量

w=windmatlab();

nstart = find(strcmp(onePosition(:,1),startday));%在第一列中找到开始日期下标
nend = find(strcmp(onePosition(:,1),endday));%在第一列中找到开始日期下标
tradingdays = onePosition(nstart:nend,1); %策略持续时间
lasttradingday = w.tdaysoffset(1,tradingdays{end});%为了应付回测当天是一周最后一天的情况，在最后一个交易日之后加入未来一天交易日
lasttradingday = datestr(lasttradingday,29);
tradingdays1 = [tradingdays;lasttradingday];%tradingdays1多一天
%从日期序列中按照换仓频率提取下标
transvector = computeFreqSubscript(tradingdays1, cycle);%找调仓下标
% ret LLT 赋值
%初始化
ret = zeros(n, m); %收益率矩阵
LLTs = zeros(n, m);%LLT指标矩阵

for iPosition = 1:size(Position,2)
    
    oneCloseData = CloseData{1,iPosition};
    prices = cell2mat(oneCloseData(2:end,3));%价格
    %ret = log(close(2:end)./close(1:(end-1))); %对数收益率
    oneret = diff(prices(:))./prices(1:(end-1));%收益率
    oneret = [0;oneret];
    %收益率矩阵赋值
    ret(:,iPosition) = oneret;


    ntv = size(transvector,1);
    for i = 1:ntv
        itv = transvector(i) + nstart - 1;%onepnldada中调仓日下标
        Position{1,iPosition}{itv,6} = 1;%%isChg,调仓日
    end
end

%% 计算并记录权重，分配资金, 填写Position的手数和方向
Direction = cell(n+1,m+1);    %weights存储权重
Direction(1,:) = [{'TradingDay'},names];
Direction(2:end,1) = onePosition(2:end,1);

onePosition = Position{1,1};
for j = 1:n
    if onePosition{j+1,6} %如果是调仓日        
        direction = zeros(1,m);
        for iPosition = 1:m
            %择时数据跟权重数据计算独立开来
            direction(iPosition) = 1; %配置一直做多
        end
        Direction(j+1, 2:end) = num2cell(direction);
    end
end
 
 %填充theWeights
 for k = 1:m %循环多空品种
     nP = size(Direction,1);%此品种数据大小
     oneDirection = 0;
     for i = 2:nP
         if Position{1,k}{i,6} == 1 %如果这一天持仓变化了isChg
             %记录下curren和direction
             oneDirection = Direction{i,k+1};
         end
         Direction{i,k+1} = oneDirection;
     end
 end
 
 %% 截取需要的Direction时间段
startnull = 2:(nstart-1);%start之前的为空
endnull = (nend+1):(n+1);%end之后的为空

Direction([startnull,endnull],:) = [];

end