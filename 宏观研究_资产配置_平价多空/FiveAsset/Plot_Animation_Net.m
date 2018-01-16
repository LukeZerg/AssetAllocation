function Plot_Animation_Net( output)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
    t = 2:1:size(output,1)-1;
    %tradingdays = datenum(output(:,1));%显示日期
    %tradingdays = tradingdays(2:(end-1));
    m=cell2mat(output(t,2));  
    plot(t,m)
    x=5;
    axis([0,x+5,0,1.5]);
    grid on 
    while 1
        if x>max(t)
            break;
        end
        x=x+1;
        axis([0,x+1,output{x,2}-0.1,output{x,2}+0.1]);
        pause(1);
    end

end