function MAcol = priceToMA(prices, dMA)
%���۸�����ת��ΪMA��
%prices�۸�����
%d�ǻ�������
%MA����
len = length(prices);
MAcol = zeros(len,1);
for i = 1:dMA
    MAcol(i) = mean(prices(1:i));
end
for i = (dMA+1):len
    MAcol(i) = mean(prices((i-dMA):i));
end
%��ǰ����ֵ�������ֵ��ͬ,һ����˵�����õ�������ֵ��3����������һ��Ƚϴ�
end