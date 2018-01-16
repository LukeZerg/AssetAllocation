clc
clear
% ȡ��������ƽ�۶�ղ�����Ҫ������
load('D:/001Work/����о�_�ʲ�����_ƽ�۶��/FiveAsse_NASDAQ/data.mat'); 
%% ��������
%��currentFolderĿ¼�������ļ�����ӵ�·��
%feature('DefaultCharacterSet', 'GBK');%ʹ��matlab�ܹ�ʶ��utf8
% currentFolder = 'D:\001Work';
% rmpath(genpath(currentFolder))
currentFolder = 'D:\001Work\����о�_�ʲ�����_ƽ�۶��\FiveAsse_AU';
addpath(genpath(currentFolder))

%�������ʱ��
%startdayInput = '2017-06-01';
startdayInput = '2014-06-01';
enddayInput = '2017-08-04';   

backtime = 225;%����ƽ��ģ�ͻ��ݴ���
 %б�ʼ�������
backtimeD = [80,43,20,200,50];%������Ϊ��1���ʲ��������ľ���ÿһ������������ʲ�б�ʼ�������
if max(backtimeD) > backtime
    wrong('б�ʼ��������������ݼ�������');
end

%���ʲ�
capital = 3000 * 10000;%20170626��λ

%BL���Բ���
d = 39; %LLT����(MA���߼�������d)
alpha = 2 / (d + 1); %LLT��ʽ�еĳ�����0��1֮��
longcol = [1,3,4]; %ֻ�ڷ��������ź�ʱ�볡���ʲ��±�

%�ý�������������ʱ��
w = windmatlab();
[w_tdays_data,~,~,~,~,~]=w.tdays(startdayInput, enddayInput);
if(isempty(w_tdays_data))
    error('wind����Ϊ��');
end
startday = datestr(w_tdays_data{1},29);
endday = datestr(w_tdays_data{end},29);

%% ȡ��Imformation������position �� closeData

infoFile = '��Լ��Ϣ.txt';
Information = GetAssetInformation(infoFile); %���ʲ�˳�򱣳�һ��

[Position0, CloseData0] = GetPosAndCls(Data,Information);

%% ----------------------Riskparity��ղ���------------------------
%LLT��ʱ
cycle = 'w';  %m w
[Position, CloseData, theWeights ] = ...
    strategyRiskpParityLLT(startday, endday, backtime, capital, Position0,...
    CloseData0, Information, names, longcol,alpha, backtimeD, cycle);
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
myplot_FourAsset(AssetAll,AssetData,theWeights)

%% ---------------d---- �������� ---------------------
% 
% backtimeD = [80,43,40,43,50]; %б�ʼ�������   
% parlist = 10:10:220;
% lenp = length(parlist);
% k = 1;
% for i = 1:lenp
%         disp(i);
%         backtimeD(4) = parlist(i); 
%         % ----------------------Riskparity��ղ���------------------------
%         %LLT��ʱ
%         cycle = 'w';  %m w
%         [Position, CloseData, theWeights ] = ...
%             strategyRiskpParityLLT(startday, endday, backtime, capital, Position0,...
%             CloseData0, Information, names, longcol,alpha, backtimeD, cycle);
%         %DMAChg��ʱ
%         % [Position, CloseData, theWeights ] = ...
%         %     strategyRiskpParityDMAChg(startday, endday, backtime, capital, Position0,...
%         %     CloseData0, Information, names, cashcol,backtimeDMA);
% 
%         % ----------------------���Ĳ��� �Ӳ�λ�ͼ۸��ý��׼�¼-----------
%         TradeRecord = computetraderecord(Position, CloseData);
% 
%         % ---------------------------���岿�� ����pnl��asset --------------
%         [AssetData,AssetAll] = computeAsset(Position,TradeRecord, CloseData,...
%             Information, capital);
% 
%         % ----------------------------Performance-----------------------
%         [ output ] = Performance( AssetAll );
% 
%         
% 
%         if k == 1
%             %��������
%             myoutputs{1,1} = {'Dbacktime'};
%             myoutputs{2,1} = {'backtime'};
%             myoutputs(3:10,1) = output(1:8,3);%name
%             myoutputs{1,k+1} = parlist(i);
%             myoutputs{2,k+1} = backtime;
%             myoutputs(3:10,k+1) = output(1:8,4);%data
%         else
%             myoutputs{1,k+1} = parlist(i);
%             myoutputs{2,k+1} = backtime;
%             myoutputs(3:10,k+1) = output(1:8,4);
%         end
%         k = k + 1;
% end
% surf(blist,Dlsit,Msharpratio); %������άͼ
% 
% surf(blist((end-15):end),Dlsit(1:21),Msharpratio(1:21,5:20)); %������άͼ
% 
% save canshuTest myoutputs Msharpratio Dlsit blist
% load('canshuTest.mat')