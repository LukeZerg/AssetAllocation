function weights = markowitz( sub, marketRet)
%����ά��ģ�ͼ���Ȩ��                      
%���룺ub��N��M�е����ݣ�N�����ڣ�M���ʲ�������
%�����M���ʲ���Ȩ��
ExpReturn = mean(sub); %ÿ�еľ�ֵ
ExpCovariance = cov(sub); %ÿ�е�
NumPorts = 20; %20��
[PortRisk, PortReturn, PortWts] = frontcon(ExpReturn,ExpCovariance, NumPorts);
weights = PortWts(10,:); %ѡ����Ч�߽��м��Ȩ��
end