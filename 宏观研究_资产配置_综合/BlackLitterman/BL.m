function weightsBL = BL(sub,w0,P,v,conf,tau)
%BLģ��
%���룺ub��N��M�е����ݣ�N�����ڣ�M���ʲ�������
%�����M���ʲ���Ȩ��
N = size(sub,2);%sub����
delta = 2.5; %�������ϵ��
%tau=0.025*10;%tauԽ�ӽ�0��Ȩ��Խ�ӽ���ʼȨ�أ�����Խ�ӽ������Խ�ӽ�Ͷ���߹۵㡣
% w = [2;1;3;4];
w1 = w0/sum(w0);%�г�Ȩ��

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% knowledge of the market
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NumPortf=15;
R = sub;
%ExpValRets_Hat=mean(R)';
CovRets_Hat=cov(R);

% prior on the market
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %����python����bl_idz�޸�
CovRets_Prior=CovRets_Hat*tau;
%�г���������������� = �������ϵ�� * Э������� * �г����Ȩ��
ExpValRets_Prior=delta*CovRets_Hat*w1;  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % views on the market0
% P = [-1, 0, 1, 0; 1, 0, 0, -1;1,-1,0,0;];
% %Omega=P*CovRets_Hat*P';   %simple Omega
% v=[.10 .02 .02]';
% conf = [0.8; 0.8; 0.5]; %����ָ��

%����Omega���󣬶Խ��߸�ֵΪblOmega(conf(i),P(i,:)
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

%��Լ������£����֤�����³��������x0��Χ���ݼ������Ż��߲���
% x0 = [1;1;1;1]/4;
% A = []; 
% b = [];
% Aeq = ones(1,N);
% beq = 1;
%lb = zeros(N,1);
%ub = ones(N,1);
%[weightsBL,fval,exitflag] = fmincon(@(x) findmin(x,Mu_BL,Sigma_BL,delta) ,x0,A,b,Aeq,beq,lb,ub);

%��Լ��Ȩ�ؽ�����ơ�-400��+300��+0.25����������������ʽ����֪����δ���
%weightsBL = Mu_BL' * inv(delta*CovRets_Hat);%��Լ�������Ȩ��

%�������Լ����ʽ���ƣ���֪����δ���
%�������ճ��������ο�Lee(2000)
%one = ones(N,1);
%weightsBL = inv(CovRets_Hat)*one/(one'*inv(CovRets_Hat)*one)+...
%    1/delta*inv(CovRets_Hat)*(Mu_BL-one'*inv(CovRets_Hat)*Mu_BL/(one'*inv(CovRets_Hat)*one)*one);

end