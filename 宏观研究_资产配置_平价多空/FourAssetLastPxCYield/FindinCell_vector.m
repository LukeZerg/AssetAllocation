function subvector =  FindinCell_vector(cellmatrix,col,targetvector)
%在cell中查找内容，并返回向量targetvector每一个元素的位置，此函数只适合用在没有重复项cellmatrix
%cellmatrix:用来查找的矩阵,类型为cell;col：为要查找的列，target为要查找的内容
subvector = [];
ntar = size(targetvector,2);
for i = 1:ntar
    target = targetvector(i);
    onesub = FindinCell(cellmatrix,col,target);
    subvector = [subvector;onesub];
end
end