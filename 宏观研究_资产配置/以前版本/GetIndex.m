function [index_start,index] = GetIndex(Today,times,dayback)
% Today 格式2015/07/07
index = 0;                          %记录当前时间位置
for i = 1:length(times)
    if strcmp(times(i,:),Today)     %这里char矩阵，一行才是一个日期
        index = i;
        break;
    end
end
% 计算
if index > dayback
    index_start = index - (dayback-1);  
elseif index <= dayback && index > 0
    index_start = 1;
else
    index_start = -1;
end
if index_start == -1
    print('数据中没有您要找的日期');
    %return XXXX
end