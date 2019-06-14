function writeInp(NODES,SECTION,L,V,varargin)
fid = fopen('NastranStaticTemplate.txt', 'r');
fid2 = fopen('nastran_static_template.inp','wt');

cquad = 0;
cbar = 0;
crod = 0;
ctria = 0;

for i = 1:size(varargin,2)
    if strcmp(inputname(i+4),'CQUAD')
        cquad = 1;
        CQUAD = varargin{i};
    end
    if strcmp(inputname(i+4),'CBAR')
        cbar = 1;
        CBAR = varargin{i};
    end
    if strcmp(inputname(i+4),'CROD')
        crod = 1;
        CROD = varargin{i};
    end
    if strcmp(inputname(i+4),'CTRIA')
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


%add elements

fprintf(fid2,'\n$Case parameters\n');
fprintf(fid2,'$,L,%d,V,%d\n',L,V);

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

%outer skin

nodesouter = 0;

for k = 1:56
    for i = 1:L
        nodesouter = [nodesouter SECTION(k).ID(i)];
    end
    for j = 1:V-2
        nodesouter = [nodesouter SECTION(k).ID(L*j+1)];
        nodesouter = [nodesouter SECTION(k).ID(L*(j+1))];
    end
    for i = L*V-L+1:L*V
        nodesouter = [nodesouter SECTION(k).ID(i)];
    end
end
    
l1 = size(SECTION(57).ID,2)/V;

    for i = 1:l1
        nodesouter = [nodesouter SECTION(57).ID(i)];
    end
    for j = 1:V-2
        nodesouter = [nodesouter SECTION(57).ID(l1*(j+1))];
    end
    for i = l1*V-l1+1:l1*V
        nodesouter = [nodesouter SECTION(57).ID(i)];
    end

    for i = 1:L
        nodesouter = [nodesouter SECTION(58).ID(i)];
    end
    for j = 1:V-2
        nodesouter = [nodesouter SECTION(58).ID(L*j+1)];
        nodesouter = [nodesouter SECTION(58).ID(L*(j+1))];
    end
    for i = L*V-L+1:L*V
        nodesouter = [nodesouter SECTION(58).ID(i)];
    end
    
nodesouter(1)  = [];

%forces

fprintf(fid2,'\n$list of forces\n');

for i = 1 : length(nodesouter)
        fprintf(fid2,'FORCE,201,%d,0,1.0,{Fx%d},{Fy%d},{Fz%d}\n',nodesouter(i),nodesouter(i),nodesouter(i),nodesouter(i));
end

%end data
fprintf(fid2,'ENDDATA\n');

    
% write nodes outer skin

fprintf(fid2,'$List of nodes belonging to the outer skin\n');

for i = 1:length(nodesouter)
    fprintf(fid2,'$%d\n',nodesouter(i));
end
    

fclose(fid2);
end