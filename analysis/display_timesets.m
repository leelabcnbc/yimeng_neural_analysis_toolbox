function display_timesets(onsets,ymax,color,style)

% display_onsets(onsets,ymax,color,style)
%
%
% corentin 03/18/2013

for t=1:length(onsets)
    line([onsets(t) onsets(t)],[0 ymax],'color',color,'linestyle',style,'linewidth',1);
end
