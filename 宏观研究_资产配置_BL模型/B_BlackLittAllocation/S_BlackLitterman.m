% this script compares 
% - the true efficient frontier 
% - the pseudo-efficient frontier stemming from the BL general equilibrium prior
% - the pseudo-efficient frontier stemming from the BL posterior (general equilibrium + views)
% see "Risk and Asset Allocation"- Springer (2005), by A. Meucci

clear; clc; close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=10;
MaxVolRets=.4;
MinVolRets=.05;
CorrRets=.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% knowledge of the market
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CorrRets=(1-CorrRets)*eye(N)+CorrRets*ones(N,N);
StepVolRets=(MaxVolRets-MinVolRets)/(N-1);
VolRets=[MinVolRets : StepVolRets : MaxVolRets]';
CovRets=diag(VolRets)*CorrRets*diag(VolRets);
ExpValRets=2.5*CovRets*ones(N,1)/N;

NumPortf=15;
[E,V,Portfolios]=EfficientFrontier(NumPortf, CovRets, ExpValRets);
Portfolios_True=round(100*Portfolios')
PlotFrontier(Portfolios)
title('true frontier','fontweight','bold')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimation of the market
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R=mvnrnd(ExpValRets,CovRets,52*1);
ExpValRets_Hat=mean(R)';
CovRets_Hat=cov(R);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prior on the market
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CovRets_Prior=CovRets_Hat;
ExpValRets_Prior=2.5*CovRets_Hat*ones(N,1)/N;

[E,V,Portfolios]=EfficientFrontier(NumPortf, CovRets_Prior, ExpValRets_Prior);
Portfolios_Prior=round(100*Portfolios')
PlotFrontier(Portfolios)
title('prior frontier','fontweight','bold')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% views on the market
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P=zeros(2,N);
P(1,1)=1;
P(2,3)=1;
Omega=(3)^2*P*CovRets_Hat*P';
v=[.04 -.02]';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute posterior BL
Mu_BL=ExpValRets_Prior+CovRets_Hat*P'*inv(P*CovRets_Hat*P'+Omega)*(v-P*ExpValRets_Prior);
Sigma_BL=CovRets_Hat-CovRets_Hat*P'*inv(P*CovRets_Hat*P'+Omega)*P*CovRets_Hat;

% compute MV efficient frontier
[E,V,Portfolios]=EfficientFrontier(NumPortf, Sigma_BL, Mu_BL);
Portfolios_BL=round(100*Portfolios')
PlotFrontier(Portfolios)
title('BL MV frontier','fontweight','bold')