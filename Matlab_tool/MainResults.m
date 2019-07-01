clearvars
close all
clc

set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultAxesFontSize',30);
set(groot, 'defaultAxesFontWeight','bold');
set(groot, 'defaultLegendLocation','northwest');

% data

Xmax = [35.599239999999995, 12.059915, 4.7880695; ...
    35.415915, 12.198085, 4.80106; ...
35.337320000000005, 12.2573, 4.805197; ...
35.293645, 12.290195, 4.8071065; ...
35.265845, 12.311125, 4.8082775; ...
35.337320000000005, 12.2573, 4.805197; ...
35.213179999999994, 12.35079, 4.810537500000001; ...
35.255425, 12.31898, 4.8087205 ; ...
35.191725000000005, 12.36695, 4.8114305; ...
35.50154, 11.926355000000001, 4.7876395];
VMmax = [249334800.0, 247375800.0, 243594900.0, 242305100.0,243701100.0,242234300.0,243326700.0,241674900.0,241164500.0, 254666100.0];
timeS = [0.29201, 0.56103, 0.48702, 0.60503,0.761043,0.845048,1.096062,1.427081, 1.54408, 1.60409];
timeR = [103.50592, 135.056725, 148.29848, 155.51489, 174.75999, 193.73008,243.2669 263.169052,325.3666,612.34402];
Cl = [0.47942,0.47773,0.47682,0.47672,0.47651,0.47639,0.47636,0.4763,0.47627, 0.47302];
tip = [7.522133, 7.504957, 7.501254, 7.498846,7.499357,7.503574,7.505784,7.507945, 7.509378, 7.57714];
L = [4 6 8 10 12 15 20 25 28 30];

for i = 1:length(L)
    dist(i) = norm(Xmax(i,:)-Xmax(end,:));
end

% plot results
xtlblstr = sprintf('4\n 6\n 8\n 10\n 12\n 15\n 20\n 25\n 28\n HF\n');
xtlbls = regexp(xtlblstr, '\n', 'split');


figure('Renderer', 'painters');
hold on
xlabel('Number of nodes in the cord direction','Interpreter','latex')
%ylabel('$\Delta \, Maximum \, Von \, Mises \,stress$','Interpreter','latex')
ylabel('Maximum VM stress [MPa]','Interpreter','latex')
%plot(L,abs(VMmax-VMmax(end)),'*-','Linewidth',2)
plot(L(1:end-1),VMmax(1:end-1)/10^6,'*-','Color',[0.9290 0.6940 0.1250],'Linewidth',3)
scatter(L(end),VMmax(end)/10^6,140,'d','filled','MarkerFaceColor', [0 0.4470 0.7410])
legend('VM max LF','VM max HF')
set(gca, 'XTick', L, 'XTickLabel', xtlbls)
xlim([3 31])
grid minor

figure('Renderer', 'painters');
hold on
xlabel('Number of nodes in the cord direction','Interpreter','latex')
%ylabel('$\Delta \, Tip \, displacement$','Interpreter','latex')
ylabel('Tip displacement [m]','Interpreter','latex')
plot(L(1:end-1),tip(1:end-1),'*-','Color',[0.9290 0.6940 0.1250],'Linewidth',1.5)
scatter(L(end),tip(end),80,'d','filled','MarkerFaceColor', [0 0.4470 0.7410])
%plot(L,abs(tip-tip(end)),'*-','Linewidth',2)
legend('Tip displacement LF','Tip displacement HF')
set(gca, 'XTick', L, 'XTickLabel', xtlbls)
xlim([3 31])
grid minor

figure('Renderer', 'painters');
hold on
xlabel('Number of nodes in the cord direction','Interpreter','latex')
ylabel('Distance maximum VM [m]','Interpreter','latex')
plot(L(1:end-1),dist(1:end-1),'o-','Linewidth',1.5)
legend('Distance of maximum VM stress')
set(gca, 'XTick', L, 'XTickLabel', xtlbls)
xlim([3 29])
grid minor

figure('Renderer', 'painters');
hold on
xlabel('Number of nodes in the cord direction','Interpreter','latex')
%ylabel('$\Delta \, Lift  \, coefficient$','Interpreter','latex')
%plot(L,abs(Cl-Cl(end)),'o-','Linewidth',2)
ylabel('Lift Coefficient','Interpreter','latex')
plot(L(1:end-1),Cl(1:end-1),'*-','Color',[0.9290 0.6940 0.1250],'Linewidth',3)
scatter(L(end),Cl(end),140,'d','filled','MarkerFaceColor', [0 0.4470 0.7410])
f = legend('Cl LF','Cl HF');
set(f,'location','northeast');
set(gca, 'XTick', L, 'XTickLabel', xtlbls)
xlim([3 31])
ylim([0.472 0.48])
grid minor
  
figure('Renderer', 'painters');
hold on
xlabel('Number of nodes in the cord direction','Interpreter','latex')
ylabel('Relative percent time [\%]','Interpreter','latex')
plot(L,timeS/timeS(end)*100,'*-','Linewidth',3)
plot(L,timeR/timeR(end)*100,'*-','Linewidth',1.5)
legend('Set up relative time','Run relative time')
set(gca, 'XTick', L, 'XTickLabel', xtlbls)
xlim([3 31])
ylim([10 100.5])
grid minor


lbl = num2str(L(1:end-1));
lbl = strsplit(lbl);
lbl = [lbl "HF"];
dx = 0.01;
dy = 0.01;
cmin = min(abs(VMmax-VMmax(end)));
cmax = max(abs(VMmax-VMmax(end)));

% figure('Renderer', 'painters')
% xlabel('X','Interpreter','latex')
% ylabel('Y','Interpreter','latex')
% scatter(Xmax(:,1),Xmax(:,2),[],abs(VMmax-VMmax(end))/cmax,'filled')
% hold on
% colorbar;
% caxis([cmin 1]);
% text(Xmax(:,1)+dx,Xmax(:,2)+dy,lbl,'HorizontalAlignment','left','FontSize',8);
% grid minor


