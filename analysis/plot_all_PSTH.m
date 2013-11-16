function plot_all_PSTH(cdt, good_neuron)

if nargin < 2 
    if isfield(cdt, 'good_neuron')
        good_neuron = cdt.good_neuron;
    else
        good_neuron = 1:size(cdt.map,1);
    end
end
        
    

for i = good_neuron
    close all;
    plot_PSTH(cdt,i);
    title(['unit ' int2str(i) ' (' int2str(cdt.map(i,1)) ',' int2str(cdt.map(i,2)) ')']);
    pause;
end