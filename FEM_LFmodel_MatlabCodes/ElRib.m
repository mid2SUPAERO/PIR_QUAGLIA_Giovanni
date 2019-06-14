function [CQUAD] = ElRib (SECTION,L,V)

Sp = [1 15 25 34 42 50 59]; %Property span changes

Prop = 0;

for i = 1:6
    Prop = [Prop i*ones(1,Sp(i+1)-Sp(i))];
end

Prop(1) = [];

c = 1;

for k = 1:56
    for i = 1:V-1
        for j = 1:L-1
        CQUAD(c).P    =    Prop(k);
        CQUAD(c).n1   =    SECTION(k).ID(j+L*(i-1)+1);
        CQUAD(c).n2   =    SECTION(k).ID(j+L*(i-1));
        CQUAD(c).n3   =    SECTION(k).ID(j+L*i);
        CQUAD(c).n4   =    SECTION(k).ID(j+L*i+1);
        
        c = c + 1;
        end
    end
end

for i = 1:V-1
   for j = 1:L-1
   CQUAD(c).P    =    Prop(58);
   CQUAD(c).n1   =    SECTION(58).ID(j+L*(i-1)+1);
   CQUAD(c).n2   =    SECTION(58).ID(j+L*(i-1));
   CQUAD(c).n3   =    SECTION(58).ID(j+L*i);
   CQUAD(c).n4   =    SECTION(58).ID(j+L*i+1);
        
   c = c + 1;
   end
end

l1 = size(SECTION(57).x,2)/V;
l2 = L - l1;

for i = 1:V-1
   CQUAD(c).P    =    Prop(57);
   CQUAD(c).n1   =    SECTION(57).ID(1+l1*(i-1));
   CQUAD(c).n2   =    SECTION(58).ID(l2+L*(i-1));
   CQUAD(c).n3   =    SECTION(58).ID(l2+L*i);
   CQUAD(c).n4   =    SECTION(57).ID(1+l1*i);
        
   c = c + 1;
end

for i = 1:V-1
   for j = 1:l1-1
   CQUAD(c).P    =    Prop(57);
   CQUAD(c).n1   =    SECTION(57).ID(j+l1*(i-1)+1);
   CQUAD(c).n2   =    SECTION(57).ID(j+l1*(i-1));
   CQUAD(c).n3   =    SECTION(57).ID(j+l1*i);
   CQUAD(c).n4   =    SECTION(57).ID(j+l1*i+1);
        
   c = c + 1;
   end
end


end