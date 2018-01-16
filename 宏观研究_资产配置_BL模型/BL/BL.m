function weightsBL = BL(sub)
%BLģ��
%���룺ub��N��M�е����ݣ�N�����ڣ�M���ʲ�������
%�����M���ʲ���Ȩ��
N = size(sub,2);%sub����
delta = 3.07; %�������ϵ��
tau=0.025;
%w = [1;1;1;1];
w = [2;1;3;4];
w0 = w/sum(w);%�г�Ȩ��

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
ExpValRets_Prior=delta*CovRets_Hat*w0;  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % views on the market
% P = [1, 0, -1, 0; 0, 0, -1, 1;1, -1, 0, 0];
% %Omega=P*CovRets_Hat*P';   %simple Omega
% v=[.09 .07, 0.5]';
% conf = [0.9; 0.7; 0.5]; %����ָ��
% Omega = [blOmega(conf(1),P(1,:),CovRets_Prior),0,0;...
%         0, blOmega(conf(2),P(2,:),CovRets_Prior),0;...
%         0,0, blOmega(conf(3),P(3,:),CovRets_Prior)];

% views on the market
P = [1, 0, -1, 0; 0, 0, -1, 1;];
%Omega=P*CovRets_Hat*P';   %simple Omega
v=[.09 .07]';
%conf = [0.9; 0.7]; %����ָ��
conf = [0.2; 0.7]; %����ָ��
Omega = [blOmega(conf(1),P(1,:),CovRets_Prior),0;...
        0, blOmega(conf(2),P(2,:),CovRets_Prior)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute posterior BL
Mu_BL=ExpValRets_Prior+tau*CovRets_Hat*P'*inv(P*tau*CovRets_Hat*P'+Omega)*(v-P*ExpValRets_Prior);
%Sigma_BL=tau*CovRets_Hat-tau*CovRets_Hat*P'*inv(P*CovRets_Hat*P'+Omega)*P*tau*CovRets_Hat;
Sigma_BL=CovRets_Hat+inv(inv(tau*CovRets_Hat)+P'*inv(Omega)*P);

% compute MV efficient frontier
[ExpectedReturn,Volatility, Composition] = EfficientFrontier(NumPortf, Sigma_BL, Mu_BL);
selected = floor(NumPortf/2);
weightsBL = Composition(selected,:);

%��Լ�������
% x0 = [1;1;1;1]/4;
% A = []; 
% b = [];
% Aeq = ones(1,N);
% beq = 1;
%lb = zeros(N,1);
%ub = ones(N,1);
%[weightsBL,fval,exitflag] = fmincon(@(x) findmin(x,Mu_BL,Sigma_BL,delta) ,x0,A,b,Aeq,beq,lb,ub);

%w = Mu_BL' * inv(delta*CovRets_Hat);%��Լ�������Ȩ��

end