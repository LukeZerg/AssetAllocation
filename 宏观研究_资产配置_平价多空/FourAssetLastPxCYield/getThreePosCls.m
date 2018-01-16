function [Position1,CloseData1, Information1] = getThreePosCls(Position, CloseData, theDirection, theWeights, Information )
%�����ʲ��ľ����λ�������ڻ� 
    global s
    capital = s.capital;
    
    m = size(Position,2); %�ʲ�����
    nt = size(Position{1,1},1);%ʱ����
    Multiplier = cell2mat(Information(2:end,2));
    variety = Information(2:end,1);
    
    for i = 1:m
        if i ~= 2 %�������ڻ���
            for j = 2:nt
                if Position{1,i}{j,6} %����ǵ�����
                     onecap = capital*abs(theWeights{j,i+1});
                     cls = CloseData{1,i}{j,3};
                     mul = Multiplier(i);
                     Position{1,i}{j,3} = round(double(onecap)/double(cls*mul));
                     Position{1,i}{j,4} = theDirection{j,i+1};
                 end
            end
        end
    end
    
    %���Pos_COM��curren 3�к�direction 4��
     for k = 1:m %ѭ�����Ʒ��
         if k ~= 2
             [nP,~] = size(Position{1,k});%��Ʒ�����ݴ�С
             currenbox = 0;%��¼��
             directionbox=0;
             for i = 2:nP
                 if Position{1,k}{i,6} == 1 %�����һ��ֱֲ仯��isChg
                     %��¼��curren��direction
                     currenbox = Position{1,k}{i,3};
                     directionbox = Position{1,k}{i,4};
                 end
                 Position{1,k}{i,3} = currenbox;
                 Position{1,k}{i,4} = directionbox;
             end
         end
     end
    
    
    Position1 = cell(1,3);
    Position1{1,1} = Position{1,1};
    Position1{1,2} = Position{1,3};
    Position1{1,3} = Position{1,4};
    
    Position1{2,1} = variety{1};
    Position1{2,2} = variety{3};
    Position1{2,3} = variety{4};
    
    CloseData1 = cell(1,3);
    CloseData1{1,1} = CloseData{1,1};
    CloseData1{1,2} = CloseData{1,3};
    CloseData1{1,3} = CloseData{1,4};
    
    CloseData1{2,1} = variety{1};
    CloseData1{2,2} = variety{3};
    CloseData1{2,3} = variety{4};
    
    Information1 = cell(3+1,size(Information,2));
    Information1(1,:) = Information(1,:);
    Information1(1+1,:) = Information(1+1,:);
    Information1(2+1,:) = Information(3+1,:);
    Information1(3+1,:) = Information(4+1,:);
end