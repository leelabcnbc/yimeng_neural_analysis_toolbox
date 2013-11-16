function [ h1,h2 ] = STA( stimulus_list, firing_rate_list, k, p)
%STA Summary of this function goes here
%   Detailed explanation goes here

average_stimulus = zeros(size(stimulus_list{1}));



stimulus_list = stimulus_list(:);


for i = 1:length(stimulus_list)
    stimulus_list{i} = 255- stimulus_list{i};
end

if nargin < 4
    p = 0;
end

if nargin < 3
    k = length(stimulus_list);
end

if nargin < 2
    firing_rate_list = ones(length(stimulus_list),1);
end

firing_rate_list = firing_rate_list(:);

[firing_rate_list,sort_index] = sort(firing_rate_list,'descend');
stimulus_list = stimulus_list(sort_index);

firing_rate_list_top = firing_rate_list(1:k);
stimulus_list_top = stimulus_list(1:k);

firing_rate_list_bottom = firing_rate_list(end-p+1:end);
stimulus_list_bottom = stimulus_list(end-p+1:end);


stimulus_list_total = [stimulus_list_top; stimulus_list_bottom];
firing_list_total = [firing_rate_list_top; firing_rate_list_bottom];

total_firing_rate = sum(firing_list_total(:));



for i = 1:length(stimulus_list_total)
    average_stimulus = average_stimulus + double(stimulus_list_total{i}) * firing_list_total(i)/total_firing_rate;
end


normalize_stimulus = ones(size(stimulus_list{1}));

for i = 1:length(stimulus_list)
    normalize_stimulus = normalize_stimulus +  double(stimulus_list{i})/length(stimulus_list);
end

close all;

h1 = figure;
imagesc(normalize_stimulus);
colormap(gray);
h2 = figure;

imagesc(average_stimulus./normalize_stimulus);
colormap(gray);


end

