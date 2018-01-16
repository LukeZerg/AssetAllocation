function weights = markowitz( sub, marketRet)
%卡科维茨模型计算权重                      
%输入：ub是N行M列的数据，N个日期，M个资产的收益
%输出：M个资产的权重
ExpReturn = mean(sub); %每列的均值
ExpCovariance = cov(sub); %每列的
NumPorts = 20; %20种
[PortRisk, PortReturn, PortWts] = frontcon(ExpReturn,ExpCovariance, NumPorts);
weights = PortWts(10,:); %选择有效边界中间的权重
end