function subvector =  FindinCell_vector(cellmatrix,col,targetvector)
%��cell�в������ݣ�����������targetvectorÿһ��Ԫ�ص�λ�ã��˺���ֻ�ʺ�����û���ظ���cellmatrix
%cellmatrix:�������ҵľ���,����Ϊcell;col��ΪҪ���ҵ��У�targetΪҪ���ҵ�����
subvector = [];
ntar = size(targetvector,2);
for i = 1:ntar
    target = targetvector(i);
    onesub = FindinCell(cellmatrix,col,target);
    subvector = [subvector;onesub];
end
end