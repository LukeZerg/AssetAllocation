function []= myplot(AssetAll,AssetData,theWeights)
%��������ͼ
asset = cell2mat(AssetAll(2:end,5));
assetNet = asset/asset(1);
tradingdays = AssetAll(2:end,1);
T=datenum(tradingdays,'yyyy-mm-dd');
subplot(2,1,1), plot(T,assetNet,'b');
xlabel('��ֵ����ͼ')
datetick('x','yy-mm','keepticks');
% scrsz=get(0,'screensize');              %��ȡ���������ԣ���left bottom width length�������Ϊ1 1 1280 1024
% figure('position',[1 scrsz(4)/2 scrsz(3) scrsz(4)/2]);



end