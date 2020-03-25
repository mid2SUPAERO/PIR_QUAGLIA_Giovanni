function [listbar] = createListBar()

%oldcbar = ImportNodesSection('listCbar.txt');
load oldcbar
load nodes

S = size(oldcbar,1);
listbar(:,1) = oldcbar(:,1);

for i = 1:S
    c1 = findRealCoord (oldcbar(i,2),nodes);
    c2 = findRealCoord (oldcbar(i,3),nodes);
    
    listbar(i,2:4) = c1;
    listbar(i,5:7) = (c1-c2)/norm(c1-c2);
    listbar(i,8:10) = oldcbar(i,4:6);
end
end