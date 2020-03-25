fid = fopen('NastranDynamicTemplateSM.txt', 'r');
fid2 = fopen("nastran_dynamic_template_SM.inp",'wt');

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

for i = 1:56
    fprintf(fid2,'PBAR,%d,2,{A%d},{Ix%d},{Iy%d},{J%d}\n',10+i,i,i,i,i);
end
fprintf(fid2,'\n');

for i = 1:56
    fprintf(fid2,'CBAR,%d,%d,%d,%d,%#.1E,%#.1E,%#.1E\n',2000+i,10+i,i,i+1,1,0,0);
end

fprintf(fid2,'\n');

for i = 1:56
    fprintf(fid2,'CONM2,%d,%d,0,{m%d},{cgx%d},{cgy%d},{cgz%d}\n',5000+i,i+1,i,i,i,i);
    fprintf(fid2,',{Ixx%d},{Iyx%d},{Iyy%d},{Izx%d},{Izy%d},{Izz%d}\n',i,i,i,i,i,i);
end

fprintf(fid2,'\n');



%end data
fprintf(fid2,'ENDDATA\n');

fclose(fid2);