function direction = getDirectionLLT(subLLT, cashcol , backtimeD)
%����LLTֵ����б�ʣ��ж϶�շ���
%subLLT: LLT�Ӽ�
%cashcol �ֽ��ʲ���Data�е���������Ҫ�ܿ�����
%backtimeD ����ʱ���
len = size(subLLT,1);
if backtimeD > len
    wrong('���ݼ���ʱ�䳬�����ݳ���');
end
%����б��
ks = (subLLT(len,:) - subLLT(len-backtimeD,:))/backtimeD;
direction = zeros(size(subLLT,2),1);
for iK = 1:size(subLLT,2)
    if iK~=cashcol
        %����б���ж϶�շ���
        if ks(iK)>0
            direction(iK)=1;
        elseif ks(iK)<0
            direction(iK)=-1;
        else
            direction(iK) = 0;
        end
    else
        direction(iK) = 1;
    end
end

end