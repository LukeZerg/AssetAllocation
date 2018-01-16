function LLTcol = priceToLLT(prices, alpha)
%���۸�����ת��ΪLLT
%prices�۸�����
%alpha�ǽ���0��1֮���һ������
%LLTcol����
len = length(prices);
LLTcol = zeros(len,1);
LLTcol(1) = prices(1);
LLTcol(2) = prices(2);
for i = 3:len
    LLTcol(i) = GetLLT(prices(i), prices(i-1), prices(i-2),...
        LLTcol(i-1), LLTcol(i-2), alpha);
end
%��ǰ����ֵ�������ֵ��ͬ,һ����˵�����õ�������ֵ��3����������һ��Ƚϴ�

end