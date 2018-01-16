function FactorData = GetFactorFromDatabaseMacro(conn, WSymbol, startday_dt , endday_dt)
tic %计时
% curs=exec(conn,'SELECT [Date_Trade],[Time_Trade],[Open_Price],[Close_Price],[High_Price],[Low_Price],[Volume_Price],[Position_Price] FROM [future_min].[dbo].[RB_SHF_1MIN] ');
str='SELECT [TradingDay],[ReportDay],[CHName],[WSymbol],[Freq],[LeadAndLag],[FactorValues] FROM [Macro].[dbo].[MacroFactors] WHERE WSymbol =  ';
str=strcat(str,'''');
str=strcat(str,WSymbol);
str=strcat(str,'''');
str=strcat(str,' and TradingDay >= ');
str=strcat(str,'''');
str=strcat(str,startday_dt);
str=strcat(str,'''');
str=strcat(str,' and TradingDay <= ');
str=strcat(str,'''');
str=strcat(str,endday_dt);
str=strcat(str,'''');

curs=exec(conn,str);
curs=fetch(curs);
FactorData=curs.data;
toc %计时
end