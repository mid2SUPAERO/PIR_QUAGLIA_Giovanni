function [NODES] = createNodesTipP(FP,L,V)

%function that creates first nodes on the tip rib, then an additional rib
%to imitate the original model

if V ~= 2 && V ~= 3 && V ~= 5
    error('V must be equal to 2,3 or 5')
end

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

for i = 1:size(xU,2)
dist(i) = norm(upRow(11,:)-createdNodes(i,:));
end
[mn,k] = min(dist);

p(1,:)   =  R\[xU(k) yU(k) zU(k)]';
p(2,:)   =  R\[x1M(k) y1M(k) z1M(k)]';
p(3,:)   =  R\[x2M(k) y2M(k) z2M(k)]';
p(4,:)   =  R\[x3M(k) y3M(k) z3M(k)]';
p(5,:)   =  R\[xL(k) yL(k) zL(k)]';


w(1,:) = R\upRow(11,:)';
w(2,:) = R\mid1Row(10,:)';
w(3,:) = R\mid2Row(10,:)';
w(4,:) = R\mid3Row(10,:)';
w(5,:) = R\lowRow(11,:)';


%Traslation matrix

T = p-w;

% additional rib

%traslate exsting rib
c2 = FP(1).coord;

figure()
scatter3(c2(:,1),c2(:,2),c2(:,3))

for j = 1:size(c2,1)/5
        cT(1+5*(j-1),:) = c2(1+5*(j-1),:) + T(1,:);
        cT(2+5*(j-1),:) = c2(2+5*(j-1),:) + T(2,:);
        cT(3+5*(j-1),:) = c2(3+5*(j-1),:) + T(3,:);
        cT(4+5*(j-1),:) = c2(4+5*(j-1),:) + T(4,:);
        cT(5+5*(j-1),:) = c2(5+5*(j-1),:) + T(5,:);
end

%plane traslated rib

v1N = cT(6,:);
v2N = cT(76,:);
v3N = cT(10,:);

r1N = v2N-v1N;
r2N = v3N-v1N;
normal = cross(r1N,r2N);
normal = normal/norm(normal);
planevar = [normal -normal*v2N'];
%projet ending points on the T rib

for i = 81:85
    D(i) = normal*c2(i,:)'+ planevar(4);
    EP(i-80,:) = c2(i,:) - D(i)*normal;
end

figure()
scatter3(newNodes1(:,1),newNodes1(:,2),newNodes1(:,3),'*k')
hold on
scatter3(cT(:,1),cT(:,2),cT(:,3),'*g')
scatter3(c2(:,1),c2(:,2),c2(:,3),'*b')
scatter3(p(:,1),p(:,2),p(:,3),'<r')
scatter3(w(:,1),w(:,2),w(:,3),'<c')
scatter3(EP(:,1),EP(:,2),EP(:,3),'<k')
plot3([cT(1,1) cT(1,1)+normal(1)],[cT(1,2) cT(1,2)+normal(2)],[cT(1,3) cT(1,3)+ normal(3)])
plot3([v2N(1) v2N(1)-r1N(1)],[v2N(2) v2N(2)-r1N(2)],[v2N(3) v2N(3)-r1N(3)])
plot3([v3N(1) v3N(1)-r2N(1)],[v3N(2) v3N(2)-r2N(2)],[v3N(3) v3N(3)-r2N(3)])
xlabel('x')
ylabel('y')
zlabel('z')
title('global reference frame')
legend('new nodes rib 58','shifted nodes rib 57','old nodes 57','critical points on rib 58','original cross point','EP')
axis equal

%create rotation matrix

v4 = cT(1,:);
v5 = cT(81,:);
v6 = cT(5,:);

r4 = -(v4-v5)/norm(v4-v5);
r5 = (v4-v6)/norm(v4-v6);
r6 = cross(r4,r5)/norm(cross(r4,r5));

R2 = [r4;r5;r6];

cN2 = R2*cT';
cN2 = cN2';
EP = R2*EP';
EP = EP';

cK = R2*c';
cK = cK';

figure()
scatter3(cN2(:,1),cN2(:,2),cN2(:,3),'*b')
hold on
scatter3(cK(:,1),cK(:,2),cK(:,3),'*k')
xlabel('x')
ylabel('y')
zlabel('z')


for i = 1:(size(cN2,1))/5 
   upRow2(i,:)   = cN2(1+5*(i-1),:);
   mid1Row2(i,:) = cN2(2+5*(i-1),:);
   mid2Row2(i,:) = cN2(3+5*(i-1),:);
   mid3Row2(i,:) = cN2(4+5*(i-1),:);
   lowRow2(i,:)  = cN2(5+5*(i-1),:);
end

xU2 = linspace(upRow2(1,1),EP(1,1),L-k);    %original version
x1M2 = linspace(mid1Row2(1,1),EP(2,1),L-k);
x2M2 = linspace(mid2Row2(1,1),EP(3,1),L-k);
x3M2 = linspace(mid3Row2(1,1),EP(4,1),L-k);
xL2 = linspace(lowRow2(1,1),EP(5,1),L-k);
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
createdNodes2(:,1) = [xU2 xL2];
createdNodes2(:,2) = [yU2 yL2];
createdNodes2(:,3) = [zU2 zL2]; 
elseif V == 3
createdNodes2(:,1) = [xU2 x2M2 xL2];
createdNodes2(:,2) = [yU2 y2M2 yL2];
createdNodes2(:,3) = [zU2 z2M2 zL2]; 
else
createdNodes2(:,1) = [xU2 x1M2 x2M2 x3M2 xL2];
createdNodes2(:,2) = [yU2 y1M2 y2M2 y3M2 yL2];
createdNodes2(:,3) = [zU2 z1M2 z2M2 z3M2 zL2]; 
end

newNodes2 = R2\createdNodes2';
newNodes2 = newNodes2';


figure()
scatter3(newNodes1(:,1),newNodes1(:,2),newNodes1(:,3),'*k')
hold on
scatter3(newNodes2(:,1),newNodes2(:,2),newNodes2(:,3),'*r')
scatter3(cT(:,1),cT(:,2),cT(:,3),'*g')
scatter3(c2(:,1),c2(:,2),c2(:,3),'*b')
scatter3(p(:,1),p(:,2),p(:,3),'<r')
scatter3(w(:,1),w(:,2),w(:,3),'<c')
xlabel('x')
ylabel('y')
zlabel('z')
title('global reference frame')
legend('new nodes rib 58','new nodes rib 57','shifted nodes rib 57','old nodes 57','critical points on rib 58','original cross point','EP')


NODES(2).x(:) = newNodes2(:,1);
NODES(2).y(:) = newNodes2(:,2);
NODES(2).z(:) = newNodes2(:,3);
end