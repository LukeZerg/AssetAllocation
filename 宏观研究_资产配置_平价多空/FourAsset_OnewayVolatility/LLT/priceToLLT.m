function LLTcol = priceToLLT(prices, alpha)
%将价格序列转换为LLT
%prices价格序列
%alpha是介于0到1之间的一个参数
%LLTcol序列
len = length(prices);
LLTcol = zeros(len,1);
LLTcol(1) = prices(1);
LLTcol(2) = prices(2);
for i = 3:len
    LLTcol(i) = GetLLT(prices(i), prices(i-1), prices(i-2),...
        LLTcol(i-1), LLTcol(i-2), alpha);
end
%让前两个值与第三个值相同,一般来说不用用到这两个值，3与回溯期相差一般比较大

end