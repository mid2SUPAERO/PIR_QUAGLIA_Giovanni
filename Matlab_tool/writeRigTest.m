function writeRigTest(NODES,SECTION,L,V,step,varargin)

fid = fopen('prop.txt', 'r');
%Initialisation

nB = floor(56/step);

cquad = 0;
cbar = 0;
crod = 0;
ctria = 0;

for i = 1:size(varargin,2)
    if strcmp(inputname(i+5),'CQUAD')
        cquad = 1;
        CQUAD = varargin{i};
    end
    if strcmp(inputname(i+5),'CBAR')
        cbar = 1;
        CBAR = varargin{i};
    end
    if strcmp(inputname(i+5),'CROD')
        crod = 1;
        CROD = varargin{i};
    end
    if strcmp(inputname(i+5),'CTRIA')
        ctria = 1;
        CTRIA = varargin{i};
    end
end

%%write

fid2 = fopen('LF_rigidityTest.inp','wt');

fprintf(fid2,'ID CRM WING\n');
fprintf(fid2,'SOL 1\n');
fprintf(fid2,'CEND\n');
fprintf(fid2,'MAXLINES=99999999\n');
fprintf(fid2,'TITLE=crm_reference_mda\n');
fprintf(fid2,'SET 1 = 7000 THRU %d\n',7000+nB);
fprintf(fid2,'DISP(PUNCH) = 1\n\n');

fprintf(fid2,'MPC = 20000\n');
fprintf(fid2,'SPC = 1\n');

k = 1;
for i = 1:nB
    for j = 1:6
        fprintf(fid2,'SUBCASE %d\n',k);
        fprintf(fid2,'LOAD = %d\n',200+k);
        k = k + 1;
    end
end

fprintf(fid2,'\nBEGIN BULK\n');
fprintf(fid2,'PARAM,AUTOSPC,1\n');
fprintf(fid2,'PARAM,GRDPNT,7000\n\n');


fprintf(fid2,'MAT1,1,6.89E+10,,.31,2795.67\n');
fprintf(fid2,'MAT1,2,6.89E+10,,.31,2795.67\n\n');


i = 1;
while ~feof(fid)
rline = textscan(fid,'%s',1,'delimiter','\n');
a = string(rline);
fprintf(fid2,'%s\n',a);
i = i + 1;
end
fclose(fid);
fprintf(fid2,'\n');

k = 1;
for i = 1:nB
    for j = 1:6
        fprintf(fid2,'LOAD,%d,1.0,1.0,%d\n',200+k,300+k);
        k = k + 1;
    end
end

k = 1;
for i = 1:nB
    
    fprintf(fid2,'FORCE,%d,%d,0,1.0,1.0,0.0,0.0\n',300+k,7000+i);
    k = k + 1;
    fprintf(fid2,'FORCE,%d,%d,0,1.0,0.0,1.0,0.0\n',300+k,7000+i);
    k = k + 1;
    fprintf(fid2,'FORCE,%d,%d,0,1.0,0.0,0.0,1.0\n',300+k,7000+i);
    k = k + 1;
    fprintf(fid2,'MOMENT,%d,%d,0,1.0,1.0,0.0,0.0\n',300+k,7000+i);
    k = k + 1;
    fprintf(fid2,'MOMENT,%d,%d,0,1.0,0.0,1.0,0.0\n',300+k,7000+i);
    k = k + 1;
    fprintf(fid2,'MOMENT,%d,%d,0,1.0,0.0,0.0,1.0\n',300+k,7000+i);
    k = k + 1;
end

fprintf(fid2,'\n$,Nodes,of,the,Entire,Model\n');

for i = 1 : size(NODES.ID,2)
    fprintf(fid2,'GRID,%d,,{x%d},{y%d},{z%d}\n',NODES.ID(i),NODES.ID(i),...
        NODES.ID(i),NODES.ID(i));
end

fprintf(fid2,'\n$List of elements\n');

n = 1;
if cquad
    for i = 1 : size(CQUAD,2)
        fprintf(fid2,'CQUAD4,%d,%d,%d,%d,%d,%d\n',n,CQUAD(i).P,...
            CQUAD(i).n1,CQUAD(i).n2,CQUAD(i).n3,CQUAD(i).n4);
        n = n + 1;
    end
end

if ctria
    for i = 1 : size(CTRIA.P,2)
        fprintf(fid2,'CTRIA3,%d,%d,%d,%d,%d\n',n,CTRIA.P(i),...
            CTRIA.n1(i),CTRIA.n2(i),CTRIA.n3(i));
        n = n + 1;
    end
end

if crod
    for i = 1 : size(CROD,2)
        fprintf(fid2,'CROD,%d,%d,%d,%d\n',n,CROD(i).P,...
            CROD(i).n1,CROD(i).n2);
        n = n + 1;
    end
end

if cbar
    for j = 1 : size(CBAR,2)
        fprintf(fid2,'CBAR,%d,%d,%d,%d,%#.1E,%#.1E,%#.1E\n',n,CBAR(j).P,...
            CBAR(j).n1,CBAR(j).n2,CBAR(j).v1,CBAR(j).v2,CBAR(j).v3);
        n = n + 1;
    end
end

%displacement constraint


fprintf(fid2,'\n');
fprintf(fid2,'$,Displacement,Constraints,of,Load,Set,:,spc1.1\n');
fprintf(fid2,'\n');

fprintf(fid2,'SPC1,1,123,%d,THRU,%d\n',SECTION(1).ID(1),...
    SECTION(1).ID(end));
fprintf(fid2,'SPC1,1,123,%d,THRU,%d\n',SECTION(6).ID(1),...
    SECTION(6).ID(L));
fprintf(fid2,'SPC1,1,123,%d,THRU,%d\n',SECTION(6).ID(end-L+1),...
    SECTION(6).ID(end));


%% add nodes

for i = 1:nB+1
    fprintf(fid2,'GRID,%d,,{x%d},{y%d},{z%d}\n',6999+i,6999+i,...
        6999+i,6999+i);
end

%% MPC
kk = 1;
for i = 1:nB
    fprintf(fid2,'MPC,20000,%d,1,-10.,%d,1,1.,,+%d\n',6999+i,SECTION(1+step*(i-1)).ID(1),36*(kk-1)+2);
    fprintf(fid2,'+%d,,%d,1,1.,%d,1,1.,,+%d\n',36*(kk-1)+2,SECTION(1+step*(i-1)).ID(2),SECTION(1+step*(i-1)).ID(3),36*(kk-1)+3);
    fprintf(fid2,'+%d,,%d,1,1.,%d,1,1.,,+%d\n',36*(kk-1)+3,SECTION(1+step*(i-1)).ID(4),SECTION(1+step*(i-1)).ID(5),36*(kk-1)+4);
    fprintf(fid2,'+%d,,%d,1,1.,%d,1,1.,,+%d\n',36*(kk-1)+4,SECTION(1+step*(i-1)).ID(8),SECTION(1+step*(i-1)).ID(9),36*(kk-1)+5);
    fprintf(fid2,'+%d,,%d,1,1.,%d,1,1.,,+%d\n',36*(kk-1)+5,SECTION(1+step*(i-1)).ID(10),SECTION(1+step*(i-1)).ID(11),36*(kk-1)+6);
    fprintf(fid2,'+%d,,%d,1,1.,,,,,\n',36*(kk-1)+6,SECTION(1+step*(i-1)).ID(12));
    fprintf(fid2,'MPC,20000,%d,2,-10.,%d,2,1.,,+%d\n',6999+i,SECTION(1+step*(i-1)).ID(1),36*(kk-1)+8);
    fprintf(fid2,'+%d,,%d,2,1.,%d,2,1.,,+%d\n',36*(kk-1)+8,SECTION(1+step*(i-1)).ID(2),SECTION(1+step*(i-1)).ID(3),36*(kk-1)+9);
    fprintf(fid2,'+%d,,%d,2,1.,%d,2,1.,,+%d\n',36*(kk-1)+9,SECTION(1+step*(i-1)).ID(4),SECTION(1+step*(i-1)).ID(5),36*(kk-1)+10);
    fprintf(fid2,'+%d,,%d,2,1.,%d,2,1.,,+%d\n',36*(kk-1)+10,SECTION(1+step*(i-1)).ID(8),SECTION(1+step*(i-1)).ID(9),36*(kk-1)+11);
    fprintf(fid2,'+%d,,%d,2,1.,%d,2,1.,,+%d\n',36*(kk-1)+11,SECTION(1+step*(i-1)).ID(10),SECTION(1+step*(i-1)).ID(11),36*(kk-1)+12);
    fprintf(fid2,'+%d,,%d,2,1.,,,,,\n',36*(kk-1)+12,SECTION(1+step*(i-1)).ID(12));
    fprintf(fid2,'MPC,20000,%d,3,-10.,%d,3,1.,,+%d\n',6999+i,SECTION(1+step*(i-1)).ID(1),36*(kk-1)+14);
    fprintf(fid2,'+%d,,%d,3,1.,%d,3,1.,,+%d\n',36*(kk-1)+14,SECTION(1+step*(i-1)).ID(2),SECTION(1+step*(i-1)).ID(3),36*(kk-1)+15);
    fprintf(fid2,'+%d,,%d,3,1.,%d,3,1.,,+%d\n',36*(kk-1)+15,SECTION(1+step*(i-1)).ID(4),SECTION(1+step*(i-1)).ID(5),36*(kk-1)+16);
    fprintf(fid2,'+%d,,%d,3,1.,%d,3,1.,,+%d\n',36*(kk-1)+16,SECTION(1+step*(i-1)).ID(8),SECTION(1+step*(i-1)).ID(9),36*(kk-1)+17);
    fprintf(fid2,'+%d,,%d,3,1.,%d,3,1.,,+%d\n',36*(kk-1)+17,SECTION(1+step*(i-1)).ID(10),SECTION(1+step*(i-1)).ID(11),36*(kk-1)+18);
    fprintf(fid2,'+%d,,%d,3,1.,,,,,\n',36*(kk-1)+18,SECTION(1+step*(i-1)).ID(12));
    fprintf(fid2,'MPC,20000,%d,4,-10.,%d,4,1.,,+%d\n',6999+i,SECTION(1+step*(i-1)).ID(1),36*(kk-1)+20);
    fprintf(fid2,'+%d,,%d,4,1.,%d,4,1.,,+%d\n',36*(kk-1)+20,SECTION(1+step*(i-1)).ID(2),SECTION(1+step*(i-1)).ID(3),36*(kk-1)+21);
    fprintf(fid2,'+%d,,%d,4,1.,%d,4,1.,,+%d\n',36*(kk-1)+21,SECTION(1+step*(i-1)).ID(4),SECTION(1+step*(i-1)).ID(5),36*(kk-1)+22);
    fprintf(fid2,'+%d,,%d,4,1.,%d,4,1.,,+%d\n',36*(kk-1)+22,SECTION(1+step*(i-1)).ID(8),SECTION(1+step*(i-1)).ID(9),36*(kk-1)+23);
    fprintf(fid2,'+%d,,%d,4,1.,%d,4,1.,,+%d\n',36*(kk-1)+23,SECTION(1+step*(i-1)).ID(10),SECTION(1+step*(i-1)).ID(11),36*(kk-1)+24);
    fprintf(fid2,'+%d,,%d,4,1.,,,,,\n',36*(kk-1)+24,SECTION(1+step*(i-1)).ID(12));
    fprintf(fid2,'MPC,20000,%d,5,-10.,%d,5,1.,,+%d\n',6999+i,SECTION(1+step*(i-1)).ID(1),36*(kk-1)+26);
    fprintf(fid2,'+%d,,%d,5,1.,%d,5,1.,,+%d\n',36*(kk-1)+26,SECTION(1+step*(i-1)).ID(2),SECTION(1+step*(i-1)).ID(3),36*(kk-1)+27);
    fprintf(fid2,'+%d,,%d,5,1.,%d,5,1.,,+%d\n',36*(kk-1)+27,SECTION(1+step*(i-1)).ID(4),SECTION(1+step*(i-1)).ID(5),36*(kk-1)+28);
    fprintf(fid2,'+%d,,%d,5,1.,%d,5,1.,,+%d\n',36*(kk-1)+28,SECTION(1+step*(i-1)).ID(8),SECTION(1+step*(i-1)).ID(9),36*(kk-1)+29);
    fprintf(fid2,'+%d,,%d,5,1.,%d,5,1.,,+%d\n',36*(kk-1)+29,SECTION(1+step*(i-1)).ID(10),SECTION(1+step*(i-1)).ID(11),36*(kk-1)+30);
    fprintf(fid2,'+%d,,%d,5,1.,,,,,\n',36*(kk-1)+30,SECTION(1+step*(i-1)).ID(12));
    fprintf(fid2,'MPC,20000,%d,6,-10.,%d,6,1.,,+%d\n',6999+i,SECTION(1+step*(i-1)).ID(1),36*(kk-1)+32);
    fprintf(fid2,'+%d,,%d,6,1.,%d,6,1.,,+%d\n',36*(kk-1)+32,SECTION(1+step*(i-1)).ID(2),SECTION(1+step*(i-1)).ID(3),36*(kk-1)+33);
    fprintf(fid2,'+%d,,%d,6,1.,%d,6,1.,,+%d\n',36*(kk-1)+33,SECTION(1+step*(i-1)).ID(4),SECTION(1+step*(i-1)).ID(5),36*(kk-1)+34);
    fprintf(fid2,'+%d,,%d,6,1.,%d,6,1.,,+%d\n',36*(kk-1)+34,SECTION(1+step*(i-1)).ID(8),SECTION(1+step*(i-1)).ID(9),36*(kk-1)+35);
    fprintf(fid2,'+%d,,%d,6,1.,%d,6,1.,,+%d\n',36*(kk-1)+35,SECTION(1+step*(i-1)).ID(10),SECTION(1+step*(i-1)).ID(11),36*(kk-1)+36);
    fprintf(fid2,'+%d,,%d,6,1.,,,,,\n',36*(kk-1)+36,SECTION(1+step*(i-1)).ID(12));
    kk = kk + 1;
end

fprintf(fid2,'MPC,20000,%d,1,-10.,%d,1,1.,,+%d\n',7000+nB,SECTION(end).ID(1),36*(kk-1)+2);
fprintf(fid2,'+%d,,%d,1,1.,%d,1,1.,,+%d\n',36*(kk-1)+2,SECTION(end).ID(2),SECTION(end).ID(3),36*(kk-1)+3);
fprintf(fid2,'+%d,,%d,1,1.,%d,1,1.,,+%d\n',36*(kk-1)+3,SECTION(end).ID(4),SECTION(end).ID(5),36*(kk-1)+4);
fprintf(fid2,'+%d,,%d,1,1.,%d,1,1.,,+%d\n',36*(kk-1)+4,SECTION(end).ID(8),SECTION(end).ID(9),36*(kk-1)+5);
fprintf(fid2,'+%d,,%d,1,1.,%d,1,1.,,+%d\n',36*(kk-1)+5,SECTION(end).ID(10),SECTION(end).ID(11),36*(kk-1)+6);
fprintf(fid2,'+%d,,%d,1,1.,,,,,\n',36*(kk-1)+6,SECTION(end).ID(12));
fprintf(fid2,'MPC,20000,%d,2,-10.,%d,2,1.,,+%d\n',7000+nB,SECTION(end).ID(1),36*(kk-1)+8);
fprintf(fid2,'+%d,,%d,2,1.,%d,2,1.,,+%d\n',36*(kk-1)+8,SECTION(end).ID(2),SECTION(end).ID(3),36*(kk-1)+9);
fprintf(fid2,'+%d,,%d,2,1.,%d,2,1.,,+%d\n',36*(kk-1)+9,SECTION(end).ID(4),SECTION(end).ID(5),36*(kk-1)+10);
fprintf(fid2,'+%d,,%d,2,1.,%d,2,1.,,+%d\n',36*(kk-1)+10,SECTION(end).ID(8),SECTION(end).ID(9),36*(kk-1)+11);
fprintf(fid2,'+%d,,%d,2,1.,%d,2,1.,,+%d\n',36*(kk-1)+11,SECTION(end).ID(10),SECTION(end).ID(11),36*(kk-1)+12);
fprintf(fid2,'+%d,,%d,2,1.,,,,,\n',36*(kk-1)+12,SECTION(end).ID(12));
fprintf(fid2,'MPC,20000,%d,3,-10.,%d,3,1.,,+%d\n',7000+nB,SECTION(end).ID(1),36*(kk-1)+14);
fprintf(fid2,'+%d,,%d,3,1.,%d,3,1.,,+%d\n',36*(kk-1)+14,SECTION(end).ID(2),SECTION(end).ID(3),36*(kk-1)+15);
fprintf(fid2,'+%d,,%d,3,1.,%d,3,1.,,+%d\n',36*(kk-1)+15,SECTION(end).ID(4),SECTION(end).ID(5),36*(kk-1)+16);
fprintf(fid2,'+%d,,%d,3,1.,%d,3,1.,,+%d\n',36*(kk-1)+16,SECTION(end).ID(8),SECTION(end).ID(9),36*(kk-1)+17);
fprintf(fid2,'+%d,,%d,3,1.,%d,3,1.,,+%d\n',36*(kk-1)+17,SECTION(end).ID(10),SECTION(end).ID(11),36*(kk-1)+18);
fprintf(fid2,'+%d,,%d,3,1.,,,,,\n',36*(kk-1)+18,SECTION(end).ID(12));
fprintf(fid2,'MPC,20000,%d,4,-10.,%d,4,1.,,+%d\n',7000+nB,SECTION(end).ID(1),36*(kk-1)+20);
fprintf(fid2,'+%d,,%d,4,1.,%d,4,1.,,+%d\n',36*(kk-1)+20,SECTION(end).ID(2),SECTION(end).ID(3),36*(kk-1)+21);
fprintf(fid2,'+%d,,%d,4,1.,%d,4,1.,,+%d\n',36*(kk-1)+21,SECTION(end).ID(4),SECTION(end).ID(5),36*(kk-1)+22);
fprintf(fid2,'+%d,,%d,4,1.,%d,4,1.,,+%d\n',36*(kk-1)+22,SECTION(end).ID(8),SECTION(end).ID(9),36*(kk-1)+23);
fprintf(fid2,'+%d,,%d,4,1.,%d,4,1.,,+%d\n',36*(kk-1)+23,SECTION(end).ID(10),SECTION(end).ID(11),36*(kk-1)+24);
fprintf(fid2,'+%d,,%d,4,1.,,,,,\n',36*(kk-1)+24,SECTION(end).ID(12));
fprintf(fid2,'MPC,20000,%d,5,-10.,%d,5,1.,,+%d\n',7000+nB,SECTION(end).ID(1),36*(kk-1)+26);
fprintf(fid2,'+%d,,%d,5,1.,%d,5,1.,,+%d\n',36*(kk-1)+26,SECTION(end).ID(2),SECTION(end).ID(3),36*(kk-1)+27);
fprintf(fid2,'+%d,,%d,5,1.,%d,5,1.,,+%d\n',36*(kk-1)+27,SECTION(end).ID(4),SECTION(end).ID(5),36*(kk-1)+28);
fprintf(fid2,'+%d,,%d,5,1.,%d,5,1.,,+%d\n',36*(kk-1)+28,SECTION(end).ID(8),SECTION(end).ID(9),36*(kk-1)+29);
fprintf(fid2,'+%d,,%d,5,1.,%d,5,1.,,+%d\n',36*(kk-1)+29,SECTION(end).ID(10),SECTION(end).ID(11),36*(kk-1)+30);
fprintf(fid2,'+%d,,%d,5,1.,,,,,\n',36*(kk-1)+30,SECTION(end).ID(12));
fprintf(fid2,'MPC,20000,%d,6,-10.,%d,6,1.,,+%d\n',7000+nB,SECTION(end).ID(1),36*(kk-1)+32);
fprintf(fid2,'+%d,,%d,6,1.,%d,6,1.,,+%d\n',36*(kk-1)+32,SECTION(end).ID(2),SECTION(end).ID(3),36*(kk-1)+33);
fprintf(fid2,'+%d,,%d,6,1.,%d,6,1.,,+%d\n',36*(kk-1)+33,SECTION(end).ID(4),SECTION(end).ID(5),36*(kk-1)+34);
fprintf(fid2,'+%d,,%d,6,1.,%d,6,1.,,+%d\n',36*(kk-1)+34,SECTION(end).ID(8),SECTION(end).ID(9),36*(kk-1)+35);
fprintf(fid2,'+%d,,%d,6,1.,%d,6,1.,,+%d\n',36*(kk-1)+35,SECTION(end).ID(10),SECTION(end).ID(11),36*(kk-1)+36);
fprintf(fid2,'+%d,,%d,6,1.,,,,,\n',36*(kk-1)+36,SECTION(end).ID(12));

fprintf(fid2,'ENDDATA\n');
fclose(fid2);
end