function transvector = computeFreqSubscript(tradingdays, cycle)
%�����������а��ջ���Ƶ����ȡ�±�
%tradingdays����������
%cycle��������
nt = size(tradingdays,1);
%������ֵ�����Ϊ��
if strcmp(cycle,'m')
    transvector = 1;%��һ�쿪ʼ����
    premonth = 0;
    for i = 1:(nt-1)
        vec = datevec(tradingdays{i});
        month = vec(2);
        if month ~= premonth
            transvector = [transvector;i];
        end ;%��¼�����·ݺ��һ��������
        premonth = month;
    end
elseif strcmp(cycle,'w')
    weeks = zeros(nt,1);
    weekflag = zeros(nt,1);%��ʶÿ�ܵĵ�һ��������
    weekend = zeros(nt,1);%��ʶÿ�ܵ����һ��������
    weekflag(1) = 1;%��һ�������ձض��ǲ������һ�ܵĵ�һ��������
    for i = 1:nt
        vec = datevec(tradingdays{i});
        year = vec(1);
        month = vec(2);
        day = vec(3);
        weeks(i) = returenWeekDay(year,month,day);%���չ�ʽ�����ڼ������ڼ� 
        if i > 1
           daydelta = datenum(tradingdays{i}) - datenum(tradingdays{i-1});%����һ�������յ���Ȼ�վ���
           weekdaydelta = weeks(i) - weeks(i-1);%����һ���������������ֱȽ�
           %���
           if daydelta >= 7 || weekdaydelta <= 0 
               weekflag(i)=1; %���µ�һ�ܵĵ�һ��������
               weekend(i-1)=1; %ǰһ��һ������һ�ܵ����һ��������
           end
        end
    end
    transvector = find(weekend);%��Ϊweekend��ำֵ����nt-1�������Բ���ɾ�����һ��
    if transvector(1) ~= 1
        transvector = [1;transvector];
    end
else
    error('û�д���������');
end

end