function [distance] = distPointPlane(plane,Xpoint)

distance = abs(plane(1)*Xpoint(1)+plane(2)*Xpoint(2)+plane(3)*Xpoint(3)+plane(4))/norm(plane(1:3));