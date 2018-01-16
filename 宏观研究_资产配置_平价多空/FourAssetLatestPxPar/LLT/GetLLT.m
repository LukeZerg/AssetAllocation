function valueLLT = GetLLT(p0, p1, p2, L1, L2, alpha)
%计算得LLT值
%p0,回溯X天的价格，LX,回溯X天的LLT，alpha是介于0到1之间的一个参数
%valueLLT是LLT的值

%p0 = prices(i)
%p1 = price(i-1)
%p2 = price(i-2)

value1 = 2*(1-alpha)*L1-(1-alpha)^2*L2;
value2 = (alpha-alpha^2/4)*p0+(alpha^2/2)*p1-(alpha-3*alpha^2/4)*p2;
valueLLT = value1 + value2;

end