function [Position1,CloseData1, Information1] = getThreePosCls(Position, CloseData, theDirection, theWeights, Information )
%三种资产的具体仓位，跳过期货 
    global s
    capital = s.capital;
    
    m = size(Position,2); %资产个数
    nt = size(Position{1,1},1);%时间数
    Multiplier = cell2mat(Information(2:end,2));
    variety = Information(2:end,1);
    
    for i = 1:m
        if i ~= 2 %不计算期货列
            for j = 2:nt
                if Position{1,i}{j,6} %如果是调仓日
                     onecap = capital*abs(theWeights{j,i+1});
                     cls = CloseData{1,i}{j,3};
                     mul = Multiplier(i);
                     Position{1,i}{j,3} = round(double(onecap)/double(cls*mul));
                     Position{1,i}{j,4} = theDirection{j,i+1};
                 end
            end
        end
    end
    
    %填充Pos_COM的curren 3列和direction 4列
     for k = 1:m %循环多空品种
         if k ~= 2
             [nP,~] = size(Position{1,k});%此品种数据大小
             currenbox = 0;%记录器
             directionbox=0;
             for i = 2:nP
                 if Position{1,k}{i,6} == 1 %如果这一天持仓变化了isChg
                     %记录下curren和direction
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