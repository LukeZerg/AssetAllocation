function []= myplot_oneAsset(AssetAll,theWeights)
%��ֵ����ͼ

asset = cell2mat(AssetAll(2:end,5));
assetNet = asset/asset(1);
tradingdays = AssetAll(2:end,1);
T=datenum(tradingdays,'yyyy-mm-dd');
subplot(1,2,1), plot(T,assetNet,'b');
xlabel('��ֵ����ͼ')
datetick('x','yy-mm','keepticks');
grid on;

%�ʲ����ñ���ͼ
subplot(1,2,2), area(T,abs(cell2mat(theWeights(2:end,2:end))),...
    'DisplayName','T,cell2mat(theWeights(2:end,2:end))')
xlabel('�ʲ���������ͼ')
datetick('x','yy-mm','keepticks');
legend( '��ծ');
grid on;
end