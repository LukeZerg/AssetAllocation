function direction = getDirectionTSMON(onedayexRet,cashcol)
%����ʱ��������ʱ�ж�
%onedayexRetΪĳһ�������յ��ڹ�ȥһ��ʱ��ĳ���������
%cashcolΪ��������㣬ʼ�������Ʒ������
%direction�����صĸ��ʲ�����ʱ����
nExRet = length(onedayexRet);
direction = zeros(nExRet,1);
for iExRet = 1:nExRet
    if iExRet ~= cashcol
        if onedayexRet(iExRet) > 0
            direction(iExRet) = 1;
        elseif onedayexRet(iExRet) < 0
            direction(iExRet) = -1;
        else
            direction(iExRet) = 0;
        end
    else
        onedayexRet(iExRet) = 1; %�����cashcol�У�ʼ������
    end
end
end