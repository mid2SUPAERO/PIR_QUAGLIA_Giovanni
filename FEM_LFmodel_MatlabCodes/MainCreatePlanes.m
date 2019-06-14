clearvars
close all
clc

% import nodes

%nodes = ImportNodes('nodes.txt');
%NodesSection = ImportNodesSection('nodesSection.txt');
%massNodes = ImportMass('mass.txt');

%save nodes.mat nodes
%save massNodes.mat massNodes
%save NodesSection.mat NodesSection
%%
load('massNodes.mat')
load('nodes.mat')
load('NodesSection.mat')

N = size(nodes,1);

%% remove mass nodes

for i = 1:length(massNodes)
found = true;
p = 1;
while found
if nodes(p,1) == massNodes(i)
found = false;
NodesM(i,:) = nodes(p,:);
nodes(p,:) = [];
end
p = p + 1;
end
end

%% find planes

%initial planes
nodelist = nodes;
k = 1;
for i = 1:59
    
[inP,outP,planevar] = findPlane(nodelist,NodesSection(:,2:3),2*10^-2,1);
nodelist = outP;

if k ~= 1
a = size(Planes(k-1).coord,1);
end

if size(inP,1) < 140 && a < 140
Planes(k-1).coord(a+1:a+size(inP,1),:) = inP;
else
Planes(k).coord = inP;
Planes(k).plane = planevar;
k = k + 1;
end
end


%remove nodes to ease bottom planes
r = 1;
for j = 1 : size(outP,1)
    if outP(j,3) < 28.641
        LNind(r) = j;
        r = r + 1;
    end
end

LeftNodes = outP(LNind,:);
outP(LNind,:) = [];
nodelist = outP;

%last two planes
for i = 60:61
[inP,outP] = findPlane(nodelist,NodesSection(:,2:3),1*10^-2,3);
nodelist = outP;
Planes(k).coord = inP;
Planes(k).plane = planevar;
k = k + 1;
end

%removed nodes
LeftNodes = [LeftNodes; outP];

save LeftNodes.mat LeftNodes

%structure for sorted planes
for i = 1:58
nP = projectPlane(Planes(i));
nPS = nodeSort(nP);
%FP(i).globalRef = nPS(:,2);
FP(i).localRef = nPS(:,1);
for j = 1:size(nPS,1)
 FP(i).coord(j,:) = findRealCoord(nPS(j,2),nodes);   
end
end

%planes sorted along the wing 1 root 58 tip
for i = 1:58
    yL(i) = FP(i).coord(1,2);
end
[~,idx] = sort(yL); % sort just the first column
FP = FP(idx);  

% %readding masses at plane 59
% 
% [~,idx] = sort(NodesM(:,4)); % sort just the first column
% NodesM = NodesM(idx,:);
% FP(59).coord = NodesM(:,3:5);
% FP(59).globalRef = NodesM(:,2);
% FP(59).localRef = [1:size(NodesM,1)]';
% 
 save FP.mat FP   

%% plot section

figure()
%scatter3(FP(1).coord(:,1),FP(1).coord(:,2),FP(1).coord(:,3))

for i = 1:58
scatter3(FP(i).coord(:,1),FP(i).coord(:,2),FP(i).coord(:,3))
hold on
end
%scatter3(FP(59).coord(:,1),FP(59).coord(:,2),FP(59).coord(:,3),'*k')
grid minor
xlabel('x')
ylabel('y')
zlabel('z')
