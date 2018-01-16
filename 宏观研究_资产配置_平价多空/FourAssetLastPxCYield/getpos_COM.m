function Pos_COM = getpos_COM(Position_COM, CloseData_COM, Weights_COM, Direction_COM, cdata ,comInfo ,nls)
%计算商品的仓位
%整理comInfo的商品信息
global s    
name_com = comInfo(2:end,1);
Multiplier_com = cell2mat(comInfo(2:end,3));   %乘数
variety_com = comInfo(2:end,2); %获取品种代码
% Kind_com = comInfo(2:end,6);%种类

%得到日期和数字化日期
tradingdays = Weights_COM(2:end,1);
nt = size(tradingdays,1);
num_tradingdays = zeros(nt,1);
for i = 1:nt
    num_tradingdays(i) = datenum(tradingdays(i));
end
%商品持仓Pos_COM初始化
Pos_COM = cell(1,size(CloseData_COM,2));
for i = 1:size(CloseData_COM,2)
    Pos_COM{1,i} = {'TradingDay','Contract','Curren','Direciton',...
        'Variety','isChg'};
    Pos_COM{2,i} = variety_com(i);
    Pos_COM{1,i}(2:(nt+1),1) = tradingdays; %日期
    Pos_COM{1,i}(2:(nt+1),2) = CloseData_COM{1,i}(2:(nt+1),2); %合约
    Pos_COM{1,i}(2:(nt+1),3) = {0}; %curren
    Pos_COM{1,i}(2:(nt+1),4) = {0}; %direction
    Pos_COM{1,i}(2:(nt+1),5) = CloseData_COM{1,i}(2:(nt+1),6); %资产种类
    Pos_COM{1,i}(2:(nt+1),6) = Position_COM(2:(nt+1),6); %ischg
end

%在每一个调仓日期计算仓位
ncdata = size(cdata,1);
for i = 1:ncdata
    %在c值表每一行中
    row_cdata = cdata(i,:);
    %在tradingdays中找到第一个等于这行日期的元素
    theday = datestr(row_cdata(1),29);
    num_theday = datenum(theday);
    temp =  (num_tradingdays == num_theday);
    temp2 = find(temp>0);
    %如果找不到这个日期，就跳过，如果找到了，就开始确认品种，计算仓位
    if isempty(temp2)
        continue;
    else
        sub = temp2(1);%下标
       %计算分配到每个商品上的资金
        onecomcap = Weights_COM{sub+1,2} * s.capital / nls;
        %找到做多做空品种的下标
        longname = row_cdata(2:(2+nls-1));
        longsub = FindinCell_vector(name_com,1,longname);
        shortname = row_cdata((end-nls+1):end);
        shortsub = FindinCell_vector(name_com,1,shortname);
        %方向
        d = Direction_COM{sub+1,2};
        if d > 0
            lssub = longsub;
        elseif d < 0
            lssub = shortsub;
        end
        if d ~= 0
            %找到操作品种下标
            for j = 1:nls
                isub = lssub(j);
                cls = CloseData_COM{1,isub}{sub+1,3};
                mul = Multiplier_com(isub);
                %持仓 = 资金 / （收盘价 * 乘数）
                Pos_COM{1,isub}{sub+1,3} = round( onecomcap / ( cls * mul) );
                %direcition
                Pos_COM{1,isub}{sub+1,4} = d;
            end
        end
        %如果d为0，就跳过不计算仓位
    end %如果找到日期，就开始确认品种，计算仓位
end %循环cdata

%填充Pos_COM的curren 3列和direction 4列
 for k = 1:size(CloseData_COM,2) %循环多空品种
     [nP,~] = size(Pos_COM{1,k});%此品种数据大小
     currenbox = 0;%记录器
     directionbox=0;
     for i = 2:nP
         if Pos_COM{1,k}{i,6} == 1 %如果这一天持仓变化了isChg
             %记录下curren和direction
             currenbox = Pos_COM{1,k}{i,3};
             directionbox = Pos_COM{1,k}{i,4};
         end
         Pos_COM{1,k}{i,3} = currenbox;
         Pos_COM{1,k}{i,4} = directionbox;
     end
 end
 
 
 
end