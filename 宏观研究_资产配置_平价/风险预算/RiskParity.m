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
%��ʽԼ��
%��Ϊ1��(x1+x2)/(x3+x4) = 3/7;  % Aeq = [1,1,1,1; 7,7,-3,-3];

Aeq = [1,1,1,1];  %����30%����ô���1-30%���Ҳ�-30%
beq = 1;

% Aeq = [1,1,1,1];
% beq = 1;
%���С�0.05,0.3�����ڻ���0.05,0.3����,��ع�������0.7
lb = [0; 0; 0; 0];
ub = [1; 1; 1; 1];

option = optimoptions(@fmincon,'Algorithm','sqp');
weights = fmincon(@(x) TotalTRC(CovMatrix, x),x0,A,b,Aeq,beq,lb,ub,[],option);

% w = fminsearch(@(x) TotalTRC(CovMatrix, x),x0);
% weights = [w;1-sum(w)];
end
