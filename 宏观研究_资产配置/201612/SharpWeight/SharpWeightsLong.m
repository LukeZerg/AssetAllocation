function weights = SharpWeightsLong(sub)
%���������ʼ���Ȩ��
%���룺ub��N��M�е����ݣ�N�����ڣ�M���ʲ�������
%�����M���ʲ���Ȩ��
m = size(sub,2);%sub����
sharp = zeros(m,1);
weights = zeros(m,1);
for iSharp = 1:m
    retlist = sub(:,iSharp); %��iSharp���ʲ���������
    sharp(iSharp) = mean(retlist)/std(retlist)*250;
end
% 1-4�Ȳ�����,���3/(m-1)
sharpsort = [(1:4)',sharp];
sharpsort = sortrows(sharpsort,2);%�����±�������ʴ�С��������
for iSharp = 1:m
   subscript = sharpsort(iSharp,1);%��С����ȡ���±�
   weights(subscript) = 1+3/(m-1)*(iSharp-1); %��1��ʼ���ϼ��
end
weights = weights/sum(weights);%ʹȨ��֮��Ϊ��
end
