Data = getindexdata('2010-11-02', '2017-01-11', [{'000300.SH'},{'000905.SH'},...
    {'NH0300.NHF'},{'NH0200.NHF'},{'AU.SHF'},{'NH0500.NHF'},{'NH0400.NHF'}]);
names = {{'����300'},{'��֤500'},{'�ϻ�ũ��Ʒָ��'},{'�ϻ���ҵƷָ��'},...
    {'SHFE�ƽ�'},{'�ϻ��ܻ�ָ��'},{'�ϻ�����ָ��'},{'��ծ'}};
%���а���Ϊ����300����֤500
%�ϻ���Ʒָ������Ϊ
% NH0300.NHF �ϻ�ũ��Ʒָ��
% NH0200.NHF �ϻ���ҵƷָ��
% AU.SHF �ûƽ�����������
% NH0500.NHF �ϻ��ܻ�ָ��
% NH0400.NHF �ϻ�����ָ��
%% ��ȡ��ծ����
feature('DefaultCharacterSet', 'UTF8');%ʹ��matlab�ܹ�ʶ��utf8
fid = fopen('D:/001Work/����о�_�ʲ�����/201612/data/10���ڹ�ծ������.txt','r');
info = textscan(fid, '%s%f','HeaderLines',0,'Delimiter',',');%textscan��Name-Value Pair Arguments������������ʼ��1�У���','Ϊ�ָ���,infoÿ��cellΪ1��
fclose(fid);
%��ȡ��ծ���ݣ��ϳ�DataƷ�ֵ�һ����
tradingdays = info{1,1};
treasurycls = num2cell(info{1,2});

%onedata��wind�ӿ�ȡ�����ݵ����ڲ�һ�£��໥���в�һ�µ�����
%Ѱ�Ҳ�ͬ���ڲ���onedata��ɾ��
ddt = Data{1,1};
tdays = ddt(2:end,1);
daydiff = setdiff(tradingdays, tdays); %�ҵ�wind�ӿ���û�е�����
% Lia = ismember(A,B) returns an array containing 1 (true) where the ...
% data in A is found in B. Elsewhere, it returns 0 (false).
vectorfind = find(ismember(tradingdays,daydiff)==1);
tradingdays(vectorfind) = [];
treasurycls(vectorfind) = [];%ɾ��

%�޳����tradingdays��tdays�е�λ��
vectorfind2 = find(ismember(tdays,tradingdays)==1);
tdays2 = tdays;
treasurycls2 = zeros(size(tdays2,1),size(tdays2,2));
treasurycls2(vectorfind2) = cell2mat(treasurycls);%����Ӧλ���ϸ�ֵ

%�������0ֵ
prebox = 0;
n = length(treasurycls2);
for i = 1:n
    if treasurycls2(i) == 0
        treasurycls2(i) = prebox;
    else
        prebox = treasurycls2(i);
    end
end

%�ϳ�Data��һ����
contract = cell(size(tdays2,1),1);
contract(:,1) = {'treasury'};
onedata = [tdays2, contract, num2cell(treasurycls2)];
onedata = [{'TradingDay'},{'Contract'},{'Close'};onedata];
%�ϲ���Data��
Data = [Data,{onedata}];
%% �������۲���
[pnldata, Assetall, Cumsums, weights ] = strategyriskprityandcomputeasset( '2011-02-01', ...
                            '2017-01-11', 60, 30000*10000, Data, names);
[ output ] = Performance( Assetall );

%Plot_Animation_Net(output);
