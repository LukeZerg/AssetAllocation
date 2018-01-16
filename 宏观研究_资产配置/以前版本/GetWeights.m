function weights = GetWeights(dt1,dt2,dt3)
%�����ƽ�����Ž�
%ͨ��SQP�㷨���õ�Ȩ�أ�dtΪ�۸���������
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
%��ʼ��fmincon
x0 = [0.2;0.2;0.6];
A = [];
b = [];
Aeq = [1,1,1];
beq = 1;
lb = [0;0;0];
ub = [1;1;1];
%��������ʲ���Ȩ��
[weights,~] = fmincon(@(x) fmin(x,CovMatrix),x0,A,b,Aeq,beq,lb,ub);
end