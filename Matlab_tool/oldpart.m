xs2 = linspace(pN(1,1),upRow2(end-1,1),L-k+1);    %original version


yU2 = spline(upRow2(:,1),upRow2(:,2),xs2);
zU2 = mean(upRow2(:,3),1)*ones(1,size(xs2,2));
y1M2 = spline(mid1Row2(:,1),mid1Row2(:,2),xs2);
z1M2 = mean(mid1Row2(:,3),1)*ones(1,size(xs2,2));
y2M2 = spline(mid2Row2(:,1),mid2Row2(:,2),xs2);
z2M2 = mean(mid2Row2(:,3),1)*ones(1,size(xs2,2));
y3M2 = spline(mid3Row2(:,1),mid3Row2(:,2),xs2);
z3M2 = mean(mid3Row2(:,3),1)*ones(1,size(xs2,2));
yL2 = spline(lowRow2(:,1),lowRow2(:,2),xs2);
zL2 = mean(lowRow2(:,3),1)*ones(1,size(xs2,2));

if V == 2
createdNodes2(:,1) = [xs2(2:end) xs2(2:end)];
createdNodes2(:,2) = [yU2(2:end) yL2(2:end)];
createdNodes2(:,3) = [zU2(2:end) zL2(2:end)]; 
elseif V == 3
createdNodes2(:,1) = [xs2(2:end) xs2(2:end) xs2(2:end)];
createdNodes2(:,2) = [yU2(2:end) y2M2(2:end) yL2(2:end)];
createdNodes2(:,3) = [zU2(2:end) z2M2(2:end) zL2(2:end)]; 
else
createdNodes2(:,1) = [xs2(2:end) xs2(2:end) xs2(2:end) xs2(2:end) xs2(2:end)];
createdNodes2(:,2) = [yU2(2:end) y1M2(2:end) y2M2(2:end) y3M2(2:end) yL2(2:end)];
createdNodes2(:,3) = [zU2(2:end) z1M2(2:end) z2M2(2:end) z3M2(2:end) zL2(2:end)]; 
end