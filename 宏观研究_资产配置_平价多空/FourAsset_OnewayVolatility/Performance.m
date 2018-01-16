function [ output ] = Performance( AssetData,AssetAll )
global strategy
%%
%��������ָ��
caplist = cell2mat(AssetAll(2:end,5));%���ʱ�����
capital = caplist(1);
TradingDays = AssetAll(2:end,1);
%capitalΪ�ʱ���
%tradingdaysΪ����
%pnllistΪӯ������
%% ����ӯ��
pnllist = diff(caplist);
pnl_week = sum(pnllist((end-4):(end))); %����ӯ��
ret_week = pnl_week/capital; %����������

%% �ۼ�ӯ�����ۼ�ӯ����������
cumpnl = cumsum(pnllist);%�ۼ�ӯ������
cumpnl_end = cumpnl(end); %�ۼ�ӯ��
ret_all = cumpnl(end)/capital;%������

%% ����������
%retlist = diff(caplist)./caplist(1:(end-1));
retlist = log(caplist(2:end)./caplist(1:(end-1))); %����������,��Ӧ�����ۼ������ʵļ���
retlist = [0;retlist]; %�ڵ�һ��λ�����һ����
dailyret = retlist;%����������

%% ���س�
dailyret(isnan(dailyret)) = 0;
retcum = cumsum(dailyret);
drawdown = retcum - cummax(retcum);
MaxDD = min(drawdown);

%%  �껯������
AnnualYield = mean(dailyret)*252;

%% �껯������
volatility_year = std(dailyret)*sqrt(252);% �껯������
%�껯������
if(std(dailyret) ~= 0)
    Sharpe = sqrt(252)*mean(dailyret)./std(dailyret);
else
    Sharpe = NaN;
end

%% �ۼƾ�ֵ����
netlist = cell(size(caplist,1),size(caplist,2));
for i = 1:size(caplist,1)
    netlist{i} = caplist(i)/caplist(1);
end
%% ��������


%% ������
output(:,1) = TradingDays; %����
output(:,2) = netlist; %�ۼƾ�ֵ
output{1,3} = '����ӯ��'; output{1,4} = pnl_week;
output{2,3} = '����������' ; output{2,4} = ret_week;
output{3,3} = '�ۼ�ӯ��' ; output{3,4} = cumpnl_end;
output{4,3} = '������'; output{4,4} = ret_all;
output{5,3} = '���س�'; output{5,4} = MaxDD;
output{6,3} = '�껯������'; output{6,4} = AnnualYield;
output{7,3} = '�껯������'; output{7,4} = volatility_year;
output{8,3} = '�껯������'; output{8,4} = Sharpe;

%% �����ʲ��ۼ�����
%AssetData ͳ�Ƹ����ʲ��ۼ�������
m = size(AssetData,2);
n = size(AssetData{1,1},1)-1;
cumsums = zeros(n,m);
for i = 1:m
    cumsum_pnlh = cumsum(cell2mat(AssetData{1,i}(2:end,3)));
    cumsum_pnlt = cumsum(cell2mat(AssetData{1,i}(2:end,4)));
    cumsums(:,i) = cumsum_pnlh + cumsum_pnlt;
end
output{1,6} = '���ʲ��ۼ�������';
for i = 1:m
    output{1,6+i} = cumsums(end,i)/strategy.capital;
end

end