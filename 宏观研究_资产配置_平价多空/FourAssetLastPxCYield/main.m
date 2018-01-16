clc
clear
%% ��������
%��currentFolderĿ¼�������ļ�����ӵ�·��
%feature('DefaultCharacterSet', 'GBK');%ʹ��matlab�ܹ�ʶ��utf8
% currentFolder = 'D:\001Work';
% rmpath(genpath(currentFolder))
currentFolder = 'D:\001Work\����о�_�ʲ�����_ƽ�۶��\FourAssetLastPxCYield';
addpath(genpath(currentFolder))

%ԭʼ����ʱ��
% startday_dt = '2012-07-01';
% endday_dt = '2017-03-14';
startday_dt = '2015-03-22';
endday_dt = '2017-07-18';
%�������ʱ��
%startdayInput = '2017-06-01';
startdayInput = '2016-07-01';
enddayInput = '2017-07-18';   

backtime = 225;%����ƽ��ģ�ͻ��ݴ���
%capital = 550 * 10000;%20170622��λ
global s
s.capital = 800 * 10000;%20170626��λ
%���ʲ�
%capital = 1000*10000;
%BL���Բ���
d = 39; %LLT����(MA���߼�������d)
alpha = 2 / (d + 1); %LLT��ʽ�еĳ�����0��1֮��
longcol = [1,3]; %ֻ�ڷ��������ź�ʱ�볡���ʲ��±�
backtimeD = 43; %б�ʼ�������
backtimeDMA = 3;%DMAChg�����ж�����


%% ȡ��������ƽ�۶�ղ�����Ҫ������
%��������ع��������ʲ�

[startday, endday, data, names] = ...
    getData_riskparityAndLS_LatestPx(startday_dt,endday_dt,startdayInput,...
    enddayInput,backtime,backtimeD);

%% ȡ��Imformation������position �� closeData

infoFile = '��Լ��Ϣ.txt';
Information = GetAssetInformation(infoFile);
[Position0, CloseData0] = GetPosAndCls(data,Information);

%% ȡ��Cֵ������Cֵ������

% [~,~,cdata] = xlsread('D:/001Work/����о�_�ʲ�����_ƽ�۶��/FourAssetLastPxCYield/��������.csv');
%save('D:/001Work/����о�_�ʲ�����_ƽ�۶��/FourAssetLastPxCYield/cdata.mat','cdata');
load('D:/001Work/����о�_�ʲ�����_ƽ�۶��/FourAssetLastPxCYield/cdata.mat');

% [~,~,comInfo] = xlsread('D:/001Work/����о�_�ʲ�����_ƽ�۶��/FourAssetLastPxCYield/��Ʒ��Ϣ.xlsx');
% save('D:/001Work/����о�_�ʲ�����_ƽ�۶��/FourAssetLastPxCYield/comInfo.mat','comInfo');
load('D:/001Work/����о�_�ʲ�����_ƽ�۶��/FourAssetLastPxCYield/comInfo.mat');

%% ----------------------Riskparity��ղ���------------------------
%LLT��ʱ

[Position, CloseData, theWeights, theDirection ] = ...
    strategyRiskpParityLLTAsset(startday, endday, backtime, Position0,...
    CloseData0, names, longcol,alpha, backtimeD, cdata);

%% ���������Ʒ�������ʲ���position��Close
comcol = 2;%��Ʒ�ǵڶ����ʲ�
[threePos,threeCls,threeInfo] = getThreePosCls(Position, CloseData, theDirection, theWeights, Information );
 
%% ȡ����Ʒcls��������Ʒpos
Position_COM = Position{1,2};

% CloseData_COM = getcls_COM(Position_COM,comInfo); %��ȡ��Ʒ�۸�
% save('D:/001Work/����о�_�ʲ�����_ƽ�۶��/FourAssetLastPxCYield/CloseData_COM.mat','CloseData_COM');
load('D:/001Work/����о�_�ʲ�����_ƽ�۶��/FourAssetLastPxCYield/CloseData_COM.mat');

[Weights_COM, Direction_COM] = getWD_COM(theWeights,theDirection,comcol); %��ȡ��Ʒ�����Ȩ���뷽��

nls = 6; %��ո�������nls������nls��
Pos_COM = getpos_COM(Position_COM, CloseData_COM, Weights_COM, Direction_COM, cdata ,comInfo ,nls ); %���Cֵ����ȷ����Ʒ��λ

%% ----------------------�ϲ���λ �۸� Imfo--------------
CloseData2 = [threeCls,CloseData_COM];
Position2 = [threePos,Pos_COM];
%info
temp = comInfo;
cominfo1 = temp(2:end,2:5);
Information2 = [threeInfo;cominfo1];
%% ----------------------���Ĳ��� �Ӳ�λ�ͼ۸��ý��׼�¼-----------
TradeRecord = computetraderecord(Position2, CloseData2);

%% ---------------------------���岿�� ����pnl��asset --------------
[AssetData,AssetAll] = computeAsset(Position2,TradeRecord, CloseData2,...
    Information2);

%��Ʒӯ������
nA = size(AssetData,2);
nt = size(AssetData{1,i},1);
AssetCom = cell(nt,length(4:nA)+1);
AssetCom(:,1) =  AssetData{1,i}(:,1);
variety = comInfo(2:end,2)';
AssetCom(1,2:end) = variety;
for i = 4:nA
    temp = AssetData{1,i}(2:end,3:4);
    temp1 = cumsum(cell2mat(temp));
    temp2 = sum(temp1,2);
    AssetCom(2:end,i-2) = num2cell(temp2);
end


%���ڻ��ϲ�
collist = 4:36;
AssetDataMerge = mergeCOMAssetData(AssetData,collist);
%% ----------------------------Performance-----------------------
[ output ] = Performance( AssetAll );
open output
myplot_FourAsset(AssetAll,AssetDataMerge,theWeights)

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