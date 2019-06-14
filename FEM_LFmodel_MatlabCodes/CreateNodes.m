function [NODES,SECTION] = CreateNodes(FP,V,L)

if V ~= 2 && V ~= 3 && V ~= 5
    error('V must be equal to 2,3 or 5')
end

tot = 0;
for i = 1:56
    
    SECTION(i) = createNodesWing(FP(i),L,V);
    for j = 1:size(SECTION(i).x,2)
        NODES.ID(tot+j) = tot + j;
        NODES.x(tot+j) = SECTION(i).x(j);
        NODES.y(tot+j) = SECTION(i).y(j);
        NODES.z(tot+j) = SECTION(i).z(j);
    end
    tot = tot + j;
end

SECTION(58:-1:57) = createNodesTip(FP(57:58),L,V);
for i = 57:58
for j = 1:size(SECTION(i).x,2)
   SECTION(i).ID(j) = tot + j;
   NODES.ID(tot+j) = tot + j;
   NODES.x(tot+j) = SECTION(i).x(j);
   NODES.y(tot+j) = SECTION(i).y(j);
   NODES.z(tot+j) = SECTION(i).z(j);
end
tot = tot + j;
end

tot2 = 0;
for i = 1:58
    for j = 1:size(SECTION(i).x,2)
        SECTION(i).ID(j) = tot2 + j;
    end
    tot2 = tot2 + j;
end



% figure()
% for i = 1:58
%     scatter3(SECTION(i).x(:),SECTION(i).y(:),SECTION(i).z(:));
%     hold on
% end
%grid minor
end
