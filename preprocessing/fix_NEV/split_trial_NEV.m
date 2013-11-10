function [ NEV_trials ] = split_trial_NEV( nev_codes, starting_codes, ending_codes )
%SPLIT_TRAIL_NEV split a string of NEV codes into trials
%   Detailed explanation goes here

% now, we temporarily assume starting_codes and ending codes are unique.

% next we have the problem of how to identify boundaries between trials.
% now I find trials by first finding a starting code and continue until I
% find a ending code.

% Yimeng Zhang, 09/18/2013
% Pittsburgh, PA, USA

starting_code = starting_codes(1);
ending_code = ending_codes(1);

starting_find = find(nev_codes == starting_code);
ending_find = find(nev_codes == ending_code);

fprintf('number of starting code %d, ending code %d\n', length(starting_find), length(ending_find));

NEV_trials = {};
i=1;  
while ~isempty(ending_find) && ~isempty(starting_find) % assume that 
% whenever we find a starting code, we can always find a ending code later than it.
NEV_trials{i}.start = starting_find(1);
%prune ending_find
ending_find = ending_find(ending_find > starting_find(1));
if ~isempty(ending_find)
    NEV_trials{i}.end = ending_find(1);
    starting_find = starting_find(starting_find > ending_find(1));
    i=i+1;
else
    NEV_trials(i) = [];
end
%prune starting_find

end

fprintf('number of sets is %d\n', length(NEV_trials));

end

