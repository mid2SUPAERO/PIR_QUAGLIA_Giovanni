function [inPlane,outOfPlane,planevar] = findPlane(nodes,section,toll,opt)

N = size(nodes,1);

start = true;
s = 1;
  
while start && s < size(section,1)
    p = 1;
    scanned = true;
    while scanned && p < N
        if nodes(p,1) == section(s,1)
            scanned = false;
            v1 = nodes(p,2:4);
            node1 = p;
        end
        p = p + 1;
    end
    
    found = true;
    
    while found && p < N
    if nodes(p,1) == section(s,2)
        found = false;
        v2 = nodes(p,2:4);
        node2 = p;
        start = false;
    end
    p = p + 1;
    end
    
    s = s + 1;
end

[min] = findNear(v1,v2,node1,node2,nodes,opt);

v3 = nodes(min,2:4);

r1 = v2-v1;
r2 = v3-v1;
normal = cross(r1,r2);
planevar = [normal -normal*v2'];

in = 1;
out = 1;

for i = 1:N
if distPointPlane(planevar,nodes(i,2:4)) < toll
    inPlane(in,:) = nodes(i,:);
    in = in + 1;
else
    outOfPlane(out,:) = nodes(i,:);
    out = out + 1;
end
end
end
