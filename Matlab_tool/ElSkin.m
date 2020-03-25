function [CQUAD] = ElSkin (SECTION,L,V)

Sp = [1 15 25 34 41 49 59]; %Property span changes

Prop = 0;

for i = 1:6
    Prop = [Prop i*ones(1,Sp(i+1)-Sp(i))];
end

Prop(1) = [];

S = size(SECTION(1).x,2);
c = 1;

J1 = [1:L]; 
J2 = [S-L+1:S];

for k = 1:55
    for j = 1:L-1
        CQUAD(c).P    =    Prop(k);
        CQUAD(c).n1   =    SECTION(k+1).ID(J1(j+1));
        CQUAD(c).n2   =    SECTION(k+1).ID(J1(j));
        CQUAD(c).n3   =    SECTION(k).ID(J1(j));
        CQUAD(c).n4   =    SECTION(k).ID(J1(j+1));
      
        c = c + 1;
    end
    for j = 1:L-1
        CQUAD(c).P    =    Prop(k);
        CQUAD(c).n1   =    SECTION(k+1).ID(J2(j+1));
        CQUAD(c).n2   =    SECTION(k+1).ID(J2(j));
        CQUAD(c).n3   =    SECTION(k).ID(J2(j));
        CQUAD(c).n4   =    SECTION(k).ID(J2(j+1));
        
        c = c + 1;
    end
end

%tip

l1 = size(SECTION(57).x,2)/V;

l2 = L - l1;

%first set
J3 = [1:l2]; 
J4 = [S-L+1:S-L+1+l2-1];
for j = 1:l2-1
        CQUAD(c).P    =    Prop(56);
        CQUAD(c).n1   =    SECTION(58).ID(J3(j+1));
        CQUAD(c).n2   =    SECTION(58).ID(J3(j));
        CQUAD(c).n3   =    SECTION(56).ID(J3(j));
        CQUAD(c).n4   =    SECTION(56).ID(J3(j+1));

        c = c + 1;
end
for j = 1:l2-1
        CQUAD(c).P    =    Prop(56);
        CQUAD(c).n1   =    SECTION(58).ID(J4(j+1));
        CQUAD(c).n2   =    SECTION(58).ID(J4(j));
        CQUAD(c).n3   =    SECTION(56).ID(J4(j));
        CQUAD(c).n4   =    SECTION(56).ID(J4(j+1));
        
        c = c + 1;
end

%second set

CQUAD(c).P    =    Prop(56);
CQUAD(c).n1   =    SECTION(57).ID(1);
CQUAD(c).n2   =    SECTION(58).ID(l2);
CQUAD(c).n3   =    SECTION(56).ID(l2);
CQUAD(c).n4   =    SECTION(56).ID(l2+1);

c = c + 1;

CQUAD(c).P    =    Prop(56);
CQUAD(c).n1   =    SECTION(57).ID(l1*V-l1+1);
CQUAD(c).n2   =    SECTION(58).ID(S-L+l2);
CQUAD(c).n3   =    SECTION(56).ID(S-L+l2);
CQUAD(c).n4   =    SECTION(56).ID(S-L+l2+1);

c = c + 1;

J5 = [1:l1]; 
J6 = [l1*V-l1+1:l1*V];
for j = 1:l1-1
        CQUAD(c).P    =    Prop(56);
        CQUAD(c).n1   =    SECTION(57).ID(J5(j+1));
        CQUAD(c).n2   =    SECTION(57).ID(J5(j));
        CQUAD(c).n3   =    SECTION(56).ID(J5(j)+l2);
        CQUAD(c).n4   =    SECTION(56).ID(J5(j+1)+l2);
        
        c = c + 1;
end
for j = 1:l1-1
        CQUAD(c).P    =    Prop(56);
        CQUAD(c).n1   =    SECTION(57).ID(J6(j+1));
        CQUAD(c).n2   =    SECTION(57).ID(J6(j));
        CQUAD(c).n3   =    SECTION(56).ID(j+S-L+l2);
        CQUAD(c).n4   =    SECTION(56).ID(j+S-L+l2+1);
        
        c = c + 1;
end
% 
% %third set
% 
J7 = [1:l1]; 
J8 = [l1*V-l1+1:l1*V];

for j = 1:l1-1
        CQUAD(c).P    =    Prop(56);
        CQUAD(c).n1   =    SECTION(58).ID(J7(j+1)+l2);
        CQUAD(c).n2   =    SECTION(58).ID(J7(j)+l2);
        CQUAD(c).n3   =    SECTION(57).ID(J7(j));
        CQUAD(c).n4   =    SECTION(57).ID(J7(j+1));
        
        c = c + 1;
end
for j = 1:l1-1
        CQUAD(c).P    =    Prop(56);
        CQUAD(c).n1   =    SECTION(58).ID(j+S-L+l2+1);
        CQUAD(c).n2   =    SECTION(58).ID(j+S-L+l2);
        CQUAD(c).n3   =    SECTION(57).ID(J8(j));
        CQUAD(c).n4   =    SECTION(57).ID(J8(j+1));
        
        c = c + 1;
end
end

