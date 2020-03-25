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
writeRigTest(NODES,SECTION,L,V,5,CTRIA,CQUAD,CROD,CBAR);


