function [NODES] = createNodesTip(FP,L,V)

%function that creates first nodes on the tip rib, then an additional rib
%to imitate the original model

%tip rib

c = FP(2).coord;

v1 = c(1,:);
v2 = c(133,:);
v3 = c(2,:);

r1 = -(v1-v2)/norm(v1-v2);
r2 = (v1-v3)/norm(v1-v3);
r3 = cross(r1,r2)/norm(cross(r1,r2));

R = [r1;r2;r3];

cN = R*c';
cN = cN';

upRow(1,:) = cN(1,:);
lowRow(1,:) = cN(2,:);

for i = 1:(size(cN,1)-2)/5 
   upRow(i+1,:) = cN(3+5*(i-1),:);
   mid1Row(i,:) = cN(4+5*(i-1),:);
   mid2Row(i,:) = cN(5+5*(i-1),:);
   mid3Row(i,:) = cN(6+5*(i-1),:);
   lowRow(i+1,:) = cN(7+5*(i-1),:);
end

xU = linspace(upRow(2,1),upRow(end-1,1),L);
x1M = linspace(mid1Row(1,1),mid1Row(end-1,1),L);
x2M = linspace(mid2Row(1,1),mid2Row(end-1,1),L);
x3M = linspace(mid3Row(1,1),mid3Row(end-1,1),L);
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

newNodes1 = R\createdNodes';
newNodes1 = newNodes1';

NODES(1).x(:) = newNodes1(:,1);
NODES(1).y(:) = newNodes1(:,2);
NODES(1).z(:) = newNodes1(:,3);

%find nearest nodes to the original rib position

w(1,:) = R\upRow(11,:)';
w(2,:) = R\mid1Row(10,:)';
w(3,:) = R\mid2Row(10,:)';
w(4,:) = R\mid3Row(10,:)';
w(5,:) = R\lowRow(11,:)';

for i = 1:size(xU,2)
dist(i) = norm(upRow(11,:)-createdNodes(i,:));
end
[mn,k] = min(dist);

p(1,:)   =  R\[xU(k) yU(k) zU(k)]';
p(2,:)   =  R\[x1M(k) y1M(k) z1M(k)]';
p(3,:)   =  R\[x2M(k) y2M(k) z2M(k)]';
p(4,:)   =  R\[x3M(k) y3M(k) z3M(k)]';
p(5,:)   =  R\[xL(k) yL(k) zL(k)]';

% additional rib

%create rotation matrix
c2 = FP(1).coord;

v4 = c2(6,:);
v5 = c2(81,:);
v6 = c2(10,:);

r4 = -(v4-v5)/norm(v4-v5);
r5 = (v4-v6)/norm(v4-v6);
r6 = cross(r4,r5)/norm(cross(r4,r5));

R2 = [r4;r5;r6];

cN2 = R2*c2';
cN2 = cN2';

W = R2*w';
W = W';
pN = R2*p';
pN = pN';


%translate original rib

v1N = cN2(1,:);
v2N = cN2(81,:);
v3N = cN2(5,:);

r1N = v2N-v1N;
r2N = v3N-v1N;
normal = cross(r1N,r2N);
normal = normal/norm(normal);
planevar = [normal -normal*v2N'];
D = normal*pN(1,:)'+ planevar(4);
T = normal*W(1,:)'+planevar(4);

for i = 1:size(cN2,1)
   cN3(i,:) = cN2(i,:) + (D-T)*normal;
end

% figure()
% scatter3(cN2(:,1),cN2(:,2),cN2(:,3),'*k')
% hold on
% scatter3(cN3(:,1),cN3(:,2),cN3(:,3),'ob')
% scatter3(pN(:,1),pN(:,2),pN(:,3),'<r')


CN3 = R2\cN3';
CN3 = CN3';

% figure()
% scatter3(c2(:,1),c2(:,2),c2(:,3),'*k')
% hold on
% scatter3(CN3(:,1),CN3(:,2),CN3(:,3),'ob')
% scatter3(p(:,1),p(:,2),p(:,3),'<r')
% scatter3(c(:,1),c(:,2),c(:,3),'oc')
% scatter3(newNodes1(:,1),newNodes1(:,2),newNodes1(:,3),'*k')


for i = 1:(size(cN3,1))/5 
   upRow2(i,:)   = cN3(1+5*(i-1),:);
   mid1Row2(i,:) = cN3(2+5*(i-1),:);
   mid2Row2(i,:) = cN3(3+5*(i-1),:);
   mid3Row2(i,:) = cN3(4+5*(i-1),:);
   lowRow2(i,:)  = cN3(5+5*(i-1),:);
end

xU2 = linspace(pN(1,1),upRow2(end-1,1),L-k+1);    %original version
x1M2 = linspace(pN(2,1),mid1Row2(end-1,1),L-k+1);
x2M2 = linspace(pN(3,1),mid2Row2(end-1,1),L-k+1);
x3M2 = linspace(pN(4,1),mid3Row2(end-1,1),L-k+1);
xL2 = linspace(pN(5,1),lowRow2(end-1,1),L-k+1);
yU2 = spline(upRow2(:,1),upRow2(:,2),xU2);
zU2 = mean(upRow2(:,3),1)*ones(1,size(xU2,2));
y1M2 = spline(mid1Row2(:,1),mid1Row2(:,2),x1M2);
z1M2 = mean(mid1Row2(:,3),1)*ones(1,size(x1M2,2));
y2M2 = spline(mid2Row2(:,1),mid2Row2(:,2),x2M2);
z2M2 = mean(mid2Row2(:,3),1)*ones(1,size(x2M2,2));
y3M2 = spline(mid3Row2(:,1),mid3Row2(:,2),x3M2);
z3M2 = mean(mid3Row2(:,3),1)*ones(1,size(x3M2,2));
yL2 = spline(lowRow2(:,1),lowRow2(:,2),xL2);
zL2 = mean(lowRow2(:,3),1)*ones(1,size(xL2,2));

if V == 2
createdNodes2(:,1) = [xU2(2:end) xL2(2:end)];
createdNodes2(:,2) = [yU2(2:end) yL2(2:end)];
createdNodes2(:,3) = [zU2(2:end) zL2(2:end)]; 
elseif V == 3
createdNodes2(:,1) = [xU2(2:end) x2M2(2:end) xL2(2:end)];
createdNodes2(:,2) = [yU2(2:end) y2M2(2:end) yL2(2:end)];
createdNodes2(:,3) = [zU2(2:end) z2M2(2:end) zL2(2:end)]; 
else
createdNodes2(:,1) = [xU2(2:end) x1M2(2:end) x2M2(2:end) x3M2(2:end) xL2(2:end)];
createdNodes2(:,2) = [yU2(2:end) y1M2(2:end) y2M2(2:end) y3M2(2:end) yL2(2:end)];
createdNodes2(:,3) = [zU2(2:end) z1M2(2:end) z2M2(2:end) z3M2(2:end) zL2(2:end)]; 
end

newNodes2 = R2\createdNodes2';
newNodes2 = newNodes2';
% 
% figure()
% scatter3(createdNodes2(:,1),createdNodes2(:,2),createdNodes2(:,3),'*k')
% hold on
% scatter3(cN2(:,1),cN2(:,2),cN2(:,3),'*b')
% scatter3(cN3(:,1),cN3(:,2),cN3(:,3),'*g')
% scatter3(pN(:,1)+dN(:,1),pN(:,2)+dN(:,2),pN(:,3)+dN(:,3),'<r')
% scatter3(W(:,1),W(:,2),W(:,3),'<c')
% xlabel('x')
% ylabel('y')
% zlabel('z')
% title('57 reference frame')
% legend('new nodes','old nodes','old nodes shifted','critical points on rib 58','original cross points')
% % 
% figure()
% scatter3(newNodes1(:,1),newNodes1(:,2),newNodes1(:,3),'*k')
% hold on
% scatter3(newNodes2(:,1),newNodes2(:,2),newNodes2(:,3),'*b')
% scatter3(c2(:,1),c2(:,2),c2(:,3),'*g')
% scatter3(p(:,1),p(:,2),p(:,3),'<r')
% scatter3(p(:,1)+d(:,1),p(:,2)+d(:,2),p(:,3)+d(:,3),'<r')
% scatter3(w(:,1),w(:,2),w(:,3),'<c')
% scatter3(FP(1).coord(:,1),FP(1).coord(:,2),FP(1).coord(:,3),'*r')
% xlabel('x')
% ylabel('y')
% zlabel('z')
% title('global reference frame')
% legend('new nodes rib 58','new nodes rib 57','old nodes rib 57','critical points on rib 58','diff', ...
% 'original cross point','rib 56')

NODES(2).x(:) = newNodes2(:,1);
NODES(2).y(:) = newNodes2(:,2);
NODES(2).z(:) = newNodes2(:,3);
end