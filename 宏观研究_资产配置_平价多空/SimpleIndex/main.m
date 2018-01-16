%% ��������
%��currentFolderĿ¼�������ļ�����ӵ�·��
currentFolder = 'D:\001Work\����о�_�ʲ�����_ƽ�۶��\SimpleIndex';
addpath(genpath(currentFolder))

%ԭʼ����ʱ��
startday_dt = '2012-11-01';
endday_dt = '2017-03-03';
%�������ʱ��
startdayInput = '2013-02-04';
enddayInput = '2017-03-03';   
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
    getData_riskparityAndLS(startday_dt,endday_dt,startdayInput,enddayInput,backtime,backtimeD);

%% Riskparity����
[pnldata, Assetall, Cumsums, weights ] = ...
    strategyriskprityandcomputeasset(startday, endday, backtime, capital, data, names, cashcol,alpha, backtimeD);
[ output ] = Performance( Assetall );
