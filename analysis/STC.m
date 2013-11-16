function [ coeff,latent ] = STC(stimlist, countList_new, uniform)
%STC Summary of this function goes here
%   Detailed explanation goes here


if nargin < 2
    countList_new = ones(length(stimlist),1);
end

if nargin < 3
    uniform = false;
end

if uniform
    countList_new(:) = 1;
end

%countList_new(:) = 1;

assert(length(countList_new)==length(stimlist));

data_matrix = zeros(sum(countList_new), numel(stimlist{1}));

k = 0;

for i = 1:length(stimlist)
    stimulus = stimlist{i}(:);
    stimulus = double(stimulus); 
    data_matrix(k+1:k+countList_new(i),:) = repmat(stimulus',countList_new(i),1);
    k = k+countList_new(i);
end

[coeff,~,latent] = pca(data_matrix);

end

