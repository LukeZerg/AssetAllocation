function weekday = returenWeekDay(year,month,day)
%���ò��չ�ʽ�����ڼ������ڼ� 
 if(month<3)
     year = year - 1;
     month = month + 12;
 end
 c = fix(year/100);
 y = year - 100*c;
 weekday = fix(c/4) - 2*c + y + fix(y/4) + (26*(month+1)/10)+day-1;%���չ�ʽ
 if weekday >= 0
     weekday = rem(weekday,7);
 else
     weekday = rem(weekday,7) + 7; %weekdayΪ����ʱȡģ
 end
 weekday = fix(weekday);
 if weekday == 0
     weekday = 7; %�����ղ���Ϊһ�ܵĵ�һ��
 end
end