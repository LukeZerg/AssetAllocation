clc
clear
%% ��������
%��currentFolderĿ¼�������ļ�����ӵ�·��
%feature('DefaultCharacterSet', 'GBK');%ʹ��matlab�ܹ�ʶ��utf8
%currentFolder = 'D:\001Work';
%rmpath(genpath(currentFolder))
currentFolder = 'D:\001Work\����о�_�ʲ�����_ƽ�۶��\FourAsset_OnewayVolatility';
addpath(genpath(currentFolder))

%ԭʼ����ʱ��
% startday_dt = '2012-07-01';
% endday_dt = '2017-03-14';
startday_dt = '2012-10-22';
endday_dt = '2017-07-10';
%�������ʱ��
%startdayInput = '2017-06-01';
startdayInput = '2016-01-01';
enddayInput = '2017-07-10';   

backtime = 225;%����ƽ��ģ�ͻ��ݴ���


global strategy
strategy.cycle = 'w';  %Ƶ�� m w
strategy.MA_LEN = 40; %���������ʼ�������ƽ������
strategy.VOL_LEN = 10; %�����ʼ��㴰��
strategy.THRESHOLD = [0.15, 0.025, 0.125, 0.03]; %�򵥴��̷���жϻ�׼

strategy.capital = 650 * 10000;%���ʲ�
%capital = 550 * 10000;%20170622��λ
%capital = 650 * 10000;%20170626��λ



%% ȡ��������ƽ�۶�ղ�����Ҫ������
%��������ع��������ʲ�

[startday, endday, data, names] = ...
    getData_riskparityAndLS(startday_dt,endday_dt,startdayInput,enddayInput);

%% ȡ��Imformation������position �� closeData

infoFile = '��Լ��Ϣ.txt';
Information = GetAssetInformation(infoFile);
[Position0, CloseData0] = GetPosAndCls(data,Information);


%% ----------------------Riskparity��ղ���------------------------
%LLT��ʱ
[Position, CloseData, theWeights ] = ...
    strategyRiskpParity_OnewayVolatility(startday, endday, backtime, Position0,...
    CloseData0, Information, names);
%DMAChg��ʱ
% [Position, CloseData, theWeights ] = ...
%     strategyRiskpParityDMAChg(startday, endday, backtime, capital, Position0,...
%     CloseData0, Information, names, cashcol,backtimeDMA);

%% ----------------------���Ĳ��� �Ӳ�λ�ͼ۸��ý��׼�¼-----------
TradeRecord = computetraderecord(Position, CloseData);

%% ---------------------------���岿�� ����pnl��asset --------------
[AssetData,AssetAll] = computeAsset(Position,TradeRecord, CloseData,...
    Information, strategy.capital);

%% ----------------------------Performance-----------------------
[ output ] = Performance(AssetData, AssetAll );
open output
myplot_FourAsset(AssetAll,AssetData,theWeights)

%% ---------------d---- �������� ---------------------
% Dlsit = [40:1:60,160:1:170];
% lend = length(Dlsit);
% 
% blist = [25:10:55,165:10:315];
% lenb = length(blist);
% 
% alpha = 2 / (39 + 1);
% 
% Msharpratio = zeros(lend,lenb);
% myoutputs = cell(8,1+lend*lenb);
% k = 1;
% for i = 1:lend
%     for j = 1:lenb
%         disp(i);
%         backtimeD = Dlsit(i);
%         backtime = blist(j);
%         [Position, CloseData, theWeights ] = ...
%         strategyRiskpParityLLT(startday, endday, backtime, capital, Position0,...
%         CloseData0, Information, names, cashcol,alpha, backtimeD,cycle);
% 
%         TradeRecord = computetraderecord(Position, CloseData);
% 
%         [AssetData,AssetAll] = computeAsset(Position,TradeRecord, CloseData,...
%             Information, capital);
% 
%         [ output ] = Performance( AssetAll );
%         
%         Msharpratio(i,j) = output{8,4};%��¼�����ʾ���
%         if k == 1
%             %��������
%             myoutputs{1,1} = {'Dbacktime'};
%             myoutputs{2,1} = {'backtime'};
%             myoutputs(3:10,1) = output(1:8,3);%name
%             myoutputs{1,k+1} = backtimeD;
%             myoutputs{2,k+1} = backtime;
%             myoutputs(3:10,k+1) = output(1:8,4);%data
%         else
%             myoutputs{1,k+1} = backtimeD;
%             myoutputs{2,k+1} = backtime;
%             myoutputs(3:10,k+1) = output(1:8,4);
%         end
%         k = k + 1;
%     end
% end
% 
% surf(blist,Dlsit,Msharpratio); %������άͼ
% 
% surf(blist((end-15):end),Dlsit(1:21),Msharpratio(1:21,5:20)); %������άͼ
% 
% save canshuTest myoutputs Msharpratio Dlsit blist
% load('canshuTest.mat')