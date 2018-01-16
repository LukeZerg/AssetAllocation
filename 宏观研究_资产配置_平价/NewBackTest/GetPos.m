function [Position] = GetPos(Close,Information)
%���ó���������������Position��CloseData�ı�׼��ʽ
    n = size(Close,2);%�ʲ�����
    Position = cell(1,n);%��ʼ����λ��׼����
    rowdt = size(Close{1,1},1);
    variety = Information(2:end,1);
    for i = 1:n
        onedata = Close{1,i};
        Position{1,i} = {'TradingDay','Contract','Curren','Direciton',...
            'Variety','isChg'};
        Position{1,i}(2:rowdt,1) = onedata(2:rowdt,1); %����
        Position{1,i}(2:rowdt,2) = onedata(2:rowdt,2); %��Լ
        Position{1,i}(2:rowdt,3) = {0}; %curren
        Position{1,i}(2:rowdt,4) = {0}; %direction
        Position{1,i}(2:rowdt,5) = {variety{i}}; %�ʲ�����
        Position{1,i}(2:rowdt,6) = {0}; %ischg
    end
end