function [t,r,b] = writeInpBox(NODES,SECTION,L,V,box,varargin)
fid = fopen('NastranStaticTemplateBox.txt', 'r');
fid2 = fopen("nastran_static_template" + num2str(box) + ".inp",'wt');

cquad = 0;
cbar = 0;
crod = 0;
ctria = 0;


rod = 0;
bar = 0;
t1 = 0;
t2 = 0;

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

%copy template

i = 1;
while ~feof(fid)
rline = textscan(fid,'%s',1,'delimiter','\n');
a = string(rline);
fprintf(fid2,'%s\n',a);
i = i + 1;
end
fclose(fid);
fprintf(fid2,'\n');


%add elements if box != 56

fprintf(fid2,'\n$Case parameters\n');
fprintf(fid2,'$,L,%d,V,%d\n',L,V);

if  (box ~= 56)
fprintf(fid2,'\n$,Nodes,of,the,Box,Model\n');

for i = 1+12*(box-1) : 1+12*(box-1)+23
        fprintf(fid2,'GRID,%d,,{x%d},{y%d},{z%d}\n',NODES.ID(i),NODES.ID(i),...
            NODES.ID(i),NODES.ID(i));
end
fprintf(fid2,'GRID,%d,,{x%d},{y%d},{z%d}\n',7000,7000,...
            7000,7000);

fprintf(fid2,'\n$List of elements\n');

n = 1;
if cquad
for i = 1+4*(box-1) : 1+4*(box-1)+3
        fprintf(fid2,'CQUAD4,%d,%d,%d,%d,%d,%d\n',n,CQUAD(i).P,...
            CQUAD(i).n1,CQUAD(i).n2,CQUAD(i).n3,CQUAD(i).n4);
        n = n + 1;
        if t1 == 0
            t(1) = CQUAD(i).P-1;
            t1 = 1;
        end
end
for i = 227+6*(box-1) : 227+6*(box-1)+5
        fprintf(fid2,'CQUAD4,%d,%d,%d,%d,%d,%d\n',n,CQUAD(i).P,...
            CQUAD(i).n1,CQUAD(i).n2,CQUAD(i).n3,CQUAD(i).n4);
        n = n + 1;
        if t2 == 0
            t(2) = CQUAD(i).P-1;
            t2 = 1;
        end
end
for i = 565+6*(box-1) : 565+6*(box-1)+11
        fprintf(fid2,'CQUAD4,%d,%d,%d,%d,%d,%d\n',n,CQUAD(i).P,...
            CQUAD(i).n1,CQUAD(i).n2,CQUAD(i).n3,CQUAD(i).n4);
        n = n + 1;
end
end

if crod
for i = 1+4*(box-1) : 1+4*(box-1)+3
        fprintf(fid2,'CROD,%d,%d,%d,%d\n',n,CROD(i).P,...
            CROD(i).n1,CROD(i).n2);
        n = n + 1;
        if rod == 0
            r = CROD(i).P-13;
            rod = 1;
        end
end
end

if cbar
for j = 1+6*(box-1) : 1+6*(box-1)+11
         fprintf(fid2,'CBAR,%d,%d,%d,%d,%#.1E,%#.1E,%#.1E\n',n,CBAR(j).P,...
            CBAR(j).n1,CBAR(j).n2,CBAR(j).v1,CBAR(j).v2,CBAR(j).v3);
         n = n + 1;
end
for j = 347+8*(box-1) : 347+8*(box-1)+15
         fprintf(fid2,'CBAR,%d,%d,%d,%d,%#.1E,%#.1E,%#.1E\n',n,CBAR(j).P,...
            CBAR(j).n1,CBAR(j).n2,CBAR(j).v1,CBAR(j).v2,CBAR(j).v3);
         n = n + 1;
end
for j = 807+4*(box-1) : 807+4*(box-1)+3
         fprintf(fid2,'CBAR,%d,%d,%d,%d,%#.1E,%#.1E,%#.1E\n',n,CBAR(j).P,...
            CBAR(j).n1,CBAR(j).n2,CBAR(j).v1,CBAR(j).v2,CBAR(j).v3);
         n = n + 1;
        if bar == 0
            b = CBAR(j).P-30;
            bar = 1;
        end
end
end

%displacement constraint


% fprintf(fid2,'\n');
% fprintf(fid2,'$,Displacement,Constraints,of,Load,Set,:,spc1.1\n');
% fprintf(fid2,'\n');
% 
% fprintf(fid2,'SPC1,1,123456,%d,THRU,%d\n',SECTION(box).ID(1),...
%     SECTION(box).ID(end));
% fprintf(fid2,'MPC,2000,7000,1,-10.,%d,1,1.,,+2\n',SECTION(box+1).ID(1));
% fprintf(fid2,'+2,,%d,1,1.,%d,1,1.,,+3\n',SECTION(box+1).ID(2),SECTION(box+1).ID(3));
% fprintf(fid2,'+3,,%d,1,1.,%d,1,1.,,+4\n',SECTION(box+1).ID(4),SECTION(box+1).ID(5));
% fprintf(fid2,'+4,,%d,1,1.,%d,1,1.,,+5\n',SECTION(box+1).ID(8),SECTION(box+1).ID(9));
% fprintf(fid2,'+5,,%d,1,1.,%d,1,1.,,+6\n',SECTION(box+1).ID(10),SECTION(box+1).ID(11));
% fprintf(fid2,'+6,,%d,1,1.,,,,,\n',SECTION(box+1).ID(12));
% fprintf(fid2,'MPC,2000,7000,2,-10.,%d,2,1.,,+8\n',SECTION(box+1).ID(1));
% fprintf(fid2,'+8,,%d,2,1.,%d,2,1.,,+9\n',SECTION(box+1).ID(2),SECTION(box+1).ID(3));
% fprintf(fid2,'+9,,%d,2,1.,%d,2,1.,,+10\n',SECTION(box+1).ID(4),SECTION(box+1).ID(5));
% fprintf(fid2,'+10,,%d,2,1.,%d,2,1.,,+11\n',SECTION(box+1).ID(8),SECTION(box+1).ID(9));
% fprintf(fid2,'+11,,%d,2,1.,%d,2,1.,,+12\n',SECTION(box+1).ID(10),SECTION(box+1).ID(11));
% fprintf(fid2,'+12,,%d,2,1.,,,,,\n',SECTION(box+1).ID(12));
% fprintf(fid2,'MPC,2000,7000,3,-10.,%d,3,1.,,+14\n',SECTION(box+1).ID(1));
% fprintf(fid2,'+14,,%d,3,1.,%d,3,1.,,+15\n',SECTION(box+1).ID(2),SECTION(box+1).ID(3));
% fprintf(fid2,'+15,,%d,3,1.,%d,3,1.,,+16\n',SECTION(box+1).ID(4),SECTION(box+1).ID(5));
% fprintf(fid2,'+16,,%d,3,1.,%d,3,1.,,+17\n',SECTION(box+1).ID(8),SECTION(box+1).ID(9));
% fprintf(fid2,'+17,,%d,3,1.,%d,3,1.,,+18\n',SECTION(box+1).ID(10),SECTION(box+1).ID(11));
% fprintf(fid2,'+18,,%d,3,1.,,,,,\n',SECTION(box+1).ID(12));
% fprintf(fid2,'MPC,2000,7000,4,-10.,%d,4,1.,,+20\n',SECTION(box+1).ID(1));
% fprintf(fid2,'+20,,%d,4,1.,%d,4,1.,,+21\n',SECTION(box+1).ID(2),SECTION(box+1).ID(3));
% fprintf(fid2,'+21,,%d,4,1.,%d,4,1.,,+22\n',SECTION(box+1).ID(4),SECTION(box+1).ID(5));
% fprintf(fid2,'+22,,%d,4,1.,%d,4,1.,,+23\n',SECTION(box+1).ID(8),SECTION(box+1).ID(9));
% fprintf(fid2,'+23,,%d,4,1.,%d,4,1.,,+24\n',SECTION(box+1).ID(10),SECTION(box+1).ID(11));
% fprintf(fid2,'+24,,%d,4,1.,,,,,\n',SECTION(box+1).ID(12));
% fprintf(fid2,'MPC,2000,7000,5,-10.,%d,5,1.,,+26\n',SECTION(box+1).ID(1));
% fprintf(fid2,'+26,,%d,5,1.,%d,5,1.,,+27\n',SECTION(box+1).ID(2),SECTION(box+1).ID(3));
% fprintf(fid2,'+27,,%d,5,1.,%d,5,1.,,+28\n',SECTION(box+1).ID(4),SECTION(box+1).ID(5));
% fprintf(fid2,'+28,,%d,5,1.,%d,5,1.,,+29\n',SECTION(box+1).ID(8),SECTION(box+1).ID(9));
% fprintf(fid2,'+29,,%d,5,1.,%d,5,1.,,+30\n',SECTION(box+1).ID(10),SECTION(box+1).ID(11));
% fprintf(fid2,'+30,,%d,5,1.,,,,,\n',SECTION(box+1).ID(12));
% fprintf(fid2,'MPC,2000,7000,6,-10.,%d,6,1.,,+32\n',SECTION(box+1).ID(1));
% fprintf(fid2,'+32,,%d,6,1.,%d,6,1.,,+33\n',SECTION(box+1).ID(2),SECTION(box+1).ID(3));
% fprintf(fid2,'+33,,%d,6,1.,%d,6,1.,,+34\n',SECTION(box+1).ID(4),SECTION(box+1).ID(5));
% fprintf(fid2,'+34,,%d,6,1.,%d,6,1.,,+35\n',SECTION(box+1).ID(8),SECTION(box+1).ID(9));
% fprintf(fid2,'+35,,%d,6,1.,%d,6,1.,,+36\n',SECTION(box+1).ID(10),SECTION(box+1).ID(11));
% fprintf(fid2,'+36,,%d,6,1.,,,,,\n',SECTION(box+1).ID(12));
%end data
fprintf(fid2,'ENDDATA\n');


%last wingbox case
else
    
for i = 1+12*(box-1) : size(NODES.ID,2)
        fprintf(fid2,'GRID,%d,,{x%d},{y%d},{z%d}\n',NODES.ID(i),NODES.ID(i),...
            NODES.ID(i),NODES.ID(i));
end
fprintf(fid2,'GRID,%d,,{x%d},{y%d},{z%d}\n',7000,7000,...
            7000,7000);

fprintf(fid2,'\n$List of elements\n');

n = 1;
if cquad
for i = 1+4*(box-1) : 1+4*(box-1)+5
        fprintf(fid2,'CQUAD4,%d,%d,%d,%d,%d,%d\n',n,CQUAD(i).P,...
            CQUAD(i).n1,CQUAD(i).n2,CQUAD(i).n3,CQUAD(i).n4);
        n = n + 1;
                if t1 == 0
            t(1) = CQUAD(i).P-1;
            t1 = 1;
        end
end
for i = 227+6*(box-1) : 227+6*(box-1)+7
        fprintf(fid2,'CQUAD4,%d,%d,%d,%d,%d,%d\n',n,CQUAD(i).P,...
            CQUAD(i).n1,CQUAD(i).n2,CQUAD(i).n3,CQUAD(i).n4);
        n = n + 1;
                if t2 == 0
            t(2) = CQUAD(i).P-1;
            t2 = 1;
        end
end
for i = 565+6*(box-1) : 565+6*(box-1)+15
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
for i = 1+4*(box-1) : 1+4*(box-1)+5
        fprintf(fid2,'CROD,%d,%d,%d,%d\n',n,CROD(i).P,...
            CROD(i).n1,CROD(i).n2);
        n = n + 1;
                if rod == 0
            r = CROD(i).P-13;
            rod = 1;
        end
end
end

if cbar
for j = 1+6*(box-1) : 1+6*(box-1)+15
         fprintf(fid2,'CBAR,%d,%d,%d,%d,%#.1E,%#.1E,%#.1E\n',n,CBAR(j).P,...
            CBAR(j).n1,CBAR(j).n2,CBAR(j).v1,CBAR(j).v2,CBAR(j).v3);
         n = n + 1;
         
end
for j = 347+8*(box-1) : 347+8*(box-1)+19
         fprintf(fid2,'CBAR,%d,%d,%d,%d,%#.1E,%#.1E,%#.1E\n',n,CBAR(j).P,...
            CBAR(j).n1,CBAR(j).n2,CBAR(j).v1,CBAR(j).v2,CBAR(j).v3);
         n = n + 1;
end
for j = 807+4*(box-1) : 807+4*(box-1)+5
         fprintf(fid2,'CBAR,%d,%d,%d,%d,%#.1E,%#.1E,%#.1E\n',n,CBAR(j).P,...
            CBAR(j).n1,CBAR(j).n2,CBAR(j).v1,CBAR(j).v2,CBAR(j).v3);
         n = n + 1;
                 if bar == 0
            b = CBAR(j).P-30;
            bar = 1;
        end
end
end

%displacement constraint


% fprintf(fid2,'\n');
% fprintf(fid2,'$,Displacement,Constraints,of,Load,Set,:,spc1.1\n');
% fprintf(fid2,'\n');
% 
% fprintf(fid2,'SPC1,1,123456,%d,THRU,%d\n',SECTION(box).ID(1),...
%     SECTION(box).ID(end));
% fprintf(fid2,'RBE3,100,,7000,123456,1.0,123456,%d,%d,\n',SECTION(box+2).ID(1),SECTION(box+2).ID(2));
% fprintf(fid2,',%d,%d,%d,%d,%d,%d,%d,%d,\n',SECTION(box+2).ID(3),SECTION(box+2).ID(4),SECTION(box+2).ID(5)...
%     ,SECTION(box+2).ID(8),SECTION(box+2).ID(9),SECTION(box+2).ID(10),SECTION(box+2).ID(11),SECTION(box+2).ID(12));
% fprintf(fid2,'MPC,2000,7000,1,-10.,%d,1,1.,,+2\n',SECTION(box+2).ID(1));
% fprintf(fid2,'+2,,%d,1,1.,%d,1,1.,,+3\n',SECTION(box+2).ID(2),SECTION(box+2).ID(3));
% fprintf(fid2,'+3,,%d,1,1.,%d,1,1.,,+4\n',SECTION(box+2).ID(4),SECTION(box+2).ID(5));
% fprintf(fid2,'+4,,%d,1,1.,%d,1,1.,,+5\n',SECTION(box+2).ID(8),SECTION(box+2).ID(9));
% fprintf(fid2,'+5,,%d,1,1.,%d,1,1.,,+6\n',SECTION(box+2).ID(10),SECTION(box+2).ID(11));
% fprintf(fid2,'+6,,%d,1,1.,,,,,\n',SECTION(box+2).ID(12));
% fprintf(fid2,'MPC,2000,7000,2,-10.,%d,2,1.,,+8\n',SECTION(box+2).ID(1));
% fprintf(fid2,'+8,,%d,2,1.,%d,2,1.,,+9\n',SECTION(box+2).ID(2),SECTION(box+2).ID(3));
% fprintf(fid2,'+9,,%d,2,1.,%d,2,1.,,+10\n',SECTION(box+2).ID(4),SECTION(box+2).ID(5));
% fprintf(fid2,'+10,,%d,2,1.,%d,2,1.,,+11\n',SECTION(box+2).ID(8),SECTION(box+2).ID(9));
% fprintf(fid2,'+11,,%d,2,1.,%d,2,1.,,+12\n',SECTION(box+2).ID(10),SECTION(box+2).ID(11));
% fprintf(fid2,'+12,,%d,2,1.,,,,,\n',SECTION(box+2).ID(12));
% fprintf(fid2,'MPC,2000,7000,3,-10.,%d,3,1.,,+14\n',SECTION(box+2).ID(1));
% fprintf(fid2,'+14,,%d,3,1.,%d,3,1.,,+15\n',SECTION(box+2).ID(2),SECTION(box+2).ID(3));
% fprintf(fid2,'+15,,%d,3,1.,%d,3,1.,,+16\n',SECTION(box+2).ID(4),SECTION(box+2).ID(5));
% fprintf(fid2,'+16,,%d,3,1.,%d,3,1.,,+17\n',SECTION(box+2).ID(8),SECTION(box+2).ID(9));
% fprintf(fid2,'+17,,%d,3,1.,%d,3,1.,,+18\n',SECTION(box+2).ID(10),SECTION(box+2).ID(11));
% fprintf(fid2,'+18,,%d,3,1.,,,,,\n',SECTION(box+2).ID(12));
% fprintf(fid2,'MPC,2000,7000,4,-10.,%d,4,1.,,+20\n',SECTION(box+2).ID(1));
% fprintf(fid2,'+20,,%d,4,1.,%d,4,1.,,+21\n',SECTION(box+2).ID(2),SECTION(box+2).ID(3));
% fprintf(fid2,'+21,,%d,4,1.,%d,4,1.,,+22\n',SECTION(box+2).ID(4),SECTION(box+2).ID(5));
% fprintf(fid2,'+22,,%d,4,1.,%d,4,1.,,+23\n',SECTION(box+2).ID(8),SECTION(box+2).ID(9));
% fprintf(fid2,'+23,,%d,4,1.,%d,4,1.,,+24\n',SECTION(box+2).ID(10),SECTION(box+2).ID(11));
% fprintf(fid2,'+24,,%d,4,1.,,,,,\n',SECTION(box+2).ID(12));
% fprintf(fid2,'MPC,2000,7000,5,-10.,%d,5,1.,,+26\n',SECTION(box+2).ID(1));
% fprintf(fid2,'+26,,%d,5,1.,%d,5,1.,,+27\n',SECTION(box+2).ID(2),SECTION(box+2).ID(3));
% fprintf(fid2,'+27,,%d,5,1.,%d,5,1.,,+28\n',SECTION(box+2).ID(4),SECTION(box+2).ID(5));
% fprintf(fid2,'+28,,%d,5,1.,%d,5,1.,,+29\n',SECTION(box+2).ID(8),SECTION(box+2).ID(9));
% fprintf(fid2,'+29,,%d,5,1.,%d,5,1.,,+30\n',SECTION(box+2).ID(10),SECTION(box+2).ID(11));
% fprintf(fid2,'+30,,%d,5,1.,,,,,\n',SECTION(box+2).ID(12));
% fprintf(fid2,'MPC,2000,7000,6,-10.,%d,6,1.,,+32\n',SECTION(box+2).ID(1));
% fprintf(fid2,'+32,,%d,6,1.,%d,6,1.,,+33\n',SECTION(box+2).ID(2),SECTION(box+2).ID(3));
% fprintf(fid2,'+33,,%d,6,1.,%d,6,1.,,+34\n',SECTION(box+2).ID(4),SECTION(box+2).ID(5));
% fprintf(fid2,'+34,,%d,6,1.,%d,6,1.,,+35\n',SECTION(box+2).ID(8),SECTION(box+2).ID(9));
% fprintf(fid2,'+35,,%d,6,1.,%d,6,1.,,+36\n',SECTION(box+2).ID(10),SECTION(box+2).ID(11));
% fprintf(fid2,'+36,,%d,6,1.,,,,,\n',SECTION(box+2).ID(12));
%end data
fprintf(fid2,'ENDDATA\n');
    
end
fclose(fid2);
end