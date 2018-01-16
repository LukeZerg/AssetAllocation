clc
clear
%% ��������
%��currentFolderĿ¼�������ļ�����ӵ�·��
currentFolder = 'D:\001Work\����о�_�ʲ�����_ƽ�۶��\ThreeAssetTSMON';
addpath(genpath(currentFolder))

%ԭʼ����ʱ��
% startday_dt = '2012-07-01';
% endday_dt = '2017-03-14';
startday_dt = '2010-01-01';
endday_dt = '2017-05-16';
%�������ʱ��
startdayInput = '2013-02-04';
enddayInput = '2017-05-16';   

backtime = 225;%����ƽ��ģ�ͻ��ݴ���
%���ʲ�
capital = 700*10000;
%BL���Բ���
d = 39; %LLT����(MA���߼�������d)
cashcol = 4; %LLT��ؼ�����ж���Ҫ�ܿ�����


%% ȡ��������ƽ�۶�ղ�����Ҫ������
%��������ع��������ʲ�
[startday, endday, data, names] = ...
    getData_riskparityAndLS(startday_dt,endday_dt,startdayInput,enddayInput);

%��ԭʼ������ʼʱ��ȡ����ع�����
riskFreeAsset = GetRiskfreeassetData(startday_dt,endday_dt);

%% ȡ��Imformation������position �� closeData

infoFile = '��Լ��Ϣ.txt';
Information = GetInformation(infoFile);
[Position0, CloseData0] = GetPosAndCls(data,Information);


%% ----------------------Riskparity��ղ���------------------------
%LLT��ʱ
backtimeTSMON = 21; %��������TSMON�������������
cycle = 'w';  %m w
[Position, CloseData, theWeights ] = ...
    strategyRiskpParityTSMON(startday, endday, backtime, capital, Position0,...
    CloseData0, Information, names, cashcol, cycle, riskFreeAsset, backtimeTSMON);
%DMAChg��ʱ
% [Position, CloseData, theWeights ] = ...
%     strategyRiskpParityDMAChg(startday, endday, backtime, capital, Position0,...
%     CloseData0, Information, names, cashcol,backtimeDMA);

%% ----------------------���Ĳ��� �Ӳ�λ�ͼ۸��ý��׼�¼-----------
TradeRecord = computetraderecord(Position, CloseData);

%% ---------------------------���岿�� ����pnl��asset --------------
[AssetData,AssetAll] = computeAsset(Position,TradeRecord, CloseData,...
    Information, capital);

%% ----------------------------Performance-----------------------
[ output ] = Performance( AssetAll );
open output
myplot(AssetAll,AssetData,theWeights)

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