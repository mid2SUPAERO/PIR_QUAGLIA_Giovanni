clearvars
clc
%fid = fopen('NastranLightStaticTemplate.bdf', 'r');
%fid = fopen('uCRM_FEM_cbar.bdf', 'r');
fid2 = fopen('testLong.bdf','wt');
fid = fopen('Long.bdf','r');


%copy template

i = 1;
while ~feof(fid)
rline = textscan(fid,'%s',1,'delimiter','\n');
a = string(rline);
b = strsplit(rline{1}{1},',');
if strcmp(b{1},"CQUAD4") ~= 1
    fprintf(fid2,'%s\n',a);
else
    if strcmp(b{3},"12") == 1
     fprintf(fid2,'%s\n',a);
    end
end
i = i + 1;
end
fclose(fid);
fclose(fid2);