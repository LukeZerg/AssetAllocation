clc;
clear;
%��ȡ���ʲ��۸�����Data��������Լ����Close�������ʲ�ÿ��cell�;����Լ����ÿ��cellһһ��Ӧ
startday_dt = '2015-04-20';
endday_dt = '2017-12-01';
currentFolder = 'D:\001Work\����о�_�ʲ�����_���ʲ�';
addpath(genpath(currentFolder))

%% �����ʲ��۸�Data
w=windmatlab();
%A�ɡ���Ʒ���۹ɡ���ծ
names = {'��֤50','��֤500','��ծ�̶�����ծȯȫ��','���������м�����ծ�ۺ�ָ��','WIND��Ʒָ��','WIND�ƽ�ָ��','����ָ��'};
contract = {'000016.SH','000905.SH','0451.CS','SCH012.SCH','CCFI.WI','NH0008.NHF','HSI.HI'};
Data = getindexdata(startday_dt, endday_dt, contract);
Data = [Data;names];
%��Data���һ���û�Ϊ��ʱ�۸�
% [w_data,w_codes,w_fields,w_times,w_errorid,w_reqid]=w.wsq('000300.SH,NH0100.NHF,159920.SZ','rt_last');
% Data{1,1}{end,3} = w_data(1);
% Data{1,2}{end,3} = w_data(2);
% Data{1,3}{end,3} = w_data(3);

%% �����Լ����CLose
%A�ɡ���Ʒ���۹ɡ���ծ
Close = getETFdata(startday_dt, endday_dt, contract);
Close = [Close;names];

%% Information
Information = cell(length(contract)+1,4);
Information(1,:) = {'variety','Multiplier','SlipPrice','fee'};
Information(2:end,1) = contract';
Information(2:end,2) = {1};%����
Information(2:end,3) = {0.01};%����
Information(2:end,4) = {0.0005};%����������

save('D:/001Work/����о�_�ʲ�����_���ʲ�/data_RiskParity.mat','Data','Close','Information');