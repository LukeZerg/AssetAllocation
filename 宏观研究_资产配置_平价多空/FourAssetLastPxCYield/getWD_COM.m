function [Weights_COM, Direction_COM] = getWD_COM(theWeights,theDirection,comcol)
%��theWWeights��theDirection����ȡֻ����Ʒ�Ĳ���
theWeights1 = theWeights;
theWeights1(:,2:(comcol+1-1))=[]; %��һ�е���Ʒ��֮ǰ��һ�и�ֵΪ��
theWeights1(:,3:end)=[];

theDirection1 = theDirection;
theDirection1(:,2:(comcol+1-1))=[]; %��һ�е���Ʒ��֮ǰ��һ�и�ֵΪ��
theDirection1(:,3:end)=[];

Weights_COM = theWeights1;
Direction_COM = theDirection1;
end