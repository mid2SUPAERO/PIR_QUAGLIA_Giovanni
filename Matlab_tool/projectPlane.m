function [newPlane] = projectPlane(Planes)

coord = Planes.coord;
plane = Planes.plane;
% v1 = PlaneCoord(4,3:5);
% v2 = PlaneCoord(5,3:5);
PCA = pca(coord(:,2:4));
e1 = PCA(:,1)';
e2 = PCA(:,2)';
e3 = PCA(:,3)';
% e1 = (v1-v2)/norm(v1-v2);
% e3 = plane(1:3)/norm(plane(1:3));
% e2 = -cross(e1,e3);

R = [e1;e2;e3];

newPlane(:,1) = coord(:,1);

for i = 1:size(coord,1)
newPlane(i,2:4) = R*coord(i,2:4)';
end

