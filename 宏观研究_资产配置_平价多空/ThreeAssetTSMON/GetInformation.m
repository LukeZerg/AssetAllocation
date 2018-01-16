function Information = GetInformation(infoFile)
%取得合约需要的乘数、手续费等信息
%feature('DefaultCharacterSet', 'UTF8');%使得matlab能够识别utf8
fid = fopen(infoFile,'r');
info = textscan(fid, '%s%d%f%f','HeaderLines',1,'Delimiter',',');%textscan的Name-Value Pair Arguments方法，跳过开始的1行，以','为分隔符,info每个cell为1列
fclose(fid); 


variety = info{1,1}; %获取品种代码
Multiplier = info{1,2};   %乘数
SlipPrice = info{1,3}; %滑点
fee = info{1,4}; %手续费比例

Information = cell(size(variety,1)+1,size(info,2));
Information(1,:) = {'variety','Multiplier','SlipPrice','fee'};

Information(2:end,1) = variety;
Information(2:end,2) = num2cell(Multiplier);
Information(2:end,3) = num2cell(SlipPrice);
Information(2:end,4) = num2cell(fee);

end