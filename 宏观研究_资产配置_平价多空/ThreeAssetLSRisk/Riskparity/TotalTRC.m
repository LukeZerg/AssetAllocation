function y = TotalTRC(Cov , x)
%input:xΪ�����ʲ���ʼ��Ȩ��
%      CovΪЭ�������
%output:Ϊ�����ĸ����ʲ�Ȩ��
%�ú���ΪTotalTRC�ļ��㹫ʽ
TRC = Cov * x .* x ; %������չ���
y = std(TRC);
% len = length(TRC);
% dataTRC = zeros(len,len); 
% for i = 1:len
%     for j = 1:len
%             dataTRC(i,j) = ( TRC(i)-TRC(j) )^2 ; %������չ���֮���ƽ����
%     end
% end %for
% y = sum(sum(dataTRC));
end
