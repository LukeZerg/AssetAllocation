function weights = RiskParity(sub)
%风险平价模型
%输入：ub是N行M列的数据，N个日期，M个资产的收益
%输出：M个资产的权重
m = size(sub,2);%sub列数
%清洗数据，补全非法值

CovMatrix = cov(sub);%计算各个列之间的协方差矩阵
x0 = 1/m*ones(m-1,1);  %初始化权重，只有4个
x0 = [x0;1-sum(x0)];
%切换算法

A = [];
b= [];
%等式约束
%和为1；(x1+x2)/(x3+x4) = 3/7;  % Aeq = [1,1,1,1; 7,7,-3,-3];

Aeq = [1,1,1,1];  %风险30%，那么左侧1-30%，右侧-30%
beq = 1;

% Aeq = [1,1,1,1];
% beq = 1;
%股市【0.05,0.3】，期货【0.05,0.3】，,逆回购不超过0.7
lb = [0; 0; 0; 0];
ub = [1; 1; 1; 1];

option = optimoptions(@fmincon,'Algorithm','sqp');
weights = fmincon(@(x) TotalTRC(CovMatrix, x),x0,A,b,Aeq,beq,lb,ub,[],option);

% w = fminsearch(@(x) TotalTRC(CovMatrix, x),x0);
% weights = [w;1-sum(w)];
end
