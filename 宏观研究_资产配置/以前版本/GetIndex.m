function [index_start,index] = GetIndex(Today,times,dayback)
% Today ��ʽ2015/07/07
index = 0;                          %��¼��ǰʱ��λ��
for i = 1:length(times)
    if strcmp(times(i,:),Today)     %����char����һ�в���һ������
        index = i;
        break;
    end
end
% ����
if index > dayback
    index_start = index - (dayback-1);  
elseif index <= dayback && index > 0
    index_start = 1;
else
    index_start = -1;
end
if index_start == -1
    print('������û����Ҫ�ҵ�����');
    %return XXXX
end