%sec1
clearvars
clc

load nodes
format long

%1
l1(1) = norm(findRealCoord(10823,nodes)-findRealCoord(250,nodes));
l1(2) = norm(findRealCoord(6918,nodes)-findRealCoord(873,nodes));
l1(3) = norm(findRealCoord(901,nodes)-findRealCoord(8904,nodes));
l1(4) = norm(findRealCoord(7353,nodes)-findRealCoord(898,nodes));

l1(5) = norm(findRealCoord(303,nodes)-findRealCoord(6957,nodes));
l1(6) = norm(findRealCoord(304,nodes)-findRealCoord(9203,nodes));
l1(7) = norm(findRealCoord(7096,nodes)-findRealCoord(454,nodes));
l1(8) = norm(findRealCoord(451,nodes)-findRealCoord(8891,nodes));

L(1) = mean(l1);

%2
l2(1) = norm(findRealCoord(303,nodes)-findRealCoord(6957,nodes));
l2(2) = norm(findRealCoord(304,nodes)-findRealCoord(9203,nodes));
l2(3) = norm(findRealCoord(7096,nodes)-findRealCoord(454,nodes));
l2(4) = norm(findRealCoord(451,nodes)-findRealCoord(8891,nodes));

l2(5) = norm(findRealCoord(8871,nodes)-findRealCoord(5070,nodes));
l2(6) = norm(findRealCoord(9038,nodes)-findRealCoord(4050,nodes));
l2(7) = norm(findRealCoord(9275,nodes)-findRealCoord(1185,nodes));
l2(8) = norm(findRealCoord(6897,nodes)-findRealCoord(1184,nodes));

L(2) = mean(l2);

%2
l3(1) = norm(findRealCoord(8871,nodes)-findRealCoord(5070,nodes));
l3(2) = norm(findRealCoord(9038,nodes)-findRealCoord(4050,nodes));
l3(3) = norm(findRealCoord(9275,nodes)-findRealCoord(1185,nodes));
l3(4) = norm(findRealCoord(6897,nodes)-findRealCoord(1184,nodes));

l3(5) = norm(findRealCoord(6780,nodes)-findRealCoord(2937,nodes));
l3(6) = norm(findRealCoord(9293,nodes)-findRealCoord(2938,nodes));
l3(7) = norm(findRealCoord(4692,nodes)-findRealCoord(8843,nodes));
l3(8) = norm(findRealCoord(3559,nodes)-findRealCoord(9116,nodes));
L(3) = mean(l3);

%2

l4(1) = norm(findRealCoord(6780,nodes)-findRealCoord(2937,nodes));
l4(2) = norm(findRealCoord(9293,nodes)-findRealCoord(2938,nodes));
l4(3) = norm(findRealCoord(4692,nodes)-findRealCoord(8843,nodes));
l4(4) = norm(findRealCoord(3559,nodes)-findRealCoord(9116,nodes));

l4(5) = norm(findRealCoord(9237,nodes)-findRealCoord(824,nodes));
l4(6) = norm(findRealCoord(6920,nodes)-findRealCoord(823,nodes));
l4(7) = norm(findRealCoord(3578,nodes)-findRealCoord(10884,nodes));
l4(8) = norm(findRealCoord(4333,nodes)-findRealCoord(10803,nodes));
L(4) = mean(l4);

%2
l5(1) = norm(findRealCoord(9237,nodes)-findRealCoord(824,nodes));
l5(2) = norm(findRealCoord(6920,nodes)-findRealCoord(823,nodes));
l5(3) = norm(findRealCoord(3578,nodes)-findRealCoord(10884,nodes));
l5(4) = norm(findRealCoord(4333,nodes)-findRealCoord(10803,nodes));

l5(5) = norm(findRealCoord(6828,nodes)-findRealCoord(2273,nodes));
l5(6) = norm(findRealCoord(9180,nodes)-findRealCoord(2274,nodes));
l5(7) = norm(findRealCoord(2215,nodes)-findRealCoord(8123,nodes));
l5(8) = norm(findRealCoord(2216,nodes)-findRealCoord(9083,nodes));

L(5) = mean(l5);

%2
l6(1) = norm(findRealCoord(6828,nodes)-findRealCoord(2273,nodes));
l6(2) = norm(findRealCoord(9180,nodes)-findRealCoord(2274,nodes));
l6(3) = norm(findRealCoord(2215,nodes)-findRealCoord(8123,nodes));
l6(4) = norm(findRealCoord(2216,nodes)-findRealCoord(9083,nodes));

l6(5) = norm(findRealCoord(9170,nodes)-findRealCoord(84,nodes));
l6(6) = norm(findRealCoord(9312,nodes)-findRealCoord(83,nodes));
l6(7) = norm(findRealCoord(2418,nodes)-findRealCoord(8241,nodes));
l6(8) = norm(findRealCoord(2415,nodes)-findRealCoord(9103,nodes));


L(6) = mean(l6);