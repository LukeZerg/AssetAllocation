function weekday = returenWeekDay(year,month,day)
%利用蔡勒公式从日期计算星期几 
 if(month<3)
     year = year - 1;
     month = month + 12;
 end
 c = fix(year/100);
 y = year - 100*c;
 weekday = fix(c/4) - 2*c + y + fix(y/4) + (26*(month+1)/10)+day-1;%蔡勒公式
 if weekday >= 0
     weekday = rem(weekday,7);
 else
     weekday = rem(weekday,7) + 7; %weekday为负数时取模
 end
 weekday = fix(weekday);
 if weekday == 0
     weekday = 7; %星期日不作为一周的第一天
 end
end