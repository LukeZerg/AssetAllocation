%%取数据,3种资产

w = windmatlab;
[data1,codes1,fields1,times1,~]=w.edb('S0105896','2015-01-01','2016-08-03','Fill=Previous'); %南华
[data2,codes2,fields2,times2,~]=w.edb('M0066367','2015-01-01','2016-08-03','Fill=Previous'); %活跃合约 沪深300
[data3,codes3,fields3,times3,~]=w.edb('M0096849','2015-01-01','2016-08-03','Fill=Previous'); %活跃合约 5年期国债期货
%数据较少，去除 [GZ10_data,GZ10_codes,GZ10_fields,GZ10_times,~]=w.edb('S0213051','2015-02-01','2016-08-03','Fill=Previous'); %活跃合约 10年期国债期货

%% 获得权重
Today = '2016/02/08';
Yesterday = '2016/02/05';                           %注意格式，1位月、日前要加0,Yesterday是今天的上一个 交 易 日
[index_start,index] = GetIndex(Yesterday, datestr(times1,26), 252);     %获得时间起始index
dt1 = data1(index_start:index,1);
ret1 = ( data1(index_start:index,1) - data1((index_start-1):(index-1),1) ) ./ data1((index_start-1):(index-1),1); %收益率
t = datestr(times1(index_start:index,1),26);                            %获得日期序列
[index_start,index] = GetIndex(Yesterday, datestr(times2,26), 252);     %获得时间起始index
%dt2 = data2(index_start:index,1);
ret2 = ( data2(index_start:index,1) - data2((index_start-1):(index-1),1) ) ./ data2((index_start-1):(index-1),1); 
t2 = datestr(times2(index_start:index,1),26);
[index_start,index] = GetIndex(Yesterday, datestr(times3,26), 252);     %获得时间起始index
dt3 = data3(index_start:index,1);
ret3 = ( data3(index_start:index,1) - data3((index_start-1):(index-1),1) ) ./ data3((index_start-1):(index-1),1); 
%t3 = datestr(times3(index_start:index,1),26);
box(1).dt = dt1;
box(2).dt = dt2;
box(3).dt = dt3;
CovMatrix = zeros(3,3);
for i = 1:3
    for j = 1:3
        temp = cov(box(i).dt,box(j).dt);
        CovMatrix(i,j) = temp(1,2);
    end
end
%初始化fmincon
x0 = [0.2;0.2;0.6];
A = [];
b = [];
Aeq = [1,1,1];
beq = 1;
lb = [0;0;0];
ub = [1;1;1];
%求得三种资产的权重
[weights,fval] = fmincon(@(x) fmin(x,CovMatrix),x0,A,b,Aeq,beq,lb,ub);
%% 计算收益净值
cap = 100000000; %初始化，之后需要读取值
cap1 = cap * weights(1);
cap2 = cap * weights(2);
cap3 = cap * weights(3);
w.tdays('2015-01-01','2015-05-01');


