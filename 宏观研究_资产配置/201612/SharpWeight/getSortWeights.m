function weights = getSortWeights(m)
%��1��m�����а���proportion��������Ȩ�أ�����1��mÿ��λ���ϵ�Ȩ��
if m == 3
    weights = [1-1/2-1/3;1/3;1/2];
elseif m == 4
    weights = [1/6;1/6;1/6;1/2];
    %weights = [1/10;2/10;3/10;4/10];
else
    error('getSortWeightsû�п����������ʲ�����');
end
end