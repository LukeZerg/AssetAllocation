function []= myplot(AssetAll,AssetData,theWeights)
%��ֵ����ͼ
%2017/3/13
ax = gca;  
outerpos = ax.OuterPosition;  
ti = ax.TightInset;  
left = outerpos(1) + ti(1);  
bottom = outerpos(2) + ti(2);  
ax_width = outerpos(3) - ti(1) - ti(3);  
ax_height = outerpos(4) - ti(2) - ti(4);  
ax.Position = [left bottom ax_width ax_height];  

asset = cell2mat(AssetAll(2:end,5));
assetNet = asset/asset(1);
tradingdays = AssetAll(2:end,1);
T=datenum(tradingdays,'yyyy-mm-dd');
subplot(2,2,1), plot(T,assetNet,'b');
xlabel('��ֵ����ͼ')
datetick('x','yy-mm','keepticks');
grid on;




%�ʲ����ñ���ͼ
subplot(2,2,2), area(T,abs(cell2mat(theWeights(2:end,2:end))),...
    'DisplayName','T,cell2mat(theWeights(2:end,2:end))')

xlabel('�ʲ���������ͼ')
datetick('x','yy-mm','keepticks');
legend('��Ʊ','��Ʒ�ڻ�', '��ծ', '�ֽ�');
grid on;

%�ۼ�����ͼ
m = size(AssetData,2);
n = size(AssetData{1,1},1)-1;
cumsums = zeros(n,m);
for i = 1:m
    cumsum_pnlh = cumsum(cell2mat(AssetData{1,i}(2:end,3)));
    cumsum_pnlt = cumsum(cell2mat(AssetData{1,i}(2:end,4)));
    cumsums(:,i) = cumsum_pnlh + cumsum_pnlt;
end
subplot(2,2,3),plot(T,cumsums(:,1),T,cumsums(:,2),T,cumsums(:,3),T,cumsums(:,4))
xlabel('�ۼ�����ͼ')
datetick('x','yy-mm','keepticks');
legend('��Ʊ','��Ʒ�ڻ�', '��ծ', '�ֽ�');
grid on;



end