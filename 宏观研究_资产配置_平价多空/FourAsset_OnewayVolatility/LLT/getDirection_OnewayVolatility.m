function direction = getDirection_OnewayVolatility(sub_cumret_len, sub_vol_diff_mean, THRESHOLD )
%���õ�����ʲ�ֵ��ʱ
%sub_cumret_len:  ����ÿ���ʲ���len�����ۼ�������
%sub_vol_diff_mean:  ������ڲ����ʾ�ֵ

direction = zeros(size(sub_cumret_len,2),1);
for i = 1:size(sub_cumret_len,2)
    disp(THRESHOLD(i));
    if sub_cumret_len(i) <= -THRESHOLD(i) %��ת�����򲨶��ʲ�Ϊ��ʱ����
        if sub_vol_diff_mean(i) < 0
            direction(i) = 1; 
        else
            direction(i) = 0; 
        end
    elseif sub_cumret_len(i) >= THRESHOLD(i) %���ƣ����򲨶��ʲ�Ϊ��ʱ����
        if sub_vol_diff_mean(i) > 0
            direction(i) = 1; 
        else
            direction(i) = 0; 
        end
    else
        direction(i) = 1; %��ʱ�򵥵ĳ���
    end
end

end