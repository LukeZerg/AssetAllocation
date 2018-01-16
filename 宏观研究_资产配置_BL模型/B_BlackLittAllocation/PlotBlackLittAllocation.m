figure

subplot('Position',[0.3 0.58 0.4 0.35])
Data=cumsum(BLComposition,2);
for n=1:NumAssets
    x=[BLVolatility(1); BLVolatility; BLVolatility(end)];
    y=[0; Data(:,NumAssets-n+1); 0];
    hold on
    h=fill(x,y,[.9 .9 .9]-mod(n,3)*[.2 .2 .2]);
end
set(gca,'xlim',[min(x) max(x)],'ylim',[0 max(max(Data))])
grid on
title('Black-Litterman "posterior" frontier')

subplot('Position',[0.05 0.07 0.4 0.35])
Data=cumsum(Composition,2);
for n=1:NumAssets
    x=[Volatility(1); Volatility; Volatility(end)];
    y=[0; Data(:,NumAssets-n+1); 0];
    hold on
    h=fill(x,y,[.9 .9 .9]-mod(n,3)*[.2 .2 .2]);
end
set(gca,'xlim',[min(x) max(x)],'ylim',[0 max(max(Data))])
grid on
title('no-views frontier')

subplot('Position',[0.55 0.07 0.4 0.35])
Data=cumsum(ModComposition,2);
for n=1:NumAssets
    x=[ModVolatility(1); ModVolatility; ModVolatility(end)];
    y=[0; Data(:,NumAssets-n+1); 0];
    hold on
    h=fill(x,y,[.9 .9 .9]-mod(n,3)*[.2 .2 .2]);
end
set(gca,'xlim',[min(x) max(x)],'ylim',[0 max(max(Data))])
grid on
title('"brute force" views frontier')





