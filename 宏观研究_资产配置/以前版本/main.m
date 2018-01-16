w = windmatlab;
if isempty('data.mat') == 1         %如果为空
   
end
load data

firstcell = {'TradingDay','cap1','cap2','cap3','count'};
% len_data = size(data.data,1);
% cella = cell(len_data + 1, 5);
% cella(1,:) = firstcell;
% for i = 1:len_data
%     onecell = { data.textdata{i+1,1}, data.data(i,1), data.data(i,2), data.data(i,3), data.data(i,4) };
%     cella(i+1,:) = onecell;
% end

data 

%StartDay = '2016/02/08';
StartDay = datestr(datenum(cella{end,1})+1,26)
StartDay = w.tdaysoffset(1,'2016/02/08');
StartDay = StartDay{1};
Today = datestr(now,26);
temp = cellstr(w.tdays(StartDay,Today));                    %提取交易日期
len = length(temp);
data2 = cell( len, 5 );
for i = 1:len
    onecell = RiskEvaluationStrategy( data2, w, 'S0105896', 'M0020209', 'M0096849', temp{1}, 10000000, 22);
    data2(i,:) = onecell;
    print i;
end
