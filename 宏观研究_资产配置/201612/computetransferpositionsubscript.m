function transvector = computetransferpositionsubscript(tradingdays, cycle)
%�����������а��ջ���Ƶ����ȡ�±�
%tradingdays����������
%cycle��������
nt = size(tradingdays,1);
transvector = [];
subscript = 0;%�±�
%������ֵ�����Ϊ��
if strcmp(cycle,'m')
    premonth = 0;
    for i = 1:nt
        vec = datevec(tradingdays{i});
        month = vec(2);
        if month ~= premonth
            transvector = [transvector;i];
        end ;%��¼�����·ݺ��һ��������
        premonth = month;
    end
else
    error('û�д���������');
end

end