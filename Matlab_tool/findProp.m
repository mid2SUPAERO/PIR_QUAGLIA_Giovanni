function [prop,V] = findProp(listBar,n1,n2)

p1 = n1;
e1 = (n2-n1)/norm(n2-n1);

c = 1;

%find parallel bars
for i = 1:size(listBar,1)
    e2 = listBar(i,5:7);
    
    if abs(dot(e1,e2)) > 0.9
        lsort(c,:) = listBar(i,:);
        c = c + 1;
    end
end

%find closest bar
for i = 1:size(lsort,1)
        p2 = lsort(i,2:4);
        e2 = lsort(i,5:7);
        
        lsort(i,11) = norm(p1-p2);
        %lsort(i,11) = abs(dot(cross(e1,e2),(p1-p2)))/norm(cross(e1,e2));
end

[mn,k] = min(lsort(:,11));

prop = lsort(k,1);
V    = lsort(k,8:10);

end