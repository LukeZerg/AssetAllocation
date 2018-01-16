function TradeRecord = computetraderecord(position,CloseData)
%从仓位和价格数据里获取交易记录
    n = size(position,2);
    TradeRecord = cell(1,n);%交易记录
    for k = 1:n %分多空品种计算
        disp(k);
        TradeRecord{1,k} = {'TradingDays','Contract','TradePrice',...
            'curren','direction','variety','curren_after'};
        pos = position{1,k};
        oneClosetata = CloseData{1,k};%该品种价格数据
        onevariety = pos{2,5};%记录品种
        [rows,~] = size(pos);
        for i = 3:rows %从内容第二行开始
            num = 0;%这一天交易次数初始化,一行还是两行以实际情况为准
            
            %if pos{i,7} == 1;%如果持仓改变日
                onetrade = cell(2,size(TradeRecord{1,k},2));%临时存储
                onetrade(:,1) = {pos{i,1}}; %日期 
                onetrade(:,6) = {onevariety}; %日期 
                close = oneClosetata{i,3};
                preclose = oneClosetata{i,5};%前一个合约今日价格
                
                if strcmp(pos{i,2},pos{i-1,2}) %如果今昨合约相同
                    onetrade(:,2) = {pos{i,2}}; %合约
                    onetrade(:,3) = {close};
                    if pos{i,4}*pos{i-1,4} == -1    %如果今昨仓方向相反
                        num = 2;%有两笔交易
                        %平昨
                        onetrade{1,4} = pos{i-1,3};%昨日仓位
                        onetrade{1,5} = -1*pos{i-1,4};%平仓交易方向相反
                        onetrade{1,7} = 0;%交易后仓位
                        %开今仓
                        onetrade{2,4} = pos{i,3};   %今日仓位
                        onetrade{2,5} = pos{i,4};   %今日方向
                        onetrade{2,7} = pos{i,3}*pos{i,4};
                    elseif pos{i,4}*pos{i-1,4} == 1  ...
                            &&  pos{i,3}~=pos{i-1,3}  
                        %如果今昨仓方向相同且仓位不相等
                        num = 1;%有一笔交易
                        chg =  pos{i,3} - pos{i-1,3} ;  %手数比较
                        onetrade{1,4} = abs(chg);       %交易手数
                        onetrade{1,7} = pos{i,3}*pos{i,4};
                        if pos{i,4} > 0     %多仓
                            if chg > 0 , onetrade{1,5} = 1;
                            elseif chg < 0, onetrade{1,5} = -1; end
                        else                 %空仓
                            if chg > 0,onetrade{1,5} = -1;
                            elseif chg < 0, onetrade{1,5} = 1; end
                        end
                        %方向相同，手数相同，不用交易
                    elseif pos{i,4}*pos{i-1,4} == 0 && pos{i,4}+pos{i-1,4}~=0
                        num = 1;
                        if pos{i-1,4} ~= 0 %清空昨仓
                            onetrade{1,4} = pos{i-1,3};
                            onetrade{1,5} = -1 * pos{i-1,4};
                            onetrade{1,7} = 0;
                        elseif pos{i,4}~= 0 %从无仓位到今仓
                            onetrade{1,4} = pos{i,3};
                            onetrade{1,5} = pos{i,4};
                            onetrade{1,7} = pos{i,3} * pos{i,4};
                        %仓位都为0时不用交易
                        else
                            cerr('相同合约，只有一个仓位为0的情况，有错误');
                        end
                    end
                    
                else %如果合约不同
                    if pos{i,4}*pos{i-1,4} ~= 0
                        num = 2;%有两笔交易
                        onetrade(1,2) = pos(i-1,2); %合约
                        onetrade(2,2) = pos(i,2); %合约
                        %平昨仓
                        onetrade{1,3} = preclose;
                        onetrade{1,4} = pos{i-1,3};%昨日仓位
                        onetrade{1,5} = -1*pos{i-1,4};%平仓交易方向相反
                        onetrade{1,7} = 0;
                        %开今仓
                        onetrade{2,3} = close;
                        onetrade{2,4} = pos{i,3};%今日仓位
                        onetrade{2,5} = pos{i,4};%今日方向
                        onetrade{2,7} = pos{i,3}*pos{i,4};%交易后仓位
                    elseif pos{i,4} ~= 0 && pos{i-1,4} == 0
                        %开今仓
                        num = 1;
                        onetrade(1,2) = pos(i,2); %合约
                        onetrade{1,3} = close;
                        onetrade{1,4} = pos{i,3};%今日仓位
                        onetrade{1,5} = pos{i,4};%今日方向
                        onetrade{1,7} = pos{i,3}*pos{i,4};%今日方向
                    elseif pos{i,4} == 0 && pos{i-1,4} ~= 0
                        %平昨仓
                        num = 1;
                        onetrade(1,2) = pos(i-1,2); %合约
                        onetrade{1,3} = preclose;
                        onetrade{1,4} = pos{i-1,3};%昨日仓位
                        onetrade{1,5} = -1*pos{i-1,4};%平仓交易方向相反
                        onetrade{1,7} = 0;
                    end
                    %仓位都为0不用交易
                end
                if num == 1
                    temp = onetrade(1,:);
                elseif num == 2
                    temp = onetrade(1:2,:);
                end
                %将交易记录添加到末尾
                if num > 0,TradeRecord{1,k} = [TradeRecord{1,k};temp];end
           % end    %如果是改变持仓日
        end
    end
end