function TradeRecord = computetraderecord(position,CloseData)
%�Ӳ�λ�ͼ۸��������ȡ���׼�¼
    n = size(position,2);
    TradeRecord = cell(1,n);%���׼�¼
    for k = 1:n %�ֶ��Ʒ�ּ���
        disp(k);
        TradeRecord{1,k} = {'TradingDays','Contract','TradePrice',...
            'curren','direction','variety','curren_after'};
        pos = position{1,k};
        oneClosetata = CloseData{1,k};%��Ʒ�ּ۸�����
        onevariety = pos{2,5};%��¼Ʒ��
        [rows,~] = size(pos);
        for i = 3:rows %�����ݵڶ��п�ʼ
            num = 0;%��һ�콻�״�����ʼ��,һ�л���������ʵ�����Ϊ׼
            
            %if pos{i,7} == 1;%����ֲָı���
                onetrade = cell(2,size(TradeRecord{1,k},2));%��ʱ�洢
                onetrade(:,1) = {pos{i,1}}; %���� 
                onetrade(:,6) = {onevariety}; %���� 
                close = oneClosetata{i,3};
                preclose = oneClosetata{i,5};%ǰһ����Լ���ռ۸�
                
                if strcmp(pos{i,2},pos{i-1,2}) %��������Լ��ͬ
                    onetrade(:,2) = {pos{i,2}}; %��Լ
                    onetrade(:,3) = {close};
                    if pos{i,4}*pos{i-1,4} == -1    %�������ַ����෴
                        num = 2;%�����ʽ���
                        %ƽ��
                        onetrade{1,4} = pos{i-1,3};%���ղ�λ
                        onetrade{1,5} = -1*pos{i-1,4};%ƽ�ֽ��׷����෴
                        onetrade{1,7} = 0;%���׺��λ
                        %�����
                        onetrade{2,4} = pos{i,3};   %���ղ�λ
                        onetrade{2,5} = pos{i,4};   %���շ���
                        onetrade{2,7} = pos{i,3}*pos{i,4};
                    elseif pos{i,4}*pos{i-1,4} == 1  ...
                            &&  pos{i,3}~=pos{i-1,3}  
                        %�������ַ�����ͬ�Ҳ�λ�����
                        num = 1;%��һ�ʽ���
                        chg =  pos{i,3} - pos{i-1,3} ;  %�����Ƚ�
                        onetrade{1,4} = abs(chg);       %��������
                        onetrade{1,7} = pos{i,3}*pos{i,4};
                        if pos{i,4} > 0     %���
                            if chg > 0 , onetrade{1,5} = 1;
                            elseif chg < 0, onetrade{1,5} = -1; end
                        else                 %�ղ�
                            if chg > 0,onetrade{1,5} = -1;
                            elseif chg < 0, onetrade{1,5} = 1; end
                        end
                        %������ͬ��������ͬ�����ý���
                    elseif pos{i,4}*pos{i-1,4} == 0 && pos{i,4}+pos{i-1,4}~=0
                        num = 1;
                        if pos{i-1,4} ~= 0 %������
                            onetrade{1,4} = pos{i-1,3};
                            onetrade{1,5} = -1 * pos{i-1,4};
                            onetrade{1,7} = 0;
                        elseif pos{i,4}~= 0 %���޲�λ�����
                            onetrade{1,4} = pos{i,3};
                            onetrade{1,5} = pos{i,4};
                            onetrade{1,7} = pos{i,3} * pos{i,4};
                        %��λ��Ϊ0ʱ���ý���
                        else
                            cerr('��ͬ��Լ��ֻ��һ����λΪ0��������д���');
                        end
                    end
                    
                else %�����Լ��ͬ
                    if pos{i,4}*pos{i-1,4} ~= 0
                        num = 2;%�����ʽ���
                        onetrade(1,2) = pos(i-1,2); %��Լ
                        onetrade(2,2) = pos(i,2); %��Լ
                        %ƽ���
                        onetrade{1,3} = preclose;
                        onetrade{1,4} = pos{i-1,3};%���ղ�λ
                        onetrade{1,5} = -1*pos{i-1,4};%ƽ�ֽ��׷����෴
                        onetrade{1,7} = 0;
                        %�����
                        onetrade{2,3} = close;
                        onetrade{2,4} = pos{i,3};%���ղ�λ
                        onetrade{2,5} = pos{i,4};%���շ���
                        onetrade{2,7} = pos{i,3}*pos{i,4};%���׺��λ
                    elseif pos{i,4} ~= 0 && pos{i-1,4} == 0
                        %�����
                        num = 1;
                        onetrade(1,2) = pos(i,2); %��Լ
                        onetrade{1,3} = close;
                        onetrade{1,4} = pos{i,3};%���ղ�λ
                        onetrade{1,5} = pos{i,4};%���շ���
                        onetrade{1,7} = pos{i,3}*pos{i,4};%���շ���
                    elseif pos{i,4} == 0 && pos{i-1,4} ~= 0
                        %ƽ���
                        num = 1;
                        onetrade(1,2) = pos(i-1,2); %��Լ
                        onetrade{1,3} = preclose;
                        onetrade{1,4} = pos{i-1,3};%���ղ�λ
                        onetrade{1,5} = -1*pos{i-1,4};%ƽ�ֽ��׷����෴
                        onetrade{1,7} = 0;
                    end
                    %��λ��Ϊ0���ý���
                end
                if num == 1
                    temp = onetrade(1,:);
                elseif num == 2
                    temp = onetrade(1:2,:);
                end
                %�����׼�¼��ӵ�ĩβ
                if num > 0,TradeRecord{1,k} = [TradeRecord{1,k};temp];end
           % end    %����Ǹı�ֲ���
        end
    end
end