nf = size(FactorDataWeek,1);
wtw = cell(size(FactorDataWeek));
wtw(:,1) = FactorDataWeek(:,1);
wtw{1,2} = 1;%ͬ�����е�һ����1
for i = 2:nf
    wtw{i,2} = FactorDataWeek{i,2}/FactorDataWeek{i-1,2};
end