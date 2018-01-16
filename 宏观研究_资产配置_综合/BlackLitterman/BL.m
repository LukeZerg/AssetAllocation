function weightsBL = BL(sub,w0,P,v,conf,tau)
%BL模型
%输入：ub是N行M列的数据，N个日期，M个资产的收益
%输出：M个资产的权重
N = size(sub,2);%sub列数
delta = 2.5; %风险厌恶系数
%tau=0.025*10;%tau越接近0，权重越接近初始权重，数据越接近正无穷，越接近投资者观点。
% w = [2;1;3;4];
w1 = w0/sum(w0);%市场权重

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% knowledge of the market
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NumPortf=15;
R = sub;
%ExpValRets_Hat=mean(R)';
CovRets_Hat=cov(R);

% prior on the market
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %根据python程序bl_idz修改
CovRets_Prior=CovRets_Hat*tau;
%市场隐含收益均衡收益 = 风险厌恶系数 * 协方差矩阵 * 市场组合权重
ExpValRets_Prior=delta*CovRets_Hat*w1;  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % views on the market0
% P = [-1, 0, 1, 0; 1, 0, 0, -1;1,-1,0,0;];
% %Omega=P*CovRets_Hat*P';   %simple Omega
% v=[.10 .02 .02]';
% conf = [0.8; 0.8; 0.5]; %信心指数

%生成Omega矩阵，对角线赋值为blOmega(conf(i),P(i,:)
nP = size(P,1);
Omega = zeros(nP,nP);
for i = 1:nP
    Omega(i,i) = blOmega(conf(i),P(i,:),CovRets_Prior);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute posterior BL
Mu_BL=ExpValRets_Prior+tau*CovRets_Hat*P'*inv(P*tau*CovRets_Hat*P'+Omega)*(v-P*ExpValRets_Prior);
%Sigma_BL=tau*CovRets_Hat-tau*CovRets_Hat*P'*inv(P*CovRets_Hat*P'+Omega)*P*tau*CovRets_Hat;
Sigma_BL=CovRets_Hat+inv(inv(tau*CovRets_Hat)+P'*inv(Omega)*P);

%Lambda = 1/delta*tau*

% % compute MV efficient frontier
 [ExpectedReturn,Volatility, Composition] = EfficientFrontier(NumPortf, Sigma_BL, Mu_BL);
 selected = floor(NumPortf/2);
% %selected = 3;
 weightsBL = Composition(selected,:);

%有约束情况下，结果证明以下程序算出来x0周围不递减，最优化走不动
% x0 = [1;1;1;1]/4;
% A = []; 
% b = [];
% Aeq = ones(1,N);
% beq = 1;
%lb = zeros(N,1);
%ub = ones(N,1);
%[weightsBL,fval,exitflag] = fmincon(@(x) findmin(x,Mu_BL,Sigma_BL,delta) ,x0,A,b,Aeq,beq,lb,ub);

%无约束权重结果类似“-400，+300，+0.25，……”这样的形式，不知道如何处理
%weightsBL = Mu_BL' * inv(delta*CovRets_Hat);%无约束情况下权重

%结果和无约束公式类似，不知道如何处理
%拉格朗日乘数法，参考Lee(2000)
%one = ones(N,1);
%weightsBL = inv(CovRets_Hat)*one/(one'*inv(CovRets_Hat)*one)+...
%    1/delta*inv(CovRets_Hat)*(Mu_BL-one'*inv(CovRets_Hat)*Mu_BL/(one'*inv(CovRets_Hat)*one)*one);

end