function nodesSection = ImportNodesSection(filename)

fid = fopen(filename,'r');
i = 1;
while ~feof(fid)
rline = textscan(fid,'%s',1,'delimiter','\n');
a = strsplit(rline{1}{1},',');
for j = 3:8
nodesSection(i,j-2) = str2double(a{j});
end
i = i + 1;
end

fclose(fid);