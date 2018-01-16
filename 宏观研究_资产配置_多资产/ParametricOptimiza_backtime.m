
%最优化
aa = 10:10:225;%回溯天数
result = cell(length(aa)+1,2);
result{1,1} = '回溯天数';
result(2:end,1) = num2cell(aa)';
for ia = 1:length(aa)
           strategy.backtime = aa(ia);%短均线
           Position0 = GetPos(Close,Information);
           [Position_abs, theWeights_abs, Close_strategy ] = ...
                WeightRiskpParity(Position0, Data, Close, Information);
            Direction = DirectionAllocation(Data,Position0);
            Position = createPosition( Position_abs, Direction );
            Weight = createWeight(theWeights_abs, Direction );
            TradeRecord = computetraderecord(Position, Close_strategy);
            [AssetData,AssetAll] = computeAsset(Position,TradeRecord, Close_strategy,...
                Information);
            [ output ] = Performance( AssetAll );
            result{ia+1,2} = output{8,4};
            disp([ 'ia = ',num2str(ia),', a = ',num2str(aa(ia)),', sharp = ',num2str(output{8,4}) ]);
end
ParametricOptimizaResult = result;
save('D:/001Work/CTA波动率因子/ParametricOptimizaResult.mat','ParametricOptimizaResult');