function [CBAR] = ElStr (SECTION,NODES,L,V)

[listBar] = createListBar();

c = 1;

% horizontal stringers

for k = 1:56
    for i = 1:2
        for j = 1:L-1
        CBAR(c).n1   =    SECTION(k).ID(j+(L*(V-1))*(i-1)+1);
        CBAR(c).n2   =    SECTION(k).ID(j+(L*(V-1))*(i-1));
        
        c = c + 1;
        end
    end
end

for i = 1:2
   for j = 1:L-1
   CBAR(c).n1   =    SECTION(58).ID(j+(L*(V-1))*(i-1)+1);
   CBAR(c).n2   =    SECTION(58).ID(j+(L*(V-1))*(i-1));
        
   c = c + 1;
   end
end

l1 = size(SECTION(57).x,2)/V;
l2 = L - l1;

for i = 1:2
   for j = 1:l1-1
   CBAR(c).n1   =    SECTION(57).ID(j+l1*(V-1)*(i-1)+1);
   CBAR(c).n2   =    SECTION(57).ID(j+l1*(V-1)*(i-1));
        
   c = c + 1;
   end
end

for i = 1:2
   CBAR(c).n1   =    SECTION(57).ID(1+(l1*(V-1))*(i-1));
   CBAR(c).n2   =    SECTION(58).ID(l2+(L*(V-1))*(i-1));
        
   c = c + 1;
end
%vertical stringers

for k = 1:56
    for i = 1:V-1
        for j = 1:L
            CBAR(c).n1   =    SECTION(k).ID(j+L*(i-1));
            CBAR(c).n2   =    SECTION(k).ID(j+L*i);
            
            c = c + 1;
        end
    end
end


for i = 1:V-1
   for j = 1:l1
      CBAR(c).n1   =    SECTION(57).ID(j+l1*(i-1));
      CBAR(c).n2   =    SECTION(57).ID(j+l1*i);
      
      c = c + 1;
   end
end

for i = 1:V-1
   for j = 1:L
      CBAR(c).n1   =    SECTION(58).ID(j+L*(i-1));
      CBAR(c).n2   =    SECTION(58).ID(j+L*i);
      
      c = c + 1;
   end
end

%longitudinal stringers

for k = 1:55
    for i = 1:2
        for j = 2:L-1      %choice of jumping the next and previous wrt the long
            CBAR(c).n1   =    SECTION(k).ID(j+(L*(V-1))*(i-1));
            CBAR(c).n2   =    SECTION(k+1).ID(j+(L*(V-1))*(i-1));
        
            c = c + 1;
        end
    end
end

    for i = 1:2
        for j = 2:l2      %choice of jumping the next and previous wrt the long
            CBAR(c).n1   =    SECTION(56).ID(j+(L*(V-1))*(i-1));
            CBAR(c).n2   =    SECTION(58).ID(j+(L*(V-1))*(i-1));
        
            c = c + 1;
        end
    end

    for i = 1:2
        for j = 1:l1-1          %choice of jumping the next and previous wrt the long
            CBAR(c).n1   =    SECTION(56).ID(j+(L*(V-1))*(i-1)+l2);
            CBAR(c).n2   =    SECTION(57).ID(j+(l1*(V-1))*(i-1));
        
            c = c + 1;
        end
    end
    for i = 1:2
        for j = l2+1:L-1    %choice of jumping the next and previous wrt the long
            CBAR(c).n1   =    SECTION(57).ID(j+(l1*(V-1))*(i-1)-l2);
            CBAR(c).n2   =    SECTION(58).ID(j+(L*(V-1))*(i-1));
        
            c = c + 1;
        end
    end
    
%appending property and V

for i = 1:size(CBAR,2)
[p,V] = findProp(listBar,[NODES.x(CBAR(i).n1) NODES.y(CBAR(i).n1) ...
    NODES.z(CBAR(i).n1)],[NODES.x(CBAR(i).n2) NODES.y(CBAR(i).n2) ...
    NODES.z(CBAR(i).n2)]);

dx = abs(NODES.x(CBAR(i).n1) - NODES.x(CBAR(i).n2));
dy = abs(NODES.y(CBAR(i).n1) - NODES.y(CBAR(i).n2));
dz = abs(NODES.z(CBAR(i).n1) - NODES.z(CBAR(i).n2));

if dz > dx && dz > dy
    CBAR(i).P = p+3;
else 
    CBAR(i).P = p;
end

CBAR(i).v1 = V(1);
CBAR(i).v2 = V(2);
CBAR(i).v3 = V(3);
end

end