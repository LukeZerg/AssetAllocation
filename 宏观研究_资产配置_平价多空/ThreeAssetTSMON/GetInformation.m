function Information = GetInformation(infoFile)
%ȡ�ú�Լ��Ҫ�ĳ����������ѵ���Ϣ
%feature('DefaultCharacterSet', 'UTF8');%ʹ��matlab�ܹ�ʶ��utf8
fid = fopen(infoFile,'r');
info = textscan(fid, '%s%d%f%f','HeaderLines',1,'Delimiter',',');%textscan��Name-Value Pair Arguments������������ʼ��1�У���','Ϊ�ָ���,infoÿ��cellΪ1��
fclose(fid); 


variety = info{1,1}; %��ȡƷ�ִ���
Multiplier = info{1,2};   %����
SlipPrice = info{1,3}; %����
fee = info{1,4}; %�����ѱ���

Information = cell(size(variety,1)+1,size(info,2));
Information(1,:) = {'variety','Multiplier','SlipPrice','fee'};

Information(2:end,1) = variety;
Information(2:end,2) = num2cell(Multiplier);
Information(2:end,3) = num2cell(SlipPrice);
Information(2:end,4) = num2cell(fee);

end