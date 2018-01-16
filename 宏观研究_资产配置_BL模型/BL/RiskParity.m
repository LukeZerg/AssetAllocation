function weights = RiskParity(sub)
%����ƽ��ģ��
%���룺ub��N��M�е����ݣ�N�����ڣ�M���ʲ�������
%�����M���ʲ���Ȩ��
m = size(sub,2);%sub����
%��ϴ���ݣ���ȫ�Ƿ�ֵ

CovMatrix = cov(sub);%���������֮���Э�������
x0 = 1/m*ones(m-1,1);  %��ʼ��Ȩ�أ�ֻ��4��
x0 = [x0;1-sum(x0)];
%�л��㷨

A = [];
b= [];
Aeq = ones(1,m);
beq = 1;
lb = zeros(m,1);
ub = ones(m,1);

option = optimoptions(@fmincon,'Algorithm','sqp');
weights = fmincon(@(x) TotalTRC(CovMatrix, x),x0,A,b,Aeq,beq,lb,ub,[],option);

% w = fminsearch(@(x) TotalTRC(CovMatrix, x),x0);
% weights = [w;1-sum(w)];
end
