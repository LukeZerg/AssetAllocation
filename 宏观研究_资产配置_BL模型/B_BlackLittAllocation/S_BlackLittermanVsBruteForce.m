% this script compares the Black-Litterman approach to inputing views on the market
% with a brute force approach, which gives rise to corner solutions
% see "Risk and Asset Allocation"- Springer (2005), by A. Meucci

clear; clc; close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pick = [2; 4; 6];              % views pick matrix
Views = [0; -200; 200]/10000;   % views value
Gamma=100;                      % views uncertainty
NumPortf=20;                   % number of MV-efficient portfolios 
load('CovNRets');               % input Covariance and Mu of asset returns from database...

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NumAssets=size(Sigma,2);
NumViews=length(Pick);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute efficient frontier
[M,S]=Log2Lin(Mu,Sigma);
[ExpectedReturn,Volatility, Composition]=EfficientFrontier(NumPortf, S, M);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% modify expected returns the direct way and compute new efficient frontier 
ModMu=Mu;
ModMu(Pick)=Views;
ModSigma=Sigma;
ModSigma(Pick,Pick)=0*Sigma(Pick,Pick);
[M,S]=Log2Lin(ModMu,ModSigma);
[E,V, ModComposition]=EfficientFrontier(NumPortf, S, M);
ModVolatility=[];
for n=1:NumPortf
    ModVolatility=[ModVolatility
                sqrt(ModComposition(n,:)*Sigma*ModComposition(n,:)')];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% modify expected returns the Black-Litterman way and compute new efficient frontier 
ViewsSelector=zeros(NumViews,NumAssets);
for i=1:NumViews
    ViewsSelector(i,Pick(i))=1;
end
ViewsUncertainty=Gamma*ViewsSelector*Sigma*ViewsSelector';

BLMu = Mu + Sigma*ViewsSelector'*...
                    inv(ViewsSelector*Sigma*ViewsSelector'+ViewsUncertainty)*(Views-ViewsSelector*Mu);
BLSigma =  Sigma -  Sigma*ViewsSelector'*...
                    inv(ViewsSelector*Sigma*ViewsSelector'+ViewsUncertainty)*ViewsSelector*Sigma;
[M,S]=Log2Lin(BLMu,BLSigma);                
[E,V, BLComposition]=EfficientFrontier(NumPortf, S, M);
BLVolatility=[];
for n=1:NumPortf
    BLVolatility=[BLVolatility
                sqrt(BLComposition(n,:)*Sigma*BLComposition(n,:)')];
end

PlotBlackLittAllocation