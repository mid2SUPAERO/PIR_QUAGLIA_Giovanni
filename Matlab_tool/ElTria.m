function [CTRIA] = ElTria(SECTION,L,V)

l1 = size(SECTION(57).x,2)/V;
l2 = L - l1;
S = L*V;

CTRIA.P(1) = 6;
CTRIA.n1(1) = SECTION(58).ID(l2+1);
CTRIA.n2(1) = SECTION(58).ID(l2);
CTRIA.n3(1) = SECTION(57).ID(1);

CTRIA.P(2) = 6;
CTRIA.n1(2) = SECTION(58).ID(S-L+l2+1);
CTRIA.n2(2) = SECTION(58).ID(S-L+l2);
CTRIA.n3(2) = SECTION(57).ID(l1*V-l1+1);
end