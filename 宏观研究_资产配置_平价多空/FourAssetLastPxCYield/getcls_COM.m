function CloseData_COM = getcls_COM(Position_COM,comInfo)
%��ȡ��Ʒ�۸�
    variety_com = comInfo(2:end,2); %��ȡƷ�ִ���
    comtdays = Position_COM(2:end,1);
    nt = size(comtdays,1);
    CloseData_COM = getFuturedataRiskParity(comtdays{1}, comtdays{nt}, variety_com); %��ȡ��Ʒ�۸��������
end