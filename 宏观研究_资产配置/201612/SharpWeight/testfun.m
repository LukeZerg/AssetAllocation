%测试参数
backtime = 40:2:200;
Test = {{'test'},{'cumret'},{'annret'},{'sharpe'},{'最大回撤'}};
for iBacktime = 1:length(backtime)
    disp(iBacktime);
[pnldata, Assetall, Cumsums, weights ] = ...
    strategSharpWeightsAndComputeAsset(startday, endday, backtime(iBacktime), 30000*10000, Data, names);
[ output ] = Performance( Assetall );
Test{iBacktime+1,1} = backtime(iBacktime);
Test{iBacktime+1,2} = output{4,4};%累计收益率
Test{iBacktime+1,3} = output{6,4};%年化收益率
Test{iBacktime+1,4} = output{8,4};%夏普比率
Test{iBacktime+1,5} = output{5,4};%最大回撤
end

save Test
%参数 100 110 效果不错