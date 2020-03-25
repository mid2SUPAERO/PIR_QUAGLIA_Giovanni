function [M,N,L] = chooseMNL (L,a,b)

n(1) = floor(a*L/(a+b));
d(1) = a/n(1);
m(1) = floor(b/d(1));
l(1) = b - (m(1)-1)*d(1);

n(2) = n(1)+ 1;
d(2) = a/n(2);
m(2) = floor(b/d(2));
l(2) = b - (m(2)-1)*d(2);

n(3) = n(1);
d(3) = d(1);
m(3) = m(1) + 1;
l(3) = b - (m(3)-1)*d(3);

a = abs(d-l);
[mn,i] = min(a);

M = m(i);
N = n(i);
L = l(i);
end
