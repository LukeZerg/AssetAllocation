function [] = colorXYZ(Dlsit, blist, Msharpratio)
%һ��xһ��yһ��z���ֱ�Ϊ��һ����ĵ���վ���ȣ���ȣ��Լ�����ó��������ܶ�ֵ  
%��һ��������д����C++��,������һ����Ӱ��ʹ��  
%�����ļ�����ȡx��ֵ  
lend = length(Dlist);
lenb = length(blist);
lenz = lend * lenb;
x = zeros(lenz,1);
y = zeros(lenz,1);
z = zeros(lenz,1);
k = 1;
for i = 1:lend
    for j = 1:lenb
        x(k) = Dlist(i);
        y(k) = blist(j);
        z(k) = Msharpratio(i,j);
        k = k + 1;
    end
end

%ȡx�����ֵ  
maxx=max(x);  
%ȡx����Сֵ  
minx=min(x);  
%ͬx  
maxy=max(y);  
miny=min(y);  
%��������  
[X,Y]=meshgrid(linspace(minx,maxx),linspace(miny,maxy));  
%������Ա�ܶ�ֵ  
Z=griddata(x,y,z,X,Y,'v4');  
subplot(1,2,1);  
%������ά��  
mesh(X,Y,Z)  
hold on  
%����ά���ϻ�����Ա�ܶ�ֵ���ߵͷ���ֵ�Ĵ�С���ı䣬��ɫҲ��  
plot3(x,y,z,'r.')  
hold on  
%��������  
xlabel('X-����վ����');  
ylabel('Y-����վ���');  
zlabel('Z-��Ա�ܶ�ֵ');  
%������ɫ��  
colorbar  
%��ά�ӽ�  
subplot(1,2,2);  
%������ά��  
mesh(X,Y,Z)  
hold on  
%����ά���ϻ�����Ա�ܶ�ֵ���ߵͷ���ֵ�Ĵ�С���ı䣬��ɫҲ��  
plot3(x,y,z,'r.')  
hold on  
view(2);  
%��������  
xlabel('X-����վ����');  
ylabel('Y-����վ���');  
zlabel('Z-��Ա�ܶ�ֵ');  
%������ɫ��  
colorbar  

end