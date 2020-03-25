function [NODES] = createNodesWing(FP,L,V)

if V ~= 2 && V ~= 3 && V ~= 5
    error('V must be equal to 2,3 or 5')
end

c = FP.coord;

v1 = c(1,:);
v2 = c(136,:);
v3 = c(5,:);

r1 = -(v1-v2)/norm(v1-v2);
r2 = (v1-v3)/norm(v1-v3);
r3 = cross(r1,r2)/norm(cross(r1,r2));

R = [r1;r2;r3];

cN = R*c';
cN = cN';

for i = 1:size(cN,1)/5 
   upRow(i,:) = cN(1+5*(i-1),:);
   mid1Row(i,:) = cN(2+5*(i-1),:);
   mid2Row(i,:) = cN(3+5*(i-1),:);
   mid3Row(i,:) = cN(4+5*(i-1),:);
   lowRow(i,:) = cN(5+5*(i-1),:);
end

xU = linspace(upRow(2,1),upRow(end-1,1),L);
x1M = linspace(mid1Row(2,1),mid1Row(end-1,1),L);
x2M = linspace(mid2Row(2,1),mid2Row(end-1,1),L);
x3M = linspace(mid3Row(2,1),mid3Row(end-1,1),L);
xL = linspace(lowRow(2,1),lowRow(end-1,1),L);
yU = spline(upRow(:,1),upRow(:,2),xU);
zU = mean(upRow(:,3),1)*ones(1,size(xU,2));
y1M = spline(mid1Row(:,1),mid1Row(:,2),x1M);
z1M = mean(mid1Row(:,3),1)*ones(1,size(x1M,2));
y2M = spline(mid2Row(:,1),mid2Row(:,2),x2M);
z2M = mean(mid2Row(:,3),1)*ones(1,size(x2M,2));
y3M = spline(mid3Row(:,1),mid3Row(:,2),x3M);
z3M = mean(mid3Row(:,3),1)*ones(1,size(x3M,2));
yL = spline(lowRow(:,1),lowRow(:,2),xL);
zL = mean(lowRow(:,3),1)*ones(1,size(xL,2));

if V == 2
createdNodes(:,1) = [xU xL];
createdNodes(:,2) = [yU yL];
createdNodes(:,3) = [zU zL]; 
elseif V == 3
createdNodes(:,1) = [xU x2M xL];
createdNodes(:,2) = [yU y2M yL];
createdNodes(:,3) = [zU z2M zL]; 
else
createdNodes(:,1) = [xU x1M x2M x3M xL];
createdNodes(:,2) = [yU y1M y2M y3M yL];
createdNodes(:,3) = [zU z1M z2M z3M zL]; 
end

newNodes = R\createdNodes';
newNodes = newNodes';

NODES.x(:) = newNodes(:,1);
NODES.y(:) = newNodes(:,2);
NODES.z(:) = newNodes(:,3);


set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultAxesFontSize',30);
set(groot, 'defaultAxesFontWeight','bold');
set(groot, 'defaultLegendLocation','northwest');


% figure()
% scatter3(c(:,1),c(:,2),c(:,3),'o','filled','MarkerFaceColor',[0 0.4470 0.7410])
% hold on
% scatter3(newNodes(:,1),newNodes(:,2),newNodes(:,3),80,'d','filled','MarkerFaceColor',[0.9290 0.6940 0.1250])
% grid on
% legend('HF nodes','LF nodes')
% xlabel('X [m]','Interpreter','latex')
% ylabel('Y [m]','Interpreter','latex')
% zlabel('Z [m]','Interpreter','latex')


end