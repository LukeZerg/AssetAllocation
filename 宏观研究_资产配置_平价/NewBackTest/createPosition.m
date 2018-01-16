function Position = createPosition( Position_abs, Direction )
%��û�з���Ĳ�λPosition_abs�뷽��Direction�ϲ�����,�õ�Position����
n1 = size(Position_abs,2); %�����������������
n2 = size(Direction,2)-1;
if n1 ~= n2
    error('û�з���Ĳ�λPosition_abs�뷽��Direction���ʲ�����ͬ');
end
Position = cell(1,n1);
nt = size(Direction,1)-1;
for iAsset = 1:n1
    onePosition = Position_abs{1,iAsset} ;
    for j = 1:nt
        onePosition(j+1,4) = Direction(j+1,iAsset+1); %����ֵ
    end
    Position{1,iAsset} = onePosition;
end
end