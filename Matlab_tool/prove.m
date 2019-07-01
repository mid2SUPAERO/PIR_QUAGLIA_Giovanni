%clearvars
close all
clc
clear nPS
i = 57;

nP = projectPlane(Planes(i));
nPS = nodeSort(nP,2);

figure()
xlabel('x');
hold on
ylabel('y');
scatter(nP(1,3),nP(1,4),'ob')
hold on
 for i = 2:size(nP,1)
     scatter(nP(i,3),nP(i,4),'ob')
 end
grid minor



figure()
xlabel('x');
hold on
ylabel('y');
scatter(nPS(1,4),nPS(1,5),'ob')
text(nPS(1,4),nPS(1,5),num2str(1));
hold on
 for i = 2:size(nPS,1)
     scatter(nPS(i,4),nPS(i,5),'ob')
     text(nPS(i,4),nPS(i,5),num2str(i));
 end
grid minor