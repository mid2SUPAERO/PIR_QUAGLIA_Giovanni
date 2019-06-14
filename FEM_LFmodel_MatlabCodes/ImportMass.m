function massNodes = ImportMass(filename)

fid = fopen(filename,'r');
i = 1;
while ~feof(fid)
rline = textscan(fid,'%s',1,'delimiter','\n');
a = strsplit(rline{1}{1},',');
massNodes(i) = str2double(a{3});
i = i + 1;
end
fclose(fid);
end