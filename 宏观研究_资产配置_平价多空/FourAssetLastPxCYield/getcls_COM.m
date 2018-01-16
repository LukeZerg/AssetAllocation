function CloseData_COM = getcls_COM(Position_COM,comInfo)
%获取商品价格
    variety_com = comInfo(2:end,2); %获取品种代码
    comtdays = Position_COM(2:end,1);
    nt = size(comtdays,1);
    CloseData_COM = getFuturedataRiskParity(comtdays{1}, comtdays{nt}, variety_com); %获取商品价格基础数据
end