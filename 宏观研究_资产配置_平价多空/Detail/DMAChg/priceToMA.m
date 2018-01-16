function MAcol = priceToMA(prices, dMA)
%将价格序列转换为MA线
%prices价格序列
%d是回溯天数
%MA序列
len = length(prices);
MAcol = zeros(len,1);
for i = 1:dMA
    MAcol(i) = mean(prices(1:i));
end
for i = (dMA+1):len
    MAcol(i) = mean(prices((i-dMA):i));
end
%让前两个值与第三个值相同,一般来说不用用到这两个值，3与回溯期相差一般比较大
end