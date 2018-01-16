function [Weights_COM, Direction_COM] = getWD_COM(theWeights,theDirection,comcol)
%从theWWeights和theDirection中提取只有商品的部分
theWeights1 = theWeights;
theWeights1(:,2:(comcol+1-1))=[]; %第一列到商品列之前那一列赋值为空
theWeights1(:,3:end)=[];

theDirection1 = theDirection;
theDirection1(:,2:(comcol+1-1))=[]; %第一列到商品列之前那一列赋值为空
theDirection1(:,3:end)=[];

Weights_COM = theWeights1;
Direction_COM = theDirection1;
end