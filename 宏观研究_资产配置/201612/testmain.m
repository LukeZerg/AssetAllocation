%% 从txt取出数据

feature('DefaultCharacterSet', 'UTF8');%使得matlab能够识别utf8
fid = fopen('数据.txt','r');
info = textscan(fid, '%f%f%f%f%f','HeaderLines',1,'Delimiter',',');%textscan的Name-Value Pair Arguments方法，跳过开始的1行，以','为分隔符,info每个cell为1列
fclose(fid);

%从info到收益率矩阵
nVariety = size(info,2);
RetMatrix = zeros(size(info{1,k},1)-1,nVariety);
for k = 1:nVariety
    close = info{1,k};
    ret = diff(close)./close(1:(end-1));
    RetMatrix(:,k) = ret;
end
weights = RiskParity(RetMatrix);

