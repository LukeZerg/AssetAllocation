% this script implements a simple technique to assess the impact of 
% inputting views with the Black-Litterman approach, in such a way that the
% most extreme views can be modified
% see "Risk and Asset Allocation"- Springer (2005), by A. Meucci
clear; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Index = [2; 4; 6];
Views = [0; -200; 200]/10000;
Delta=20/10000;
load('CovNRets');                 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NumAssets=size(Covariance,2);
NumViews=length(Index);
ViewsSelector=zeros(NumViews,NumAssets);
for i=1:NumViews
  ViewsSelector(i,Index(i))=1;
end
ViewsUncertainty=ViewsSelector*Covariance*ViewsSelector';

StoreViews=[]; StoreProb=[]; StoreMahalanobis=[];
for s=1:10
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % modify expected returns the Black-Litterman way and compute new efficient frontier 
  BLExpectedValues = ExpectedValues + Covariance*ViewsSelector'*...
    inv(ViewsSelector*Covariance*ViewsSelector'+ViewsUncertainty)*(Views-ViewsSelector*ExpectedValues);
  BLCovariance =  Covariance -  Covariance*ViewsSelector'*...
    inv(ViewsSelector*Covariance*ViewsSelector'+ViewsUncertainty)*ViewsSelector*Covariance;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % test and modify views
  Mahalanobis=(BLExpectedValues-ExpectedValues)'*inv(Covariance)*(BLExpectedValues-ExpectedValues);
  Prob=1 - chi2cdf(Mahalanobis,NumAssets);
  
  StoreViews=[StoreViews Views];
  StoreProb=[StoreProb Prob];
  StoreMahalanobis=[StoreMahalanobis Mahalanobis];
  
  f = chi2pdf(Mahalanobis,NumAssets);
  Sensitivities=-2*f*inv(ViewsSelector*Covariance*ViewsSelector'+ViewsUncertainty)*ViewsSelector*(BLExpectedValues-ExpectedValues);
  [c,i]=max(abs(Sensitivities));
  Views(i)=Views(i)+sign(Sensitivities(i))*Delta;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plots

figure

subplot(2,1,1)

[Ax,h_left,h_right] = plotyy([1:10],StoreProb,[1:10],StoreMahalanobis,'plot');
set(Ax(1),'xlim',[.5 10.5],'xtick',[])
set(Ax(2),'xlim',[.5 10.5],'xtick',[])
set(h_left,'color','k','linestyle','-','linewidth',2)
set(h_right,'color','k','linestyle','--','linewidth',2)
grid on
title('Mahalanobis distance / views probability')

subplot(2,1,2)
h=bar(100*StoreViews(2,:)')
set(h,'facecolor',[.8 .8 .8]) % Canada
hold on
h=bar(100*StoreViews(3,:)') % Germany
set(h,'facecolor',[.6 .6 .6])
set(gca,'xlim',[.5 10.5],'ylim',[-2.1 2.1],'xtick',[])
grid on
title('allocation')
