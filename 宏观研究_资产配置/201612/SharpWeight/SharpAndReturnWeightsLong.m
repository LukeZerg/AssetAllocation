function weights = SharpAndReturnWeightsLong(sub)
%���������ʺ������ʼ������֣��ټ���Ȩ��
%���룺ub��N��M�е����ݣ�N�����ڣ�M���ʲ�������
%�����M���ʲ���Ȩ��
m = size(sub,2);%sub����
%������ʲ������ʣ��ۼ�������
sharp = zeros(m,1);
cumsumlist = zeros(m,1);
for iSharp = 1:m
    retlist = sub(:,iSharp); %��iSharp���ʲ���������
    sharp(iSharp) = mean(retlist)/std(retlist)*250; %�ɻ�Ϊ����
    temp = cumsum(retlist);
    cumsumlist(iSharp) = temp(end);%��iSharp���ʲ����ۼ�������
end

%��������������
score_sharp = zeros(m,1);
score_cumsum = zeros(m,1);

%������Ӧ��֮ǰ���±�
[~,sharpPresub] = sort(sharp);%����SharpRatio��С��������sharpPresub���������ʲ�������֮ǰ��λ��
[~,cumsumPresub] = sort(cumsumlist);%�����ۼ�����������������cumsumPresub�� cumsumPresub���������ʲ�������֮ǰ��λ��

%��¼�������֣�����Խǰ������ԽС
score_sharp(sharpPresub) = 1:m;
score_cumsum(cumsumPresub) = 1:m;
score_all = 1/2*score_sharp + 1/2*score_cumsum;
%������������õ�����
[~, scorePresub]=sort(score_all);

%���ո�����Ϊ����,ÿ���ڵ�Ȩ�ط���
sortweights = getSortWeights(m); %����ÿ���ʲ���Ȩ��
weights = zeros(m,1);

for iWeights = 1:m
    %ȡ��С�������ֵ�˳��ȡ���ʲ����±�
    subw = scorePresub(iWeights);
    weights(subw) = sortweights(iWeights);
end

end
