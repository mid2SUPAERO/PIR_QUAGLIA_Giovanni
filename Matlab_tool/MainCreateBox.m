clearvars
close all
clc

load FP

V = 3;
L = 4;


%NODES
[NODES,SECTION] = CreateNodes(FP,V,L);

%%
%ELEMENTS
[CQUAD CROD] = ElLong (SECTION,L,V);
CQUAD = [CQUAD ElSkin(SECTION,L,V)];
CQUAD = [CQUAD ElRib(SECTION,L,V)];
CTRIA = ElTria(SECTION,L,V);
CBAR = ElStr(SECTION,NODES,L,V);
%%
for i = 1:56
[t(i,:),r(i),b(i)] = writeInpBox(NODES,SECTION,L,V,i,CTRIA,CQUAD,CROD,CBAR);
end