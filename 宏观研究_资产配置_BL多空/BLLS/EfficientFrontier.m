function [ExpectedReturn,Volatility, Composition] = EfficientFrontier(NumPortf, EstimatedCovariance, ExpectedValues)
% This function returns the NumPortf x 1 vector expected returns, 
%                       the NumPortf x 1 vector of volatilities and 
%                       the NumPortf x NumAssets matrix of compositions 
% of NumPortf efficient portfolios whos returns are equally spaced along the whole range of the efficient frontier

warning off;
NumAssets=size(EstimatedCovariance,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% determine return of minimum-risk portfolio
FirstDegree=zeros(NumAssets,1);
SecondDegree=EstimatedCovariance;
Aeq=ones(1,NumAssets);
beq=1;
A=-eye(NumAssets);
b=zeros(NumAssets,1);
x0=1/NumAssets*ones(NumAssets,1);
MinVol_Weights = quadprog(SecondDegree,FirstDegree,A,b,Aeq,beq,[],[],x0);
MinVol_Return=MinVol_Weights'*ExpectedValues;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% determine return of maximum-return portfolio
MaxRet_Return=max(ExpectedValues);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% slice efficient frontier in NumPortf equally thick horizontal sectors in the upper branch only
TargetReturns=MinVol_Return + [0:NumPortf-1]'*(MaxRet_Return-MinVol_Return)/(NumPortf-1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute the NumPortf compositions and risk-return coordinates
Composition=[];
Volatility=[];
ExpectedReturn=[];

[MinRet, IndexMin]=min(ExpectedValues);
[MaxRet, IndexMax]=max(ExpectedValues);

for i=1:NumPortf
    % determine initial condition
    WMaxRet=(TargetReturns(i)-MinRet)/(MaxRet-MinRet);
    WMinRet=1-WMaxRet;
    x0=zeros(NumAssets,1);
    x0(IndexMax)=WMaxRet;
    x0(IndexMin)=WMinRet;
    
    % determine least risky portfolio for given expected return
    AEq=[Aeq
        ExpectedValues'];
    bEq=[beq
        TargetReturns(i)];
    Weights = quadprog(SecondDegree,FirstDegree,A,b,AEq,bEq,[],[],x0)';
    Composition=[Composition 
                    Weights];
    Volatility=[Volatility
                sqrt(Weights*EstimatedCovariance*Weights')];
    ExpectedReturn=[ExpectedReturn
                    TargetReturns(i)];
end
