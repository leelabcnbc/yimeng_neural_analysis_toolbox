function [  ] = plot_PSTH( cdt, channel, grouping, ncol, control_group )
%PLOT_PSTH Summary of this function goes here
%   Detailed explanation goes here

nstimuli = cdt.exp_param.nstimuli;
ntests = cdt.exp_param.number_of_test;


info=cdt.info;


if nargin < 2
    channel=info.channel; % we only have one channel's info
end

% spike_times_cond(:,new_ntrials+1:new_ntrials+ntrials,ch) = cdt.EVENTS(ch,:,1:ntrials);
spike_times_cond = cdt.EVENTS(channel,:,:);
data = cdt.data;
TC = cdt.TC;

spike_times_cond = squeeze(spike_times_cond);

% grouping now provides absolute indexing into the second dimension of
% cdt.EVENTS.

for i = 1:numel( spike_times_cond )
    spike_times_cond{i} = spike_times_cond{i}*1000;
end




if nargin < 3
    grouping = {1:nstimuli};
end

if nargin < 4
    ncol = ceil(sqrt(numel(grouping)));
end

if nargin < 5
    control_group = [];
end

if isscalar(control_group)
    control_group = repmat(control_group,length(grouping),1);
end


%calculate onsets, offsets, and fixation.
for cond=1:nstimuli
    %assert(ntrials == TC(cond)); debug
    onsets(cond,:)=mean(reshape(cell2mat(data.starttime(cond,1:TC(cond))),ntests,TC(cond)),2);
    offsets(cond,:)=mean(reshape(cell2mat(data.stoptime(cond,1:TC(cond))),ntests,TC(cond)),2);
    fixation(cond)=mean(data.fixation(cond,:));
end
onsets=mean(onsets);
offsets=mean(offsets);
fixation=mean(fixation);

nrow = ceil(numel(grouping)/ncol);

psth = cell(nrow,ncol);


max_psth=0;
x_bound = 0;

for k = 1:length(grouping)
    
    
    spike_times_cond_tmp = cell(sum(TC(grouping{k})),1);
    
    kk = 0;
    
    for jj = 1:length(grouping{k})
        spike_times_cond_tmp(kk+1:kk+TC(grouping{k}(jj))) = spike_times_cond(grouping{k}(jj),1:TC(grouping{k}(jj)));
        kk = kk+TC(grouping{k}(jj));
    end
    
    psth{k}=calc_PSTH(spike_times_cond_tmp,[],20);
    
    %psth_test=calc_PSTH(spike_times_cond(grouping{k},:),[],20);
    
    %assert(isequal(psth{k},psth_test));
    
    
    max_psth=max(max_psth,max(psth{k}));
    x_bound=max(x_bound,length(psth{k}));
end


for k = 1:length(grouping)
    psth{k} = padarray(psth{k},[x_bound-length(psth{k}),0],0,'post');
end

display(max_psth);


for k = 1:numel(grouping)
    hold on;
    subplot(nrow,ncol,k);
    
    if ~isempty(control_group)
        plot([psth{k},psth{control_group(k)}]);
    else
        plot([psth{k}]);
    end
    xlim([0, x_bound]);ylim([0 max_psth]);
    xlabel('time (ms)');ylabel('firing rate (spk/s)')
    
    %display timesets
    display_timesets(onsets*1000,max_psth,'b','--');
    display_timesets(offsets*1000,max_psth,'b','--');
    display_timesets(fixation*1000,max_psth,'r','-');
    hold off;
    
    fprintf('start: %f, end: %f, fixation: %f\n', onsets, offsets, fixation);
    
end




end

