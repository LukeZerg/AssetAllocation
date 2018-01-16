function []= myplot_oneAsset(AssetAll,theWeights)
%净值曲线图

asset = cell2mat(AssetAll(2:end,5));
assetNet = asset/asset(1);
tradingdays = AssetAll(2:end,1);
T=datenum(tradingdays,'yyyy-mm-dd');
subplot(1,2,1), plot(T,assetNet,'b');
xlabel('净值曲线图')
datetick('x','yy-mm','keepticks');
grid on;

%资产配置比例图
subplot(1,2,2), area(T,abs(cell2mat(theWeights(2:end,2:end))),...
    'DisplayName','T,cell2mat(theWeights(2:end,2:end))')
xlabel('资产比例配置图')
datetick('x','yy-mm','keepticks');
legend( '国债');
grid on;
end