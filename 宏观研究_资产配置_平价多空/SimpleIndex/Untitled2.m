function []= myplot(AssetAll,AssetData,theWeights)
%画出曲线图
asset = cell2mat(AssetAll(2:end,5));
assetNet = asset/asset(1);
tradingdays = AssetAll(2:end,1);
T=datenum(tradingdays,'yyyy-mm-dd');
subplot(2,1,1), plot(T,assetNet,'b');
xlabel('净值曲线图')
datetick('x','yy-mm','keepticks');
% scrsz=get(0,'screensize');              %获取画布的属性，【left bottom width length】，结果为1 1 1280 1024
% figure('position',[1 scrsz(4)/2 scrsz(3) scrsz(4)/2]);



end