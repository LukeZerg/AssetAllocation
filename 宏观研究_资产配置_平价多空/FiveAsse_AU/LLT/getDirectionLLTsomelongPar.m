function direction = getDirectionLLTsomelongPar(subLLTcol, longcol ,iPosition)
%����LLTֵ����б�ʣ��ж϶�շ���
%subLLT: LLT�Ӽ�
%cashcol �ֽ��ʲ���Data�е���������Ҫ�ܿ�����
%iPosition ����
len = size(subLLTcol,1);
%����б��
ks = (subLLTcol(len,:) - subLLTcol(1,:))/(len-1);

%���ik��cashlong֮�У���ô��ʽsum(ismember(cashlong,iK))����0
%���ik��cashlong֮�У���ôikֻ���࣬����ʱ��ղ֣�
if sum(ismember(longcol,iPosition))
    if ks > 0
        direction = 1;
    else
        direction = 0;
    end
else
    %����б���ж϶�շ���
    if ks>0
        direction = 1;
    elseif ks<0
        direction = -1;
    else
        direction = 0;
    end
end


end