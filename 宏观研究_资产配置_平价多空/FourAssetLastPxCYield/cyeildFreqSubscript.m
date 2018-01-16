function transvector = cyeildFreqSubscript(tradingdays1,ctday)
%在交易日tradingdays1中找到CYiled日期ctday的下标
    nctday = size(ctday,1);
    %为ctday每一个元素找到下标
    transvector = [];
    for i = 1:nctday
       subscript = FindinCell(tradingdays1,1,ctday{i});
       transvector = [transvector;subscript];
    end
end