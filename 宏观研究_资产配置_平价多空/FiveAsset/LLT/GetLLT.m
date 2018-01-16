function valueLLT = GetLLT(p0, p1, p2, L1, L2, alpha)
%�����LLTֵ
%p0,����X��ļ۸�LX,����X���LLT��alpha�ǽ���0��1֮���һ������
%valueLLT��LLT��ֵ

%p0 = prices(i)
%p1 = price(i-1)
%p2 = price(i-2)

value1 = 2*(1-alpha)*L1-(1-alpha)^2*L2;
value2 = (alpha-alpha^2/4)*p0+(alpha^2/2)*p1-(alpha-3*alpha^2/4)*p2;
valueLLT = value1 + value2;

end