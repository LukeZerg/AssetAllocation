function [AssetData, AssetAll] = computeAsset(position,TradeRecord, CloseData, Information, iniCapital)
%�ӽ��׼�¼�ͼ۸��������ȡ�ʲ���Ϣ
%AssetData��Ʒ��pnl��AssetAll�ܵ�pnl

% position = Position
% iniCapital = capital


%Ʒ����Ϣ��ʼ��
%name = Information(2:end,1); %����
multiplier = Information(2:end,2);   %����
slipPrice = Information(2:end,3); %����
fee = Information(2:end,4); %������

Multiplier = multiplier;
SlipPrice = slipPrice;
Fee = fee;

%�ʲ������ʼ��
nPosition = size(position,2);
AssetData = cell(1,nPosition);%��������Ʒ�֣�ÿ��Ʒ�ַ�Ϊ�������
for i = 1:nPosition %ѭ��Ʒ�ֶ��
    AssetData{1,i} = {'TradingDay','Contract','pnl_h','pnl_t','Asset_deposit','Asset_all','Asset_cash','deposit'};
    pos = position{1,i}; %��ȡ��λ
    nt = size(pos,1)-1;%��������
    TradingDays = pos(2:end,1);
    oneCloseData = CloseData{1,i}; %��Ʒ��CloseData����
    oneContract = pos(:,2);%ȡ����Լ��
    for j = 1:nt
       %��ֵ����
       AssetData{1,i}(j+1,1) = TradingDays(j);
       AssetData{1,i}(j+1,2) = oneContract(j+1);%��Լ
       AssetData{1,i}{j+1,3} = 0;
       AssetData{1,i}{j+1,4} = 0;
       AssetData{1,i}{j+1,5} = 0;
       AssetData{1,i}{j+1,6} = 0;
       AssetData{1,i}{j+1,7} = 0;
       AssetData{1,i}(j+1,8) = oneCloseData(j+1,7);%��֤���� deposit 
    end
end

%�ʲ��������
for i = 1:nPosition
    pos = position{1,i};
    trecord = TradeRecord{1,i};
    cdata = CloseData{1,i};
    nt = size(pos,1)-1;
    %nt
    for t = 2:nt  %ѭ������,�ӵڶ��쿪ʼ��
        tradeDay = AssetData{1,i}{t+1,1};
        %trading pnl
        AssetData{1,i}{t+1,4} = 0;%tradepnl��ʼ��Ϊ0
        %���ҽ����Ƿ��н���
        vector = FindinCell(trecord ,1 ,tradeDay);
        if ~isempty(vector) %���н���
            tradeprice = trecord{vector,3}; %�ɽ���
            curren = trecord{vector,4};     %����
            %������=-1*����*�ɽ���*����*��������
            feeCost = double(-1 * Multiplier{i} * tradeprice...
                * curren * Fee{i});
            %������ʧ=-1*����*����*����  
            slipCost = double( -1 * SlipPrice{i} * Multiplier{i} * curren);
            %����double��Ϊ��ͳһ��������
            AssetData{1,i}{t+1,4} = feeCost + slipCost;
        end
        % Hoding Pnl      
        AssetData{1,i}{t+1,3} = ...     
        double( cdata{t+1,5} - cdata{t,3} )...%���պ�Լ���ռ۸�-���պ�Լ���ռ۸�
        * double(pos{t,3} * pos{t,4} * Multiplier{i});  %���ղ�λ�����շ���              
        %deposit
        %���ղ�λ=����*���պ�Լ���ռ۸�*���ղ�λ
        todayposition = double(Multiplier{i} * cdata{t+1,3} * pos{t+1,3});
        ratedeposit = double(AssetData{1,i}{t+1,8}/100);%���ձ�֤����
        AssetData{1,i}{t+1,5} = todayposition * ratedeposit;%��֤��
    end
end

%����
AssetAll = {'TradingDay','pnl_h','pnl_t','Asset_deposit','Asset_all','Asset_cash'};
ad = AssetData{1,1};
pos = position{1,1};
TradingDays = pos(2:end,1);
nt = size(TradingDays,1);
AssetAll(2:nt+1,1) = TradingDays;
%����
hodingpnlAll = zeros(size(ad,1)-1,1);
tradepnlAll = zeros(size(ad,1)-1,1);
assetdepositAll = zeros(size(ad,1)-1,1);
for i = 1:nPosition
    ad = AssetData{1,i};
    %ÿһ��Ʒ�ֵ�pnl
    hodingpnl = cell2mat(ad(2:end,3));
    tradepnl = cell2mat(ad(2:end,4));
    assetdeposit = cell2mat(ad(2:end,5));
    %��Ӧÿһ�����
    hodingpnlAll = hodingpnlAll + hodingpnl;
    tradepnlAll = tradepnlAll + tradepnl;
    assetdepositAll = assetdepositAll + assetdeposit;
end
%�ۼ�pnl
temp = cumsum(hodingpnlAll);
temp2 = cumsum(tradepnlAll);
temp3 = [temp,temp2];
cumpnl = cumsum(hodingpnlAll) + cumsum(tradepnlAll);
%��Ȩ��
assettotal = iniCapital + cumpnl;
%����
assetcash = assettotal - assetdepositAll;

AssetAll(2:nt+1,2) = num2cell(hodingpnlAll);
AssetAll(2:nt+1,3) = num2cell(tradepnlAll);
AssetAll(2:nt+1,4) = num2cell(assetdepositAll);
AssetAll(2:nt+1,5) = num2cell(assettotal);
AssetAll(2:nt+1,6) = num2cell(assetcash);


end