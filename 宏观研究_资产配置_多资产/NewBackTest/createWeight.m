function Weight = createWeight(theWeights_abs, Direction )
%��û�з���Ĳ�λtheWeights_abs�뷽��Direction�ϲ�����,�õ�Weight����
n1 = size(theWeights_abs,2)-1; %�����������������
n2 = size(Direction,2)-1;
if n1 ~= n2
    error('û�з���Ĳ�λtheWeights_abs�뷽��Direction���ʲ�����ͬ');
end
nt = size(Direction,1)-1;
Weight = theWeights_abs ;
for iAsset = 1:n1
    for j = 1:nt
        Weight{j+1,iAsset+1} = Direction{j+1,iAsset+1}*Weight{j+1,iAsset+1}; %����ֵ
    end
end
end