%% ��������
%��currentFolderĿ¼�������ļ�����ӵ�·��
currentFolder = 'D:\001Work\����о�_�ʲ�����_BL���';
addpath(genpath(currentFolder))

%ԭʼ����ʱ��
startday_dt = '2010-01-01';
endday_dt = '2017-03-22';
%�������ʱ��
startdayInput = '2013-02-04';
enddayInput = '2017-03-22';   
backtime = 60;

%���ʲ�
capital = 30000*10000;
%BL���Բ���
d = 39; %MA���߼�������d
alpha = 2 / (d + 1); %LLT��ʽ�еĳ�����0��1֮��
cashcol = 4; %LLT��ؼ�����ж���Ҫ�ܿ�����
backtimeD = 39; %б�ʼ�������

%% ȡ��������ƽ�۶�ղ�����Ҫ������
[startday, endday, data, names] = ...
    getData_riskparityAndLS(startday_dt,endday_dt,startdayInput,...
    enddayInput,backtime,backtimeD);

%% ȡ��Imformation������position �� closeData
infoFile = '��Լ��Ϣ.txt';
Information = GetInformation(infoFile);
[Position0, CloseData0] = GetPosAndCls(data,Information);

%% ----------------------BL��ղ���------------------------
%w0 = [2;1;3;4];%��ʼȨ��
w0 = [4;1;1;1];%��ʼȨ��
tau=0.025;%tauԽ�ӽ�0��Ȩ��Խ�ӽ���ʼȨ�أ�����Խ�ӽ������Խ�ӽ�Ͷ���߹۵㡣

[Position, CloseData, theWeights ] = ...
    strategyBLLS(startday, endday, backtime, capital, Position0,...
    CloseData0, Information, names, cashcol,alpha, backtimeD, w0, tau);

%% ----------------------���Ĳ��� �Ӳ�λ�ͼ۸��ý��׼�¼-----------
TradeRecord = computetraderecord(Position, CloseData);

%% ---------------------------���岿�� ����pnl��asset --------------
[AssetData,AssetAll] = computeAsset(Position,TradeRecord, CloseData,...
    Information, capital);

%% ----------------------------Performance-----------------------
[ output ] = Performance( AssetAll );
open output
myplot(AssetAll,AssetData,theWeights)

%% ��������
% backtimelist = 20:5:250;
% k=1;
% myoutputs = cell(8,length(backtimelist));
% for i = 1:length(backtimelist)
%     disp(i);
%     backtime = backtimelist(i);
%     
%     [Position, CloseData, theWeights ] = ...
%         strategyBLLS(startday, endday, backtime, capital, Position0,...
%         CloseData0, Information, names, cashcol,alpha, backtimeD, w0, tau);
% 
%     TradeRecord = computetraderecord(Position, CloseData);
% 
%     [AssetData,AssetAll] = computeAsset(Position,TradeRecord, CloseData,...
%         Information, capital);
% 
%     [ output ] = Performance( AssetAll );
%     
%     if k == 1
%         myoutputs{1,1} = {'d'};
%         myoutputs{2,1} = {'backtime'};
%         myoutputs(3:10,1) = output(1:8,3);%name
%         myoutputs{1,k+1} = d;
%         myoutputs{2,k+1} = backtime;
%         myoutputs(3:10,k+1) = output(1:8,4);%data
%     else
%         myoutputs{1,k+1} = d;
%         myoutputs{2,k+1} = backtime;
%         myoutputs(3:10,k+1) = output(1:8,4);
%     end
%     k = k + 1;
% end
