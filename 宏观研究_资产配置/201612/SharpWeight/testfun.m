%���Բ���
backtime = 40:2:200;
Test = {{'test'},{'cumret'},{'annret'},{'sharpe'},{'���س�'}};
for iBacktime = 1:length(backtime)
    disp(iBacktime);
[pnldata, Assetall, Cumsums, weights ] = ...
    strategSharpWeightsAndComputeAsset(startday, endday, backtime(iBacktime), 30000*10000, Data, names);
[ output ] = Performance( Assetall );
Test{iBacktime+1,1} = backtime(iBacktime);
Test{iBacktime+1,2} = output{4,4};%�ۼ�������
Test{iBacktime+1,3} = output{6,4};%�껯������
Test{iBacktime+1,4} = output{8,4};%���ձ���
Test{iBacktime+1,5} = output{5,4};%���س�
end

save Test
%���� 100 110 Ч������