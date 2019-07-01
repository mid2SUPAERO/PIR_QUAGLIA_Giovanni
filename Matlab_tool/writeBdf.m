function writeBdf(NODES,SECTION,L,V,varargin)
fid = fopen('NastranLightStaticTemplate.txt', 'r');
fid2 = fopen('NastranLightStaticTemplate.bdf','wt');

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
for i = 1 : size(NODES.ID,2)
        fprintf(fid2,'GRID,%d,,%d,%d,%d \n',NODES.ID(i),NODES.x(i),...
            NODES.y(i),NODES.z(i));
end
n = 1;
if cquad
for i = 1 : size(CQUAD,2)
        fprintf(fid2,'CQUAD4,%d,%d,%d,%d,%d,%d \n',n,CQUAD(i).P,...
            CQUAD(i).n1,CQUAD(i).n2,CQUAD(i).n3,CQUAD(i).n4);
        n = n + 1;
end
end

if ctria
for i = 1 : size(CTRIA.P,2)
        fprintf(fid2,'CTRIA3,%d,%d,%d,%d,%d \n',n,CTRIA.P(i),...
            CTRIA.n1(i),CTRIA.n2(i),CTRIA.n3(i));
        n = n + 1;
end
end

if crod
for i = 1 : size(CROD,2)
        fprintf(fid2,'CROD,%d,%d,%d,%d \n',n,CROD(i).P,...
            CROD(i).n1,CROD(i).n2);
        n = n + 1;
end
end

if cbar
for j = 1 : size(CBAR,2)
         fprintf(fid2,'CBAR,%d,%d,%d,%d,%#E,%#E,%#E \n',n,CBAR(j).P,...
            CBAR(j).n1,CBAR(j).n2,CBAR(j).v1,CBAR(j).v2,CBAR(j).v3);
         n = n + 1;
end
end

%displacement constraint


fprintf(fid2,'\n');
fprintf(fid2,'$,Displacement,Constraints,of,Load,Set,:,spc1.1 \n');
fprintf(fid2,'\n');

fprintf(fid2,'SPC1,1,123,%d,THRU,%d \n',SECTION(1).ID(1),...
    SECTION(1).ID(end));
fprintf(fid2,'SPC1,1,123,%d,THRU,%d \n',SECTION(11).ID(1),...
    SECTION(11).ID(L));
fprintf(fid2,'SPC1,1,123,%d,THRU,%d \n',SECTION(11).ID(end-L+1),...
    SECTION(11).ID(end));

%forces

for i = 1 : size(NODES.ID,2)
        fprintf(fid2,'FORCE,201,%d,0,1.0,1.0,1.0,1.0 \n',NODES.ID(i));
end

%end data
fprintf(fid2,'ENDDATA \n');

%outer skin
fprintf(fid2,'$List of nodes belonging to the outer skin \n');
for k = 1:56
    for i = 1:L
        fprintf(fid2,'$%d \n',SECTION(k).ID(i));
    end
    for j = 1:V-2
        fprintf(fid2,'$%d \n',SECTION(k).ID(L*j+1));
        fprintf(fid2,'$%d \n',SECTION(k).ID(L*(j+1)));
    end
    for i = L*V-L+1:L*V
        fprintf(fid2,'$%d \n',SECTION(k).ID(i));
    end
end
    
l1 = size(SECTION(57).ID,2)/V;

    for i = 1:l1
        fprintf(fid2,'$%d \n',SECTION(57).ID(i));
    end
    for j = 1:V-2
        fprintf(fid2,'$%d \n',SECTION(57).ID(l1*(j+1)));
    end
    for i = l1*V-l1+1:l1*V
        fprintf(fid2,'$%d \n',SECTION(57).ID(i));
    end

    for i = 1:L
        fprintf(fid2,'$%d \n',SECTION(58).ID(i));
    end
    for j = 1:V-2
        fprintf(fid2,'$%d \n',SECTION(58).ID(L*j+1));
        fprintf(fid2,'$%d \n',SECTION(58).ID(L*(j+1)));
    end
    for i = L*V-L+1:L*V
        fprintf(fid2,'$%d \n',SECTION(58).ID(i));
    end

fclose(fid2);
end