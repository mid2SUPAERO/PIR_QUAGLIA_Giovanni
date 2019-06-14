function [nSorted] = nodeSort(coord)

if size(coord,1) == 137
    opt = 2;
else
    opt = 1;
end

nSorted = [1:size(coord,1)]';

switch opt
    case 1
        [~,idx] = sort(coord(:,2)); % sort just the first column
        xsort = coord(idx,:);   % sort the whole matrix using the sort indices
        for i = 1:size(coord,1)/5
            mat = xsort(5*i-4:5*i,:);
            [~,idx] = sort(mat(:,3),'descend'); % sort just the first column
            nSorted(5*i-4:5*i,2:5) = mat(idx,:);
        end
    case 2
        [~,idx] = sort(coord(:,2)); % sort just the first column
        xsort = coord(idx,:);   % sort the whole matrix using the sort indices
        mat = xsort(1:2,:);
        [~,idx] = sort(mat(:,3),'descend'); % sort just the first column
        nSorted(1:2,2:5) = mat(idx,:);
        for i = 1:floor(size(coord,1)/5)
            mat = xsort(2+5*i-4:2+5*i,:);
            [~,idx] = sort(mat(:,3),'descend'); % sort just the first column
            nSorted(2+5*i-4:2+5*i,2:5) = mat(idx,:);
        end
end
end

