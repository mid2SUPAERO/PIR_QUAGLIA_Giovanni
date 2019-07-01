function [coord] = findRealCoord (globalRef,nodes)

found = true;
i = 1;
while found
    if nodes(i,1) == globalRef
        found = false;
        coord = nodes(i,2:4);
    end
    i = i + 1;
end
end