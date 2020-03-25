clearvars
close all
clc

set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultAxesFontSize',30);
set(groot, 'defaultAxesFontWeight','bold');
set(groot, 'defaultLegendLocation','northwest');


b_0 = 58.7629;
sweep_0 = 37.16;

b = [b_0-10 b_0-5 b_0 b_0+5 b_0+10];
s = [sweep_0-5 sweep_0-2.5 sweep_0 sweep_0+2.5 sweep_0+5];


%LF
Cl_LF     = [0.48784  0.46413  0.44002  0.4158  0.39161; ...
        0.51606  0.48879  0.46171  0.43535  0.40927; ...
       0.53748  0.5082 0.47998 0.45145  0.42438; ...
       0.55516 0.52437 0.49477 0.46526 0.43837; ...
       0.56985 0.53855 0.50851 0.47843 0.4525];
   
Cdi_LF    = [0.01222  0.01101  0.00987  0.0088  0.00781; ...
       0.01135  0.01017  0.00908  0.00811  0.00723; ...
       0.01055  0.00947 0.00851 0.00761 0.00684; ...
       0.00995  0.00897 0.0081 0.00731 0.00665; ...
       0.00955  0.00867 0.00789 0.00718 0.0066];
       
VMmax_LF  = [216686600.0  214746000.0  213519200.0 211852500.0  209600200.0; ...
   243141200.0  239253100.0  235138400.0  230897300.0  226088800.0; ...
   262768300.0 256495300.0  249956900.0 243040200.0 236024900.0; ...
   275563600.0  266712400.0 258073100.0 248339800.0 239791600.0; ...
   281057300.0  270530000.0 260171800.0 248474200.0 240199700.0];

tip_LF    = [6.270606  6.3241499999999995  6.385137  6.455688  6.536189; ...
    6.832107  6.8823039999999995  6.94148  7.014138  7.098031; ...
    7.429599  7.472405999999999  7.5260739999999995 7.5911290000000005 7.672953; ...
    8.038278  8.063552999999999  8.105936 8.1485 8.226368; ...
    8.616828  8.625499 8.650936999999999 8.669101999999999 8.765118999999999];

%HF

Cl_HF = [0.48616 0.46192 0.43728 0.41255 0.38794 ; ...
         0.51256 0.48493 0.45766 0.43052 0.40406 ; ...
         0.53235 0.50251 0.47393 0.44517 0.41818 ; ...
         0.54794 0.51694 0.48784 0.4585  0.43294 ; ...
         0.56239 0.53052 0.502   0.47184 0.44509 ];
Cdi_HF = [0.01214 0.01092 0.00976 0.00868 0.00769 ; ...
          0.01123 0.01005 0.00897 0.00799 0.00711 ; ...
          0.01043 0.00934 0.0084  0.00752 0.00676 ; ...
          0.00984 0.00888 0.00804 0.00727 0.00664 ;...
          0.00952 0.00865 0.00791 0.00722 0.00664];
VMmax_HF = [222841200.0 221989100.0 220579600.0 218602300.0 216078500.0 ; ...
            249871800.0 245977800.0 241513400.0 237008900.0 231741500.0 ; ...
            268489900.0 261782300.0 254950400.0 247669300.0 239750200.0 ; ...
            278631000.0 269678200.0 259784400.0 251620600.0 240557200.0 ; ...
            280045500.0 270227700.0 258602300.0 250077100.0 239870700.0];
        
tip_HF = [6.322033 6.377827 6.442270000000001 6.516778 6.6015880000000005; ...
          6.889536 6.941067 7.001331 7.077374000000001 7.163886          ; ...
          7.482111 7.5216270000000005 7.57485  7.639595 7.71495          ; ...
          8.059486 8.0822 8.10711 8.172936 8.213596                      ; ...
          8.569942000000001 8.583867 8.583945 8.651702 8.710313 ];
      
%plot
xtlblstr = sprintf('-5\n -2.5\n 0\n 2.5\n 5\n');
xtlbls = regexp(xtlblstr, '\n', 'split');
ytlblstr = sprintf('-10\n -5\n 0\n 5\n 10\n');
ytlbls = regexp(ytlblstr, '\n', 'split');


figure()
h1 = surf(s,b,Cl_LF,'EdgeColor', 'black', 'FaceColor',[0.9290 0.6940 0.1250] , 'FaceAlpha', .5, 'Marker', '.' );
hold on
h2 = surf(s,b,Cl_HF,'EdgeColor', 'black', 'FaceColor', [0 0.4470 0.7410], 'FaceAlpha', .5, 'Marker', '.' );
xlabel(['$ \Delta$ Sweep angle [$^{\circ}$]'],'Interpreter','latex')
ylabel('$ \Delta$ Wing span [m]','Interpreter','latex')
zlabel('Cl','Interpreter','latex')
set(gca, 'XTick', s, 'XTickLabel', xtlbls)
set(gca, 'YTick', b, 'YTickLabel', ytlbls)
legend([h1, h2], {'LF', 'HF'});
xlim([30 45])
ylim([45 70])


ztlblstr = sprintf('0.005\n 0.007\n 0.009\n 0.011\n 0.013\n');
ztlbls = regexp(ztlblstr, '\n', 'split');

figure()
h3 = surf(s,b,Cdi_LF,'EdgeColor', 'black', 'FaceColor',[0.9290 0.6940 0.1250] , 'FaceAlpha', .5, 'Marker', '.' );
hold on
h4 = surf(s,b,Cdi_HF,'EdgeColor', 'black', 'FaceColor', [0 0.4470 0.7410], 'FaceAlpha', .5, 'Marker', '.' );
xlabel('$ \Delta$ Sweep angle [$^{\circ}$]','Interpreter','latex')
ylabel('$ \Delta$ Wing span [m]','Interpreter','latex')
zlabel('Cdi','Interpreter','latex')
set(gca, 'XTick', s, 'XTickLabel', xtlbls)
set(gca, 'YTick', b, 'YTickLabel', ytlbls)
set(gca, 'ZTick',[0.005:0.002:0.013], 'ZTickLabel', ztlbls)
legend([h3, h4], {'LF', 'HF'});
xlim([30 45])
ylim([45 70])

figure()
h5 = surf(s,b,VMmax_LF/10^6,'EdgeColor', 'black', 'FaceColor',[0.9290 0.6940 0.1250] , 'FaceAlpha', .5, 'Marker', '.' );
hold on
h6 = surf(s,b,VMmax_HF/10^6,'EdgeColor', 'black', 'FaceColor', [0 0.4470 0.7410], 'FaceAlpha', .5, 'Marker', '.' );
xlabel('$ \Delta$ Sweep angle [$^{\circ}$]','Interpreter','latex')
ylabel('$ \Delta$ Wing span [m]','Interpreter','latex')
zlabel('VM [MPa]','Interpreter','latex')
set(gca, 'XTick', s, 'XTickLabel', xtlbls)
set(gca, 'YTick', b, 'YTickLabel', ytlbls)
legend([h5, h6], {'LF', 'HF'});
xlim([30 45])
ylim([45 70])
zlim([200 290])


figure()
h7 = surf(s,b,tip_LF,'EdgeColor', 'black', 'FaceColor',[0.9290 0.6940 0.1250], 'FaceAlpha', .5, 'Marker', '.' );
hold on
h8 = surf(s,b,tip_HF,'EdgeColor', 'black', 'FaceColor',  [0 0.4470 0.7410], 'FaceAlpha', .5, 'Marker', '.' );
xlabel('$ \Delta$ Sweep angle [$^{\circ}$]','Interpreter','latex')
ylabel('$ \Delta$ Wing span [m]','Interpreter','latex')
zlabel('Tip displacement [m]','Interpreter','latex')
set(gca, 'XTick', s, 'XTickLabel', xtlbls)
set(gca, 'YTick', b, 'YTickLabel', ytlbls)
legend([h7, h8], {'LF', 'HF'});
xlim([30 45])
ylim([45 70])



% corr
Cov_cl = corrcoef(normalize(Cl_LF),normalize(Cl_HF))
Cov_cd = corrcoef(normalize(Cdi_LF),normalize(Cdi_HF))
Cov_vm = corrcoef(normalize(VMmax_LF),normalize(VMmax_HF))
Cov_tip = corrcoef(normalize(tip_LF),normalize(tip_HF))

Max_cl = max(max(abs(Cl_LF-Cl_HF)))/Cl_HF(3,3)*100
Max_cdi = max(max(abs(Cdi_LF-Cdi_HF)))/Cdi_HF(3,3)*100
Max_VM = max(max(abs(VMmax_LF-VMmax_HF)))/VMmax_HF(3,3)*100
Max_tip = max(max(abs(tip_LF-tip_HF)))/tip_HF(3,3)*100

min_cl = min(min(abs(Cl_LF-Cl_HF)))/Cl_HF(3,3)*100
min_cdi = min(min(abs(Cdi_LF-Cdi_HF)))/Cdi_HF(3,3)*100
min_VM = min(min(abs(VMmax_LF-VMmax_HF)))/VMmax_HF(3,3)*100
min_tip = min(min(abs(tip_LF-tip_HF)))/tip_HF(3,3)*100




