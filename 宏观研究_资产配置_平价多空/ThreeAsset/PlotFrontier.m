function PlotFrontier(Portfolios)

figure
[xx,N]=size(Portfolios);
Data=cumsum(Portfolios,2);
for n=1:N
    x=[1; [1 : xx]'; xx];
    y=[0; Data(:,N-n+1); 0];
    hold on
    h=fill(x,y,[.9 .9 .9]-mod(n,3)*[.2 .2 .2]);
end
set(gca,'xlim',[1 xx],'ylim',[0 max(max(Data))])
xlabel('portfolio # (risk propensity)')
ylabel('portfolio composition')