function transvector = cyeildFreqSubscript(tradingdays1,ctday)
%�ڽ�����tradingdays1���ҵ�CYiled����ctday���±�
    nctday = size(ctday,1);
    %Ϊctdayÿһ��Ԫ���ҵ��±�
    transvector = [];
    for i = 1:nctday
       subscript = FindinCell(tradingdays1,1,ctday{i});
       transvector = [transvector;subscript];
    end
end