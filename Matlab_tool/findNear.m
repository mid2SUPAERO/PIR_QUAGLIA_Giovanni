function [min] = findNear (v1,v2,node1,node2,nodes,opt);

N = size(nodes,1);

min = 0;
dmin = 1000;

rad2 = sqrt(2);

if opt == 1
vm = (v1+v2)./2;
elseif opt == 2;
    vm = v1;
else 
    vm = v2;
end

for i = 1:N
    v = nodes(i,2:4);
    d = norm(v-vm);
    if d < dmin && i ~= node1 && i ~= node2
        if nodes(i,3) > 25
           if  abs(v(3)-vm(3)) < 0.04 %abs(-v(1)-v(2)+vm(1)+vm(2))/rad2 < 0.06
            min = i;
            dmin = d;
           end
        elseif nodes(i,3) < 5
            if abs(vm(2)-v(2)) < 0.1
            min = i;
            dmin = d;
            end
        else
           min = i;
           dmin = d; 
        end
    end
end
end