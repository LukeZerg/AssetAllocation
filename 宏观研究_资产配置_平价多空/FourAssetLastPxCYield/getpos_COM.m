function Pos_COM = getpos_COM(Position_COM, CloseData_COM, Weights_COM, Direction_COM, cdata ,comInfo ,nls)
%������Ʒ�Ĳ�λ
%����comInfo����Ʒ��Ϣ
global s    
name_com = comInfo(2:end,1);
Multiplier_com = cell2mat(comInfo(2:end,3));   %����
variety_com = comInfo(2:end,2); %��ȡƷ�ִ���
% Kind_com = comInfo(2:end,6);%����

%�õ����ں����ֻ�����
tradingdays = Weights_COM(2:end,1);
nt = size(tradingdays,1);
num_tradingdays = zeros(nt,1);
for i = 1:nt
    num_tradingdays(i) = datenum(tradingdays(i));
end
%��Ʒ�ֲ�Pos_COM��ʼ��
Pos_COM = cell(1,size(CloseData_COM,2));
for i = 1:size(CloseData_COM,2)
    Pos_COM{1,i} = {'TradingDay','Contract','Curren','Direciton',...
        'Variety','isChg'};
    Pos_COM{2,i} = variety_com(i);
    Pos_COM{1,i}(2:(nt+1),1) = tradingdays; %����
    Pos_COM{1,i}(2:(nt+1),2) = CloseData_COM{1,i}(2:(nt+1),2); %��Լ
    Pos_COM{1,i}(2:(nt+1),3) = {0}; %curren
    Pos_COM{1,i}(2:(nt+1),4) = {0}; %direction
    Pos_COM{1,i}(2:(nt+1),5) = CloseData_COM{1,i}(2:(nt+1),6); %�ʲ�����
    Pos_COM{1,i}(2:(nt+1),6) = Position_COM(2:(nt+1),6); %ischg
end

%��ÿһ���������ڼ����λ
ncdata = size(cdata,1);
for i = 1:ncdata
    %��cֵ��ÿһ����
    row_cdata = cdata(i,:);
    %��tradingdays���ҵ���һ�������������ڵ�Ԫ��
    theday = datestr(row_cdata(1),29);
    num_theday = datenum(theday);
    temp =  (num_tradingdays == num_theday);
    temp2 = find(temp>0);
    %����Ҳ���������ڣ�������������ҵ��ˣ��Ϳ�ʼȷ��Ʒ�֣������λ
    if isempty(temp2)
        continue;
    else
        sub = temp2(1);%�±�
       %������䵽ÿ����Ʒ�ϵ��ʽ�
        onecomcap = Weights_COM{sub+1,2} * s.capital / nls;
        %�ҵ���������Ʒ�ֵ��±�
        longname = row_cdata(2:(2+nls-1));
        longsub = FindinCell_vector(name_com,1,longname);
        shortname = row_cdata((end-nls+1):end);
        shortsub = FindinCell_vector(name_com,1,shortname);
        %����
        d = Direction_COM{sub+1,2};
        if d > 0
            lssub = longsub;
        elseif d < 0
            lssub = shortsub;
        end
        if d ~= 0
            %�ҵ�����Ʒ���±�
            for j = 1:nls
                isub = lssub(j);
                cls = CloseData_COM{1,isub}{sub+1,3};
                mul = Multiplier_com(isub);
                %�ֲ� = �ʽ� / �����̼� * ������
                Pos_COM{1,isub}{sub+1,3} = round( onecomcap / ( cls * mul) );
                %direcition
                Pos_COM{1,isub}{sub+1,4} = d;
            end
        end
        %���dΪ0���������������λ
    end %����ҵ����ڣ��Ϳ�ʼȷ��Ʒ�֣������λ
end %ѭ��cdata

%���Pos_COM��curren 3�к�direction 4��
 for k = 1:size(CloseData_COM,2) %ѭ�����Ʒ��
     [nP,~] = size(Pos_COM{1,k});%��Ʒ�����ݴ�С
     currenbox = 0;%��¼��
     directionbox=0;
     for i = 2:nP
         if Pos_COM{1,k}{i,6} == 1 %�����һ��ֱֲ仯��isChg
             %��¼��curren��direction
             currenbox = Pos_COM{1,k}{i,3};
             directionbox = Pos_COM{1,k}{i,4};
         end
         Pos_COM{1,k}{i,3} = currenbox;
         Pos_COM{1,k}{i,4} = directionbox;
     end
 end
 
 
 
end