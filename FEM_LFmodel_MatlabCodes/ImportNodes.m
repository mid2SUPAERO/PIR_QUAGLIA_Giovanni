function nodes = ImportNodes(filename)

fid = fopen(filename,'r');
i = 1;
while ~feof(fid)
rline = textscan(fid,'%s',1,'delimiter','\n');
a = strsplit(rline{1}{1},',');
for j = 2:5
nodes(i,j-1) = str2double(a{j});
end
i = i + 1;
end

fclose(fid);
end