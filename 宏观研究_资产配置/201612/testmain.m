%% ��txtȡ������

feature('DefaultCharacterSet', 'UTF8');%ʹ��matlab�ܹ�ʶ��utf8
fid = fopen('����.txt','r');
info = textscan(fid, '%f%f%f%f%f','HeaderLines',1,'Delimiter',',');%textscan��Name-Value Pair Arguments������������ʼ��1�У���','Ϊ�ָ���,infoÿ��cellΪ1��
fclose(fid);

%��info�������ʾ���
nVariety = size(info,2);
RetMatrix = zeros(size(info{1,k},1)-1,nVariety);
for k = 1:nVariety
    close = info{1,k};
    ret = diff(close)./close(1:(end-1));
    RetMatrix(:,k) = ret;
end
weights = RiskParity(RetMatrix);

