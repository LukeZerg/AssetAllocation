function direction = getDirectionLLTsomelong(subLLT, cashlong )
%����LLTֵ����б�ʣ��ж϶�շ���
%subLLT: LLT�Ӽ�
%cashcol �ֽ��ʲ���Data�е���������Ҫ�ܿ�����
%backtimeD ����ʱ���
len = size(subLLT,1);
%����б��
ks = (subLLT(len,:) - subLLT(1,:))/(len-1);
direction = zeros(size(subLLT,2),1);
for iK = 1:size(subLLT,2)
    %���ik��cashlong֮�У���ô��ʽsum(ismember(cashlong,iK))����0
    %���ik��cashlong֮�У���ôikֻ���࣬����ʱ��ղ֣�
    if sum(ismember(cashlong,iK))
        if ks(iK) > 0
            direction(iK) = 1;
        else
            direction(iK) = 0;
        end
    else
        %����б���ж϶�շ���
        if ks(iK)>0
            direction(iK) = 1;
        elseif ks(iK)<0
            direction(iK) = -1;
        else
            direction(iK) = 0;
        end
    end
end

end