clearvars
close all
clc
load FP.mat
c = FP(3).coord;

v1 = c(1,:);
v2 = c(136,:);
v3 = c(5,:);

r1 = -(v1-v2)/norm(v1-v2);
r2 = (v1-v3)/norm(v1-v3);
r3 = cross(r1,r2)/norm(cross(r1,r2));

R = [r1;r2;r3];

cN = R*c';
cN = cN';

for i = 1:140/5 
upRow(i,:) = cN(1+5*(i-1),:);
midRow(i,:) = cN(3+5*(i-1),:);
lowRow(i,:) = cN(5+5*(i-1),:);
end
upRow
xs = linspace(upRow(1,1),upRow(end,1),7);

ysU = spline(upRow(:,1),upRow(:,2),xs);
zsU = mean(upRow(:,3),1)*ones(1,size(xs,2));
ysM = spline(midRow(:,1),midRow(:,2),xs);
zsM = mean(midRow(:,3),1)*ones(1,size(xs,2));
ysL = spline(lowRow(:,1),lowRow(:,2),xs);
zsL = mean(lowRow(:,3),1)*ones(1,size(xs,2));

yMedium = (ysU+ysL)./2;
zMedium = (zsU+zsL)./2;

createdNodes(:,1) = [xs xs xs xs];
createdNodes(:,2) = [ysU ysM ysL yMedium];
createdNodes(:,3) = [zsU zsM zsL zMedium]; 

newNodes = R\createdNodes';
newNodes = newNodes';

M = (newNodes(1:7,:)+newNodes(15:21,:))./2;

%
figure()
scatter3(cN(:,1),cN(:,2),cN(:,3));
hold on
scatter3(upRow(1:5,1),upRow(1:5,2),upRow(1:5,3),'k')
scatter3(lowRow(:,1),lowRow(:,2),lowRow(:,3),'k')
scatter3(xs,ysU,zsU,'*r')
scatter3(xs,ysM,zsM,'*r')
scatter3(xs,ysL,zsL,'*r')
xlabel('x')
ylabel('y')
zlabel('z')
zlim([mean(cN(:,3))-1 mean(cN(:,3))+1])

%
figure()
scatter3(c(:,1),c(:,2),c(:,3));
hold on
scatter3(newNodes(1:4,1),newNodes(1:4,2),newNodes(1:4,3),'*r');
xlabel('x')
ylabel('y')
zlabel('z')
scatter3(M(:,1),M(:,2),M(:,3),'*k');