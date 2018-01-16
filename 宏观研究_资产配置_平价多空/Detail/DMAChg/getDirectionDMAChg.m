function direction = getDirectionDMAChg(subMAfast, subMAslow , cashcol)
%����MA����仯ֵ���ж϶�շ���
%subMAfast: MA���߾���MA���߾���
%cashcol �ֽ��ʲ���Data�е���������Ҫ�ܿ�����

%subMAChg��һ�����Ӧ���һ��ͬ���򣬱Ⱦ���ֵ�жϼ��仯����ͬ���򣬶϶������
subMAChg = subMAfast - subMAslow;
stdMAchg = std(subMAChg); %��׼��
m = size(subMAfast,2);
direction = zeros(m,1);
for iK = 1:m
    now = subMAChg(end,iK);
    before = subMAChg(1,iK);
    if iK~=cashcol
        if now>=0       %����ǰ���Ϊ��
            if before >= 0  %���֮ǰ���Ϊ��
                if abs(now) > abs(before) %����������
                    direction(iK) = 1;
                elseif abs(now) < abs(before) %�������С
                    direction(iK) = -1; 
                else
                    direction(iK) = 0; 
                end
            elseif before < 0 %�����෴,�϶�Ϊ���Ϊ��������
                direction(iK) = 1;
            end
        elseif now<0   %����ǰ���Ϊ����
            if before <= 0  %���֮ǰ���Ϊ��
                if abs(now) > abs(before) %����������
                    direction(iK) = -1;
                elseif abs(now) < abs(before) %�������С
                    direction(iK) = 1; 
                else
                    direction(iK) = 0; 
                end
            elseif before > 0 %�����෴,,�϶�Ϊ���Ϊ��������
                direction(iK) = -1;
            end
        end %now�ļ������
    else
        direction(iK) = 1;%cashcol�����⴦�������ֽ�
    end %�Ƿ�cashcol��
end %ѭ��ÿ���ʲ�
end