function vector = FindinCell(cellmatrix,col,target)
%��cell�в������ݣ�����������
%cellmatrix:�������ҵľ���,����Ϊcell;col��ΪҪ���ҵ��У�targetΪҪ���ҵ�����
[m,n] = size(cellmatrix);
if col > n || col <= 0
    error('���������±�����');
end
temp = cellmatrix(:,col);
%���Ϊ�ַ���
if any([1,2,6]==col) 
    temp2 = cellstr(temp);
    vector = find(strcmp(temp2 , target));
elseif any([3,4,5]==col)%���Ϊ����
    temp2 = cell2mat(temp);%ת��Ϊ����
    vector = find(temp2 == target);
else
    error('�����Ƿ�');
end
end