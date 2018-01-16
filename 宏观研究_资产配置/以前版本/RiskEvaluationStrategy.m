function [resultcell] = RiskEvaluationStrategy(data, w, code1, code2, code3, Today, capital_start, cycle )
%w = windmatlab;
% code1 = 'S0105896';                             %�ϻ�
% %code2 = 'M0066367';                            %��Ծ��Լ ����300
% code2 = 'M0020209';                             %����300 ָ��
% code3 = 'M0096849';                             %��Ծ��Լ 5���ڹ�ծ�ڻ�
% Today = '2016/02/08';
% capital_start = 10000000;
% cycle = 22;                                     %����
%data = importdata('data1.xlsx');  
StartDate = datestr(datenum(Today)-366, 29);    %ȡ��ȥһ���ʱ��������Ȩ��
EndDate = datestr(datenum(Today), 29);   
[data1,~,~,~,~]=w.edb(code1,StartDate,EndDate,'Fill=Previous'); 
[data2,~,~,~,~]=w.edb(code2,StartDate,EndDate,'Fill=Previous');
[data3,~,~,~,~]=w.edb(code3,StartDate,EndDate,'Fill=Previous');
weights = GetWeights(data1(1:(end-1)),data2(1:(end-1)),data3(1:(end-1)));    %��÷���ƽ�����Ž��Ȩ��,�ý�����ǰ�����ݼ���
if isempty(data) == 1
    capital = capital_start ;                          %�ʱ���ʼ��,���׵�һ��
    cap = capital * weights;                           %�������ʲ��Ϸ����ʽ�
    TradingDay = Today;
    count = 1;
    %д��
    firstcell = {'TradingDay','cap1','cap2','cap3','count'};
    secondcell = {  TradingDay, cap(1), cap(2), cap(3), count };
    mycell = 
    %xlswrite('data1.xlsx',mycell);
else
    onedata = data.data(end,:);
    cap_pre = onedata(1:3);
    count = onedata(4); 
    count = count + 1;                                  %�������ڼ���
    ret = zeros(3,1);
    %���������
    ret(1) = ( data1(end) - data1(end-1) ) / data1(end-1);
    ret(2) = ( data2(end) - data2(end-1) ) / data2(end-1);
    ret(3) = ( data3(end) - data3(end-1) ) / data3(end-1);
    cap = cap_pre'.*(ret+1);                             %����������ʱ�
    if count == cycle                                    %����������ˣ���Ȩ�ط����ʽ�
        cap = sum(cap)*weights;
    end
    TradingDay = data.textdata(end,:);
    mycell = { TradingDay, cap(1), cap(2), cap(3), count };

end
%xlswrite('data1.xlsx',mycell);
%system('tskill excel');                                 %�ص�EXCEL����
resultcell = mycell;
end