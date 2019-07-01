function writeGeom(NODES)

fid = fopen('nastran_input_geometry.inp','wt');

for i = 1 : size(NODES.ID,2)
        fprintf(fid,'GRID,%d,,%d,%d,%d \n',NODES.ID(i),NODES.x(i),...
            NODES.y(i),NODES.z(i));
end

fclose(fid);

end