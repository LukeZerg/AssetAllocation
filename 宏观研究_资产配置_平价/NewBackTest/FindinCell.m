function vector = FindinCell(cellmatrix,col,target)
%在cell中查找内容，并返回向量
%cellmatrix:用来查找的矩阵,类型为cell;col：为要查找的列，target为要查找的内容
[m,n] = size(cellmatrix);
if col > n || col <= 0
    error('列数超出下标限制');
end
temp = cellmatrix(:,col);
%如果为字符串
if any([1,2,6]==col) 
    temp2 = cellstr(temp);
    vector = find(strcmp(temp2 , target));
elseif any([3,4,5]==col)%如果为数字
    temp2 = cell2mat(temp);%转换为数字
    vector = find(temp2 == target);
else
    error('列数非法');
end
end